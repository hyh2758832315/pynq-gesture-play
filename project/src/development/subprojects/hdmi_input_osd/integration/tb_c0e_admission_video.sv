`timescale 1ns/1ps
// Actual generated video_in/demosaic and production C0E capture/lifecycle.
// Fixed 74.25 MHz camera, 100 MHz AXI, 1280 active / 1650 total pixels per line.
// Both output sinks always ready: isolate processing from DDR/GPU contention.
// Five physical 720p frames: accept 1-3, skip 4 at full capacity, release one,
// accept 5, then close and release all remaining tokens. Actual source/budget/owner.
// Always-ready DMA completion model; this is NOT actual DDR or board acceptance.
module tb_c0e_video_rate;
    localparam integer ACTIVE_LINES=32, FRAME_COUNT=1, BLANK_LINES=30;
    reg clk=0,pclk=0,resetn=0,armed=0,de=0,vsync=0;
    always #5 clk=~clk;
    always #6.734 pclk=~pclk;
    reg [7:0] pixel=0;
    reg [5:0] awaddr=0;
    reg [31:0] wdata=0;
    reg awvalid=0,wvalid=0,bready=0;
    wire awready,wready,bvalid;
    wire [1:0] bresp;
    wire [7:0] bayer;
    wire bv,br,bu,bl,overflow,underflow;
    wire [23:0] rgb,out_rgb;
    wire rv,rr,ru,rl,ov,ou,ol,pv,pl;
    wire [31:0] packet;
    wire [3:0] keep;
    wire axis_enable,capture_n,source_fault,monitor_ready;
    wire fault,credit,credit_request,owner_fault;
    wire [2:0] faults;
    wire [3:0] owner_causes;
    wire [31:0] granted;
    wire [31:0] released_frames,available_epoch,available_frame_id,closed_frame_count,admitted_frames;
    wire [63:0] admitted_pixels,closed_pixel_count;
    wire source_closed,pipeline_drained,cpu_available,cpu_held,claim_accepted,release_accepted;
    wire owner_drained,barrier_complete,epoch_sealed,budget_fault,boundary_fault;
    reg cpu_claim=0,cpu_release=0,barrier_request=0;
    reg [31:0] cpu_epoch=0,cpu_frame_id=0;
    integer rgb_frames=0;
    integer packet_file;
    initial begin
        packet_file=$fopen("accepted-packets.hex","w");
        if(packet_file==0) $fatal(1,"PACKET_EVIDENCE_OPEN_FAILED");
    end
    wire [143:0] context_word={32'h12345678,32'd1,32'd1,48'hff46ff141400};
    integer sent=0,bayer_taken=0,rgb_taken=0,rgb_out=0,stalls=0,line_number=-1,packet_words=0,packet_frames=0;
    reg overflow_seen=0;
    wire [9:0] dilation_column=capture.capture.capture.frontend.pair.dilation.scan_column;
    wire [8:0] dilation_row=capture.capture.capture.frontend.pair.dilation.scan_row;
    wire dilation_active=capture.capture.capture.frontend.pair.dilation.active;
    wire skin_ready=capture.capture.capture.frontend.skin_ready;
    wire skin_valid=capture.capture.capture.frontend.skin_valid;
    c6v_video_in_0 video_in(
        .vid_io_in_clk(pclk),.vid_io_in_ce(1'b1),.vid_io_in_reset(!resetn),
        .vid_active_video(de),.vid_vblank(1'b0),.vid_hblank(1'b0),
        .vid_vsync(vsync),.vid_hsync(1'b0),.vid_field_id(1'b0),.vid_data(pixel),
        .aclk(clk),.aclken(1'b1),.aresetn(resetn),.axis_enable(axis_enable),
        .m_axis_video_tdata(bayer),.m_axis_video_tvalid(bv),.m_axis_video_tready(br),
        .m_axis_video_tuser(bu),.m_axis_video_tlast(bl),.overflow(overflow),.underflow(underflow));
    c6v_demosaic_0 demosaic(
        .ap_clk(clk),.ap_rst_n(resetn),
        .s_axi_CTRL_AWADDR(awaddr),.s_axi_CTRL_AWVALID(awvalid),.s_axi_CTRL_AWREADY(awready),
        .s_axi_CTRL_WDATA(wdata),.s_axi_CTRL_WSTRB(4'hf),.s_axi_CTRL_WVALID(wvalid),.s_axi_CTRL_WREADY(wready),
        .s_axi_CTRL_BRESP(bresp),.s_axi_CTRL_BVALID(bvalid),.s_axi_CTRL_BREADY(bready),
        .s_axi_CTRL_ARADDR(6'd0),.s_axi_CTRL_ARVALID(1'b0),.s_axi_CTRL_RREADY(1'b1),
        .s_axis_video_TDATA(bayer),.s_axis_video_TVALID(bv),.s_axis_video_TREADY(br),
        .s_axis_video_TUSER(bu),.s_axis_video_TLAST(bl),.s_axis_video_TKEEP(1'b1),
        .s_axis_video_TSTRB(1'b1),.s_axis_video_TID(1'b0),.s_axis_video_TDEST(1'b0),
        .m_axis_video_TDATA(rgb),.m_axis_video_TVALID(rv),.m_axis_video_TREADY(rr),
        .m_axis_video_TUSER(ru),.m_axis_video_TLAST(rl));
    axis_rgb_capture_bd #(.CONTINUOUS(1),.SEQUENCE_FRAME_IDS(1),.USE_FRAME_CREDITS(1)) capture(
        .aclk(clk),.aresetn(capture_n),.s_axis_tdata(rgb),.s_axis_tkeep(3'b111),
        .s_axis_tvalid(rv),.s_axis_tready(rr),.s_axis_tuser(ru),.s_axis_tlast(rl),
        .cfg_frame_context(context_word),.source_fault(source_fault),.abort_requested(1'b0),
        .source_closed(source_closed),.closed_frame_count(closed_frame_count),.frame_credit_ready(credit),.frame_credit_request(credit_request),
        .m_rgb_tdata(out_rgb),.m_rgb_tvalid(ov),.m_rgb_tready(1'b1),.m_rgb_tuser(ou),.m_rgb_tlast(ol),
        .m_packet_tdata(packet),.m_packet_tkeep(keep),.m_packet_tvalid(pv),.m_packet_tready(1'b1),
        .m_packet_tlast(pl),.frame_fault(fault),.pipeline_drained(pipeline_drained));
    vision_capture_lifecycle lifecycle(
        .aclk(clk),.vid_io_in_clk(pclk),.common_aresetn(resetn),
        .control_capture_aresetn(resetn && armed),.control_armed(armed),
        .control_abort_requested(1'b0),.control_barrier_request(barrier_request),.cfg_frame_context(context_word),
        .vid_active_video(de),.vid_vsync(vsync),.video_overflow(overflow),.aclk_underflow(underflow),
        .capture_fault(fault),.pipeline_drained(pipeline_drained),.dma_drained(1'b1),.dma_fault(1'b0),
        .rgb_completed_frames(rgb_frames),.packet_completed_frames(packet_frames),.status_completed_frames(packet_frames),
        .frame_credit_request(credit_request),.cpu_claim(cpu_claim),.cpu_release(cpu_release),.cpu_command_fault(1'b0),
        .cpu_epoch(cpu_epoch),.cpu_frame_id(cpu_frame_id),.axis_enable(axis_enable),.capture_aresetn(capture_n),
        .capture_source_fault(source_fault),.monitor_ready(monitor_ready),.frame_credit_ready(credit),
        .owner_fault(owner_fault),.owner_fault_causes(owner_causes),.fault_causes(faults),.granted_frames(granted),
        .released_frames(released_frames),.cpu_available(cpu_available),.cpu_held(cpu_held),
        .available_epoch(available_epoch),.available_frame_id(available_frame_id),
        .claim_accepted(claim_accepted),.release_accepted(release_accepted),
        .source_closed(source_closed),.closed_frame_count(closed_frame_count),.closed_pixel_count(closed_pixel_count),
        .admitted_frames(admitted_frames),.admitted_pixels(admitted_pixels),
        .owner_drained(owner_drained),.barrier_complete(barrier_complete),.epoch_sealed(epoch_sealed),
        .budget_fault(budget_fault),.boundary_fault(boundary_fault));
    always @(posedge clk) if(resetn) begin
        if(bv && br) bayer_taken=bayer_taken+1;
        if(rv && rr) rgb_taken=rgb_taken+1;
        if(rv && !rr) stalls=stalls+1;
        if(ov) begin rgb_out=rgb_out+1;if(rgb_out%921600==0) rgb_frames=rgb_frames+1;end
        if(pv) begin
            $fdisplay(packet_file,"%08x",packet);
            packet_words=packet_words+1;if(pl) packet_frames=packet_frames+1;
        end
    end
    always @(posedge pclk) if(resetn && overflow && !overflow_seen) begin
        overflow_seen=1;
        $fatal(1,"ADMISSION_VIDEO_OVERFLOW line=%0d grants=%0d releases=%0d packets=%0d",line_number,granted,released_frames,packet_frames);
        $display("FIRST_OVERFLOW time=%0t line=%0d sent=%0d bayer=%0d rgb=%0d rgb_out=%0d stalls=%0d",$time,line_number,sent,bayer_taken,rgb_taken,rgb_out,stalls);
        $display("OVERFLOW_INTERNAL dilation_active=%b row=%0d column=%0d skin_valid=%b skin_ready=%b",dilation_active,dilation_row,dilation_column,skin_valid,skin_ready);
    end
    task automatic write_reg(input [5:0] address,input [31:0] data);
        @(negedge clk); awaddr=address;wdata=data;awvalid=1;wvalid=1;bready=1;
        fork
            begin
                fork
                    begin do @(posedge clk); while(!awready); @(negedge clk); awvalid=0; end
                    begin do @(posedge clk); while(!wready); @(negedge clk); wvalid=0; end
                join
                while(!bvalid) @(negedge clk);
                if(bresp!==0) $fatal(1,"DEMOSAIC_WRITE_RESPONSE");
                @(negedge clk);bready=0;
            end
            begin repeat(1000) @(negedge clk);$fatal(1,"DEMOSAIC_WRITE_TIMEOUT");end
        join_any
        disable fork;
    endtask
    task automatic release_one;
        if(!cpu_available) $fatal(1,"COMPLETE_FRAME_NOT_AVAILABLE");
        @(negedge clk);cpu_epoch=available_epoch;cpu_frame_id=available_frame_id;cpu_claim=1;
        @(negedge clk);cpu_claim=0;
        if(!claim_accepted || !cpu_held) $fatal(1,"CPU_CLAIM_REJECTED");
        @(negedge clk);cpu_release=1;
        @(negedge clk);cpu_release=0;
        if(!release_accepted || cpu_held) $fatal(1,"CPU_RELEASE_REJECTED");
        repeat(3) @(negedge clk);
    endtask
    initial begin
        #1000;@(negedge clk);resetn=1;
        repeat(30) @(negedge clk);
        write_reg(6'h10,1280);write_reg(6'h18,720);write_reg(6'h28,1);write_reg(0,32'h81);
        armed=1;
        repeat(50) @(negedge pclk);
        for(integer frame=0;frame<FRAME_COUNT;frame=frame+1) begin
          vsync=1;repeat(64) @(negedge pclk);vsync=0;
          repeat(64) @(negedge pclk);
          for(integer y=0;y<ACTIVE_LINES;y=y+1) begin
            line_number=y;de=1;
            for(integer x=0;x<1280;x=x+1) begin
                if(axis_enable !== (frame!=3)) $fatal(1,"WRONG_PHYSICAL_FRAME_ADMISSION frame=%0d enable=%b",frame,axis_enable);
                pixel=x+y;sent=sent+1;@(negedge pclk);
            end
            de=0;repeat(370) @(negedge pclk);
            if(faults!=0 || fault) $fatal(1,"NON_OVERFLOW_FIRST_FAULT faults=%h capture=%b",faults,fault);
          end
          repeat(1650*BLANK_LINES) @(negedge pclk);
          if(frame==3) begin
              if(granted!=3 || released_frames!=0 || rgb_frames!=3 || packet_frames!=3 || packet_words!=345648)
                  $fatal(1,"SKIPPED_FRAME_CHANGED_OUTPUT granted=%0d released=%0d rgb=%0d packet=%0d words=%0d",granted,released_frames,rgb_frames,packet_frames,packet_words);
              release_one();repeat(20) @(negedge pclk);
          end
        end
        barrier_request=1;repeat(20) @(negedge pclk);
        vsync=1;repeat(64) @(negedge pclk);vsync=0;
        repeat(100) @(negedge clk);
        repeat(3) release_one();
        repeat(1000) @(negedge clk);
        if(faults!=0 || fault || overflow_seen || owner_fault || budget_fault || boundary_fault)
            $fatal(1,"VIDEO_FINAL_FAULT faults=%h owner=%h budget=%b boundary=%b",faults,owner_causes,budget_fault,boundary_fault);
        if(rgb_out!=3686400 || granted!=4 || packet_frames!=4 || packet_words!=460864 || released_frames!=4 ||
           closed_frame_count!=4 || closed_pixel_count!=3686400 || admitted_frames!=4 || admitted_pixels!=3686400 ||
           !owner_drained || !pipeline_drained || !barrier_complete || !epoch_sealed || axis_enable || stalls!=0)
            $fatal(1,"VIDEO_ADMISSION_FINAL_COUNTS rgb=%0d grants=%0d packets=%0d words=%0d releases=%0d closed=%0d pixels=%0d owner_drained=%b pipeline=%b barrier=%b sealed=%b stalls=%0d",rgb_out,granted,packet_frames,packet_words,released_frames,closed_frame_count,closed_pixel_count,owner_drained,pipeline_drained,barrier_complete,epoch_sealed,stalls);
        $display("TEST_PASS C0E_VIDEO_RATE_ADMISSION_RECOVERY physical=5 accepted=4 skipped=1 released=4 rgb=%0d words=%0d stalls=%0d sealed=%b",rgb_out,packet_words,stalls,epoch_sealed);
        $fclose(packet_file);
        $finish;
    end
    initial begin #(2000000+FRAME_COUNT*20000000); $fatal(1,"VIDEO_RATE_WATCHDOG");end
endmodule
