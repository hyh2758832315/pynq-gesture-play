`timescale 1ns/1ps
module tb_button_osd;
    reg pclk=0;
    always #5 pclk=~pclk;
    reg resetn=0,in_de=0,in_hs=0,in_vs=0,hand_fresh=0;
    reg [23:0] in_rgb=24'h112233;
    reg [191:0] cfg=0;
    wire [23:0] out_rgb;
    wire out_de,out_hs,out_vs,frame_boundary;
    integer phase=0, green=0, red=0, bad=0, i;
    input_osd_pixels dut(
        .pclk(pclk),.resetn(resetn),.in_rgb(in_rgb),.in_de(in_de),.in_hs(in_hs),.in_vs(in_vs),
        .cfg(cfg),.hand_fresh(hand_fresh),
        .out_rgb(out_rgb),.out_de(out_de),.out_hs(out_hs),.out_vs(out_vs),
        .frame_boundary(frame_boundary)
    );
    always @(posedge pclk) begin
        if(resetn && out_de) begin
            if(out_rgb==24'h0000ff) green=green+1;
            else if(out_rgb==24'hff0000) red=red+1;
            else if(out_rgb!=24'h112233) bad=bad+1;
        end
    end
    task automatic scan_line;
        begin
            resetn=0;in_de=0;
            repeat(4) @(negedge pclk);
            resetn=1;
            for(i=0;i<1280;i=i+1) begin
                in_de=1;
                @(negedge pclk);
            end
            in_de=0;
            repeat(6) @(negedge pclk);
        end
    endtask
    initial begin
        cfg[0]=1;
        cfg[42:32]=640;
        cfg[57:48]=0;
        cfg[3]=1;                // legacy sound-valid bit must have no pixels
        cfg[73:64]=10'h3ff;     // legacy meter level must have no pixels
        cfg[89:80]=10'h3ff;
        cfg[105:96]=10'h3ff;
        scan_line();
        if(green!=0 || red!=0 || bad!=0) $fatal(1,"legacy volume bar painted");
        phase=1;hand_fresh=1;
        scan_line();
        if(green<15 || red!=0 || bad!=0) $fatal(1,"green hand marker missing");
        phase=2;cfg[2]=1;green=0;
        scan_line();
        if(red<15 || green!=0 || bad!=0) $fatal(1,"red fist marker missing");
        $display("BUTTON_OSD_PIXEL_PASS green_and_red_visible audio_bar_absent");
        $finish;
    end
endmodule
