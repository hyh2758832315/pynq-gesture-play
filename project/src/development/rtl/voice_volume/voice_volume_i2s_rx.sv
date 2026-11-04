`timescale 1ns/1ps
module voice_volume_i2s_rx (
    input wire clk, rst_n, bclk, lrclk, sdata,
    output reg pcm_valid,
    output reg signed [15:0] pcm_s16,
    output reg frame_fault
);
    (* ASYNC_REG = "TRUE" *) reg [1:0] bclk_sync, lrclk_sync, sdata_sync;
    reg bclk_previous, channel, started;
    reg [5:0] slot_index;
    reg [15:0] shift_data;
    always @(posedge clk) begin
        if (!rst_n) begin
            bclk_sync <= 0; lrclk_sync <= 0; sdata_sync <= 0;
            bclk_previous <= 0; channel <= 0; started <= 0; slot_index <= 0;
            shift_data <= 0; pcm_valid <= 0; pcm_s16 <= 0; frame_fault <= 0;
        end else begin
            bclk_sync <= {bclk_sync[0], bclk};
            lrclk_sync <= {lrclk_sync[0], lrclk};
            sdata_sync <= {sdata_sync[0], sdata};
            bclk_previous <= bclk_sync[1];
            pcm_valid <= 0; frame_fault <= 0;
            if (bclk_sync[1] && !bclk_previous) begin
                if (lrclk_sync[1] != channel) begin
                    if (started && slot_index != 31) frame_fault <= 1;
                    started <= 1; channel <= lrclk_sync[1]; slot_index <= 0; shift_data <= 0;
                end else if (started) begin
                    if (slot_index < 32) slot_index <= slot_index + 1;
                    if (slot_index == 31) frame_fault <= 1;
                    if (!channel && slot_index < 16) begin
                        shift_data <= {shift_data[14:0], sdata_sync[1]};
                        if (slot_index == 15) begin
                            pcm_s16 <= {shift_data[14:0], sdata_sync[1]}; pcm_valid <= 1;
                        end
                    end
                end
            end
        end
    end
endmodule