`timescale 1ns/1ps
module rgb_mask_frontend_case #(
    parameter integer WIDTH = 4,
    parameter integer HEIGHT = 4,
    parameter integer GOLD = 0,
    parameter integer CAPTURE = 0
)(output reg done = 0);
    localparam integer OUTPUT_PIXELS = WIDTH * HEIGHT / 4;
    localparam integer FRAMES = GOLD ? 4 : 6;
    localparam string GOLD_ROOT = "E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r259-frontend-reference";
    localparam string CAPTURE_ROOT = "E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r274-capture-output";
    reg aclk = 0;
    always #5 aclk = !aclk;
    reg aresetn = 0;
    reg [23:0] input_data = 0;
    reg input_valid = 0, input_user = 0, input_last = 0;
    wire input_ready;
    reg [47:0] input_thresholds = 0;
    reg [31:0] frame_id = 0, config_id = 0, epoch = 0;
    wire [15:0] output_data, output_width, output_height;
    wire output_valid, output_user, output_last, frame_fault;
    wire [31:0] output_frame, output_config, output_epoch;
    wire [47:0] output_thresholds;
    reg output_ready = 0;
    integer cycles = 0, received = 0, overlapped = 0, max_contexts = 0, input_stalls = 0;
    integer send_frame, pixel_index;
    integer file_handle, bytes_read;
    reg [7:0] image [0:WIDTH*HEIGHT*3-1];
    reg [7:0] raw [0:OUTPUT_PIXELS-1];
    reg [7:0] filtered [0:OUTPUT_PIXELS-1];
    reg checking = 1;
    reg stalled = 0;
    reg [161:0] held_output;
    wire [161:0] current_output = {output_data, output_user, output_last,
        output_epoch, output_config, output_frame, output_thresholds};
    wire [2:0] context_count;
    wire monitor_ready;
    integer packets_received = 0, rgb_received = 0;

    generate if (CAPTURE) begin: capture_case
        wire [23:0] rgb_data;
        wire rgb_valid, rgb_user, rgb_last;
        wire rgb_ready = cycles > 900 && cycles % 17 < 11;
        wire [31:0] packet_data;
        wire [3:0] packet_keep;
        wire packet_valid, packet_last;
        reg [28:0] rgb_held;
        reg [36:0] packet_held;
        reg rgb_stalled = 0, packet_stalled = 0;
        integer packet_file = 0, packet_words = 0;
        axis_rgb_dual_mask_capture #(.INPUT_WIDTH(WIDTH), .INPUT_HEIGHT(HEIGHT)) dut (
            .aclk(aclk), .aresetn(aresetn), .s_axis_tdata(input_data), .s_axis_tvalid(input_valid),
            .s_axis_tready(input_ready), .s_axis_tuser(input_user), .s_axis_tlast(input_last),
            .cfg_frame_context({epoch, config_id, frame_id, input_thresholds}),
            .source_fault(1'b0),
            .m_rgb_tdata(rgb_data), .m_rgb_tvalid(rgb_valid), .m_rgb_tready(rgb_ready),
            .m_rgb_tuser(rgb_user), .m_rgb_tlast(rgb_last), .m_packet_tdata(packet_data),
            .m_packet_tkeep(packet_keep), .m_packet_tvalid(packet_valid),
            .m_packet_tready(output_ready), .m_packet_tlast(packet_last), .frame_fault(frame_fault)
        );
        assign context_count = dut.frontend.context_count;
        assign output_data = dut.mask_data;
        assign output_valid = dut.mask_valid;
        assign monitor_ready = dut.mask_ready;
        assign output_user = dut.mask_user;
        assign output_last = dut.mask_last;
        assign output_frame = dut.mask_frame;
        assign output_config = dut.mask_config;
        assign output_epoch = dut.mask_epoch;
        assign output_thresholds = dut.mask_thresholds;
        assign output_width = WIDTH/2;
        assign output_height = HEIGHT/2;
        always @(posedge aclk) begin
            if (aresetn && !done) begin
                if (rgb_stalled && (!rgb_valid || {rgb_data, rgb_user, rgb_last} !== rgb_held))
                    $fatal(1, "CAPTURE RGB stalled output changed");
                if (packet_stalled && (!packet_valid || {packet_data, packet_keep, packet_last} !== packet_held))
                    $fatal(1, "CAPTURE packet stalled output changed");
                rgb_stalled = rgb_valid && !rgb_ready;
                rgb_held = {rgb_data, rgb_user, rgb_last};
                packet_stalled = packet_valid && !output_ready;
                packet_held = {packet_data, packet_keep, packet_last};
                if (rgb_valid && rgb_ready) begin
                    if (rgb_data !== {image[3*(rgb_received % (WIDTH*HEIGHT))+2],
                        image[3*(rgb_received % (WIDTH*HEIGHT))+1], image[3*(rgb_received % (WIDTH*HEIGHT))]} ||
                        rgb_user !== (rgb_received % (WIDTH*HEIGHT) == 0) ||
                        rgb_last !== (rgb_received % WIDTH == WIDTH-1))
                        $fatal(1, "CAPTURE RGB mismatch pixel=%0d", rgb_received);
                    rgb_received = rgb_received + 1;
                end
                if (packet_valid && output_ready) begin
                    if (!packet_file) packet_file = $fopen($sformatf("%s/h%04d-w%04d-case-%02d.bin", CAPTURE_ROOT, HEIGHT, WIDTH, packets_received), "wb");
                    if (!packet_file || packet_keep !== 4'hf) $fatal(1, "CAPTURE packet file/keep");
                    $fwrite(packet_file, "%c%c%c%c", packet_data[7:0], packet_data[15:8], packet_data[23:16], packet_data[31:24]);
                    packet_words = packet_words + 1;
                    if (packet_last) begin
                        if (packet_words != (OUTPUT_PIXELS+1)/2+16) $fatal(1, "CAPTURE packet length");
                        $fclose(packet_file);
                        packet_file = 0;
                        packet_words = 0;
                        packets_received = packets_received + 1;
                    end
                end
            end
        end
    end else begin: frontend_case
        assign context_count = dut.context_count;
        assign monitor_ready = output_ready;

    axis_rgb_mask_frontend #(.INPUT_WIDTH(WIDTH), .INPUT_HEIGHT(HEIGHT)) dut (
        .aclk(aclk), .aresetn(aresetn), .s_axis_tdata(input_data),
        .s_axis_tvalid(input_valid), .s_axis_tready(input_ready),
        .s_axis_tuser(input_user), .s_axis_tlast(input_last),
        .cfg_h_lo(input_thresholds[7:0]), .cfg_h_hi(input_thresholds[15:8]),
        .cfg_s_lo(input_thresholds[23:16]), .cfg_s_hi(input_thresholds[31:24]),
        .cfg_v_lo(input_thresholds[39:32]), .cfg_v_hi(input_thresholds[47:40]),
        .cfg_frame_id(frame_id), .cfg_config_id(config_id), .cfg_epoch(epoch),
        .m_axis_tdata(output_data), .m_axis_tvalid(output_valid),
        .m_axis_tready(output_ready), .m_axis_tuser(output_user), .m_axis_tlast(output_last),
        .m_frame_id(output_frame), .m_config_id(output_config), .m_epoch(output_epoch),
        .m_thresholds(output_thresholds), .m_width(output_width), .m_height(output_height),
        .frame_fault(frame_fault)
    );
    end endgenerate

    function automatic [47:0] frame_thresholds(input integer frame_number);
        begin
            if (GOLD) begin
                case (frame_number)
                    0: frame_thresholds = {8'd255, 8'd45, 8'd255, 8'd35, 8'd22, 8'd0};
                    1: frame_thresholds = {8'd255, 8'd255, 8'd255, 8'd255, 8'd120, 8'd120};
                    2: frame_thresholds = {8'd255, 8'd0, 8'd255, 8'd1, 8'd179, 8'd0};
                    default: frame_thresholds = {8'd240, 8'd20, 8'd210, 8'd60, 8'd90, 8'd7};
                endcase
            end else frame_thresholds = frame_number % 4 == 1 || frame_number % 4 == 2 ?
                {8'd255, 8'd250, 8'd255, 8'd250, 8'd120, 8'd120} :
                {8'd255, 8'd250, 8'd255, 8'd250, 8'd0, 8'd0};
        end
    endfunction

    always @(negedge aclk) begin
        if (aresetn) begin
            cycles = cycles + 1;
            output_ready = cycles > 1800 && cycles % 13 < 9;
        end
    end

    always @(posedge aclk) begin
        if (!aresetn) stalled = 0;
        else if (!done) begin
            if (checking && frame_fault) $fatal(1, "FRONTEND fault %0dx%0d", WIDTH, HEIGHT);
            if (stalled && (!output_valid || current_output !== held_output))
                $fatal(1, "FRONTEND stall stability %0dx%0d", WIDTH, HEIGHT);
            stalled = output_valid && !monitor_ready;
            held_output = current_output;
            if (context_count > max_contexts) max_contexts = context_count;
            if (input_valid && !input_ready) input_stalls = input_stalls + 1;
            if (context_count > 4) $fatal(1, "FRONTEND context overflow");
            if (input_valid && input_ready && input_user && received < send_frame * OUTPUT_PIXELS)
                overlapped = overlapped + 1;
            if (checking && output_valid && monitor_ready) begin
                if (received >= FRAMES * OUTPUT_PIXELS) $fatal(1, "FRONTEND extra output");
                if (output_data !== (GOLD ? {filtered[received % OUTPUT_PIXELS], raw[received % OUTPUT_PIXELS]} :
                    ((received / OUTPUT_PIXELS) % 2 == 0 ? 16'hffff : 16'h0000)) ||
                    output_user !== (received % OUTPUT_PIXELS == 0) ||
                    output_last !== (received % OUTPUT_PIXELS == OUTPUT_PIXELS-1) ||
                    output_frame !== 32'h10203000 + received / OUTPUT_PIXELS ||
                    output_config !== 32'h40506000 + received / OUTPUT_PIXELS ||
                    output_epoch !== 32'h70809000 + received / OUTPUT_PIXELS ||
                    output_thresholds !== frame_thresholds(received / OUTPUT_PIXELS) ||
                    output_width !== WIDTH/2 || output_height !== HEIGHT/2)
                    $fatal(1, "FRONTEND mismatch %0dx%0d pixel=%0d data=%h frame=%h config=%h epoch=%h",
                        WIDTH, HEIGHT, received, output_data, output_frame, output_config, output_epoch);
                received = received + 1;
            end
        end
    end

    task automatic reset_unit;
        begin
            @(negedge aclk);
            aresetn = 0;
            input_valid = 0;
            repeat (12) @(negedge aclk);
            aresetn = 1;
            repeat (12) @(negedge aclk);
        end
    endtask

    task automatic drive_pixel(input bit user_bit, last_bit);
        begin
            @(negedge aclk);
            input_data = 24'h0000ff;
            input_user = user_bit;
            input_last = last_bit;
            input_valid = 1;
            do @(posedge aclk); while (!input_ready);
            @(negedge aclk);
            input_valid = 0;
        end
    endtask

    task automatic reject_frame(input integer fault_case);
        begin
            reset_unit();
            drive_pixel(fault_case != 0, fault_case == 1);
            if (fault_case == 2) begin
                drive_pixel(0, 0);
                drive_pixel(0, 0);
                drive_pixel(0, 0);
            end
            if (fault_case == 3) drive_pixel(1, 0);
            repeat (10) @(negedge aclk);
            if (!frame_fault || input_ready) $fatal(1, "FRONTEND framing fault not sticky case=%0d", fault_case);
        end
    endtask

    task automatic load_gold(input integer frame_number);
        begin
            file_handle = $fopen($sformatf("%s/h%04d-w%04d-case-%02d-input.bin", GOLD_ROOT, HEIGHT, WIDTH, frame_number), "rb");
            if (!file_handle) $fatal(1, "FRONTEND missing RGB gold");
            bytes_read = $fread(image, file_handle);
            $fclose(file_handle);
            if (bytes_read != WIDTH*HEIGHT*3) $fatal(1, "FRONTEND RGB gold length");
            file_handle = $fopen($sformatf("%s/h%04d-w%04d-case-%02d-raw.bin", GOLD_ROOT, HEIGHT, WIDTH, frame_number), "rb");
            if (!file_handle) $fatal(1, "FRONTEND missing raw gold");
            bytes_read = $fread(raw, file_handle);
            $fclose(file_handle);
            if (bytes_read != OUTPUT_PIXELS) $fatal(1, "FRONTEND raw gold length");
            file_handle = $fopen($sformatf("%s/h%04d-w%04d-case-%02d-filtered.bin", GOLD_ROOT, HEIGHT, WIDTH, frame_number), "rb");
            if (!file_handle) $fatal(1, "FRONTEND missing filtered gold");
            bytes_read = $fread(filtered, file_handle);
            $fclose(file_handle);
            if (bytes_read != OUTPUT_PIXELS) $fatal(1, "FRONTEND filtered gold length");
        end
    endtask

    initial begin
        repeat (12) @(negedge aclk);
        aresetn = 1;
        repeat (12) @(negedge aclk);
        for (send_frame = 0; send_frame < FRAMES; send_frame = send_frame + 1) begin
            if (GOLD) load_gold(send_frame);
            for (pixel_index = 0; pixel_index < WIDTH*HEIGHT; pixel_index = pixel_index + 1) begin
                input_data = GOLD ? {image[3*pixel_index+2], image[3*pixel_index+1], image[3*pixel_index]} :
                    (send_frame % 4 < 2 ? 24'h0000ff : 24'hff0000);
                input_valid = 1;
                input_user = pixel_index == 0;
                input_last = pixel_index % WIDTH == WIDTH-1;
                input_thresholds = pixel_index == 0 ? frame_thresholds(send_frame) : 48'hffffffffffff;
                frame_id = pixel_index == 0 ? 32'h10203000 + send_frame : 32'hdeadbeef;
                config_id = pixel_index == 0 ? 32'h40506000 + send_frame : 32'hbad0cafe;
                epoch = pixel_index == 0 ? 32'h70809000 + send_frame : 32'h12345678;
                @(posedge aclk);
                while (!input_ready) @(posedge aclk);
                @(negedge aclk);
                if (GOLD && send_frame % 2 && pixel_index % 7 == 0) begin
                    input_valid = 0;
                    @(negedge aclk);
                end
            end
            input_valid = 0;
            if (GOLD) begin
                wait (received == (send_frame+1)*OUTPUT_PIXELS);
                if (CAPTURE) wait (packets_received == send_frame+1 && rgb_received == (send_frame+1)*WIDTH*HEIGHT);
            end
        end
        input_valid = 0;
        input_user = 0;
        input_last = 0;
        wait (received == FRAMES*OUTPUT_PIXELS);
        repeat (20) @(negedge aclk);
        if (output_valid || context_count != 0 || (!GOLD && overlapped == 0))
            $fatal(1, "FRONTEND drain/overlap %0dx%0d", WIDTH, HEIGHT);
        if (input_stalls == 0) $fatal(1, "FRONTEND backpressure not exercised");
        $display("FRONTEND_CASE_PASS size=%0dx%0d gold=%0d frames=%0d pairs=%0d overlap=%0d max_contexts=%0d input_stalls=%0d",
            WIDTH, HEIGHT, GOLD, FRAMES, received, overlapped, max_contexts, input_stalls);
        if (!GOLD && WIDTH == 4) begin
            checking = 0;
            reject_frame(0);
            reject_frame(1);
            reject_frame(2);
            reject_frame(3);
            reset_unit();
            drive_pixel(1, 0);
            drive_pixel(0, 0);
            reset_unit();
            if (frame_fault || context_count != 0) $fatal(1, "FRONTEND midframe reset failed");
            received = 0;
            checking = 1;
            frame_id = 32'h10203000;
            config_id = 32'h40506000;
            epoch = 32'h70809000;
            input_thresholds = frame_thresholds(0);
            for (pixel_index = 0; pixel_index < WIDTH*HEIGHT; pixel_index = pixel_index + 1)
                drive_pixel(pixel_index == 0, pixel_index % WIDTH == WIDTH-1);
            wait (received == OUTPUT_PIXELS);
            repeat (20) @(negedge aclk);
            if (frame_fault || output_valid || context_count != 0) $fatal(1, "FRONTEND recovery drain failed");
            $display("FRONTEND_FAULT_RESET_PASS rejected_frames=4 midframe_reset=1 recovery_frames=1");
        end
        done = 1;
    end
endmodule

module tb_axis_rgb_mask_frontend;
    wire small_done, medium_done;
    wire [5:0] gold_done;
    rgb_mask_frontend_case #(.WIDTH(4), .HEIGHT(4)) small_case (.done(small_done));
    rgb_mask_frontend_case #(.WIDTH(32), .HEIGHT(24)) medium_case (.done(medium_done));
    rgb_mask_frontend_case #(.WIDTH(4), .HEIGHT(4), .GOLD(1)) gold_min (.done(gold_done[0]));
    rgb_mask_frontend_case #(.WIDTH(6), .HEIGHT(4), .GOLD(1)) gold_wide (.done(gold_done[1]));
    rgb_mask_frontend_case #(.WIDTH(4), .HEIGHT(6), .GOLD(1)) gold_tall (.done(gold_done[2]));
    rgb_mask_frontend_case #(.WIDTH(6), .HEIGHT(6), .GOLD(1)) gold_odd (.done(gold_done[3]));
    rgb_mask_frontend_case #(.WIDTH(32), .HEIGHT(24), .GOLD(1)) gold_medium (.done(gold_done[4]));
    rgb_mask_frontend_case #(.WIDTH(1280), .HEIGHT(720), .GOLD(1)) gold_full (.done(gold_done[5]));
    initial begin
        wait (small_done && medium_done && &gold_done);
        $display("TEST_PASS RGB_MASK_FRONTEND BOARD_GOLD_CONFIG_IDENTITY_FRAMING_RESET_STALL_OVERLAP frames=37 pairs=923648 gold_pairs=922468");
        $finish;
    end
    initial begin
        #150000000;
        $fatal(1, "FRONTEND watchdog");
    end
endmodule

module tb_axis_rgb_dual_mask_capture;
    wire [5:0] gold_done;
    rgb_mask_frontend_case #(.WIDTH(4), .HEIGHT(4), .GOLD(1), .CAPTURE(1)) gold_min (.done(gold_done[0]));
    rgb_mask_frontend_case #(.WIDTH(6), .HEIGHT(4), .GOLD(1), .CAPTURE(1)) gold_wide (.done(gold_done[1]));
    rgb_mask_frontend_case #(.WIDTH(4), .HEIGHT(6), .GOLD(1), .CAPTURE(1)) gold_tall (.done(gold_done[2]));
    rgb_mask_frontend_case #(.WIDTH(6), .HEIGHT(6), .GOLD(1), .CAPTURE(1)) gold_odd (.done(gold_done[3]));
    rgb_mask_frontend_case #(.WIDTH(32), .HEIGHT(24), .GOLD(1), .CAPTURE(1)) gold_medium (.done(gold_done[4]));
    rgb_mask_frontend_case #(.WIDTH(1280), .HEIGHT(720), .GOLD(1), .CAPTURE(1)) gold_full (.done(gold_done[5]));
    initial begin
        wait (&gold_done);
        $display("TEST_PASS RGB_DUAL_MASK_CAPTURE BOARD_GOLD_RGB_PRESERVED_CONFIG_PACKET_STALL frames=24 pairs=922468 rgb_pixels=3689872");
        $finish;
    end
    initial begin
        #150000000;
        $fatal(1, "CAPTURE watchdog");
    end
endmodule