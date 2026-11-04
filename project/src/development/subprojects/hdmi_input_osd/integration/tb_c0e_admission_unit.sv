`timescale 1ns/1ps
// Admission/actual release CDC/actual closure budget unit test. No video IP or DDR.
// Run: run_latency_admission_unit.py --output build/hosd/c0e-admission-unit-r01
// Artifacts: source, XSim transcript/WDB/VCD and receipt; next: real-IP full frames.
module tb_c0e_admission_unit;
    reg clk=0,pclk=0,resetn=0,request_open=0,request_close=0,de=0,vsync=0;
    real pclk_half=6.734;
    always #5 clk=~clk;
    always #(pclk_half) pclk=~pclk;
    reg [31:0] released=0;
    wire [2:0] released_video;
    wire enabled,quiescent,boundary_fault,closed,budget_fault;
    wire [31:0] frames,closed_frames;
    wire [63:0] pixels,closed_pixels;
    integer expected_frames=0,expected_pixels=0,checked_frames=0,epochs=0;
    reg [2:0] previous_gray=0;
    reg gray_valid=0;
    reg [2:0] gray_delta;
    vision_release_credit_cdc release_cdc(
        .aclk(clk),.vid_io_in_clk(pclk),.common_aresetn(resetn),
        .released_frames(released),.released_sequence(released_video));
    vision_source_admission admission(
        .vid_io_in_clk(pclk),.common_aresetn(resetn),.request_open(request_open),
        .request_close(request_close),.released_sequence(released_video),
        .vid_active_video(de),.vid_vsync(vsync),.axis_enable(enabled),
        .source_quiescent(quiescent),.boundary_fault(boundary_fault),
        .admitted_frames(frames),.admitted_pixels(pixels));
    vision_source_budget_cdc #(.INPUT_WIDTH(8),.INPUT_HEIGHT(3)) budget(
        .vid_io_in_clk(pclk),.aclk(clk),.common_aresetn(resetn),
        .source_quiescent(quiescent),.admitted_frames(frames),.admitted_pixels(pixels),
        .source_closed(closed),.budget_fault(budget_fault),
        .closed_frame_count(closed_frames),.closed_pixel_count(closed_pixels));
    always @(negedge clk) begin
        if(!resetn) gray_valid=0;
        else begin
            gray_delta=previous_gray^release_cdc.source_gray;
            if(gray_valid && gray_delta!=0 && (gray_delta&(gray_delta-1))!=0)
                $fatal(1,"SOURCE_GRAY_MULTIBIT_CHANGE");
            previous_gray=release_cdc.source_gray;
            gray_valid=1;
        end
    end
    task automatic fresh;
        @(negedge pclk);resetn=0;request_open=0;request_close=0;de=0;vsync=0;
        @(negedge clk);released=0;
        repeat(20) @(negedge pclk);
        resetn=1;
        repeat(30) @(negedge pclk);
        expected_frames=0;expected_pixels=0;epochs=epochs+1;
        if(enabled || frames!=0 || pixels!=0 || released_video!=0 || boundary_fault || closed || budget_fault)
            $fatal(1,"RESET_STATE_MISMATCH");
    endtask
    task automatic open_source;
        request_open=1;repeat(15) @(negedge pclk);
        if(enabled) $fatal(1,"OPEN_BEFORE_FRAME_BOUNDARY");
    endtask
    task automatic release_one;
        @(negedge clk);
        if(released>=expected_frames) $fatal(1,"TEST_RELEASE_UNCOMPLETED_FRAME");
        released=released+1;
    endtask
    task automatic boundary;
        @(negedge pclk);vsync=1;repeat(3) @(negedge pclk);vsync=0;
        repeat(5) @(negedge pclk);
    endtask
    task automatic video_frame(input integer selected,close_mid);
        boundary();
        if(frames!=expected_frames || pixels!=expected_pixels)
            $fatal(1,"BOUNDARY_BUDGET frames=%0d expected=%0d pixels=%0d expected_pixels=%0d",frames,expected_frames,pixels,expected_pixels);
        for(integer y=0;y<3;y=y+1) begin
            de=1;
            for(integer x=0;x<8;x=x+1) begin
                if(enabled!==selected[0]) $fatal(1,"FRAME_SELECTION_CHANGED selected=%0d actual=%b y=%0d x=%0d",selected,enabled,y,x);
                if(close_mid && y==0 && x==4) request_close=1;
                @(negedge pclk);
            end
            de=0;repeat(4) @(negedge pclk);
        end
        if(selected) begin expected_frames=expected_frames+1;expected_pixels=expected_pixels+24;end
        if(pixels!=expected_pixels || boundary_fault || budget_fault)
            $fatal(1,"FRAME_PIXEL_BUDGET_OR_FAULT actual=%0d expected=%0d",pixels,expected_pixels);
        checked_frames=checked_frames+1;
    endtask
    task automatic verify_closed;
        boundary();repeat(25) @(negedge pclk);
        if(!quiescent || !closed || enabled || boundary_fault || budget_fault ||
            frames!=expected_frames || pixels!=expected_pixels ||
            closed_frames!=expected_frames || closed_pixels!=expected_pixels)
            $fatal(1,"CLOSE_BUDGET_OR_STATE frames=%0d expected=%0d pixels=%0d expected_pixels=%0d",closed_frames,expected_frames,closed_pixels,expected_pixels);
        // Closure remains sticky even when CPU releases more frames afterward.
        request_open=1;request_close=0;
        repeat(20) @(negedge pclk);
        if(enabled || !closed || !quiescent || budget_fault) $fatal(1,"CLOSE_REOPENED");
    endtask
    initial begin
        for(integer phase=0;phase<3;phase=phase+1) begin
            if(phase==1) pclk_half=11.137;
            if(phase==2) pclk_half=3.917;
            fresh();open_source();
            repeat(3) video_frame(1,0);
            repeat(5) video_frame(0,0);
            // A release arriving in the middle of a skipped frame must not admit its tail.
            fork
                begin wait(de);repeat(3) @(negedge pclk);release_one();end
                video_frame(0,0);
            join
            video_frame(1,0);
            // Twenty releases exercise several modulo-eight wraps, at all clock ratios.
            repeat(20) begin release_one();repeat(15) @(negedge pclk);video_frame(1,0);end
            // Back-to-back CPU releases may be coalesced by the destination synchronizer.
            repeat(3) release_one();repeat(15) @(negedge pclk);
            repeat(3) video_frame(1,0);
            video_frame(0,1);verify_closed();

            fresh();open_source();video_frame(1,1);verify_closed();
            fresh();request_close=1;repeat(30) @(negedge pclk);verify_closed();
            // Open at VSYNC then close before the first active pixel: legitimate zero-frame stop.
            fresh();open_source();boundary();request_close=1;
            repeat(15) @(negedge pclk);verify_closed();

            fresh();@(negedge clk);released=1;
            repeat(25) @(negedge pclk);
            if(!boundary_fault || enabled) $fatal(1,"ILLEGAL_RELEASE_NOT_REJECTED");
            fresh();open_source();@(negedge pclk);de=1;vsync=1;
            repeat(3) @(negedge pclk);
            if(!boundary_fault) $fatal(1,"VSYNC_ACTIVE_VIDEO_NOT_REJECTED");
        end
        $display("TEST_PASS C0E_ADMISSION_UNIT clocks=3 epochs=%0d checked_source_frames=%0d",epochs,checked_frames);
        $finish;
    end
    initial begin #2000000;$fatal(1,"ADMISSION_UNIT_WATCHDOG");end
endmodule
