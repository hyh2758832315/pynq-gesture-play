`timescale 1ns/1ps
module tb_frontend;
    localparam N=1381676;
    reg clk=0;always #5 clk=~clk;
    reg rst=0;
    reg [23:0] din;
    reg vin=0,uin=0,lin=0;
    wire rin;
    reg [47:0] bounds;
    wire [23:0] hsv;
    wire [7:0] mask;
    wire valid,user,last,ready;
    wire [31:0] packed_data;
    wire [3:0] packed_keep;
    wire packed_valid,packed_user,packed_last;
    reg packed_ready=0;
    reg [31:0] inputs[0:N-1];
    reg [39:0] gold[0:N-1];
    reg [47:0] configs[0:N-1];
    integer sent=0,checked=0,packed_checked=0,frames=0,cycles=0;
    integer full_start=0,full_cycles=0;
    reg running=0;
    reg source_accepted=0;
    reg [31:0] rng=32'h20261005;
    reg held_hsv=0,held_pack=0;
    reg [33:0] prev_hsv;
    reg [37:0] prev_pack;
    reg [31:0] expected_pack;
    reg [3:0] expected_keep;
    reg expected_last,expected_user;
    integer j,k;
    axis_bgr_hsv_skin dut(.aclk(clk),.aresetn(rst),.s_axis_tdata(din),
        .s_axis_tvalid(vin),.s_axis_tready(rin),.s_axis_tuser(uin),.s_axis_tlast(lin),
        .cfg_h_lo(bounds[7:0]),.cfg_h_hi(bounds[15:8]),
        .cfg_s_lo(bounds[23:16]),.cfg_s_hi(bounds[31:24]),
        .cfg_v_lo(bounds[39:32]),.cfg_v_hi(bounds[47:40]),
        .m_axis_hsv(hsv),.m_axis_mask(mask),.m_axis_tvalid(valid),
        .m_axis_tready(ready),.m_axis_tuser(user),.m_axis_tlast(last));
    axis_mask_pack32 packer(.aclk(clk),.aresetn(rst),.s_axis_tdata(mask),
        .s_axis_tvalid(valid),.s_axis_tready(ready),.s_axis_tuser(user),.s_axis_tlast(last),
        .m_axis_tdata(packed_data),.m_axis_tkeep(packed_keep),
        .m_axis_tvalid(packed_valid),.m_axis_tready(packed_ready),
        .m_axis_tuser(packed_user),.m_axis_tlast(packed_last));

    always @(posedge clk) begin
        if(!rst) begin held_hsv=0;held_pack=0;end
        else if(running) begin
            source_accepted=vin && rin;
            cycles=cycles+1;
            if(held_hsv && (!valid || {last,user,mask,hsv}!==prev_hsv))
                $fatal(1,"HSV output changed while stalled");
            if(held_pack && (!packed_valid || {packed_last,packed_user,packed_keep,packed_data}!==prev_pack))
                $fatal(1,"Packed output changed while stalled");
            held_hsv=valid && !ready;prev_hsv={last,user,mask,hsv};
            held_pack=packed_valid && !packed_ready;
            prev_pack={packed_last,packed_user,packed_keep,packed_data};
            if(vin && rin) begin
                if(sent==460032) full_start=cycles;
                if(sent==1381631) full_cycles=cycles-full_start+1;
                sent=sent+1;
            end
            if(valid && ready) begin
                if(checked>=N || {last,user,mask,hsv}!==gold[checked][33:0])
                    $fatal(1,"HSV/mask mismatch pixel=%0d actual=%h expected=%h",checked,{last,user,mask,hsv},gold[checked]);
                checked=checked+1;
            end
            if(packed_valid && packed_ready) begin
                expected_pack=0;expected_keep=0;expected_last=0;
                expected_user=gold[packed_checked][32];
                k=0;
                for(j=0;j<4;j=j+1) begin
                    if(!expected_last) begin
                        expected_pack[j*8+:8]=gold[packed_checked+k][31:24];
                        expected_keep[j]=1;
                        expected_last=gold[packed_checked+k][33];
                        k=k+1;
                    end
                end
                if({packed_last,packed_user,packed_keep,packed_data}!=={expected_last,expected_user,expected_keep,expected_pack})
                    $fatal(1,"packed mismatch pixel=%0d",packed_checked);
                packed_checked=packed_checked+k;
                if(packed_last) frames=frames+1;
            end
        end
    end
    always @(negedge clk) begin
        if(running) begin
            rng={rng[30:0],rng[31]^rng[21]^rng[1]^rng[0]};
            // Stalls and bubbles in first frame and tiny tail frames.
            // Full random 640x360 and 1280x720 are continuous II=1 tests.
            packed_ready=(sent>=229632 && sent<1381632) ? 1 : (rng[2:0]!=0);
            if(!vin || source_accepted) begin
                vin=sent<N && ((sent>=229632 && sent<1381632) || rng[5:3]!=0);
                if(sent<N) begin
                    din=inputs[sent][23:0];uin=inputs[sent][24];lin=inputs[sent][25];
                    bounds=configs[sent];
                end
            end
        end
    end
    initial begin
        $readmemh("../golden/input.hex",inputs);
        $readmemh("../golden/expected.hex",gold);
        $readmemh("../golden/bounds.hex",configs);
        // Reset with partially filled pipeline/packer under stalled output.
        repeat(3) @(negedge clk);rst=1;vin=1;din=24'h0000ff;
        bounds=48'hff004000b300;
        repeat(12) @(negedge clk);
        rst=0;vin=0;
        repeat(3) @(negedge clk);
        if(valid || packed_valid) $fatal(1,"reset failed to discard in-flight data");
        rst=1;running=1;
        wait(packed_checked==N);
        @(negedge clk);vin=0;packed_ready=1;
        repeat(12) @(negedge clk);
        if(valid || packed_valid || checked!=N || sent!=N || frames!=8)
            $fatal(1,"missing/extra output frames=%0d",frames);
        if(full_cycles!=921600) $fatal(1,"continuous frame not II=1 cycles=%0d",full_cycles);
        $display("BGR_HSV_FRONTEND_PASS pixels=%0d frames=%0d full1280_cycles=%0d backpressure/reset/packed_tail=PASS",checked,frames,full_cycles);
        $finish;
    end
    initial begin #50000000;$fatal(1,"watchdog sent=%0d checked=%0d packed=%0d",sent,checked,packed_checked);end
endmodule
