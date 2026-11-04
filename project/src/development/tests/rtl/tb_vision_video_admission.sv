`timescale 1ns/1ps
module tb_vision_video_admission;
    reg aclk = 0, video_clk = 0;
    reg native_clock_run = 1;
    always #5 aclk = ~aclk;
    always #7 if (native_clock_run) video_clk = ~video_clk;
    reg aresetn = 0, axis_enable = 0;
    reg controller_mode = 0, request_open = 0, request_close = 0;
    wire controlled_enable, source_quiescent, boundary_fault;
    wire [31:0] admitted_frames, closed_frames;
    wire [63:0] admitted_pixels, closed_pixels;
    wire budget_closed, budget_fault;
    reg inject_overflow = 0, dma_complete = 0;
    wire monitor_ready, barrier_complete, epoch_sealed;
    wire [2:0] fault_causes;
    reg active_video = 0, video_vsync = 0;
    reg [7:0] video_data = 0;
    wire [7:0] stream_data;
    wire stream_valid, stream_user, stream_last, overflow, underflow;
    reg stream_ready = 0;
    integer ready_mode = 0, cycles = 0;
    integer received = 0, permitted = 64, checks = 0, frames = 0, lines = 0;
    reg stalled = 0, overflow_seen = 0, underflow_seen = 0;
    reg [9:0] held_word = 0;
    reg expected_frame_present = 0, expected_vsync_held = 0;
    reg [31:0] expected_admitted_frames = 0;
    reg [63:0] expected_admitted_pixels = 0;
    integer quiet_oracle_checks = 0;

    vision_epoch_fence fence (
        .vid_io_in_clk(video_clk), .aclk(aclk), .common_aresetn(aresetn),
        .video_overflow(overflow || inject_overflow), .aclk_underflow(underflow),
        .capture_fault(boundary_fault || budget_fault), .source_quiescent(source_quiescent),
        .request_seal(request_close), .pipeline_drained(received == permitted && !stream_valid),
        .dma_drained(dma_complete), .monitor_ready(monitor_ready), .barrier_complete(barrier_complete),
        .epoch_sealed(epoch_sealed), .fault_causes(fault_causes)
    );

    vision_source_admission admission (
        .vid_io_in_clk(video_clk), .common_aresetn(aresetn),
        .request_open(request_open), .request_close(request_close),
        .vid_active_video(active_video), .vid_vsync(video_vsync),
        .axis_enable(controlled_enable), .source_quiescent(source_quiescent), .boundary_fault(boundary_fault),
        .admitted_frames(admitted_frames), .admitted_pixels(admitted_pixels)
    );

    vision_source_budget_cdc #(.INPUT_WIDTH(16), .INPUT_HEIGHT(4)) budget (
        .vid_io_in_clk(video_clk), .aclk(aclk), .common_aresetn(aresetn), .source_quiescent(source_quiescent),
        .admitted_frames(admitted_frames), .admitted_pixels(admitted_pixels),
        .source_closed(budget_closed), .budget_fault(budget_fault),
        .closed_frame_count(closed_frames), .closed_pixel_count(closed_pixels)
    );

    c6v_video_in_0 dut (
        .vid_io_in_clk(video_clk), .vid_io_in_ce(1'b1), .vid_io_in_reset(1'b0),
        .vid_active_video(active_video), .vid_vblank(1'b0), .vid_hblank(1'b0),
        .vid_vsync(video_vsync), .vid_hsync(1'b0), .vid_field_id(1'b0), .vid_data(video_data),
        .aclk(aclk), .aclken(1'b1), .aresetn(aresetn),
        .axis_enable(controller_mode ? controlled_enable : axis_enable),
        .m_axis_video_tdata(stream_data), .m_axis_video_tvalid(stream_valid),
        .m_axis_video_tready(stream_ready), .m_axis_video_tuser(stream_user),
        .m_axis_video_tlast(stream_last), .overflow(overflow), .underflow(underflow)
    );

    task automatic check(input bit condition, input string message);
        begin
            checks = checks + 1;
            if (!condition) $fatal(1, "VIDEO_ADMISSION_FAIL %s received=%0d", message, received);
        end
    endtask

    task automatic video_cycle(input bit active, input bit sync, input integer value);
        begin
            @(negedge video_clk);
            active_video = active;
            video_vsync = sync;
            video_data = value[7:0];
        end
    endtask

    task automatic video_frame(input integer base_value);
        integer row_index, column_index;
        begin
            repeat (4) video_cycle(0, 1, 0);
            repeat (4) video_cycle(0, 0, 0);
            for (row_index = 0; row_index < 4; row_index = row_index + 1) begin
                for (column_index = 0; column_index < 16; column_index = column_index + 1)
                    video_cycle(1, 0, base_value + row_index * 16 + column_index);
                repeat (4) video_cycle(0, 0, 0);
            end
            repeat (16) video_cycle(0, 0, 0);
        end
    endtask

    always @(negedge aclk) begin
        cycles = cycles + 1;
        stream_ready = aresetn && (ready_mode == 1 || (ready_mode == 2 && cycles % 7 >= 2));
    end

    always @(posedge video_clk) begin
        if (aresetn && overflow) overflow_seen <= 1;
        if (!aresetn) begin
            expected_frame_present <= 0;
            expected_vsync_held <= 0;
            expected_admitted_frames <= 0;
            expected_admitted_pixels <= 0;
        end else begin
            expected_vsync_held <= video_vsync;
            if (controlled_enable && active_video) begin
                expected_frame_present <= 1;
                expected_admitted_pixels <= expected_admitted_pixels + 1'b1;
            end
            if (controlled_enable && video_vsync && !expected_vsync_held &&
                !active_video && expected_frame_present) begin
                expected_frame_present <= 0;
                expected_admitted_frames <= expected_admitted_frames + 1'b1;
            end
        end
    end

    always @(negedge video_clk) begin
        if (aresetn && controller_mode && source_quiescent) begin
            check(admitted_frames == expected_admitted_frames &&
                admitted_pixels == expected_admitted_pixels,
                "quiet published before accepted native events settled");
            quiet_oracle_checks = quiet_oracle_checks + 1;
        end
    end

    always @(posedge aclk) begin
        if (aresetn) begin
            if (underflow) underflow_seen <= 1;
            if (stalled) begin
                check(stream_valid === 1'b1, "VALID lost during backpressure");
                check({stream_user, stream_last, stream_data} === held_word, "stalled AXIS changed");
            end
            stalled = stream_valid === 1'b1 && !stream_ready;
            held_word = {stream_user, stream_last, stream_data};
            if (stream_valid && stream_ready) begin
                check(received < permitted, "closed admission leaked pixels");
                check(stream_data === received[7:0], "accepted pixel order/content");
                check(stream_user === (received % 64 == 0), "SOF identity");
                check(stream_last === (received % 16 == 15), "EOL identity");
                if (stream_user) frames = frames + 1;
                if (stream_last) lines = lines + 1;
                received = received + 1;
            end
        end
    end

    initial begin
        repeat (20) @(negedge aclk);
        aresetn = 1;
        repeat (40) @(negedge video_clk);
        axis_enable = 1;
        video_frame(0);
        @(negedge video_clk);
        check(stream_valid === 1'b1 && received == 0, "preclosure frame must be queued");
        axis_enable = 0;
        repeat (20) video_frame(192);
        check(!overflow_seen, "disabled writes overflowed FIFO under held backpressure");
        check(received == 0 && stream_valid === 1'b1, "queued frame lost before read admission");
        @(negedge aclk);
        ready_mode = 1;
        repeat (2) video_frame(192);
        repeat (200) @(negedge aclk);
        check(received == 64 && frames == 1 && lines == 4, "queued frame did not drain exactly");
        check(stream_valid === 1'b0 && !overflow_seen && !underflow_seen, "closed source not clean");

        permitted = 128;
        ready_mode = 2;
        @(negedge video_clk);
        axis_enable = 1;
        video_frame(64);
        @(negedge video_clk);
        axis_enable = 0;
        repeat (2) video_frame(192);
        repeat (200) @(negedge aclk);
        check(received == 128 && frames == 2 && lines == 8, "reopened frame did not drain exactly");
        check(stream_valid === 1'b0 && !overflow_seen && !underflow_seen, "reopened closure not clean");
        $display("TEST_PASS VIDEO_ADMISSION_IP scenarios=2 pixels=%0d frames=%0d lines=%0d checks=%0d", received, frames, lines, checks);

        controller_mode = 1;
        permitted = 256;
        @(negedge aclk);
        request_open = 1;
        repeat (10) @(negedge video_clk);
        check(!controlled_enable && !source_quiescent, "open requires next frame boundary");
        video_frame(128);
        check(controlled_enable && !source_quiescent, "continuous run must remain open");
        fork
            video_frame(192);
            begin
                wait (active_video);
                repeat (8) @(negedge aclk);
                request_close = 1;
                repeat (12) @(negedge aclk);
                check(controlled_enable && !source_quiescent, "midframe close truncated frame");
            end
        join
        check(controlled_enable && !source_quiescent, "closure requires next VSYNC, not blanking");
        video_frame(32);
        check(!controlled_enable && source_quiescent && !boundary_fault, "frame boundary did not close");
        repeat (200) @(negedge aclk);
        check(received == 256 && frames == 4 && lines == 16, "controller accepted-frame loss or duplication");
        @(negedge aclk);
        request_close = 0;
        request_open = 0;
        repeat (10) @(negedge video_clk);
        request_open = 1;
        repeat (20) video_frame(32);
        repeat (200) @(negedge aclk);
        check(!controlled_enable && source_quiescent, "closed epoch reopened without reset");
        check(received == 256 && stream_valid === 1'b0 && !overflow_seen && !underflow_seen,
            "closed controller leaked source pixels");
        check(budget_closed && !budget_fault && closed_frames == 2 && closed_pixels == 128,
            "actual native two-frame closure budget incoherent");
        $display("TEST_PASS VIDEO_ADMISSION_CONTROL scenarios=3 pixels=%0d frames=%0d lines=%0d checks=%0d", received, frames, lines, checks);

        check(monitor_ready && barrier_complete && !epoch_sealed && fault_causes == 0,
            "source acknowledgement must not replace DMA completion");
        @(negedge aclk);
        dma_complete = 1;
        repeat (50) @(negedge aclk);
        check(epoch_sealed && fault_causes == 0, "clean source/pipeline/DMA test oracle did not seal");
        @(negedge video_clk);
        inject_overflow = 1;
        repeat (2) @(negedge video_clk);
        inject_overflow = 0;
        repeat (50) @(negedge aclk);
        check(!epoch_sealed && fault_causes[0], "late source fault did not revoke seal");
        repeat (50) @(negedge aclk);
        check(!epoch_sealed && fault_causes[0] && source_quiescent, "late source fault not sticky");

        @(negedge aclk);
        check(!stream_valid && received == permitted, "test initialization requires emptied IP");
        aresetn = 0;
        dma_complete = 0;
        request_open = 0;
        request_close = 0;
        repeat (20) @(negedge aclk);
        check(!controlled_enable && !source_quiescent && !epoch_sealed && !budget_closed, "reset exposed stale closure");
        aresetn = 1;
        repeat (40) @(negedge video_clk);
        @(negedge aclk);
        request_open = 1;
        request_close = 1;
        repeat (40) @(negedge video_clk);
        check(!controlled_enable && source_quiescent, "close-before-open priority");
        check(budget_closed && !budget_fault && closed_frames == 0 && closed_pixels == 0,
            "cancelled opening retained earlier native budget");
        video_frame(32);
        check(received == 256 && !epoch_sealed, "cancelled opening admitted data or bypassed DMA oracle");

        @(negedge aclk);
        aresetn = 0;
        request_open = 0;
        request_close = 0;
        repeat (20) @(negedge aclk);
        aresetn = 1;
        repeat (40) @(negedge video_clk);
        permitted = 320;
        @(negedge aclk);
        request_open = 1;
        repeat (10) @(negedge video_clk);
        video_frame(0);
        @(negedge aclk);
        request_close = 1;
        repeat (100) @(negedge aclk);
        check(controlled_enable && !source_quiescent && !barrier_complete && !epoch_sealed,
            "blank input without VSYNC falsely acknowledged stop");
        @(negedge video_clk);
        native_clock_run = 0;
        repeat (100) @(negedge aclk);
        check(!source_quiescent && !barrier_complete && !epoch_sealed, "stopped PCLK falsely acknowledged stop");
        native_clock_run = 1;
        repeat (10) @(negedge video_clk);
        video_frame(32);
        repeat (100) @(negedge aclk);
        check(source_quiescent && barrier_complete && !epoch_sealed && fault_causes == 0,
            "resumed boundary must acknowledge source only");
        check(received == 320 && frames == 5 && lines == 20 && !overflow_seen && !underflow_seen,
            "clock pause/boundary completion corrupted accepted frame");
        check(budget_closed && !budget_fault && closed_frames == 1 && closed_pixels == 64,
            "resumed native source closure budget differs");
        $display("TEST_PASS VIDEO_ADMISSION_FENCE scenarios=6 pixels=%0d frames=%0d lines=%0d checks=%0d", received, frames, lines, checks);
        $display("TEST_PASS NATIVE_SOURCE_BUDGET TWO_FRAME128 EMPTY0 RESUMED_FRAME64 RESET_COHERENT");
        check(quiet_oracle_checks > 0, "quiet event scoreboard never exercised");
        $display("TEST_PASS ADMISSION_EVENT_COUNTER_QUIET_ORACLE checks=%0d", quiet_oracle_checks);

        @(negedge aclk);
        aresetn = 0;
        request_open = 0;
        request_close = 0;
        dma_complete = 0;
        repeat (20) @(negedge aclk);
        aresetn = 1;
        repeat (40) @(negedge video_clk);
        permitted = 384;
        request_open = 1;
        repeat (10) @(negedge video_clk);
        video_frame(64);
        request_close = 1;
        repeat (10) video_cycle(0, 0, 0);
        video_cycle(0, 1, 0);
        @(negedge video_clk);
        check(!controlled_enable && !source_quiescent && admitted_frames == 0,
            "closing event must settle before quiet");
        native_clock_run = 0;
        repeat (80) @(negedge aclk);
        check(!source_quiescent && !budget_closed && !barrier_complete,
            "paused pending frame event falsely published closure");
        native_clock_run = 1;
        repeat (100) @(negedge aclk);
        check(source_quiescent && budget_closed && !budget_fault &&
            closed_frames == 1 && closed_pixels == 64,
            "resumed pending frame event budget differs");
        check(received == 384 && frames == 6 && lines == 24,
            "pending event PCLK pause corrupted real stream");

        video_cycle(0, 0, 0);
        @(negedge aclk);
        aresetn = 0;
        request_open = 0;
        request_close = 0;
        repeat (20) @(negedge aclk);
        aresetn = 1;
        repeat (40) @(negedge video_clk);
        request_open = 1;
        repeat (10) @(negedge video_clk);
        repeat (4) video_cycle(0, 1, 0);
        repeat (4) video_cycle(0, 0, 0);
        check(controlled_enable, "pending pixel reset case did not open");
        video_cycle(1, 0, 128);
        @(negedge video_clk);
        check(admitted_pixels == 0, "pixel event did not use registered settlement");
        aresetn = 0;
        active_video = 0;
        request_open = 0;
        request_close = 1;
        repeat (20) @(negedge aclk);
        check(admitted_frames == 0 && admitted_pixels == 0 && !budget_closed,
            "reset retained pending native event");
        aresetn = 1;
        repeat (100) @(negedge aclk);
        check(budget_closed && !budget_fault && closed_frames == 0 && closed_pixels == 0,
            "post-reset empty closure replayed pending event");
        check(received == 384 && !stream_valid, "reset leaked pending pixel into stream");
        $display("TEST_PASS ADMISSION_EVENT_PENDING_CLOCK_RESET scenarios=2 checks=%0d", checks);
        $finish;
    end

    initial begin
        #200000;
        $fatal(1, "VIDEO_ADMISSION_WATCHDOG received=%0d", received);
    end
endmodule

module tb_vision_native_continuous_capture #(
    parameter integer USE_ACTUAL_DMA = 0,
    parameter integer USE_SG_DMA = 0,
    parameter integer USE_RGB_DMA = 0,
    parameter integer USE_FRAME_OWNER = 0,
    parameter integer USE_OWNER_MMIO = 0,
    parameter integer USE_PRODUCTION_LIFECYCLE = 0,
    parameter integer WIDE_PACKET_STREAM = 0,
    parameter integer RECYCLE_RGB_SLOTS = 0,
    parameter integer RECYCLE_PACKET_SLOTS = 0,
    parameter integer FRAME_COUNT = 7,
    parameter OUTPUT_ROOT = "E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r387-native-continuous-capture"
);
    reg clock = 0, video_clock = 0;
    always #5 clock = ~clock;
    always #7 video_clock = ~video_clock;
    reg resetn = 0, request_open = 0, request_close = 0;
    reg native_active = 0, native_vsync = 0;
    reg [7:0] native_data = 0;
    wire enabled, quiet, boundary_fault, budget_closed, budget_fault;
    wire [31:0] admitted_frames, closed_frames;
    wire [63:0] admitted_pixels, closed_pixels;
    wire [7:0] video_data;
    wire video_valid, video_ready, video_user, video_last, overflow, underflow;
    wire monitor_ready, barrier, sealed, pipeline_drained, frame_fault;
    wire [2:0] faults;
    wire [23:0] rgb_data;
    wire rgb_valid, rgb_user, rgb_last, packet_valid, packet_last;
    wire [31:0] packet_data;
    wire [3:0] packet_keep;
    reg block_rgb = 1, block_packet = 1, dma_complete = 0;
    integer cycles = 0, rgb_count = 0, packet_count = 0, checks = 0;
    integer owner_credit_stall_cycles = 0;
    integer frame_index, packet_frame, packet_position, trailer, file_handle = 0;
    reg [31:0] expected, crc = 32'hffffffff;
    wire dma_rgb_ready, dma_rgb_drained, dma_rgb_fault, dma_rgb_done, dma_rgb_armed;
    wire rgb_gate = !(block_rgb && rgb_count == FRAME_COUNT*64-1) && cycles % 7 < 4;
    wire rgb_ready = rgb_gate && dma_rgb_ready;
    wire packet_gate = !(block_packet && packet_count == FRAME_COUNT*24-1) && cycles % 11 < 7;
    wire dma_packet_ready, dma_packet_drained, dma_packet_fault, dma_packet_done;
    wire [31:0] dma_rgb_frames, dma_packet_frames;
    wire owner_grant_request, owner_grant_ready, owner_drained, owner_fault;
    wire owner_available, owner_cpu_held, owner_claimed, owner_released;
    wire [31:0] owner_grant_id, owner_epoch, owner_frame_id, owner_granted_frames, owner_released_frames;
    wire [1:0] owner_grant_slot, owner_available_slot;
    wire [3:0] owner_fault_causes;
    reg owner_cpu_claim = 0, owner_cpu_release = 0;
    reg [31:0] owner_cpu_epoch = 31, owner_cpu_frame_id = 1;
    reg control_awvalid = 0, control_wvalid = 0, control_bready = 0, control_arvalid = 0, control_rready = 0;
    reg [11:0] control_awaddr = 0, control_araddr = 0;
    reg [31:0] control_wdata = 0;
    wire control_awready, control_wready, control_bvalid, control_arready, control_rvalid;
    wire [1:0] control_bresp, control_rresp;
    wire [31:0] control_rdata, control_cpu_epoch, control_cpu_frame_id;
    wire control_cpu_claim, control_cpu_release, control_command_fault, control_armed, control_capture_resetn;
    wire [143:0] control_context;
    wire [143:0] active_context = USE_OWNER_MMIO ? control_context : {32'd31,32'd23,32'd1,48'hff00ff00ff00};
    wire lifecycle_capture_resetn, lifecycle_source_fault;
    wire capture_enabled = USE_PRODUCTION_LIFECYCLE ? lifecycle_capture_resetn :
        monitor_ready && (!USE_OWNER_MMIO || control_capture_resetn);
    reg control_ready = 0;
    integer control_reads = 0, control_writes = 0, control_claims = 0, control_releases = 0;
    reg [31:0] control_status, control_value;
    reg [159:0] control_configuration;
    axi_vision_capture_control #(.OWNER_PROTOCOL(USE_OWNER_MMIO)) owner_control (
        .s_axi_aclk(clock), .s_axi_aresetn(resetn), .common_aresetn(resetn),
        .s_axi_awaddr(control_awaddr), .s_axi_awvalid(control_awvalid), .s_axi_awready(control_awready),
        .s_axi_wdata(control_wdata), .s_axi_wstrb(4'hf), .s_axi_wvalid(control_wvalid), .s_axi_wready(control_wready),
        .s_axi_bresp(control_bresp), .s_axi_bvalid(control_bvalid), .s_axi_bready(control_bready),
        .s_axi_araddr(control_araddr), .s_axi_arvalid(control_arvalid), .s_axi_arready(control_arready),
        .s_axi_rdata(control_rdata), .s_axi_rresp(control_rresp), .s_axi_rvalid(control_rvalid), .s_axi_rready(control_rready),
        .cfg_frame_context(control_context), .capture_aresetn(control_capture_resetn), .armed(control_armed),
        .abort_requested(), .barrier_request(),
        .owner_available(owner_available), .owner_cpu_held(owner_cpu_held), .owner_drained(owner_drained), .owner_fault(owner_fault),
        .owner_claim_accepted(owner_claimed), .owner_release_accepted(owner_released),
        .owner_epoch(owner_epoch), .owner_frame_id(owner_frame_id), .owner_slot({30'd0,owner_available_slot}),
        .owner_granted_frames(owner_granted_frames), .owner_released_frames(owner_released_frames), .owner_fault_causes(owner_fault_causes),
        .owner_cpu_claim(control_cpu_claim), .owner_cpu_release(control_cpu_release),
        .owner_cpu_epoch(control_cpu_epoch), .owner_cpu_frame_id(control_cpu_frame_id), .owner_command_fault(control_command_fault)
    );
    task automatic control_write(input [11:0] address, input [31:0] value);
        begin
            @(negedge clock); control_awaddr = address; control_wdata = value;
            if (control_writes % 2) begin
                control_awvalid = 1;
                do @(posedge clock); while (!control_awready);
                @(negedge clock); control_awvalid = 0;
                repeat (2) @(negedge clock);
                control_wvalid = 1;
                do @(posedge clock); while (!control_wready);
                @(negedge clock); control_wvalid = 0;
            end else begin
                control_wvalid = 1;
                do @(posedge clock); while (!control_wready);
                @(negedge clock); control_wvalid = 0;
                repeat (2) @(negedge clock);
                control_awvalid = 1;
                do @(posedge clock); while (!control_awready);
                @(negedge clock); control_awvalid = 0;
            end
            wait (control_bvalid);
            repeat (3) begin
                @(negedge clock);
                check(control_bvalid && control_bresp == 0 && !control_awready && !control_wready,"MMIO owner write stalled response");
            end
            control_bready = 1;
            @(posedge clock);
            @(negedge clock); control_bready = 0;
            control_writes = control_writes+1;
        end
    endtask
    task automatic control_read(input [11:0] address, output [31:0] value);
        reg [31:0] snapshot;
        begin
            @(negedge clock); control_araddr = address; control_arvalid = 1;
            do @(posedge clock); while (!control_arready);
            @(negedge clock); control_arvalid = 0;
            wait (control_rvalid); snapshot = control_rdata;
            repeat (3) begin
                @(negedge clock);
                check(control_rvalid && control_rresp == 0 && control_rdata === snapshot && !control_arready,"MMIO owner read stalled response");
            end
            value = snapshot; control_rready = 1;
            @(posedge clock);
            @(negedge clock); control_rready = 0;
            control_reads = control_reads+1;
        end
    endtask
    initial if (USE_OWNER_MMIO) begin
        check(USE_FRAME_OWNER,"MMIO owner fixture requires owner");
        wait (resetn && monitor_ready);
        control_configuration = {16'd0,32'd31,32'd23,32'd1,48'hff00ff00ff00};
        control_read(4,control_value); check(control_value == 32'h00020000,"MMIO owner ABI2");
        control_read(12'h068,control_value); check(control_value == 3,"MMIO owner slot capacity");
        for (integer index = 0; index < 5; index = index+1)
            control_write(32+4*index,control_configuration[index*32 +: 32]);
        control_write(16,1);
        check(control_armed && control_capture_resetn && control_context === control_configuration[143:0],"MMIO arm context");
        control_ready = 1;
    end
    wire packet_ready = packet_gate && (!USE_ACTUAL_DMA || dma_packet_ready);
    if (USE_ACTUAL_DMA) begin : actual_dma_sink
        tb_vision_actual_packet_dma #(.EXTERNAL_SOURCE(1), .SCATTER_GATHER(USE_SG_DMA), .WIDE_STREAM(WIDE_PACKET_STREAM), .FRAME_COUNT(FRAME_COUNT),
            .RECYCLE_SLOTS(RECYCLE_PACKET_SLOTS)) receiver (
            .external_clock(clock), .external_resetn(resetn), .external_data(packet_data), .external_keep(packet_keep),
            .external_valid(packet_valid && packet_gate), .external_last(packet_last), .external_closed(budget_closed),
            .allow_final_response(dma_complete), .external_ready(dma_packet_ready), .external_drained(dma_packet_drained),
            .external_fault(dma_packet_fault), .external_done(dma_packet_done), .external_committed_frames(dma_packet_frames),
            .cpu_release_accepted(owner_released), .cpu_released_frames(owner_released_frames), .granted_frames(owner_granted_frames)
        );
    end else begin : oracle_dma_sink
        assign dma_packet_ready = 1;
        assign dma_packet_drained = 1;
        assign dma_packet_fault = 0;
        assign dma_packet_done = 1;
        assign dma_packet_frames = 0;
    end
    if (USE_RGB_DMA) begin : actual_rgb_sink
        initial check(FRAME_COUNT == 3 || (RECYCLE_RGB_SLOTS && USE_FRAME_OWNER),"actual RGB finite or recycled buffer capacity");
        tb_vision_actual_rgb_vdma #(.EXTERNAL_SOURCE(1), .FRAME_COUNT(FRAME_COUNT), .RECYCLE_SLOTS(RECYCLE_RGB_SLOTS)) receiver (
            .external_clock(clock), .external_resetn(resetn), .external_data(rgb_data),
            .external_valid(rgb_valid && rgb_gate), .external_user(rgb_user), .external_last(rgb_last),
            .external_closed(budget_closed), .allow_final_response(dma_complete),
            .external_ready(dma_rgb_ready), .external_drained(dma_rgb_drained),
            .external_fault(dma_rgb_fault), .external_done(dma_rgb_done), .external_armed(dma_rgb_armed),
            .external_committed_frames(dma_rgb_frames), .cpu_release_accepted(owner_released),
            .cpu_released_frames(owner_released_frames), .granted_frames(owner_granted_frames)
        );
    end else begin : oracle_rgb_sink
        assign dma_rgb_ready = 1;
        assign dma_rgb_drained = 1;
        assign dma_rgb_fault = 0;
        assign dma_rgb_done = 1;
        assign dma_rgb_armed = 1;
        assign dma_rgb_frames = 0;
    end

    if (USE_FRAME_OWNER) begin : actual_frame_owner
        initial check(USE_ACTUAL_DMA && USE_RGB_DMA && USE_SG_DMA,"owner requires all actual DMA receivers");
        if (!USE_PRODUCTION_LIFECYCLE) begin : legacy_owner
        vision_frame_owner owner (
            .aclk(clock), .common_aresetn(resetn), .enabled(capture_enabled),
            .upstream_fault(frame_fault || boundary_fault || budget_fault || dma_packet_fault || dma_rgb_fault || (USE_OWNER_MMIO && control_command_fault)),
            .cfg_epoch(active_context[143:112]), .cfg_first_frame_id(active_context[79:48]), .grant_request(owner_grant_request),
            .grant_ready(owner_grant_ready), .grant_frame_id(owner_grant_id), .grant_slot(owner_grant_slot),
            .rgb_completed_frames(dma_rgb_frames), .packet_completed_frames(dma_packet_frames),
            .status_completed_frames(dma_packet_frames), .source_closed(budget_closed), .closed_frame_count(closed_frames),
            .cpu_claim(USE_OWNER_MMIO ? control_cpu_claim : owner_cpu_claim),
            .cpu_release(USE_OWNER_MMIO ? control_cpu_release : owner_cpu_release),
            .cpu_epoch(USE_OWNER_MMIO ? control_cpu_epoch : owner_cpu_epoch),
            .cpu_frame_id(USE_OWNER_MMIO ? control_cpu_frame_id : owner_cpu_frame_id),
            .cpu_available(owner_available), .available_epoch(owner_epoch), .available_frame_id(owner_frame_id),
            .available_slot(owner_available_slot), .cpu_held(owner_cpu_held),
            .claim_accepted(owner_claimed), .release_accepted(owner_released),
            .granted_frames(owner_granted_frames), .released_frames(owner_released_frames),
            .owner_drained(owner_drained), .owner_fault(owner_fault), .fault_causes(owner_fault_causes)
        );
        end
        initial begin
            if (USE_OWNER_MMIO) wait (control_ready);
            for (integer identity = 1; identity <= FRAME_COUNT; identity = identity+1) begin
                if (USE_OWNER_MMIO) begin
                    do begin
                        control_read(12'h04c,control_status);
                        check(!control_status[3],"MMIO owner availability fault");
                    end while (!control_status[0]);
                    control_read(12'h050,control_value); check(control_value == 31,"MMIO owner epoch");
                    control_read(12'h054,control_value); check(control_value == identity,"MMIO owner frame identity");
                    control_read(12'h058,control_value); check(control_value == (identity-1)%3,"MMIO owner available slot");
                    control_write(12'h040,31); control_write(12'h044,identity); control_write(12'h048,1);
                    control_read(12'h04c,control_status);
                    check(control_status == 2 && owner_cpu_held && !owner_fault,"MMIO claim acknowledged before B");
                    control_claims = control_claims+1;
                end else begin
                    wait (owner_available);
                @(negedge clock);
                check(owner_epoch == 31 && owner_frame_id == identity && owner_available_slot == (identity-1)%3,
                    "actual owner available token");
                owner_cpu_epoch = owner_epoch; owner_cpu_frame_id = owner_frame_id; owner_cpu_claim = 1;
                @(negedge clock); owner_cpu_claim = 0;
                check(owner_claimed && owner_cpu_held && !owner_fault,"actual owner claim acknowledgement");
                end
                repeat (identity == 1 ? (RECYCLE_RGB_SLOTS ? 1024 : 64) : 8) begin
                    @(negedge clock);
                    check(owner_cpu_held && !owner_fault && owner_granted_frames-owner_released_frames <= 3,
                        "actual owner exceeded held-buffer capacity");
                end
                for (integer row = 0; row < 4; row = row+1)
                    for (integer column = 0; column < 16; column = column+1) begin
                        check(actual_rgb_sink.receiver.memory_bytes[((identity-1)%3)*256+row*64+column*3] ===
                            8'((identity-1)*64+row*16+column),"CPU RGB payload visibility model");
                        check(actual_rgb_sink.receiver.memory_bytes[((identity-1)%3)*256+row*64+column*3+1] === 8'd0 &&
                            actual_rgb_sink.receiver.memory_bytes[((identity-1)%3)*256+row*64+column*3+2] === 8'd0,
                            "CPU RGB packed channels model");
                    end
                for (integer offset = 0; offset < 96; offset = offset+1)
                    check(actual_dma_sink.receiver.memory_bytes[(RECYCLE_PACKET_SLOTS ? (identity-1)%3 : identity-1)*128+offset] ===
                        actual_dma_sink.receiver.reference_bytes[(identity-1)*96+offset],"CPU packet payload visibility model");
                if (USE_OWNER_MMIO) begin
                    control_write(12'h040,31); control_write(12'h044,identity); control_write(12'h048,2);
                    control_read(12'h060,control_value);
                    check(control_value == identity && !owner_cpu_held && !owner_fault,"MMIO release acknowledged before B");
                    control_releases = control_releases+1;
                end else begin
                    owner_cpu_release = 1;
                    @(negedge clock); owner_cpu_release = 0;
                    check(owner_released && !owner_cpu_held && !owner_fault,"actual owner release acknowledgement");
                end
            end
            if (RECYCLE_RGB_SLOTS) check(owner_credit_stall_cycles >= 64,"owner credit exhaustion was not exercised");
            $display("TEST_PASS ACTUAL_DMA_CPU_OWNER frames=%0d slots=3 CPU_HOLD64 ORDERED_CLAIM_RELEASE RGB_MEMORY PACKET_MEMORY TB_CACHE_MODEL_ONLY",FRAME_COUNT);
            if (RECYCLE_RGB_SLOTS) $display("TEST_PASS ACTUAL_OWNER_CREDIT_STALL cycles=%0d CPU_HOLD1024 NO_DROP_NO_REPLAY",owner_credit_stall_cycles);
            if (USE_OWNER_MMIO) begin
                check(control_claims == FRAME_COUNT && control_releases == FRAME_COUNT && control_writes == 6+6*FRAME_COUNT,
                    "MMIO exact command count");
                $display("TEST_PASS ACTUAL_DMA_OWNER_MMIO frames=%0d claims=%0d releases=%0d reads=%0d writes=%0d ABI2 CPU_REGISTERS REAL_ACK_B RGB3_PACKET3_SG3 TB_CACHE_MODEL_ONLY",FRAME_COUNT,control_claims,control_releases,control_reads,control_writes);
            end
        end
    end else begin : no_frame_owner
        assign owner_grant_ready = 1;
        assign owner_drained = 1;
        assign owner_fault = 0;
    end

    if (USE_PRODUCTION_LIFECYCLE) begin : production_lifecycle
        wire [31:0] available_slot;
        initial check(USE_FRAME_OWNER && USE_OWNER_MMIO,"production lifecycle requires real MMIO owner");
        assign owner_available_slot = available_slot[1:0];
        vision_capture_lifecycle #(.INPUT_WIDTH(16), .INPUT_HEIGHT(4)) lifecycle (
            .aclk(clock), .vid_io_in_clk(video_clock), .common_aresetn(resetn),
            .control_capture_aresetn(control_capture_resetn), .control_armed(control_armed && request_open),
            .control_abort_requested(1'b0), .control_barrier_request(request_close), .cfg_frame_context(active_context),
            .vid_active_video(native_active), .vid_vsync(native_vsync), .video_overflow(overflow), .aclk_underflow(underflow),
            .capture_fault(frame_fault), .pipeline_drained(pipeline_drained),
            .dma_drained(dma_complete && dma_packet_drained && dma_rgb_drained), .dma_fault(dma_packet_fault || dma_rgb_fault),
            .rgb_completed_frames(dma_rgb_frames), .packet_completed_frames(dma_packet_frames), .status_completed_frames(dma_packet_frames),
            .frame_credit_request(owner_grant_request), .cpu_claim(control_cpu_claim), .cpu_release(control_cpu_release),
            .cpu_command_fault(control_command_fault), .cpu_epoch(control_cpu_epoch), .cpu_frame_id(control_cpu_frame_id),
            .axis_enable(enabled), .capture_aresetn(lifecycle_capture_resetn), .capture_source_fault(lifecycle_source_fault), .monitor_ready(monitor_ready),
            .source_quiescent(quiet), .source_closed(budget_closed), .budget_fault(budget_fault), .boundary_fault(boundary_fault),
            .admitted_frames(admitted_frames), .closed_frame_count(closed_frames), .admitted_pixels(admitted_pixels), .closed_pixel_count(closed_pixels),
            .frame_credit_ready(owner_grant_ready), .grant_frame_id(owner_grant_id), .grant_slot(owner_grant_slot),
            .cpu_available(owner_available), .cpu_held(owner_cpu_held), .claim_accepted(owner_claimed), .release_accepted(owner_released),
            .available_epoch(owner_epoch), .available_frame_id(owner_frame_id), .available_slot(available_slot),
            .granted_frames(owner_granted_frames), .released_frames(owner_released_frames),
            .owner_drained(owner_drained), .owner_fault(owner_fault), .owner_fault_causes(owner_fault_causes),
            .barrier_complete(barrier), .epoch_sealed(sealed), .fault_causes(faults)
        );
    end else begin : legacy_admission
    vision_source_admission admission (
        .vid_io_in_clk(video_clock), .common_aresetn(resetn), .request_open(request_open),
        .request_close(request_close), .vid_active_video(native_active), .vid_vsync(native_vsync),
        .axis_enable(enabled), .source_quiescent(quiet), .boundary_fault(boundary_fault),
        .admitted_frames(admitted_frames), .admitted_pixels(admitted_pixels)
    );
    vision_source_budget_cdc #(.INPUT_WIDTH(16), .INPUT_HEIGHT(4)) budget (
        .vid_io_in_clk(video_clock), .aclk(clock), .common_aresetn(resetn), .source_quiescent(quiet),
        .admitted_frames(admitted_frames), .admitted_pixels(admitted_pixels), .source_closed(budget_closed),
        .budget_fault(budget_fault), .closed_frame_count(closed_frames), .closed_pixel_count(closed_pixels)
    );
    end
    c6v_video_in_0 video_input (
        .vid_io_in_clk(video_clock), .vid_io_in_ce(1'b1), .vid_io_in_reset(1'b0),
        .vid_active_video(native_active), .vid_vblank(1'b0), .vid_hblank(1'b0),
        .vid_vsync(native_vsync), .vid_hsync(1'b0), .vid_field_id(1'b0), .vid_data(native_data),
        .aclk(clock), .aclken(1'b1), .aresetn(resetn), .axis_enable(enabled),
        .m_axis_video_tdata(video_data), .m_axis_video_tvalid(video_valid), .m_axis_video_tready(video_ready),
        .m_axis_video_tuser(video_user), .m_axis_video_tlast(video_last), .overflow(overflow), .underflow(underflow)
    );
    if (!USE_PRODUCTION_LIFECYCLE) begin : legacy_fence
    vision_epoch_fence fence (
        .vid_io_in_clk(video_clock), .aclk(clock), .common_aresetn(resetn),
        .video_overflow(overflow), .aclk_underflow(underflow),
        .capture_fault(frame_fault || boundary_fault || budget_fault || dma_packet_fault || dma_rgb_fault || owner_fault), .source_quiescent(quiet),
        .request_seal(request_close), .pipeline_drained(pipeline_drained), .dma_drained(dma_complete && dma_packet_drained && dma_rgb_drained && owner_drained),
        .monitor_ready(monitor_ready), .barrier_complete(barrier), .epoch_sealed(sealed), .fault_causes(faults)
    );
    end
    axis_rgb_capture_bd #(.INPUT_WIDTH(16), .INPUT_HEIGHT(4), .CONTINUOUS(1), .SEQUENCE_FRAME_IDS(1), .USE_FRAME_CREDITS(USE_FRAME_OWNER)) capture (
        .aclk(clock), .aresetn(capture_enabled), .s_axis_tdata({16'd0,video_data}),
        .s_axis_tkeep(3'b111), .abort_requested(1'b0),
        .s_axis_tvalid(video_valid), .s_axis_tready(video_ready), .s_axis_tuser(video_user), .s_axis_tlast(video_last),
        .cfg_frame_context(active_context), .source_fault(USE_PRODUCTION_LIFECYCLE ? lifecycle_source_fault : (|faults[1:0]) || budget_fault),
        .source_closed(budget_closed), .closed_frame_count(closed_frames),
        .frame_credit_ready(owner_grant_ready), .frame_credit_request(owner_grant_request),
        .m_rgb_tdata(rgb_data), .m_rgb_tvalid(rgb_valid), .m_rgb_tready(rgb_ready),
        .m_rgb_tuser(rgb_user), .m_rgb_tlast(rgb_last), .m_packet_tdata(packet_data), .m_packet_tkeep(packet_keep),
        .m_packet_tvalid(packet_valid), .m_packet_tready(packet_ready), .m_packet_tlast(packet_last),
        .frame_fault(frame_fault), .pipeline_drained(pipeline_drained)
    );
    task automatic check(input bit condition, input string message);
        begin
            checks = checks + 1;
            if (!condition) $fatal(1,"NATIVE_CAPTURE_FAIL %s rgb=%0d packet=%0d",message,rgb_count,packet_count);
        end
    endtask
    function automatic [31:0] crc_word(input [31:0] previous_crc, value);
        reg [31:0] work;
        integer bit_index;
        begin
            work = previous_crc ^ value;
            for (bit_index = 0; bit_index < 32; bit_index = bit_index + 1)
                work = (work >> 1) ^ (work[0] ? 32'hedb88320 : 0);
            crc_word = work;
        end
    endfunction
    task automatic video_cycle(input bit active, input bit sync, input integer value);
        @(negedge video_clock);
        native_active = active; native_vsync = sync; native_data = value[7:0];
    endtask
    task automatic video_frame(input integer base_value);
        integer row_index, column_index;
        repeat (4) video_cycle(0,1,0);
        repeat (4) video_cycle(0,0,0);
        for (row_index = 0; row_index < 4; row_index = row_index + 1) begin
            for (column_index = 0; column_index < 16; column_index = column_index + 1)
                video_cycle(1,0,base_value + row_index*16 + column_index);
            repeat (4) video_cycle(0,0,0);
        end
        repeat (16) video_cycle(0,0,0);
    endtask
    always @(negedge clock) cycles = cycles + 1;
    always @(posedge clock) begin
        if (monitor_ready) begin
            if (USE_FRAME_OWNER && owner_cpu_held && !owner_grant_ready && owner_granted_frames-owner_released_frames == 3)
                owner_credit_stall_cycles <= owner_credit_stall_cycles+1;
            check(!frame_fault && !budget_fault && faults == 0, "unexpected source/pipeline fault");
            if (rgb_valid && rgb_ready) begin
                check(rgb_count < FRAME_COUNT*64 && rgb_data === {16'd0,8'(rgb_count)} &&
                    rgb_user == (rgb_count % 64 == 0) && rgb_last == (rgb_count % 16 == 15), "RGB data/identity boundary");
                rgb_count <= rgb_count + 1;
            end
            if (packet_valid && packet_ready) begin
                packet_frame = packet_count / 24;
                packet_position = packet_count % 24;
                if (packet_position == 0) begin
                    file_handle = $fopen($sformatf("%s/frame-%0d.bin",OUTPUT_ROOT,packet_frame),"wb");
                    check(file_handle != 0, "packet trace open");
                end
                if (packet_position < 8) expected = 32'hffffffff;
                else begin
                    trailer = packet_position - 8;
                    case (trailer)
                        0: expected = 32'h31534d44;
                        1: expected = 32'h00100001;
                        2: expected = packet_frame + 1;
                        3: expected = 23;
                        4: expected = 31;
                        5: expected = 32'h00020008;
                        6: expected = 16;
                        7: expected = 32;
                        9: expected = 32'hff00ff00;
                        10: expected = 32'h0000ff00;
                        11: expected = 32'h00010802;
                        15: expected = ~crc;
                        default: expected = 0;
                    endcase
                end
                check(packet_count < FRAME_COUNT*24 && packet_data === expected && packet_keep == 15 &&
                    packet_last == (packet_position == 23), "DMS1 identity/content/CRC");
                $fwrite(file_handle,"%c%c%c%c",packet_data[7:0],packet_data[15:8],packet_data[23:16],packet_data[31:24]);
                if (packet_last) begin $fclose(file_handle); file_handle = 0; crc = 32'hffffffff; end
                else crc = crc_word(crc,packet_data);
                packet_count <= packet_count + 1;
            end
        end
    end
    initial begin
        repeat (20) @(negedge clock);
        resetn = 1;
        wait (monitor_ready);
        if (USE_OWNER_MMIO) wait (control_ready);
        wait (dma_rgb_armed);
        repeat (10) @(negedge video_clock);
        request_open = 1;
        repeat (10) @(negedge video_clock);
        for (frame_index = 0; frame_index < FRAME_COUNT-1; frame_index = frame_index + 1) video_frame(frame_index*64);
        fork
            video_frame((FRAME_COUNT-1)*64);
            begin
                wait (native_active);
                repeat (8) @(negedge clock);
                request_close = 1;
            end
        join
        check(!quiet && !budget_closed && !pipeline_drained, "blanking falsely closed source");
        repeat (20) video_frame(192);
        check(quiet && budget_closed && closed_frames == FRAME_COUNT && closed_pixels == FRAME_COUNT*64 && !overflow && !underflow,
            "actual native closure budget");
        wait (packet_valid && packet_last && packet_count == FRAME_COUNT*24-1);
        repeat (20) @(negedge clock);
        check(!pipeline_drained && !sealed, "last packet did not block drain");
        block_packet = 0;
        wait (packet_count == FRAME_COUNT*24);
        repeat (10) @(negedge clock);
        check(rgb_count == FRAME_COUNT*64-1 && !pipeline_drained && !sealed, "last RGB did not block drain");
        block_rgb = 0;
        wait (rgb_count == FRAME_COUNT*64);
        repeat (30) @(negedge clock);
        check(pipeline_drained && barrier && !sealed, "real native/pipeline budget closure or DMA isolation");
        check((!USE_RGB_DMA || dma_rgb_frames < FRAME_COUNT) &&
            (!USE_ACTUAL_DMA || dma_packet_frames < FRAME_COUNT),"DMA frame receipts before final B");
        dma_complete = 1;
        wait (dma_packet_done && dma_rgb_done && owner_drained);
        repeat (30) @(negedge clock);
        check(sealed && faults == 0 && !frame_fault && !budget_fault, "source/pipeline/fence final closure");
        check((!USE_RGB_DMA || dma_rgb_frames == FRAME_COUNT) &&
            (!USE_ACTUAL_DMA || dma_packet_frames == FRAME_COUNT),"DMA final frame receipts");
        if (RECYCLE_RGB_SLOTS)
            $display("TEST_PASS NATIVE_OWNED_RGB_RECYCLE frames=%0d pixels=%0d packet_words=%0d checks=%0d REAL_VIDEOIN RGB_VDMA PACKET_SG STATUS_B CPU_RELEASE FENCE_SEALED MODEL_ONLY",FRAME_COUNT,FRAME_COUNT*64,FRAME_COUNT*24,checks);
        else if (USE_RGB_DMA)
            $display("TEST_PASS NATIVE_DUAL_ACTUAL_DMA frames=%0d pixels=%0d packet_words=%0d checks=%0d REAL_VIDEOIN RGB_VDMA PACKET_SG STATUS_B_SETTLED FENCE_SEALED FINITE_ONLY",FRAME_COUNT,FRAME_COUNT*64,FRAME_COUNT*24,checks);
        else
            $display("TEST_PASS NATIVE_CONTINUOUS_CAPTURE frames=%0d pixels=%0d packet_words=%0d checks=%0d SOURCE_BUDGET_REAL_RTL DMA_ORACLE ACTUAL_PACKET_DMA=%0d RGB_DMA_ORACLE",FRAME_COUNT,FRAME_COUNT*64,FRAME_COUNT*24,checks,USE_ACTUAL_DMA);
        $finish;
    end
    initial begin
        #3000000;
        $fatal(1,"NATIVE_CAPTURE watchdog rgb=%0d packet=%0d",rgb_count,packet_count);
    end
endmodule

module tb_vision_native_actual_dma;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r397-native-actual-dma")
    ) cases ();
endmodule

module tb_vision_native_actual_dma_recheck;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r398-native-dma-recheck")
    ) cases ();
endmodule

module tb_vision_native_oracle_compat;
    tb_vision_native_continuous_capture #(
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r399-dma-compat/native-oracle")
    ) cases ();
endmodule

module tb_vision_native_direct_dma_compat;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r405-native-sg-dma/direct")
    ) cases ();
endmodule

module tb_vision_native_sg_dma;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r405-native-sg-dma/sg")
    ) cases ();
endmodule

module tb_vision_native_sg_dma_settled;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r407-native-sg-settlement/sg")
    ) cases ();
endmodule

module tb_vision_native_direct_dma_settled;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r407-native-sg-settlement/direct")
    ) cases ();
endmodule

module tb_vision_native_dual_dma;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1), .USE_RGB_DMA(1), .FRAME_COUNT(3),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r414-native-dual-dma/dual")
    ) cases ();
endmodule

module tb_vision_native_sg_parameter_compat;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r414-native-dual-dma/compat")
    ) cases ();
endmodule

module tb_vision_native_dual_dma_armed;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1), .USE_RGB_DMA(1), .FRAME_COUNT(3),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r415-native-dual-armed/dual")
    ) cases ();
endmodule

module tb_vision_native_sg_armed_compat;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r415-native-dual-armed/compat")
    ) cases ();
endmodule

module tb_vision_native_dual_dma_bd;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1), .USE_RGB_DMA(1), .FRAME_COUNT(3),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r416-native-bd-dma/dual")
    ) cases ();
endmodule

module tb_vision_native_sg_bd_compat;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r416-native-bd-dma/compat")
    ) cases ();
endmodule

module tb_vision_native_dual_dma_receipts;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1), .USE_RGB_DMA(1), .FRAME_COUNT(3),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r419-actual-frame-receipts/dual")
    ) cases ();
endmodule

module tb_vision_native_sg_receipt_compat;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r419-actual-frame-receipts/compat")
    ) cases ();
endmodule

module tb_vision_native_dual_dma_owned;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1), .USE_RGB_DMA(1), .USE_FRAME_OWNER(1), .FRAME_COUNT(3),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r422-native-owner/dual")
    ) cases ();
endmodule

module tb_vision_native_sg_owner_compat;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r422-native-owner/compat")
    ) cases ();
endmodule

module tb_vision_native_rgb_owner_recycle;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1), .USE_RGB_DMA(1), .USE_FRAME_OWNER(1),
        .RECYCLE_RGB_SLOTS(1), .FRAME_COUNT(7),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r425-rgb-owner-recycle/packets")
    ) cases ();
endmodule

module tb_vision_native_dual_owner_recycle;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1), .USE_RGB_DMA(1), .USE_FRAME_OWNER(1),
        .RECYCLE_RGB_SLOTS(1), .RECYCLE_PACKET_SLOTS(1), .FRAME_COUNT(7),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r426-dual-owner-recycle/packets")
    ) cases ();
endmodule

module tb_vision_native_dual_owner_mmio;
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1), .USE_RGB_DMA(1), .USE_FRAME_OWNER(1), .USE_OWNER_MMIO(1),
        .RECYCLE_RGB_SLOTS(1), .RECYCLE_PACKET_SLOTS(1), .FRAME_COUNT(7),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r429-dual-owner-mmio/packets")
    ) cases ();
endmodule

module tb_vision_native_production_lifecycle #(
    parameter OUTPUT_ROOT = "E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r439-production-lifecycle/packets"
);
    tb_vision_native_continuous_capture #(
        .USE_ACTUAL_DMA(1), .USE_SG_DMA(1), .USE_RGB_DMA(1), .USE_FRAME_OWNER(1), .USE_OWNER_MMIO(1),
        .USE_PRODUCTION_LIFECYCLE(1), .WIDE_PACKET_STREAM(1), .RECYCLE_RGB_SLOTS(1), .RECYCLE_PACKET_SLOTS(1),
        .OUTPUT_ROOT(OUTPUT_ROOT)
    ) cases ();
endmodule

module tb_vision_budget_validation #(
    parameter integer INPUT_WIDTH = 16,
    parameter integer INPUT_HEIGHT = 4,
    parameter bit TEST_WIDE_BUDGETS = 1'b0
);
    timeunit 1ns; timeprecision 1ps;
    localparam logic [63:0] FRAME_PIXELS = 64'd1 * INPUT_WIDTH * INPUT_HEIGHT;
    reg aclk = 0, vid_io_in_clk = 0, common_aresetn = 0, source_quiescent = 0;
    reg [31:0] admitted_frames = 0;
    reg [63:0] admitted_pixels = 0;
    wire source_closed, budget_fault;
    wire [31:0] closed_frame_count;
    wire [63:0] closed_pixel_count;
    integer scenarios = 0;
    always #5 aclk = !aclk;
    always #7 vid_io_in_clk = !vid_io_in_clk;
    vision_source_budget_cdc #(.INPUT_WIDTH(INPUT_WIDTH), .INPUT_HEIGHT(INPUT_HEIGHT)) dut (.*);
    always @(posedge aclk) begin
        #0.001;
        if (source_closed && !budget_fault && closed_pixel_count != FRAME_PIXELS*closed_frame_count)
            $fatal(1,"BUDGET_VALIDATION exposed unchecked malformed closure");
    end
    task automatic reset_case(input [31:0] frames, input [63:0] pixels);
        begin
            @(negedge aclk); common_aresetn = 0; source_quiescent = 0;
            admitted_frames = frames; admitted_pixels = pixels;
            repeat (10) @(negedge aclk);
            if (source_closed || budget_fault) $fatal(1,"BUDGET_VALIDATION stale reset receipt");
            common_aresetn = 1;
            repeat (10) @(negedge aclk);
            source_quiescent = 1;
        end
    endtask
    task automatic await_result(input bit expect_fault);
        integer cycles;
        begin
            cycles = 0;
            while (!(expect_fault ? budget_fault : source_closed) && cycles < 100) begin
                @(negedge aclk); cycles = cycles+1;
            end
            if (cycles == 100 || budget_fault !== expect_fault ||
                (!expect_fault && (closed_frame_count != admitted_frames || closed_pixel_count != admitted_pixels)))
                $fatal(1,"BUDGET_VALIDATION result mismatch scenario=%0d",scenarios);
            repeat (10) @(negedge aclk);
            if (budget_fault !== expect_fault) $fatal(1,"BUDGET_VALIDATION unstable result");
            scenarios = scenarios+1;
        end
    endtask
    initial begin
        reset_case(3,3*FRAME_PIXELS); await_result(0);
        reset_case(3,3*FRAME_PIXELS-1); await_result(1);
        reset_case(0,0); await_result(0);
        admitted_frames = 1; admitted_pixels = FRAME_PIXELS; await_result(1);
        if (TEST_WIDE_BUDGETS) begin
            reset_case(32'hFFFFFFFF,64'hFFFFFFFF*FRAME_PIXELS); await_result(0);
            reset_case(32'hFFFFFFFF,64'hFFFFFFFF*FRAME_PIXELS+1); await_result(1);
            reset_case(3,3*FRAME_PIXELS);
            for (integer wait_cycles=0; wait_cycles<100 && !dut.budget_product_ready; wait_cycles=wait_cycles+1)
                @(negedge aclk);
            if (!dut.budget_product_ready) $fatal(1,"BUDGET_VALIDATION product-stage timeout");
            common_aresetn = 0;
            #0.001;
            if (source_closed || budget_fault) $fatal(1,"BUDGET_VALIDATION product-stage reset receipt");
            reset_case(3,3*FRAME_PIXELS); await_result(0);
        end
        $display("TEST_PASS BUDGET_VALIDATION scenarios=%0d VALID3 MALFORMED_REJECTED_NO_EARLY_CLOSE EMPTY0 MUTATION_FAULT RESET_CLEAR",scenarios);
        $finish;
    end
    initial begin #20000; $fatal(1,"BUDGET_VALIDATION watchdog"); end
endmodule