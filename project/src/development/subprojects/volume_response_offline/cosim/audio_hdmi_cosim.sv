`timescale 1ns/1ps
// Local XSI top. Run with run_cosim.py (Vivado 2026.1 / xc7z020clg400-1).
// Outputs: serialized.csv, pcm.csv, windows.csv, frames.csv, bar.csv.
// Next: inspect run receipt and independent numeric/pixel comparisons.
// No force/deposit inside DUT; hierarchy below is observation-only.
module audio_hdmi_cosim(
    input wire resetn, codec_locked, codec_active,
    input wire [31:0] request, address, write_data,
    input wire write_request, target_osd,
    input wire [31:0] sample_length,
    input wire [1:0] source_mode, scene_mode,
    output reg [31:0] completed=0, read_data=0,
    output reg [1:0] response=0,
    output reg [31:0] frame_count=0, pixel_errors=0,
    output reg [31:0] decoded_count=0, serial_errors=0,
    output reg [31:0] background_pixels_checked=0, sync_cycles_checked=0
);
    reg aclk=0, pclk=0;
    always #5 aclk=~aclk;
    // 74.25 MHz, rounded to 1 ps precision; no accelerated video frame clock.
    always #6.734 pclk=~pclk;
    reg busy=0, selected=0;
    reg [31:0] tag=0, data=0;
    reg [11:0] addr=0;
    reg av=0,wv=0,rv=0,br=0,rr=0;
    wire [1:0] awready,wready,bvalid,arready,rvalid;
    wire [1:0] bresp[0:1],rresp[0:1];
    wire [31:0] rdata[0:1];
    always @(posedge aclk) begin
        if(!resetn) begin
            completed<=0;busy<=0;av<=0;wv<=0;rv<=0;br<=0;rr<=0;
            read_data<=0;response<=0;selected<=0;tag<=0;addr<=0;data<=0;
        end else begin
            if(!busy && request!=completed) begin
                busy<=1;selected<=target_osd;tag<=request;addr<=address[11:0];data<=write_data;
                av<=write_request;wv<=write_request;rv<=!write_request;
                br<=write_request;rr<=!write_request;
            end
            if(av && awready[selected]) av<=0;
            if(wv && wready[selected]) wv<=0;
            if(rv && arready[selected]) rv<=0;
            if(busy && br && bvalid[selected]) begin
                completed<=tag;response<=bresp[selected];read_data<=0;br<=0;busy<=0;
            end
            if(busy && rr && rvalid[selected]) begin
                completed<=tag;response<=rresp[selected];read_data<=rdata[selected];rr<=0;busy<=0;
            end
        end
    end
    wire bclk,lrclk;
    reg sdata=0;
    wire [1:0] codec_address;
    voice_volume_top volume(
        .s_axi_aclk(aclk),.s_axi_aresetn(resetn),
        .s_axi_awaddr(addr),.s_axi_awprot(3'd0),.s_axi_awvalid(av && !selected),.s_axi_awready(awready[0]),
        .s_axi_wdata(data),.s_axi_wstrb(4'hf),.s_axi_wvalid(wv && !selected),.s_axi_wready(wready[0]),
        .s_axi_bresp(bresp[0]),.s_axi_bvalid(bvalid[0]),.s_axi_bready(br && !selected),
        .s_axi_araddr(addr),.s_axi_arprot(3'd0),.s_axi_arvalid(rv && !selected),.s_axi_arready(arready[0]),
        .s_axi_rdata(rdata[0]),.s_axi_rresp(rresp[0]),.s_axi_rvalid(rvalid[0]),.s_axi_rready(rr && !selected),
        .i2s_bclk(bclk),.i2s_lrclk(lrclk),.i2s_sdata(sdata),
        .codec_address(codec_address),.codec_mclk_locked(codec_locked));

    // Functional codec ADC output: 24-bit stereo I2S, one BCLK delay, 32-bit slots.
    // Timing comes ONLY from physical BCLK/LRCLK ports, never DUT counter state.
    reg [23:0] left_mem[0:99999],right_mem[0:99999];
    reg last_lr=1;
    reg [23:0] left_word=0,right_word=0;
    integer bit_index=0, sample_index=0, last_index=0;
    integer serial_file,pcm_file,window_file,frame_file,bar_file,error_file;
    initial begin
        $readmemh("left.mem",left_mem);
        $readmemh("right.mem",right_mem);
        serial_file=$fopen("serialized.csv","w");
        pcm_file=$fopen("pcm.csv","w");
        window_file=$fopen("windows.csv","w");
        frame_file=$fopen("frames.csv","w");
        bar_file=$fopen("bar.csv","w");
        error_file=$fopen("pixel_errors.csv","w");
        $fdisplay(error_file,"ns,kind,actual,expected,x,y");
        $fdisplay(serial_file,"ns,index,left,right,active,mode");
        $fdisplay(pcm_file,"ns,index,expected,actual,accepted");
        $fdisplay(window_file,"ns,epoch,window,samples,sum,state,faults,pending,kind,sequence");
        $fdisplay(frame_file,"ns,frame,w0,w1,w2,w3,w4,w5,audio_fresh");
        $fdisplay(bar_file,"frame,y,x,rgb,background");
    end
    always @(negedge bclk) begin
        if(resetn!==1'b1) begin last_lr=1;bit_index=0;sdata=0;sample_index=0;left_word=0;right_word=0;end
        else if(lrclk!=last_lr) begin
            last_lr=lrclk;bit_index=0;sdata=0;
            if(!lrclk) begin
                last_index=sample_index;
                left_word=(codec_active && sample_index<sample_length) ? left_mem[sample_index] : 24'd0;
                right_word=(codec_active && sample_index<sample_length) ? right_mem[sample_index] : 24'd0;
                if(source_mode==1) left_word=0; // injected missing LEFT route
                if(source_mode==2) begin left_word=right_word;right_word=0;end
                $fdisplay(serial_file,"%0d,%0d,%0d,%0d,%0d,%0d",$time,sample_index,$signed(left_word),$signed(right_word),codec_active,source_mode);
                sample_index=sample_index+1;
            end
        end else begin
            if(bit_index<24) sdata=lrclk ? right_word[23-bit_index] : left_word[23-bit_index];
            else sdata=0;
            bit_index=bit_index+1;
        end
    end
    always @(posedge aclk) begin
        if(resetn && volume.pcm_valid) begin
            decoded_count<=decoded_count+1;
            if(volume.pcm_s16!==$signed(left_word[23:8])) serial_errors<=serial_errors+1;
            $fdisplay(pcm_file,"%0d,%0d,%0d,%0d,%0d",$time,last_index,$signed(left_word[23:8]),$signed(volume.pcm_s16),
                volume.registers.enable && !volume.registers.configure && volume.registers.faults==0);
        end
        if(resetn && volume.registers.window_valid)
            $fdisplay(window_file,"%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",$time,
                volume.registers.config_epoch,volume.registers.window_count,volume.registers.sample_count,
                volume.registers.last_sum,volume.registers.state,volume.registers.faults,
                volume.registers.event_pending,volume.registers.event_kind,volume.registers.event_sequence);
    end

    // Independent continuous scanout. Scene may be constant or change; no audio consumer required.
    integer hx=0,vy=725;
    wire in_de=hx<1280 && vy<720;
    wire in_hs=hx>=1390 && hx<1430;
    wire in_vs=vy>=725 && vy<730;
    wire [23:0] background=scene_mode==0 ? 24'h102030 :
                              scene_mode==1 ? {8'h20,8'h30,frame_count[7:0]} : 24'h402010;
    wire [23:0] out_rgb;
    wire out_de,out_hs,out_vs;
    always @(posedge pclk) begin
        if(!resetn) begin hx<=0;vy<=725;end
        else if(hx==1649) begin hx<=0;vy<=vy==749 ? 0 : vy+1;end
        else hx<=hx+1;
    end
    input_osd_top osd(
        .aclk(aclk),.aresetn(resetn),.pclk(pclk),.presetn(resetn),
        .awaddr(addr[6:0]),.awvalid(av && selected),.awready(awready[1]),
        .wdata(data),.wstrb(4'hf),.wvalid(wv && selected),.wready(wready[1]),
        .bresp(bresp[1]),.bvalid(bvalid[1]),.bready(br && selected),
        .araddr(addr[6:0]),.arvalid(rv && selected),.arready(arready[1]),
        .rdata(rdata[1]),.rresp(rresp[1]),.rvalid(rvalid[1]),.rready(rr && selected),
        .in_rgb(background),.in_de(in_de),.in_hs(in_hs),.in_vs(in_vs),
        .out_rgb(out_rgb),.out_de(out_de),.out_hs(out_hs),.out_vs(out_vs));

    reg [2:0] de_delay=0,hs_delay=0,vs_delay=0;
    reg [23:0] rgb_delay[0:2];
    integer x_delay[0:2],y_delay[0:2],frame_delay[0:2];
    reg previous_vs=0;
    integer reference_release=0;
    integer p;
    always @(posedge pclk) begin
        if(!resetn) reference_release<=0;
        else if(reference_release<7) reference_release<=reference_release+1;
        de_delay<={de_delay[1:0],in_de};hs_delay<={hs_delay[1:0],in_hs};vs_delay<={vs_delay[1:0],in_vs};
        rgb_delay[0]<=background;x_delay[0]<=hx;y_delay[0]<=vy;frame_delay[0]<=frame_count;
        for(p=1;p<3;p=p+1) begin
            rgb_delay[p]<=rgb_delay[p-1];x_delay[p]<=x_delay[p-1];y_delay[p]<=y_delay[p-1];frame_delay[p]<=frame_delay[p-1];
        end
        previous_vs<=in_vs;
        if(resetn && in_vs && !previous_vs) begin
            frame_count<=frame_count+1;
            // Observe after nonblocking updates, including the atomic CDC commit.
            #0.001;
            $fdisplay(frame_file,"%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",$time,frame_count,
                osd.cfg[31:0],osd.cfg[63:32],osd.cfg[95:64],osd.cfg[127:96],osd.cfg[159:128],osd.cfg[191:160],osd.af);
        end
    end
    always @(negedge pclk) begin
        // External reset release crosses 2FF, then the three pixel registers.
        // The first seven PCLK edges are initialization, not valid scanout.
        if(resetn && reference_release>=7) begin
            sync_cycles_checked<=sync_cycles_checked+1;
            if({out_de,out_hs,out_vs}!=={de_delay[2],hs_delay[2],vs_delay[2]}) begin
                pixel_errors<=pixel_errors+1;
                $fdisplay(error_file,"%0d,sync,%0d,%0d,%0d,%0d",$time,{out_de,out_hs,out_vs},{de_delay[2],hs_delay[2],vs_delay[2]},x_delay[2],y_delay[2]);
            end
            if(de_delay[2] && (x_delay[2]<1262 || x_delay[2]>=1277 || y_delay[2]<240 || y_delay[2]>=480)) begin
                background_pixels_checked<=background_pixels_checked+1;
                if(out_rgb!==rgb_delay[2]) begin
                    pixel_errors<=pixel_errors+1;
                    $fdisplay(error_file,"%0d,background,%0d,%0d,%0d,%0d",$time,out_rgb,rgb_delay[2],x_delay[2],y_delay[2]);
                end
            end
            if(de_delay[2] && y_delay[2]>=240 && y_delay[2]<480 &&
                x_delay[2]>=1262 && x_delay[2]<1277)
                $fdisplay(bar_file,"%0d,%0d,%0d,%0d,%0d",frame_delay[2],y_delay[2],x_delay[2],out_rgb,rgb_delay[2]);
        end
    end
endmodule
