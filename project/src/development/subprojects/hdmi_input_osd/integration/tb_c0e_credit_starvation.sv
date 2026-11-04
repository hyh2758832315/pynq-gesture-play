`timescale 1ns/1ps
// Actual generated video_in/demosaic and production C0E capture/lifecycle.
// Fixed 74.25 MHz camera, 100 MHz AXI, 1280 active / 1650 total pixels per line.
// Both output sinks always ready: isolate processing from DDR/GPU contention.
// Four full frames, no CPU claim/release. Expect exactly three complete frames
// followed by overflow from exhausted ownership credits. Reproduction, NOT repair.
// Run via run_latency_video_rate.py --credit-starvation --dilation <prewarm RTL>
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
    wire [143:0] context_word={32'h12345678,32'd1,32'd1,48'hff46ff141400};
    integer sent=0,bayer_taken=0,rgb_taken=0,rgb_out=0,stalls=0,line_number=-1,packet_words=0,packet_frames=0;
    reg overflow_seen=0;
    integer fault_trailer_words=0;
    reg [31:0] fault_crc=32'hffffffff;
    function automatic [31:0] crc32_word(input [31:0] previous_crc, value);
        reg [31:0] work;
        begin
            work=previous_crc^value;
            for(integer bit_index=0;bit_index<32;bit_index=bit_index+1)
                work=(work>>1)^(work[0]?32'hedb88320:32'd0);
            crc32_word=work;
        end
    endfunction
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
        .source_closed(1'b0),.closed_frame_count(32'd0),.frame_credit_ready(credit),.frame_credit_request(credit_request),
        .m_rgb_tdata(out_rgb),.m_rgb_tvalid(ov),.m_rgb_tready(1'b1),.m_rgb_tuser(ou),.m_rgb_tlast(ol),
        .m_packet_tdata(packet),.m_packet_tkeep(keep),.m_packet_tvalid(pv),.m_packet_tready(1'b1),
        .m_packet_tlast(pl),.frame_fault(fault),.pipeline_drained());
    vision_capture_lifecycle lifecycle(
        .aclk(clk),.vid_io_in_clk(pclk),.common_aresetn(resetn),
        .control_capture_aresetn(resetn && armed),.control_armed(armed),
        .control_abort_requested(1'b0),.control_barrier_request(1'b0),.cfg_frame_context(context_word),
        .vid_active_video(de),.vid_vsync(vsync),.video_overflow(overflow),.aclk_underflow(underflow),
        .capture_fault(fault),.pipeline_drained(1'b0),.dma_drained(1'b1),.dma_fault(1'b0),
        .rgb_completed_frames(32'd0),.packet_completed_frames(32'd0),.status_completed_frames(32'd0),
        .frame_credit_request(credit_request),.cpu_claim(1'b0),.cpu_release(1'b0),.cpu_command_fault(1'b0),
        .cpu_epoch(32'd0),.cpu_frame_id(32'd0),.axis_enable(axis_enable),.capture_aresetn(capture_n),
        .capture_source_fault(source_fault),.monitor_ready(monitor_ready),.frame_credit_ready(credit),
        .owner_fault(owner_fault),.owner_fault_causes(owner_causes),.fault_causes(faults),.granted_frames(granted));
    always @(posedge clk) if(resetn) begin
        if(bv && br) bayer_taken=bayer_taken+1;
        if(rv && rr) rgb_taken=rgb_taken+1;
        if(rv && !rr) stalls=stalls+1;
        if(ov) rgb_out=rgb_out+1;
        if(pv) begin
            if(packet_words>=345648) begin
                if(faults!=5 || !overflow_seen) $fatal(1,"UNEXPECTED_FOURTH_PACKET_BEFORE_FAULT");
                if(fault_trailer_words==0 && packet!==32'h31534d44) $fatal(1,"FAULT_TRAILER_MAGIC");
                if(fault_trailer_words==1 && packet!==32'h00100001) $fatal(1,"FAULT_TRAILER_VERSION");
                if((fault_trailer_words==6 || fault_trailer_words==7) && packet!==0)
                    $fatal(1,"UNGRANTED_FRAME_HAS_PAYLOAD");
                if(fault_trailer_words==8 && packet!==8) $fatal(1,"FAULT_TRAILER_STATUS");
                if(pl !== (fault_trailer_words==15)) $fatal(1,"FAULT_TRAILER_TLAST");
                if(fault_trailer_words==15) begin
                    if(packet!==~fault_crc) $fatal(1,"FAULT_TRAILER_CRC");
                end else fault_crc=crc32_word(fault_crc,packet);
                fault_trailer_words=fault_trailer_words+1;
            end
            packet_words=packet_words+1;
            if(pl) packet_frames=packet_frames+1;
        end
    end
    always @(posedge pclk) if(resetn && overflow && !overflow_seen) begin
        overflow_seen=1;
        if(granted!==3 || credit!==0 || axis_enable!==1 ||
           rgb_out!=2764800 || packet_frames!=3 || packet_words!=345648)
            $fatal(1,"PRE_FAULT_CAPACITY_SIGNATURE granted=%0d credit=%b enable=%b rgb=%0d packets=%0d words=%0d",granted,credit,axis_enable,rgb_out,packet_frames,packet_words);
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
                pixel=x+y;sent=sent+1;@(negedge pclk);
            end
            de=0;repeat(370) @(negedge pclk);
            if(overflow_seen) begin
                repeat(100) @(negedge clk);
                if(frame!=3 || faults!==5 || owner_causes!==1 || granted!==3 || credit!==0 ||
                   rgb_out!=2764800 || packet_frames!=4 || packet_words!=345664 || fault_trailer_words!=16)
                    $fatal(1,"OVERFLOW_SIGNATURE_DIFF frame=%0d faults=%h owner=%h granted=%0d rgb=%0d packets=%0d words=%0d fault_words=%0d",frame,faults,owner_causes,granted,rgb_out,packet_frames,packet_words,fault_trailer_words);
                $display("TEST_PASS C0E_VIDEO_RATE_CREDIT_STARVATION_REPRODUCED faults=%h owner=%h granted=%d complete_frames=3 fault_trailers=1 rgb=%0d words=%0d",faults,owner_causes,granted,rgb_out,packet_words);
                $finish;
            end
            if(faults!=0 || fault) $fatal(1,"NON_OVERFLOW_FIRST_FAULT faults=%h capture=%b",faults,fault);
          end
          repeat(1650*BLANK_LINES) @(negedge pclk);
        end
        $fatal(1,"EXPECTED_CREDIT_STARVATION_NOT_REPRODUCED");
    end
    initial begin #(2000000+FRAME_COUNT*20000000); $fatal(1,"VIDEO_RATE_WATCHDOG");end
endmodule
