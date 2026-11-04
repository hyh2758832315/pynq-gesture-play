`timescale 1ns/1ps
module tb_c6i_volume_bd #(parameter VISION_START = 1, parameter VIDEO_FRAMES = 0);
    reg ps_clock = 0, reset_n = 0, camera_clock = 0;
    reg camera_active = 0, camera_vsync = 0;
    reg [7:0] camera_data = 0;
    always #15 ps_clock = ~ps_clock;
    always #6.734 camera_clock = ~camera_clock;
    wire ps_clock_pin = ps_clock;
    wire reset_pin = reset_n;
    wire fabric_clock = dut.c6v_i.ps7_0_FCLK_CLK0;
    wire volume_reset_n = dut.c6v_i.rst_fclk0_peripheral_aresetn;
    wire bclk, lrclk;
    tri1 camera_scl, camera_sda, codec_scl, codec_sda;
    integer reads = 0, writes = 0, snapshots = 0;
    integer read_handshakes = 0, write_handshakes = 0;
    reg checking_reset = 0;
    integer phase = 0;
    reg [31:0] current_address = 0;
    reg [31:0] value, generation, initial_samples, previous_samples = 0;
    localparam [31:0] VOLUME = 32'h43c10000;
    localparam FRAME_WIDTH = VIDEO_FRAMES > 0 ? 64 : 1280;
    localparam FRAME_HEIGHT = VIDEO_FRAMES > 0 ? 64 : 720;
    integer native_pixels = 0, rgb_pixels = 0, rgb_lines = 0, rgb_frames = 0;
    integer hp_addresses = 0, hp_last_beats = 0, hp_responses = 0, hp_bytes = 0;
    wire [32:0] hp_write_end = {1'b0, dut.c6v_i.ps7_0.S_AXI_HP1_AWADDR} +
        ((33'd1 + dut.c6v_i.ps7_0.S_AXI_HP1_AWLEN) << dut.c6v_i.ps7_0.S_AXI_HP1_AWSIZE);
    reg checking_video = 0;

    c6v_wrapper dut (
        .FIXED_IO_ps_clk(ps_clock_pin), .FIXED_IO_ps_porb(reset_pin),
        .FIXED_IO_ps_srstb(reset_pin), .bclk(bclk), .lrclk(lrclk),
        .sdata_i(1'b0), .vid_pclk(camera_clock), .vid_data(camera_data),
        .vid_hsync(camera_active), .vid_vsync(camera_vsync),
        .vid_iic_scl_io(camera_scl), .vid_iic_sda_io(camera_sda),
        .IIC_1_scl_io(codec_scl), .IIC_1_sda_io(codec_sda)
    );

    always @(posedge fabric_clock) begin
        if (checking_reset && volume_reset_n !== 1'b1)
            $fatal(1, "C0C_VOLUME_RESET_DROPPED phase=%0d", phase);
        if (dut.c6v_i.ps7_0.M_AXI_GP0_RVALID && dut.c6v_i.ps7_0.M_AXI_GP0_RREADY)
            read_handshakes = read_handshakes + 1;
        if (dut.c6v_i.ps7_0.M_AXI_GP0_BVALID && dut.c6v_i.ps7_0.M_AXI_GP0_BREADY)
            write_handshakes = write_handshakes + 1;
    end

    always @(posedge camera_clock) begin
        if (checking_video && camera_active) native_pixels = native_pixels + 1;
        if (checking_video && dut.c6v_i.video_in.overflow === 1'b1)
            $fatal(1, "C0C_VIDEO_OVERFLOW");
    end

    always @(posedge fabric_clock) begin
        if (checking_video) begin
            if (dut.c6v_i.demosaic.m_axis_video_TVALID && dut.c6v_i.demosaic.m_axis_video_TREADY) begin
                rgb_pixels = rgb_pixels + 1;
                if (dut.c6v_i.demosaic.m_axis_video_TLAST) rgb_lines = rgb_lines + 1;
                if (dut.c6v_i.demosaic.m_axis_video_TUSER) rgb_frames = rgb_frames + 1;
            end
            if (dut.c6v_i.ps7_0.S_AXI_HP1_AWVALID && dut.c6v_i.ps7_0.S_AXI_HP1_AWREADY) begin
                if (dut.c6v_i.ps7_0.S_AXI_HP1_AWBURST !== 2'b01 ||
                    ((dut.c6v_i.ps7_0.S_AXI_HP1_AWADDR >= 32'h00100000) &&
                     (hp_write_end <= 33'h020000000)) !== 1'b1)
                    $fatal(1, "C0C_HP1_DDR_RANGE address=%h end=%h",
                        dut.c6v_i.ps7_0.S_AXI_HP1_AWADDR, hp_write_end);
                hp_addresses = hp_addresses + 1;
            end
            if (dut.c6v_i.ps7_0.S_AXI_HP1_WVALID && dut.c6v_i.ps7_0.S_AXI_HP1_WREADY) begin
                for (integer lane = 0; lane < 8; lane = lane + 1)
                    if (dut.c6v_i.ps7_0.S_AXI_HP1_WSTRB[lane]) hp_bytes = hp_bytes + 1;
                if (dut.c6v_i.ps7_0.S_AXI_HP1_WLAST) hp_last_beats = hp_last_beats + 1;
            end
            if (dut.c6v_i.ps7_0.S_AXI_HP1_BVALID && dut.c6v_i.ps7_0.S_AXI_HP1_BREADY) begin
                if (dut.c6v_i.ps7_0.S_AXI_HP1_BRESP !== 0) $fatal(1, "C0C_HP1_WRITE_ERROR");
                hp_responses = hp_responses + 1;
            end
        end
    end

    task automatic camera_cycle(input bit active, input bit sync, input integer pixel);
        @(negedge camera_clock);
        camera_active = active;
        camera_vsync = sync;
        camera_data = pixel[7:0];
    endtask

    task automatic camera_frame(input integer frame_index);
        repeat (4) camera_cycle(0, 1, 0);
        repeat (4) camera_cycle(0, 0, 0);
        for (integer row = 0; row < FRAME_HEIGHT; row = row + 1) begin
            for (integer column = 0; column < FRAME_WIDTH; column = column + 1)
                camera_cycle(1, 0, frame_index + row + column);
            repeat (16) camera_cycle(0, 0, 0);
        end
        repeat (128) camera_cycle(0, 0, 0);
    endtask

    task automatic read_register(input [31:0] address, output [31:0] result);
        reg [1023:0] raw;
        reg [1:0] response;
        current_address = address;
        fork
            begin
                dut.c6v_i.ps7_0.inst.read_data(address, 4, raw, response);
            end
            begin
                repeat (2000) @(negedge fabric_clock);
                $fatal(1, "C0C_READ_TIMEOUT phase=%0d address=%h reset_n=%b", phase, address, volume_reset_n);
            end
        join_any
        disable fork;
        if (response !== 0) $fatal(1, "C0C_READ_RESPONSE address=%h response=%h", address, response);
        result = raw[31:0];
        reads = reads + 1;
    endtask

    task automatic expect_register(input [31:0] address, input [31:0] expected);
        reg [31:0] result;
        read_register(address, result);
        if (result !== expected)
            $fatal(1, "C0C_READ_VALUE address=%h expected=%h actual=%h", address, expected, result);
    endtask

    task automatic write_register(input [31:0] address, input [31:0] data);
        reg [1:0] response;
        current_address = address;
        fork
            begin
                dut.c6v_i.ps7_0.inst.write_data(address, 4, {992'd0, data}, response);
            end
            begin
                repeat (2000) @(negedge fabric_clock);
                $fatal(1, "C0C_WRITE_TIMEOUT phase=%0d address=%h reset_n=%b", phase, address, volume_reset_n);
            end
        join_any
        disable fork;
        if (response !== 0) $fatal(1, "C0C_WRITE_RESPONSE address=%h response=%h", address, response);
        writes = writes + 1;
    endtask

    task automatic snapshot;
        reg [31:0] status, sample_count;
        reg [31:0] words [0:16];
        expect_register(VOLUME + 'h18, 1);
        read_register(VOLUME + 'h10, status);
        if ((status & 'h1f) !== 9) $fatal(1, "C0C_VOLUME_STATUS value=%h", status);
        expect_register(VOLUME + 'h14, 0);
        write_register(VOLUME + 'h30, 2);
        read_register(VOLUME + 'h3c, generation);
        if (generation !== snapshots + 1) $fatal(1, "C0C_GENERATION_NOT_ADVANCING value=%h", generation);
        expect_register(VOLUME + 'h84, 1);
        for (integer offset = 'h40; offset < 'h84; offset = offset + 4)
            read_register(VOLUME + offset, words[(offset - 'h40) / 4]);
        if ((words[0] & 'h1f) !== 9 || words[1] !== 0 || words[2] !== 1 ||
            words[4] !== 0 || words[14] !== 15632 || words[15] !== 27356 || words[16] !== 10747)
            $fatal(1, "C0C_SNAPSHOT_FIELDS_INVALID generation=%0d", generation);
        if (words[3] < previous_samples) $fatal(1, "C0C_SAMPLES_REGRESSED");
        previous_samples = words[3];
        expect_register(VOLUME + 'h18, 1);
        read_register(VOLUME + 'h10, status);
        if ((status & 'h1f) !== 9) $fatal(1, "C0C_VOLUME_STATUS_CHANGED value=%h", status);
        expect_register(VOLUME + 'h14, 0);
        expect_register(VOLUME + 'h3c, generation);
        expect_register(VOLUME + 'h84, 1);
        expect_register(VOLUME + 'h48, 1);
        read_register(VOLUME + 'h4c, sample_count);
        if (snapshots == 0) initial_samples = sample_count;
        snapshots = snapshots + 1;
        $display("C0C_SNAPSHOT phase=%0d index=%0d generation=%0d samples=%0d time=%0t", phase, snapshots, generation, sample_count, $time);
    endtask

    task automatic vision_step(input integer index);
        case (index)
            0: write_register(32'h413d0004, 0);
            1: write_register(32'h413d0000, 1);
            2: expect_register(32'h413d0000, 1);
            3: write_register(32'h43c00010, FRAME_WIDTH);
            4: write_register(32'h43c00018, FRAME_HEIGHT);
            5: write_register(32'h43c00028, 1);
            6: write_register(32'h43c00000, 'h81);
            7: write_register(32'h43000030, 4);
            8: begin
                read_register(32'h43000030, value);
                if (value & 4) $fatal(1, "C0C_VDMA_RESET_STUCK");
            end
            9: write_register(32'h430000ac, 'h10000000);
            10: write_register(32'h430000b0, 'h10400000);
            11: write_register(32'h430000b4, 'h10800000);
            12: write_register(32'h430000a8, FRAME_WIDTH * 3);
            13: write_register(32'h430000a4, FRAME_WIDTH * 3);
            14: write_register(32'h43000030, 'h10003);
            15: write_register(32'h430000a0, FRAME_HEIGHT);
            default: begin
                read_register(32'h43000034, value);
                if (value & 'hc9f0) $fatal(1, "C0C_VDMA_ERROR value=%h", value);
            end
        endcase
    endtask

    initial begin
        #500 reset_n = 1;
        #500 dut.c6v_i.ps7_0.inst.fpga_soft_reset('hf);
        #1000 dut.c6v_i.ps7_0.inst.fpga_soft_reset(0);
        repeat (3000) @(negedge fabric_clock);
        if (volume_reset_n !== 1) $fatal(1, "C0C_RESET_NOT_RELEASED");
        checking_reset = 1;
        phase = 1;
        expect_register(32'h41200000, 32'hc0060c00);
        expect_register(VOLUME, 32'h564f4c31);
        expect_register(VOLUME + 4, 32'hc00c0001);
        expect_register(VOLUME + 8, 32'h00010000);
        expect_register(VOLUME + 'h1c, 977);
        write_register(VOLUME + 'h20, 15632);
        write_register(VOLUME + 'h24, 27356);
        write_register(VOLUME + 'h28, 10747);
        write_register(VOLUME + 'h2c, 1);
        write_register(VOLUME + 'h30, 1);
        snapshot();
        phase = 2;
        for (integer index = 0; index < 32; index = index + 1) begin
            if (VISION_START) vision_step(index);
            snapshot();
        end
        if (VIDEO_FRAMES > 0) begin
            if (!VISION_START) $fatal(1, "C0C_VIDEO_REQUIRES_VISION_START");
            phase = 4;
            checking_video = 1;
            fork
                begin
                    for (integer frame_index = 0; frame_index < VIDEO_FRAMES; frame_index = frame_index + 1)
                        camera_frame(frame_index);
                end
                begin
                    repeat (64) snapshot();
                end
            join
            repeat (2000) @(negedge fabric_clock);
            vision_step(16);
            if (native_pixels != VIDEO_FRAMES * FRAME_WIDTH * FRAME_HEIGHT ||
                rgb_pixels != native_pixels || rgb_frames != VIDEO_FRAMES ||
                rgb_lines != VIDEO_FRAMES * FRAME_HEIGHT || hp_bytes != rgb_pixels * 3 ||
                hp_addresses == 0 || hp_last_beats != hp_addresses || hp_responses != hp_addresses)
                $fatal(1, "C0C_VIDEO_LEDGER native=%0d rgb=%0d frames=%0d lines=%0d bytes=%0d aw=%0d last=%0d b=%0d",
                    native_pixels, rgb_pixels, rgb_frames, rgb_lines, hp_bytes, hp_addresses, hp_last_beats, hp_responses);
            $display("C0C_BD_VIDEO_PASS frames=%0d pixels=%0d bytes=%0d hp_bursts=%0d", rgb_frames, rgb_pixels, hp_bytes, hp_responses);
        end
        phase = 3;
        write_register(VOLUME + 'h30, 2);
        read_register(VOLUME + 'h4c, value);
        if (value <= initial_samples) $fatal(1, "C0C_AUDIO_SAMPLING_STOPPED");
        write_register(VOLUME + 'h2c, 0);
        write_register(VOLUME + 'h30, 1);
        expect_register(VOLUME + 'h18, 2);
        expect_register(VOLUME + 'h10, 8);
        repeat (5) @(negedge fabric_clock);
        if (reads != read_handshakes || writes != write_handshakes)
            $fatal(1, "C0C_LEDGER reads=%0d/%0d writes=%0d/%0d", reads, read_handshakes, writes, write_handshakes);
        $display("C0C_BD_CONTROL_PASS vision_start=%0d snapshots=%0d reads=%0d writes=%0d", VISION_START, snapshots, reads, writes);
        $finish;
    end

    initial begin
        #2000000;
        $fatal(1, "C0C_WATCHDOG phase=%0d address=%h reads=%0d writes=%0d", phase, current_address, reads, writes);
    end
endmodule