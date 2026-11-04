`timescale 1ns/1ps
module tb_input_osd;
`ifdef FULL_HDMI
    localparam W=1280,H=720;
`else
    localparam W=64,H=300;
`endif
    reg aclk=0,pclk=0,aresetn=0,presetn=0;
    always #5 aclk=~aclk;
    always #7 pclk=~pclk; // unrelated 100 / 71.43 MHz clocks
    reg [6:0] awaddr=0,araddr=0;
    reg awvalid=0,wvalid=0,bready=0,arvalid=0,rready=0;
    reg [31:0] wdata=0;reg [3:0] wstrb=15;
    wire awready,wready,bvalid,arready,rvalid;wire [1:0] bresp,rresp;wire [31:0] rdata;
    reg [23:0] in_rgb=24'h123456;reg in_de=0,in_hs=0,in_vs=0;
    wire [23:0] out_rgb;wire out_de,out_hs,out_vs;
    input_osd_axi #(.WIDTH(W),.HEIGHT(H)) dut(
        .s_axi_aclk(aclk),.s_axi_aresetn(aresetn),.pclk(pclk),.presetn(presetn),
        .s_axi_awaddr(awaddr),.s_axi_awprot(3'b0),.s_axi_awvalid(awvalid),.s_axi_awready(awready),
        .s_axi_wdata(wdata),.s_axi_wstrb(wstrb),.s_axi_wvalid(wvalid),.s_axi_wready(wready),
        .s_axi_bresp(bresp),.s_axi_bvalid(bvalid),.s_axi_bready(bready),
        .s_axi_araddr(araddr),.s_axi_arprot(3'b0),.s_axi_arvalid(arvalid),.s_axi_arready(arready),
        .s_axi_rdata(rdata),.s_axi_rresp(rresp),.s_axi_rvalid(rvalid),.s_axi_rready(rready),
        .in_rgb(in_rgb),.in_de(in_de),.in_hs(in_hs),.in_vs(in_vs),
        .out_rgb(out_rgb),.out_de(out_de),.out_hs(out_hs),.out_vs(out_vs));
    integer checks=0, pixel_checks=0, frame_number=0;
    integer ex_flags=0,ex_x=20,ex_y=40,ex_level=0,ex_soft=70,ex_loud=120;
    reg ex_hand=0,ex_audio=0;
    reg [26:0] expect_pipe[0:2];
    reg [23:0] expected;
    integer sx=0,sy=0,k;
    reg prev_de=0,prev_vs=0;
    reg scoreboard_enabled=0;
    function automatic [23:0] reference_pixel(input integer px,py,input [23:0] base);
        integer dx,dy,rr,ri,squared_distance,bottom,top;
        begin
            reference_pixel=base;
            dx=px-ex_x;dy=py-ex_y;squared_distance=dx*dx+dy*dy;
            rr=(ex_flags & 4) ? 32:48;ri=rr-6;
            bottom=(H+240)/2;top=bottom-240;
            if(ex_flags & 1) begin
                if(ex_hand && ex_x<W && ex_y<H &&
                   ((dx>=-4 && dx<=4 && dy>=-4 && dy<=4) || (squared_distance<=rr*rr && squared_distance>ri*ri)))
                    reference_pixel=(ex_flags & 4) ? 24'hff0000 : 24'h0000ff;
                if(px>=W-14 && px<W-6 && py>=top && py<bottom) begin
                    reference_pixel=24'h202830;
                    if(ex_audio && bottom-py<=ex_level)
                        reference_pixel=ex_level>=ex_loud ? 24'hff4848 :
                            (ex_level>=ex_soft ? 24'hff40cc : 24'h4070e0);
                    if(px==W-14 || px==W-7 || py==top || py==bottom-1) reference_pixel=24'h707070;
                end
                if(px>=W-18 && px<W-3 && py>=top && py<bottom &&
                   (bottom-py==ex_soft || bottom-py==ex_loud))
                    reference_pixel=ex_audio ? 24'he0e0e0 : 24'h505050;
            end
        end
    endfunction
    // Independent arithmetic oracle, no DUT internals or lookup tables.
    always @(posedge pclk) begin
        if(!aresetn || !presetn) begin
            sx=0;sy=0;prev_de=0;prev_vs=0;
            for(k=0;k<3;k=k+1) expect_pipe[k]=0;
        end else begin
            expected=in_de ? reference_pixel(sx,sy,in_rgb) : in_rgb;
            expect_pipe[2]=expect_pipe[1];expect_pipe[1]=expect_pipe[0];
            expect_pipe[0]={in_vs,in_hs,in_de,expected};
            if(in_vs && !prev_vs) begin sx=0;sy=0;end
            else if(in_de) sx=sx+1;
            else begin sx=0;if(prev_de) sy=sy+1;end
            prev_de=in_de;prev_vs=in_vs;
            #1;
            // Suppress only the common reset synchronizers' startup window.
            if(scoreboard_enabled) begin
                if({out_vs,out_hs,out_de,out_rgb}!==expect_pipe[2])
                    $fatal(1,"PIXEL mismatch frame=%0d x=%0d y=%0d got=%h expected=%h",frame_number,sx,sy,
                        {out_vs,out_hs,out_de,out_rgb},expect_pipe[2]);
                pixel_checks=pixel_checks+1;
            end
        end
    end
    task automatic write_reg(input [6:0] addr,input [31:0] data,input [3:0] strb,
                             input integer order,input [1:0] response);
        begin
            @(negedge aclk);awaddr=addr;wdata=data;wstrb=strb;
            // Exercise address-first, data-first and concurrent AXI channels.
            if(order!=2) awvalid=1;
            if(order!=1) wvalid=1;
            if(order==1) begin
                do @(posedge aclk); while(!awready);
                @(negedge aclk);awvalid=0;
                repeat(3) @(negedge aclk);wvalid=1;
                do @(posedge aclk); while(!wready);
                @(negedge aclk);wvalid=0;
            end else if(order==2) begin
                do @(posedge aclk); while(!wready);
                @(negedge aclk);wvalid=0;
                repeat(3) @(negedge aclk);awvalid=1;
                do @(posedge aclk); while(!awready);
                @(negedge aclk);awvalid=0;
            end else begin
                do @(posedge aclk); while(!(wready && awready));
                @(negedge aclk);awvalid=0;wvalid=0;
            end
            wait(bvalid);#1;
            if(bresp!==response) $fatal(1,"BRESP addr=%h got=%h expected=%h",addr,bresp,response);
            repeat(3) begin @(posedge aclk);#1;if(!bvalid || bresp!==response) $fatal(1,"B backpressure");end
            @(negedge aclk);bready=1;@(negedge aclk);bready=0;checks=checks+1;
        end
    endtask
    task automatic read_reg(input [6:0] addr,input [31:0] data,input [1:0] response);
        begin
            @(negedge aclk);araddr=addr;arvalid=1;
            do @(posedge aclk);while(!arready);
            @(negedge aclk);arvalid=0;wait(rvalid);#1;
            if(rresp!==response || rdata!==data) $fatal(1,"READ addr=%h got=%h/%h expected=%h/%h",addr,rdata,rresp,data,response);
            repeat(3) begin @(posedge aclk);#1;if(!rvalid || rdata!==data) $fatal(1,"R backpressure");end
            @(negedge aclk);rready=1;@(negedge aclk);rready=0;checks=checks+1;
        end
    endtask
    task automatic boundary;
        begin
            @(negedge pclk);in_de=0;in_vs=1;
            repeat(8) @(negedge pclk);
            in_vs=0;repeat(8) @(negedge pclk);
            frame_number=frame_number+1;
        end
    endtask
    task automatic stage(input integer flags,cx,cy,lev,hsq,asq,ht,at);
        begin
            write_reg('h10,flags,15,1,0);
            write_reg('h14,(cy<<16)|cx,15,2,0);
            write_reg('h18,(70<<16)|lev,15,0,0);
            write_reg('h1c,(at<<24)|(ht<<16)|120,15,0,0);
            write_reg('h20,hsq,15,0,0);write_reg('h24,asq,15,0,0);
            write_reg('h08,1,15,0,0);
            repeat(8) @(negedge pclk);
        end
    endtask
    task automatic scan(input integer mode);
        integer xx,yy;
        begin
            for(yy=0;yy<H;yy=yy+1) begin
                for(xx=0;xx<W;xx=xx+1) begin
                    @(negedge pclk);in_de=1;
                    case(mode)
                        0:in_rgb=24'h123456; // default menu / frozen framebuffer
                        1:in_rgb={8'(xx),8'(yy),8'(xx^yy)}; // arbitrary video
                        2:in_rgb=24'hdeadbe; // another scene with same observation layer
                        default:in_rgb=24'h000000;
                    endcase
                end
                @(negedge pclk);in_de=0;in_hs=1;
                repeat(4) @(negedge pclk);in_hs=0;
                repeat(4) @(negedge pclk);
            end
            repeat(5) @(negedge pclk);
        end
    endtask
    initial begin : run_test
        repeat(8) @(negedge aclk);aresetn=1;presetn=1;
        repeat(12) @(negedge pclk);scoreboard_enabled=1;
        read_reg('h00,32'h4f534401,0);read_reg('h04,0,0);
        read_reg('h40,0,2);read_reg('h11,0,2);write_reg('h40,1,15,0,2);
        write_reg('h10,32'h11223344,15,0,0);write_reg('h10,32'h00aa0000,4,0,0);
        read_reg('h10,32'h11aa3344,0);write_reg('h11,1,15,0,2);
        // Stage is invisible until VS. Commit while busy must reject.
        stage(11,20,40,90,1,1,15,6);read_reg('h04,1,0);
        write_reg('h08,1,15,0,2);scan(0);
        @(negedge pclk);ex_flags=11;ex_hand=1;ex_audio=1;ex_level=90;
        boundary;read_reg('h04,0,0);scan(0);
        // Same frozen menu, updated current fist / level: independent refresh.
        stage(15,24,44,180,2,2,15,6);
        ex_flags=15;ex_x=24;ex_y=44;ex_level=180;boundary;scan(0);
        stage(11,0,0,240,3,3,15,6);
        ex_flags=11;ex_x=0;ex_y=0;ex_level=240;boundary;scan(1); // clipping + saturation
        // Visibility candidate: complete rings plus right/bottom clipping and meter priority.
        stage(11,W/2,H/2,90,10,10,15,6);
        ex_x=W/2;ex_y=H/2;ex_level=90;boundary;scan(0);
        stage(15,W/2,H/2,180,11,11,15,6);
        ex_flags=15;ex_level=180;boundary;scan(0);
        stage(11,W-1,H-1,90,12,12,15,6);
        ex_flags=11;ex_x=W-1;ex_y=H-1;ex_level=90;boundary;scan(1);
        stage(15,W-10,H/2,180,13,13,15,6);
        ex_flags=15;ex_x=W-10;ex_y=H/2;ex_level=180;boundary;scan(2);
        // Only 1-frame audio lifetime; hand must remain visible independently.
        stage(11,20,40,30,14,14,15,1);
        ex_flags=11;ex_x=20;ex_y=40;ex_level=30;boundary;scan(2);
        ex_audio=0;boundary;scan(0);
        // Duplicate IDs cannot keep old observations alive, even with full TTL.
        stage(11,20,40,30,14,14,15,6);boundary;
        repeat(13) boundary;
        ex_hand=0;boundary;scan(0);
        stage(0,20,40,30,15,15,15,6);
        ex_flags=0;boundary;scan(1); // disabled bit-exact passthrough
        // Either independent external reset clears both clocks and old mailbox.
        scoreboard_enabled=0;@(negedge pclk);presetn=0;
        repeat(10) @(negedge pclk);presetn=1;
        repeat(12) @(negedge pclk);scoreboard_enabled=1;
        read_reg('h00,32'h4f534401,0);read_reg('h10,0,0);read_reg('h04,0,0);
        boundary;scan(0);
        scoreboard_enabled=0;@(negedge aclk);aresetn=0;
        repeat(10) @(negedge aclk);aresetn=1;
        repeat(12) @(negedge pclk);scoreboard_enabled=1;
        read_reg('h10,0,0);read_reg('h04,0,0);boundary;
        $display("TEST_PASS input_osd checks=%0d pixel_checks=%0d width=%0d height=%0d",checks,pixel_checks,W,H);
        $finish;
    end
    initial begin #500000000; $fatal(1,"WATCHDOG input_osd");end
endmodule
