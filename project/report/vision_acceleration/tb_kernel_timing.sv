`timescale 1ns/1ps
// R20 frozen kernels, 640x360, 100MHz, saturated sources, always-ready sinks.
// Two complete frames. Check zero-mask pixels, framing, counts and no faults.
// Run via run_kernel_timing.tcl; output TIMING lines and TEST_PASS in simulate.log.
// Next: convert elapsed cycles at 10ns/cycle; do not call this board latency.
module tb_kernel_timing;
  localparam integer N=640*360, FRAMES=2;
  reg clk=0, resetn=0, go=0;
  always #5 clk=~clk;
  integer cycle=0, hs=0, ho=0, ms=0, mo=0;
  integer h_start[0:1], h_end_in[0:1], h_first_out[0:1], h_end_out[0:1];
  integer m_start[0:1], m_end_in[0:1], m_first_out[0:1], m_end_out[0:1];
  integer h_stalls=0, m_stalls=0;
  wire hr,hv,hu,hl,mr,mv,mu,ml,mfault;
  wire [7:0] hmask;
  wire [23:0] hsv;
  wire [15:0] mpair;
  wire hin_valid=go && hs<FRAMES*N;
  wire min_valid=go && ms<FRAMES*N;
  axis_bgr_hsv_skin color_dut(
    .aclk(clk),.aresetn(resetn),.s_axis_tdata(24'h808080),
    .s_axis_tvalid(hin_valid),.s_axis_tready(hr),
    .s_axis_tuser(hs%N==0),.s_axis_tlast(hs%N==N-1),
    .cfg_h_lo(8'd0),.cfg_h_hi(8'd20),.cfg_s_lo(8'd20),.cfg_s_hi(8'd255),
    .cfg_v_lo(8'd70),.cfg_v_hi(8'd255),
    .m_axis_hsv(hsv),.m_axis_mask(hmask),.m_axis_tvalid(hv),
    .m_axis_tready(1'b1),.m_axis_tuser(hu),.m_axis_tlast(hl));
  axis_binary_mask_pair morphology_dut(
    .aclk(clk),.aresetn(resetn),.s_axis_tdata(8'd0),
    .s_axis_tvalid(min_valid),.s_axis_tready(mr),
    .s_axis_tuser(ms%N==0),.s_axis_tlast(ms%N==N-1),
    .m_axis_tdata(mpair),.m_axis_tvalid(mv),.m_axis_tready(1'b1),
    .m_axis_tuser(mu),.m_axis_tlast(ml),.frame_fault(mfault));

  always @(posedge clk) begin
    cycle <= cycle+1;
    if(resetn) begin
      if(mfault) $fatal(1,"MORPHOLOGY_FAULT");
      if(hin_valid && !hr) h_stalls <= h_stalls+1;
      if(min_valid && !mr) m_stalls <= m_stalls+1;
      if(hin_valid && hr) begin
        if(hs%N==0) h_start[hs/N] <= cycle;
        if(hs%N==N-1) h_end_in[hs/N] <= cycle;
        hs <= hs+1;
      end
      if(min_valid && mr) begin
        if(ms%N==0) m_start[ms/N] <= cycle;
        if(ms%N==N-1) m_end_in[ms/N] <= cycle;
        ms <= ms+1;
      end
      if(hv) begin
        if(ho>=FRAMES*N || hmask!==8'd0 || hsv!==24'h800000 ||
           hu !== (ho%N==0) || hl !== (ho%N==N-1)) $fatal(1,"HSV_DATA_OR_FRAME count=%d",ho);
        if(ho%N==0) h_first_out[ho/N] <= cycle;
        if(ho%N==N-1) h_end_out[ho/N] <= cycle;
        ho <= ho+1;
      end
      if(mv) begin
        if(mo>=FRAMES*N || mpair!==16'd0 || mu !== (mo%N==0) || ml !== (mo%N==N-1))
          $fatal(1,"MORPHOLOGY_DATA_OR_FRAME count=%d",mo);
        if(mo%N==0) m_first_out[mo/N] <= cycle;
        if(mo%N==N-1) m_end_out[mo/N] <= cycle;
        mo <= mo+1;
      end
    end
  end
  initial begin
    repeat(20) @(negedge clk); resetn=1;
    repeat(6000) @(negedge clk); go=1;
    wait(ho==FRAMES*N && mo==FRAMES*N);
    repeat(10) @(negedge clk);
    if(hs!=FRAMES*N || ms!=FRAMES*N || h_stalls!=0 || mfault) $fatal(1,"FINAL_COUNTS");
    for(integer f=0;f<FRAMES;f=f+1) begin
      $display("TIMING kernel=color frame=%0d first_in=%0d last_in=%0d first_out=%0d last_out=%0d elapsed_cycles=%0d latency_cycles=%0d tail_cycles=%0d",f,h_start[f],h_end_in[f],h_first_out[f],h_end_out[f],h_end_out[f]-h_start[f],h_first_out[f]-h_start[f],h_end_out[f]-h_end_in[f]);
      $display("TIMING kernel=morphology frame=%0d first_in=%0d last_in=%0d first_out=%0d last_out=%0d elapsed_cycles=%0d latency_cycles=%0d tail_cycles=%0d",f,m_start[f],m_end_in[f],m_first_out[f],m_end_out[f],m_end_out[f]-m_start[f],m_first_out[f]-m_start[f],m_end_out[f]-m_end_in[f]);
    end
    $display("TEST_PASS PL_KERNEL_TIMING frames=%0d pixels_per_frame=%0d color_out=%0d morphology_out=%0d source_stall_cycles=%0d",FRAMES,N,ho,mo,m_stalls);
    $finish;
  end
  initial begin #10000000; $fatal(1,"TIMING_WATCHDOG"); end
endmodule
