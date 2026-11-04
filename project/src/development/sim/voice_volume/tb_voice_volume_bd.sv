`timescale 1ns/1ps
module tb_voice_volume_bd #(
    parameter EXPECT_STUCK = 1,
    parameter EXTENDED = 0
);
    reg ps_clock = 0;
    reg ps_reset_n = 0;
    always #15 ps_clock = ~ps_clock;
    wire ps_clock_pin = ps_clock;
    wire ps_reset_pin = ps_reset_n;
    wire fabric_clock = dut.volume_i.ps7_0_FCLK_CLK0;
    wire control_reset_n = dut.volume_i.control_reset_peripheral_aresetn;
    reg [1023:0] read_data;
    reg [1:0] response;
    bit read_completed = 0;
    integer request_cycles = 0;
    integer response_cycles = 0;
    integer si_aw_count = 0, si_w_count = 0, si_b_count = 0;
    integer mi_aw_count = 0, mi_w_count = 0, mi_b_count = 0;
    reg serial_data = 0;
    wire bclk, lrclk;
    reg previous_lrclk = 0, sample_polarity = 0;
    integer serial_slot = 0;
    reg signed [15:0] serial_value;

    volume_wrapper dut (
        .FIXED_IO_ps_clk(ps_clock_pin),
        .FIXED_IO_ps_porb(ps_reset_pin),
        .FIXED_IO_ps_srstb(ps_reset_pin),
        .bclk(bclk),
        .lrclk(lrclk),
        .sdata_i(serial_data)
    );

    always @(negedge bclk) begin
        #1;
        if (lrclk != previous_lrclk) begin
            serial_slot = 0;
            previous_lrclk = lrclk;
            if (!lrclk) sample_polarity = !sample_polarity;
        end else serial_slot = serial_slot + 1;
        serial_value = lrclk ? 16'sh7fff : (sample_polarity ? 16'sd128 : -16'sd128);
        serial_data = serial_slot > 0 && serial_slot <= 16 ? serial_value[16-serial_slot] : 1'b0;
    end

    always @(posedge fabric_clock) begin
        if (control_reset_n) begin
            if (dut.volume_i.ps7_0.M_AXI_GP0_AWVALID && dut.volume_i.ps7_0.M_AXI_GP0_AWREADY) begin
                si_aw_count = si_aw_count + 1;
                $display("BD_SI_AW index=%0d address=%h size=%h len=%h id=%h", si_aw_count,
                         dut.volume_i.ps7_0.M_AXI_GP0_AWADDR, dut.volume_i.ps7_0.M_AXI_GP0_AWSIZE,
                         dut.volume_i.ps7_0.M_AXI_GP0_AWLEN, dut.volume_i.ps7_0.M_AXI_GP0_AWID);
            end
            if (dut.volume_i.ps7_0.M_AXI_GP0_WVALID && dut.volume_i.ps7_0.M_AXI_GP0_WREADY) begin
                si_w_count = si_w_count + 1;
                $display("BD_SI_W index=%0d data=%h strobe=%h last=%h", si_w_count,
                         dut.volume_i.ps7_0.M_AXI_GP0_WDATA, dut.volume_i.ps7_0.M_AXI_GP0_WSTRB,
                         dut.volume_i.ps7_0.M_AXI_GP0_WLAST);
            end
            if (dut.volume_i.ps7_0.M_AXI_GP0_BVALID && dut.volume_i.ps7_0.M_AXI_GP0_BREADY) begin
                si_b_count = si_b_count + 1;
                $display("BD_SI_B index=%0d response=%h id=%h", si_b_count,
                         dut.volume_i.ps7_0.M_AXI_GP0_BRESP, dut.volume_i.ps7_0.M_AXI_GP0_BID);
            end
            if (dut.volume_i.voice_volume_0.s_axi_awvalid && dut.volume_i.voice_volume_0.s_axi_awready) begin
                mi_aw_count = mi_aw_count + 1;
                $display("BD_MI_AW index=%0d address=%h", mi_aw_count, dut.volume_i.voice_volume_0.s_axi_awaddr);
            end
            if (dut.volume_i.voice_volume_0.s_axi_wvalid && dut.volume_i.voice_volume_0.s_axi_wready) begin
                mi_w_count = mi_w_count + 1;
                $display("BD_MI_W index=%0d data=%h strobe=%h", mi_w_count,
                         dut.volume_i.voice_volume_0.s_axi_wdata, dut.volume_i.voice_volume_0.s_axi_wstrb);
            end
            if (dut.volume_i.voice_volume_0.s_axi_bvalid && dut.volume_i.voice_volume_0.s_axi_bready) begin
                mi_b_count = mi_b_count + 1;
                $display("BD_MI_B index=%0d response=%h", mi_b_count, dut.volume_i.voice_volume_0.s_axi_bresp);
            end
        end
        if (dut.volume_i.ps7_0.M_AXI_GP0_ARVALID === 1'b1)
            request_cycles = request_cycles + 1;
        if (dut.volume_i.ps7_0.M_AXI_GP0_RVALID === 1'b1)
            response_cycles = response_cycles + 1;
    end

    task automatic check_identity(input [31:0] address, input [31:0] expected);
        dut.volume_i.ps7_0.inst.read_data(address, 4, read_data, response);
        if (response !== 0 || read_data[31:0] !== expected)
            $fatal(1, "BD_IDENTITY_FAIL address=%h value=%h response=%h", address, read_data[31:0], response);
        $display("BD_IDENTITY address=%h value=%h response=%h", address, read_data[31:0], response);
    endtask

    task automatic write_register(input [31:0] address, input [31:0] value, input [1:0] expected_response);
        dut.volume_i.ps7_0.inst.write_data(address, 4, {992'd0, value}, response);
        if (response !== expected_response)
            $fatal(1, "BD_WRITE_FAIL address=%h value=%h response=%h expected=%h", address, value, response, expected_response);
    endtask

    task automatic startup_write_checks;
        integer config_index;
        reg [31:0] config_value;
        check_identity(32'h43c00018, 0);
        for (config_index = 0; config_index < 4; config_index = config_index + 1) begin
            dut.volume_i.ps7_0.inst.read_data(32'h43c00020 + config_index * 4, 4, read_data, response);
            if (response !== 0) $fatal(1, "BD_SHADOW_PREREAD_FAIL");
            case (config_index)
                0: config_value = 32'hfffffffe;
                1: config_value = 32'hffffffff;
                2: config_value = 1;
                3: config_value = 0;
            endcase
            write_register(32'h43c00020 + config_index * 4, config_value, 0);
        end
        dut.volume_i.ps7_0.inst.read_data(32'h43c00030, 4, read_data, response);
        if (response !== 2) $fatal(1, "BD_COMMAND_PREREAD_FAIL response=%h", response);
        check_identity(32'h43c00018, 0);
        check_identity(32'h43c00010, 8);
        for (config_index = 0; config_index < 4; config_index = config_index + 1) begin
            case (config_index)
                0: config_value = 32'hfffffffe;
                1: config_value = 32'hffffffff;
                2: config_value = 1;
                3: config_value = 0;
            endcase
            write_register(32'h43c00020 + config_index * 4, config_value, 0);
        end
        write_register(32'h43c00030, 1, 0);
        check_identity(32'h43c00018, 1);
        check_identity(32'h43c00010, 8);
        check_identity(32'h43c00020, 32'hfffffffe);
        check_identity(32'h43c00024, 32'hffffffff);
        check_identity(32'h43c00028, 1);
        check_identity(32'h43c0002c, 0);
        $display("VOLUME_BD_STARTUP_WRITES_PASS command_preread=SLVERR pure_writes=5 epoch=1 disabled=1");
    endtask

    task automatic extended_checks;
        dut.volume_i.ps7_0.inst.read_data(32'h43c00ffc, 4, read_data, response);
        if (response !== 2) $fatal(1, "BD_INVALID_READ_FAIL response=%h", response);
        write_register(32'h43c0002c, 2, 2);
        check_identity(32'h43c0002c, 0);
        write_register(32'h43c00020, 123456, 0);
        check_identity(32'h43c00020, 123456);
        for (integer reset_index = 0; reset_index < 2; reset_index = reset_index + 1) begin
            dut.volume_i.ps7_0.inst.fpga_soft_reset(32'h1);
            repeat (100) @(negedge fabric_clock);
            if (control_reset_n !== 0) $fatal(1, "BD_RESET_ASSERT_FAIL");
            dut.volume_i.ps7_0.inst.fpga_soft_reset(32'h0);
            repeat (500) @(negedge fabric_clock);
            if (control_reset_n !== 1) $fatal(1, "BD_RESET_RELEASE_FAIL");
            check_identity(32'h43c00000, 32'h564f4c31);
            check_identity(32'h43c00018, 0);
            check_identity(32'h43c00020, 1000000);
        end
        write_register(32'h43c00020, 32'hfffffffe, 0);
        write_register(32'h43c00024, 32'hffffffff, 0);
        write_register(32'h43c00028, 1, 0);
        write_register(32'h43c0002c, 1, 0);
        write_register(32'h43c00030, 1, 0);
        check_identity(32'h43c00018, 1);
        repeat (1024) @(posedge lrclk);
        write_register(32'h43c00030, 2, 0);
        check_identity(32'h43c00014, 0);
        check_identity(32'h43c00084, 1);
        dut.volume_i.ps7_0.inst.read_data(32'h43c0004c, 4, read_data, response);
        if (response !== 0 || read_data[31:0] < 1000)
            $fatal(1, "BD_I2S_SAMPLE_FAIL value=%h response=%h", read_data[31:0], response);
        $display("BD_AUDIO_SAMPLES value=%0d", read_data[31:0]);
        dut.volume_i.ps7_0.inst.read_data(32'h43c00054, 4, read_data, response);
        if (response !== 0 || read_data[31:0] == 0)
            $fatal(1, "BD_AUDIO_WINDOW_FAIL value=%h response=%h", read_data[31:0], response);
        dut.volume_i.ps7_0.inst.read_data(32'h43c00058, 4, read_data, response);
        if (response !== 0 || read_data[31:0] == 0)
            $fatal(1, "BD_AUDIO_ENERGY_FAIL value=%h response=%h", read_data[31:0], response);
        $display("BD_AUDIO_SUM value=%0d", read_data[31:0]);
        write_register(32'h43c0002c, 0, 0);
        write_register(32'h43c00030, 1, 0);
        check_identity(32'h43c00018, 2);
        check_identity(32'h43c00084, 0);
        $display("VOLUME_BD_EXTENDED_PASS idle_resets=2 audio_frames=1024");
    endtask

    initial begin
        #500;
        ps_reset_n = 1;
        #500;
        dut.volume_i.ps7_0.inst.fpga_soft_reset(32'hf);
        #1000;
        dut.volume_i.ps7_0.inst.fpga_soft_reset(32'h0);
        repeat (500) @(negedge fabric_clock);
        if (dut.volume_i.ps7_0_FCLK_RESET0_N !== 1'b1)
            $fatal(1, "BD_PS_RESET_NOT_RELEASED");
        if (EXPECT_STUCK) begin
            if (control_reset_n !== 1'b0)
                $fatal(1, "BD_ORIGINAL_RESET_NOT_REPRODUCED");
            fork
                begin
                    dut.volume_i.ps7_0.inst.read_data(32'h43c00000, 4, read_data, response);
                    read_completed = 1;
                end
                begin
                    repeat (1000) @(negedge fabric_clock);
                end
            join_any
            disable fork;
            if (read_completed || request_cycles == 0 || response_cycles != 0)
                $fatal(1, "BD_STUCK_CHECK_FAIL completed=%b requests=%0d responses=%0d", read_completed, request_cycles, response_cycles);
            $display("VOLUME_BD_STUCK_REPRODUCED requests=%0d responses=%0d reset_n=%b", request_cycles, response_cycles, control_reset_n);
        end else begin
            if (control_reset_n !== 1'b1)
                $fatal(1, "BD_FIXED_RESET_NOT_RELEASED");
            check_identity(32'h43c00000, 32'h564f4c31);
            check_identity(32'h43c00004, 32'hc00c0001);
            check_identity(32'h43c00008, 32'h00010000);
            check_identity(32'h43c0001c, 32'd977);
            $display("VOLUME_BD_IDENTITY_PASS");
            if (EXTENDED) begin
                startup_write_checks();
                extended_checks();
                if (si_aw_count != si_w_count || si_w_count != si_b_count ||
                    mi_aw_count != mi_w_count || mi_w_count != mi_b_count ||
                    si_aw_count != mi_aw_count || mi_aw_count <= 9)
                    $fatal(1, "BD_WRITE_LEDGER_FAIL");
                $display("VOLUME_BD_HANDSHAKES_PASS si_aw=%0d si_w=%0d si_b=%0d mi_aw=%0d mi_w=%0d mi_b=%0d",
                         si_aw_count, si_w_count, si_b_count, mi_aw_count, mi_w_count, mi_b_count);
            end
        end
        $display("VOLUME_BD_DIAGNOSTIC_PASS expect_stuck=%0d", EXPECT_STUCK);
        $finish;
    end

    initial begin
        #30000000;
        $fatal(1, "VOLUME_BD_WATCHDOG");
    end
endmodule