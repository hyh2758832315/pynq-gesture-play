`timescale 1ns/1ps
module tb_voice_volume_axi;
    reg s_axi_aclk = 0;
    always #5 s_axi_aclk = ~s_axi_aclk;
    reg s_axi_aresetn = 0;
    reg [11:0] s_axi_awaddr = 0, s_axi_araddr = 0;
    reg [2:0] s_axi_awprot = 0, s_axi_arprot = 0;
    reg s_axi_awvalid = 0, s_axi_wvalid = 0, s_axi_bready = 0, s_axi_arvalid = 0, s_axi_rready = 0;
    wire s_axi_awready, s_axi_wready, s_axi_bvalid, s_axi_arready, s_axi_rvalid;
    reg [31:0] s_axi_wdata = 0;
    reg [3:0] s_axi_wstrb = 15;
    wire [1:0] s_axi_bresp, s_axi_rresp;
    wire [31:0] s_axi_rdata;
    reg pcm_valid = 0, input_fault = 0, clock_locked = 1;
    reg signed [15:0] pcm_s16 = 0;
    integer checks = 0, windows_sent = 0;
    integer aw_count = 0, w_count = 0, b_count = 0;
    reg [31:0] read_value, held_value;
    axi_voice_volume #(.WINDOW_SAMPLES(4), .SAMPLE_TIMEOUT_CLKS(1000), .EVENT_TIMEOUT_CLKS(10000)) dut (.*);
    always @(posedge s_axi_aclk) begin
        if (s_axi_aresetn) begin
            if (s_axi_awvalid && s_axi_awready) begin
                aw_count = aw_count + 1;
                $display("AXI_AW index=%0d address=%h time=%0t", aw_count, s_axi_awaddr, $time);
            end
            if (s_axi_wvalid && s_axi_wready) begin
                w_count = w_count + 1;
                $display("AXI_W index=%0d data=%h strobe=%h time=%0t", w_count, s_axi_wdata, s_axi_wstrb, $time);
            end
            if (s_axi_bvalid && s_axi_bready) begin
                b_count = b_count + 1;
                $display("AXI_B index=%0d response=%h time=%0t", b_count, s_axi_bresp, $time);
            end
        end
    end
    task automatic check(input bit condition, input string message);
        if (!condition) $fatal(1, "AXI_FAIL %s", message);
        checks = checks + 1;
    endtask
    task automatic write_register(input [11:0] address, input [31:0] value, input integer order, input [3:0] strobe, input [1:0] response);
        @(negedge s_axi_aclk); s_axi_awaddr = address; s_axi_wdata = value; s_axi_wstrb = strobe;
        if (order == 0) begin
            s_axi_awvalid = 1;
            do @(posedge s_axi_aclk); while (!s_axi_awready);
            @(negedge s_axi_aclk); s_axi_awvalid = 0;
            repeat (3) @(negedge s_axi_aclk);
            s_axi_wvalid = 1;
            do @(posedge s_axi_aclk); while (!s_axi_wready);
            @(negedge s_axi_aclk); s_axi_wvalid = 0;
        end else begin
            s_axi_wvalid = 1;
            do @(posedge s_axi_aclk); while (!s_axi_wready);
            @(negedge s_axi_aclk); s_axi_wvalid = 0;
            repeat (3) @(negedge s_axi_aclk);
            s_axi_awvalid = 1;
            do @(posedge s_axi_aclk); while (!s_axi_awready);
            @(negedge s_axi_aclk); s_axi_awvalid = 0;
        end
        repeat (3) @(negedge s_axi_aclk);
        check(s_axi_bvalid && s_axi_bresp == response, "bounded write response while BREADY low");
        repeat (7) begin @(negedge s_axi_aclk); check(s_axi_bvalid && s_axi_bresp == response, "B response held under backpressure"); end
        s_axi_bready = 1;
        @(negedge s_axi_aclk); s_axi_bready = 0;
    endtask
    task automatic fast_write(input [11:0] address, input [31:0] value, input integer order);
        @(negedge s_axi_aclk);
        s_axi_awaddr = address; s_axi_wdata = value; s_axi_wstrb = 15; s_axi_bready = 1;
        fork
            begin
                if (order == 1) repeat (3) @(negedge s_axi_aclk);
                s_axi_awvalid = 1;
                do @(posedge s_axi_aclk); while (!s_axi_awready);
                @(negedge s_axi_aclk); s_axi_awvalid = 0;
            end
            begin
                if (order == 0) repeat (3) @(negedge s_axi_aclk);
                s_axi_wvalid = 1;
                do @(posedge s_axi_aclk); while (!s_axi_wready);
                @(negedge s_axi_aclk); s_axi_wvalid = 0;
            end
            begin
                do @(posedge s_axi_aclk); while (!s_axi_bvalid);
                check(s_axi_bresp == 0, "BREADY high write completes with OKAY");
                @(negedge s_axi_aclk);
            end
        join
    endtask
    task automatic blocked_next_write;
        @(negedge s_axi_aclk);
        s_axi_bready = 0; s_axi_awaddr = 12'h020; s_axi_wdata = 41; s_axi_wstrb = 15;
        s_axi_awvalid = 1; s_axi_wvalid = 1;
        @(posedge s_axi_aclk); check(s_axi_awready && s_axi_wready, "simultaneous first request accepted");
        @(negedge s_axi_aclk); s_axi_awvalid = 0; s_axi_wvalid = 0;
        do @(negedge s_axi_aclk); while (!s_axi_bvalid);
        s_axi_awaddr = 12'h020; s_axi_wdata = 42; s_axi_awvalid = 1; s_axi_wvalid = 1;
        repeat (5) begin
            @(negedge s_axi_aclk);
            check(!s_axi_awready && !s_axi_wready && s_axi_bvalid && s_axi_bresp == 0,
                  "next request held while previous B response is stalled");
        end
        s_axi_bready = 1;
        @(negedge s_axi_aclk);
        @(posedge s_axi_aclk); check(s_axi_awready && s_axi_wready, "next request accepted after prior B receipt");
        @(negedge s_axi_aclk); s_axi_awvalid = 0; s_axi_wvalid = 0;
        do @(posedge s_axi_aclk); while (!s_axi_bvalid);
        check(s_axi_bresp == 0, "queued write completed once");
        @(negedge s_axi_aclk); s_axi_bready = 0;
        read_register(12'h020, 0); check(read_value == 42, "queued write updates intended register");
    endtask
    task automatic read_register(input [11:0] address, input [1:0] response);
        @(negedge s_axi_aclk); s_axi_araddr = address; s_axi_arvalid = 1;
        do @(posedge s_axi_aclk); while (!s_axi_arready);
        @(negedge s_axi_aclk); s_axi_arvalid = 0;
        check(s_axi_rvalid && s_axi_rresp == response, "bounded read response");
        held_value = s_axi_rdata;
        repeat (7) begin @(negedge s_axi_aclk); check(s_axi_rvalid && s_axi_rdata == held_value && s_axi_rresp == response, "R data held under backpressure"); end
        read_value = held_value; s_axi_rready = 1;
        @(negedge s_axi_aclk); s_axi_rready = 0;
    endtask
    task automatic window(input signed [15:0] amplitude);
        for (integer sample_index = 0; sample_index < 4; sample_index = sample_index + 1) begin
            @(negedge s_axi_aclk); pcm_valid = 1; pcm_s16 = sample_index[0] ? -amplitude : amplitude;
            @(negedge s_axi_aclk); pcm_valid = 0;
            repeat (2) @(negedge s_axi_aclk);
        end
        windows_sent = windows_sent + 1;
    endtask
    initial begin
        repeat (4) @(negedge s_axi_aclk); s_axi_aresetn = 1;
        read_register(4, 0); check(read_value == 32'hc00c0001, "independent build identity");
        read_register(12'hffc, 2); read_register(1, 2);
        read_register(12'h030, 2);
        read_register(12'h018, 0); check(read_value == 0, "write-only command pre-read faults without committing");
        fast_write(12'h020, 40, 2);
        fast_write(12'h024, 120, 0);
        fast_write(12'h028, 30, 1);
        s_axi_bready = 0;
        read_register(12'h028, 0); check(read_value == 30, "mixed read after BREADY high writes");
        blocked_next_write();
        write_register(12'h020, 40, 0, 15, 0);
        write_register(12'h024, 120, 1, 15, 0);
        write_register(12'h028, 30, 0, 15, 0);
        write_register(12'h02c, 1, 1, 15, 0);
        write_register(12'h030, 1, 0, 15, 0);
        read_register(12'h018, 0); check(read_value == 1, "atomic commit increments epoch");
        repeat (5) window(0); repeat (3) window(20);
        check(dut.event_pending && dut.event_kind == 1, "real DC core emits medium event");
        write_register(12'h030, 2, 1, 15, 0);
        read_register(12'h064, 0); check(read_value == 5, "snapshot event is atomic and pending");
        read_register(12'h05c, 0); check(read_value == 1, "event sequence snapshot");
        read_register(12'h04c, 0); check(read_value == 32, "snapshot source sample count");
        repeat (3) window(60);
        read_register(12'h04c, 0); check(read_value == 32, "snapshot held while source advances");
        write_register(12'h034, 0, 0, 15, 0); write_register(12'h038, 1, 1, 15, 0);
        write_register(12'h030, 4, 0, 15, 0);
        check(dut.event_pending && dut.ack_error, "old epoch ACK rejected");
        write_register(12'h034, 1, 1, 15, 0); write_register(12'h030, 4, 0, 15, 0);
        check(!dut.event_pending, "matching ACK accepted");
        write_register(12'h020, 99, 0, 3, 2);
        read_register(12'h020, 0); check(read_value == 40, "partial strobes rejected without mutation");
        write_register(12'h004, 0, 1, 15, 2);
        write_register(12'h024, 40, 0, 15, 0); write_register(12'h030, 1, 1, 15, 2);
        read_register(12'h018, 0); check(read_value == 1, "invalid config leaves active epoch intact");
        repeat (1010) @(negedge s_axi_aclk);
        read_register(12'h014, 0); check(read_value == 2, "source loss fault readable with no PCM clock");
        write_register(12'h024, 120, 0, 15, 0); write_register(12'h030, 1, 1, 15, 0);
        read_register(12'h018, 0); check(read_value == 2 && dut.faults == 0, "new epoch recovers explicitly");
        clock_locked = 0;
        read_register(12'h014, 0); check(read_value == 64, "audio clock loss does not hang AXI");
        @(negedge s_axi_aclk); s_axi_aresetn = 0;
        repeat (4) @(negedge s_axi_aclk); s_axi_aresetn = 1;
        read_register(12'h010, 0); check(read_value == 0, "reset disabled and no replay");
        check(aw_count == w_count && w_count == b_count && b_count == 22, "every AW/W has exactly one B response");
        $display("VOLUME_AXI_HANDSHAKES_PASS aw=%0d w=%0d b=%0d", aw_count, w_count, b_count);
        $display("VOLUME_AXI_PASS checks=%0d windows=%0d", checks, windows_sent); $finish;
    end
    initial begin #1000000; $fatal(1, "AXI_WATCHDOG"); end
endmodule