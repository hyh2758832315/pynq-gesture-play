`timescale 1ns/1ps
module tb_axi_vision_capture_status;
    reg clock = 0;
    always #5 clock = !clock;
    reg resetn = 0, awvalid = 0, wvalid = 0, bready = 0, arvalid = 0, rready = 0;
    reg [11:0] awaddr = 0, araddr = 0;
    reg [31:0] wdata = 0;
    reg [3:0] wstrb = 0;
    wire awready, wready, bvalid, arready, rvalid;
    wire [1:0] bresp, rresp;
    wire [31:0] rdata;
    reg monitor_ready = 0, epoch_sealed = 0, capture_armed = 1;
    reg [31:0] epoch = 32'h70809000;
    reg [2:0] faults = 0;
    integer reads = 0, writes = 0, snapshot_id = -1, output_file, write_index;
    reg exporting = 0;
    axi_vision_capture_status dut (
        .s_axi_aclk(clock), .s_axi_aresetn(resetn),
        .s_axi_awaddr(awaddr), .s_axi_awvalid(awvalid), .s_axi_awready(awready),
        .s_axi_wdata(wdata), .s_axi_wstrb(wstrb), .s_axi_wvalid(wvalid), .s_axi_wready(wready),
        .s_axi_bresp(bresp), .s_axi_bvalid(bvalid), .s_axi_bready(bready),
        .s_axi_araddr(araddr), .s_axi_arvalid(arvalid), .s_axi_arready(arready),
        .s_axi_rdata(rdata), .s_axi_rresp(rresp), .s_axi_rvalid(rvalid), .s_axi_rready(rready),
        .monitor_ready(monitor_ready), .capture_armed(capture_armed),
        .epoch_sealed(epoch_sealed), .capture_epoch(epoch), .fault_causes(faults)
    );
    task automatic common_reset;
        begin
            @(negedge clock);
            resetn = 0;
            monitor_ready = 0;
            capture_armed = 1;
            epoch_sealed = 0;
            faults = 0;
            arvalid = 0; awvalid = 0; wvalid = 0; rready = 0; bready = 0;
            repeat (4) @(negedge clock);
            if (rvalid || bvalid || arready || awready || wready) $fatal(1, "STATUS reset handshake mismatch");
            resetn = 1;
            repeat (2) @(negedge clock);
        end
    endtask
    task automatic read_word(input [11:0] address, input [31:0] expected, input [1:0] expected_response);
        reg [33:0] held;
        begin
            @(negedge clock); araddr = address; arvalid = 1;
            do @(posedge clock); while (!arready);
            @(negedge clock); arvalid = 0;
            wait (rvalid);
            held = {rresp, rdata};
            repeat (3) begin
                @(negedge clock);
                if (!rvalid || arready || {rresp, rdata} !== held) $fatal(1, "STATUS read response changed while stalled");
            end
            if (rdata !== expected || rresp !== expected_response)
                $fatal(1, "STATUS read mismatch addr=%h value=%h expected=%h resp=%b", address, rdata, expected, rresp);
            if (exporting) $fwrite(output_file, "%0d,%03h,%08h,%01h\n", snapshot_id, address, rdata, rresp);
            rready = 1;
            @(posedge clock);
            @(negedge clock); rready = 0;
            reads = reads + 1;
        end
    endtask
    task automatic snapshot(input integer identity, input [31:0] expected_epoch, input [2:0] expected_status, expected_faults);
        begin
            snapshot_id = identity; exporting = 1;
            read_word(0, 32'h31545356, 0);
            read_word(4, 32'h00010000, 0);
            read_word(16, expected_epoch, 0);
            read_word(8, {29'd0, expected_status}, 0);
            read_word(12, {29'd0, expected_faults}, 0);
            read_word(16, expected_epoch, 0);
            exporting = 0;
        end
    endtask
    task automatic send_aw;
        begin
            @(negedge clock); awvalid = 1;
            do @(posedge clock); while (!awready);
            @(negedge clock); awvalid = 0;
        end
    endtask
    task automatic send_w;
        begin
            @(negedge clock); wvalid = 1;
            do @(posedge clock); while (!wready);
            @(negedge clock); wvalid = 0;
        end
    endtask
    task automatic reject_write(input integer order);
        begin
            if (order % 2) begin send_aw(); repeat (3) @(negedge clock); send_w(); end
            else begin send_w(); repeat (3) @(negedge clock); send_aw(); end
            wait (bvalid);
            repeat (3) begin
                @(negedge clock);
                if (!bvalid || bresp !== 2 || awready || wready) $fatal(1, "STATUS write response/ownership mismatch");
            end
            bready = 1;
            @(posedge clock);
            @(negedge clock); bready = 0;
            writes = writes + 1;
        end
    endtask
    initial begin
        output_file = $fopen("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r285-status-output/reads.csv", "w");
        if (!output_file) $fatal(1, "STATUS output unavailable");
        $fwrite(output_file, "snapshot,offset,value,response\n");
        common_reset();
        snapshot(0, 0, 0, 0);
        monitor_ready = 1;
        repeat (3) @(negedge clock);
        snapshot(1, 32'h70809000, 1, 0);
        fork
            read_word(8, 1, 0);
            begin
                wait (rvalid);
                @(negedge clock); faults = 1;
                @(negedge clock); faults = 0;
            end
        join
        snapshot(2, 32'h70809000, 5, 1);
        epoch_sealed = 1;
        snapshot(3, 32'h70809000, 7, 1);
        for (write_index = 0; write_index < 10; write_index = write_index + 1) begin
            awaddr = write_index < 5 ? write_index * 4 : 12'h100 + write_index;
            wdata = write_index % 2 ? 0 : 32'hffffffff;
            wstrb = write_index % 3 == 0 ? 0 : 4'hf;
            reject_write(write_index);
        end
        read_word(12, 1, 0);
        read_word(1, 0, 2);
        read_word(12'h100, 0, 2);
        read_word(12'hffc, 0, 2);
        common_reset();
        epoch = 32'h70809001; monitor_ready = 1; epoch_sealed = 1;
        repeat (3) @(negedge clock);
        snapshot(4, 32'h70809001, 3, 0);
        epoch = 32'h70809002;
        repeat (2) @(negedge clock);
        snapshot(5, 32'h70809001, 7, 4);
        epoch = 32'h70809001;
        read_word(12, 4, 0);
        common_reset();
        epoch = 32'h70809002; monitor_ready = 1; epoch_sealed = 1;
        repeat (3) @(negedge clock);
        snapshot(6, 32'h70809002, 3, 0);
        monitor_ready = 0;
        repeat (2) @(negedge clock);
        monitor_ready = 1;
        snapshot(7, 32'h70809002, 7, 4);
        common_reset();
        epoch = 32'h70809003; monitor_ready = 1;
        repeat (3) @(negedge clock);
        faults = 2; @(negedge clock); faults = 0;
        snapshot(8, 32'h70809003, 5, 2);
        faults = 4; @(negedge clock); faults = 0;
        snapshot(9, 32'h70809003, 5, 6);
        common_reset();
        send_aw();
        common_reset();
        send_w();
        repeat (4) @(negedge clock);
        if (bvalid) $fatal(1, "STATUS stale AW survived reset");
        send_aw();
        wait (bvalid);
        bready = 1;
        @(posedge clock);
        @(negedge clock); bready = 0;
        writes = writes + 1;
        common_reset();
        @(negedge clock); araddr = 0; arvalid = 1;
        do @(posedge clock); while (!arready);
        @(negedge clock); arvalid = 0;
        wait (rvalid);
        common_reset();
        if (rvalid || bvalid) $fatal(1, "STATUS stale response survived reset");
        if (reads != 66 || writes != 11) $fatal(1, "STATUS transaction count differs reads=%0d writes=%0d", reads, writes);
        $display("TEST_PASS AXI_VISION_CAPTURE_STATUS snapshots=10 reads=66 writes=11 READONLY_STICKY_EPOCH_STALL_RESET");
        common_reset();
        capture_armed = 0; epoch = 0; monitor_ready = 1;
        repeat (3) @(negedge clock);
        snapshot(10, 0, 0, 0);
        epoch = 32'h00001234;
        repeat (3) @(negedge clock);
        snapshot(11, 0, 0, 0);
        epoch = 32'habcd1234;
        repeat (3) @(negedge clock);
        snapshot(12, 0, 0, 0);
        capture_armed = 1;
        repeat (3) @(negedge clock);
        snapshot(13, 32'habcd1234, 1, 0);
        epoch = 32'habcd1235;
        repeat (3) @(negedge clock);
        snapshot(14, 32'habcd1234, 5, 4);
        common_reset();
        capture_armed = 0; epoch = 32'habcd1234; monitor_ready = 1;
        faults = 1;
        @(negedge clock); faults = 0;
        snapshot(15, 0, 4, 1);
        capture_armed = 1;
        repeat (3) @(negedge clock);
        snapshot(16, 32'habcd1234, 5, 1);
        common_reset();
        epoch = 32'habcd1234; monitor_ready = 1;
        repeat (3) @(negedge clock);
        capture_armed = 0;
        repeat (3) @(negedge clock);
        snapshot(17, 32'habcd1234, 5, 4);
        if (reads != 114 || writes != 11) $fatal(1, "STATUS guarded transaction count differs");
        $fclose(output_file);
        $display("TEST_PASS STATUS_ARM_COMMIT_GUARD snapshots=18 reads=114 writes=11 EARLY_READY PARTIAL_CONTEXT PREARM_FAULT POSTARM_MUTATION ARM_DROP");
        $finish;
    end
    initial begin
        #90000;
        $fatal(1, "STATUS watchdog expired");
    end
endmodule