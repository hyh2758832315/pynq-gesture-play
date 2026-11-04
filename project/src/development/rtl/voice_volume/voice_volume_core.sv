`timescale 1ns/1ps
module voice_volume_core #(
    parameter integer WINDOW_SAMPLES = 977,
    parameter integer DC_SHIFT = 10,
    parameter integer DC_FRAC = 8,
    parameter integer SAMPLE_TIMEOUT_CLKS = 1000000,
    parameter integer EVENT_TIMEOUT_CLKS = 10000000,
    parameter integer MAX_CLIPPED_SAMPLES = 32
) (
    input wire clk, rst_n, enable, configure,
    input wire [31:0] config_epoch, soft_sum, loud_sum, quiet_sum,
    input wire pcm_valid,
    input wire signed [15:0] pcm_s16,
    input wire input_fault,
    input wire ack_valid,
    input wire [31:0] ack_epoch, ack_sequence,
    output reg [2:0] state,
    output reg [7:0] faults,
    output reg ack_error,
    output reg [63:0] sample_count,
    output reg [31:0] window_count, last_sum,
    output reg window_valid, event_pending,
    output reg [1:0] event_kind,
    output reg [31:0] event_sequence, event_epoch,
    output reg [63:0] event_sample,
    output reg [31:0] event_window, event_age
);
    localparam [2:0] UNARMED = 0, ARMED = 1, CANDIDATE = 2, RECOVERY = 3, FAULT = 4;
    localparam integer COUNT_BITS = (WINDOW_SAMPLES < 2) ? 1 : $clog2(WINDOW_SAMPLES);
    localparam integer DC_BITS = 17 + DC_FRAC;
    reg signed [DC_BITS-1:0] dc_level, scaled_latched;
    wire signed [DC_BITS-1:0] scaled_sample = $signed({{(DC_BITS-16){pcm_s16[15]}}, pcm_s16}) <<< DC_FRAC;
    wire signed [DC_BITS:0] dc_difference = {scaled_sample[DC_BITS-1], scaled_sample} - {dc_level[DC_BITS-1], dc_level};
    reg signed [DC_BITS:0] difference_latched;
    wire signed [DC_BITS:0] next_dc = $signed({dc_level[DC_BITS-1], dc_level}) + (difference_latched >>> DC_SHIFT);
    wire signed [DC_BITS+1:0] centered = $signed({{2{scaled_latched[DC_BITS-1]}}, scaled_latched}) - $signed({next_dc[DC_BITS], next_dc});
    reg signed [17:0] filtered_latched;
    reg dc_valid, filtered_valid, dc_clipped, filtered_clipped;
    wire [17:0] magnitude = filtered_latched[17] ? $unsigned(-filtered_latched) : $unsigned(filtered_latched);
    reg [COUNT_BITS-1:0] sample_in_window;
    reg [31:0] accumulation;
    wire [32:0] next_sum = {1'b0, accumulation} + {15'd0, magnitude};
    reg [15:0] clipped_count;
    wire [16:0] next_clipped = {1'b0, clipped_count} + filtered_clipped;
    reg [31:0] sample_age;
    reg [2:0] quiet_count, soft_count, loud_count, candidate_count;
    reg high_seen;
    wire above_soft = next_sum >= {1'b0, soft_sum};
    wire above_loud = next_sum >= {1'b0, loud_sum};
    wire quiet = next_sum <= {1'b0, quiet_sum};
    wire matching_ack = ack_valid && event_pending && ack_epoch == event_epoch && ack_sequence == event_sequence;

    always @(posedge clk) begin
        if (!rst_n || configure || !enable || faults != 0) begin
            dc_level <= 0; scaled_latched <= 0; difference_latched <= 0; filtered_latched <= 0;
            dc_valid <= 0; filtered_valid <= 0; dc_clipped <= 0; filtered_clipped <= 0;
        end else begin
            dc_valid <= pcm_valid && !dc_valid && !filtered_valid;
            filtered_valid <= dc_valid;
            if (pcm_valid && !dc_valid && !filtered_valid) begin
                scaled_latched <= scaled_sample; difference_latched <= dc_difference;
                dc_clipped <= pcm_s16 == 16'sh7fff || pcm_s16 == 16'sh8000;
            end
            if (dc_valid) begin
                dc_level <= next_dc[DC_BITS-1:0];
                filtered_latched <= centered >>> DC_FRAC;
                filtered_clipped <= dc_clipped;
            end
        end
    end

    task automatic trip(input [7:0] reason);
        begin
            faults <= faults | reason;
            state <= FAULT;
            event_pending <= 0;
            event_kind <= 0;
            quiet_count <= 0;
        end
    endtask

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= UNARMED;
            faults <= 0;
            ack_error <= 0;
            sample_count <= 0;
            window_count <= 0;
            sample_in_window <= 0;
            accumulation <= 0;
            clipped_count <= 0;
            last_sum <= 0;
            sample_age <= 0;
            quiet_count <= 0;
            soft_count <= 0;
            loud_count <= 0;
            candidate_count <= 0;
            high_seen <= 0;
            window_valid <= 0;
            event_pending <= 0;
            event_kind <= 0;
            event_sequence <= 0;
            event_epoch <= 0;
            event_sample <= 0;
            event_window <= 0;
            event_age <= 0;
        end else begin
            window_valid <= 0;
            if (configure || !enable) begin
                state <= UNARMED;
                sample_in_window <= 0;
                accumulation <= 0;
                clipped_count <= 0;
                sample_age <= 0;
                quiet_count <= 0;
                soft_count <= 0;
                loud_count <= 0;
                candidate_count <= 0;
                high_seen <= 0;
                event_pending <= 0;
                event_kind <= 0;
                event_age <= 0;
                if (configure) begin
                    faults <= 0;
                    ack_error <= 0;
                    sample_count <= 0;
                    window_count <= 0;
                    last_sum <= 0;
                    event_sequence <= 0;
                    event_epoch <= config_epoch;
                    event_sample <= 0;
                    event_window <= 0;
                    if (soft_sum == 0 || loud_sum <= soft_sum || quiet_sum >= soft_sum)
                        trip(8'h01);
                end
            end else if (faults == 0) begin
                if (ack_valid && !matching_ack) ack_error <= 1;
                if (matching_ack) event_pending <= 0;
                if (event_pending) event_age <= event_age + 1;
                else event_age <= 0;
                if (sample_age < SAMPLE_TIMEOUT_CLKS) sample_age <= sample_age + 1;
                if (pcm_valid) sample_age <= 0;
                if (filtered_valid) begin
                    sample_count <= sample_count + 1;
                    if (sample_in_window == WINDOW_SAMPLES - 1) begin
                        sample_in_window <= 0;
                        accumulation <= 0;
                        clipped_count <= 0;
                        window_count <= window_count + 1;
                        last_sum <= next_sum[31:0];
                        window_valid <= 1;
                        if (quiet) begin
                            if (quiet_count < 5) quiet_count <= quiet_count + 1;
                        end else quiet_count <= 0;
                        case (state)
                            UNARMED: if (quiet && quiet_count >= 4) state <= ARMED;
                            ARMED: if (above_soft) begin
                                state <= CANDIDATE;
                                candidate_count <= 1;
                                soft_count <= 1;
                                loud_count <= above_loud ? 1 : 0;
                                high_seen <= above_loud;
                            end
                            CANDIDATE: begin
                                candidate_count <= candidate_count + 1;
                                soft_count <= above_soft ? soft_count + 1 : 0;
                                loud_count <= above_loud ? loud_count + 1 : 0;
                                high_seen <= high_seen || above_loud;
                                if (above_loud && loud_count >= 1) begin
                                    state <= RECOVERY;
                                    event_pending <= 1;
                                    event_kind <= 2;
                                    event_sequence <= event_sequence + 1;
                                    event_epoch <= config_epoch;
                                    event_sample <= sample_count + 1;
                                    event_window <= window_count + 1;
                                    event_age <= 0;
                                end else if (candidate_count >= 2) begin
                                    state <= RECOVERY;
                                    if (!high_seen && !above_loud && above_soft && soft_count >= 2) begin
                                        event_pending <= 1;
                                        event_kind <= 1;
                                        event_sequence <= event_sequence + 1;
                                        event_epoch <= config_epoch;
                                        event_sample <= sample_count + 1;
                                        event_window <= window_count + 1;
                                        event_age <= 0;
                                    end
                                end
                            end
                            RECOVERY: if (quiet && quiet_count >= 4 && !event_pending) state <= ARMED;
                            default: trip(8'h40);
                        endcase
                        if (next_clipped > MAX_CLIPPED_SAMPLES) trip(8'h04);
                        if (next_sum[32]) trip(8'h08);
                        if (window_count == 32'hffffffff) trip(8'h20);
                    end else begin
                        sample_in_window <= sample_in_window + 1;
                        accumulation <= next_sum[31:0];
                        clipped_count <= next_clipped[15:0];
                    end
                    if (sample_count == 64'hffffffffffffffff) trip(8'h20);
                end
                if (!pcm_valid && sample_age >= SAMPLE_TIMEOUT_CLKS - 1) trip(8'h02);
                if (event_pending && !matching_ack && event_age >= EVENT_TIMEOUT_CLKS - 1) trip(8'h10);
                if (input_fault) trip(8'h40);
                if (pcm_valid && (dc_valid || filtered_valid)) trip(8'h80);
            end
        end
    end
endmodule