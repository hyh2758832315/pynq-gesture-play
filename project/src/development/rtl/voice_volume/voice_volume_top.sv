`timescale 1ns/1ps
module voice_volume_top #(
    parameter integer WINDOW_SAMPLES = 977
) (
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF s_axi, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000" *)
    input wire s_axi_aclk,
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *) input wire s_axi_aresetn,
    input wire [11:0] s_axi_awaddr,
    input wire [2:0] s_axi_awprot,
    input wire s_axi_awvalid,
    output wire s_axi_awready,
    input wire [31:0] s_axi_wdata,
    input wire [3:0] s_axi_wstrb,
    input wire s_axi_wvalid,
    output wire s_axi_wready,
    output wire [1:0] s_axi_bresp,
    output wire s_axi_bvalid,
    input wire s_axi_bready,
    input wire [11:0] s_axi_araddr,
    input wire [2:0] s_axi_arprot,
    input wire s_axi_arvalid,
    output wire s_axi_arready,
    output wire [31:0] s_axi_rdata,
    output wire [1:0] s_axi_rresp,
    output wire s_axi_rvalid,
    input wire s_axi_rready,
    output wire i2s_bclk, i2s_lrclk,
    input wire i2s_sdata,
    output wire [1:0] codec_address,
    input wire codec_mclk_locked
);
    wire pcm_valid, input_fault;
    wire signed [15:0] pcm_s16;
    (* ASYNC_REG = "TRUE" *) reg [1:0] locked_sync;
    reg [10:0] audio_counter = 0;
    wire clock_locked = locked_sync[1];
    assign i2s_bclk = audio_counter[4];
    assign i2s_lrclk = audio_counter[10];
    assign codec_address = 2'b11;
    always @(posedge s_axi_aclk) begin
        audio_counter <= audio_counter + 1;
        if (!s_axi_aresetn) locked_sync <= 0;
        else locked_sync <= {locked_sync[0], codec_mclk_locked};
    end
    voice_volume_i2s_rx receiver (
        .clk(s_axi_aclk), .rst_n(s_axi_aresetn), .bclk(i2s_bclk), .lrclk(i2s_lrclk), .sdata(i2s_sdata),
        .pcm_valid(pcm_valid), .pcm_s16(pcm_s16), .frame_fault(input_fault)
    );
    axi_voice_volume #(.WINDOW_SAMPLES(WINDOW_SAMPLES)) registers (.*);
endmodule