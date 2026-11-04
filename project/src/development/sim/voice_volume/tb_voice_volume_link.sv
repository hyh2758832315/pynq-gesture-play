`timescale 1ns/1ps
module tb_voice_volume_link;
    reg s_axi_aclk = 0;
    always #5 s_axi_aclk = ~s_axi_aclk;
    reg s_axi_aresetn = 0;
    reg [11:0] s_axi_awaddr = 0, s_axi_araddr = 0;
    reg [2:0] s_axi_awprot = 0, s_axi_arprot = 0;
    reg s_axi_awvalid = 0, s_axi_wvalid = 0, s_axi_bready = 1, s_axi_arvalid = 0, s_axi_rready = 1;
    wire s_axi_awready, s_axi_wready, s_axi_bvalid, s_axi_arready, s_axi_rvalid;
    reg [31:0] s_axi_wdata = 0;
    reg [3:0] s_axi_wstrb = 15;
    wire [1:0] s_axi_bresp, s_axi_rresp;
    wire [31:0] s_axi_rdata;
    reg i2s_sdata = 0, codec_mclk_locked = 1;
    wire i2s_bclk, i2s_lrclk;
    wire [1:0] codec_address;
    reg signed [15:0] amplitude = 0, serial_value;
    integer checks = 0;
    reg sample_polarity = 0;
    voice_volume_top #(.WINDOW_SAMPLES(4)) dut (.*);
    always @(negedge i2s_bclk) begin
        if (dut.audio_counter[9:5] == 0 && !i2s_lrclk) sample_polarity = !sample_polarity;
        serial_value = i2s_lrclk ? 16'sh7fff : (sample_polarity ? amplitude : -amplitude);
        if (dut.audio_counter[9:5] > 0 && dut.audio_counter[9:5] <= 16)
            i2s_sdata = serial_value[16-dut.audio_counter[9:5]];
        else i2s_sdata = 0;
    end
    task automatic write_register(input [11:0] address, input [31:0] value);
        @(negedge s_axi_aclk); s_axi_awaddr = address; s_axi_wdata = value; s_axi_awvalid = 1; s_axi_wvalid = 1;
        @(negedge s_axi_aclk);
        if (!dut.registers.aw_held || !dut.registers.w_held) $fatal(1, "LINK_FAIL request acceptance");
        s_axi_awvalid = 0; s_axi_wvalid = 0;
        @(negedge s_axi_aclk);
        if (!s_axi_bvalid || s_axi_bresp != 0) $fatal(1, "LINK_FAIL write response");
        @(negedge s_axi_aclk); checks = checks + 1;
    endtask
    task automatic read_register(input [11:0] address, input [31:0] expected);
        @(negedge s_axi_aclk); s_axi_araddr = address; s_axi_arvalid = 1;
        @(negedge s_axi_aclk);
        if (!s_axi_rvalid || s_axi_rresp != 0 || s_axi_rdata !== expected)
            $fatal(1, "LINK_FAIL address=%h got=%h expected=%h", address, s_axi_rdata, expected);
        s_axi_arvalid = 0;
        @(negedge s_axi_aclk); checks = checks + 1;
    endtask
    initial begin
        repeat (5) @(negedge s_axi_aclk); s_axi_aresetn = 1;
        read_register(4, 32'hc00c0001);
        write_register(12'h020, 40); write_register(12'h024, 120); write_register(12'h028, 30);
        write_register(12'h02c, 1); write_register(12'h030, 1);
        wait(dut.registers.state == 1);
        @(posedge i2s_lrclk); amplitude = 20;
        wait(dut.registers.event_pending);
        if (dut.registers.event_kind != 1 || dut.registers.faults != 0 || codec_address != 3)
            $fatal(1, "LINK_FAIL event kind/fault/straps");
        write_register(12'h030, 2);
        read_register(12'h064, 5); read_register(12'h060, 1); read_register(12'h05c, 1);
        read_register(12'h074, dut.registers.snapshot[13]);
        repeat (12) @(posedge i2s_lrclk);
        read_register(12'h05c, 1);
        if (!dut.registers.event_pending || dut.registers.event_sequence != 1) $fatal(1, "LINK_FAIL sustained event overwritten");
        write_register(12'h034, 1); write_register(12'h038, 1); write_register(12'h030, 4);
        @(posedge i2s_lrclk); amplitude = 0;
        wait(dut.registers.state == 1);
        @(posedge i2s_lrclk); amplitude = 80;
        wait(dut.registers.event_pending);
        if (dut.registers.event_kind != 2 || dut.registers.event_sequence != 2 || dut.registers.faults != 0)
            $fatal(1, "LINK_FAIL loud event after quiet/ACK");
        checks = checks + 2;
        $display("VOLUME_LINK_PASS checks=%0d sample=%0d BCLK=3125000 LRCLK=48828.125", checks, dut.registers.sample_count); $finish;
    end
    initial begin #10000000; $fatal(1, "LINK_WATCHDOG"); end
endmodule