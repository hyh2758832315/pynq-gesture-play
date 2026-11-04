module scene2d_frame_swap (
    input  logic write_clk,
    input  logic write_resetn,
    input  logic render_done,
    output logic write_bank,
    output logic present_pending,
    output logic present_done,
    input  logic pixel_clk,
    input  logic pixel_resetn,
    input  logic frame_start,
    output logic display_bank,
    output logic swap_pulse
);

    logic request_toggle;
    (* ASYNC_REG = "TRUE" *) logic request_sync_1;
    (* ASYNC_REG = "TRUE" *) logic request_sync_2;
    logic request_seen;
    logic acknowledgement_toggle;
    (* ASYNC_REG = "TRUE" *) logic acknowledgement_sync_1;
    (* ASYNC_REG = "TRUE" *) logic acknowledgement_sync_2;
    logic acknowledgement_seen;

    always_ff @(posedge write_clk) begin
        if (!write_resetn) begin
            write_bank <= 1'b1;
            present_pending <= 1'b0;
            request_toggle <= 1'b0;
            acknowledgement_sync_1 <= 1'b0;
            acknowledgement_sync_2 <= 1'b0;
            acknowledgement_seen <= 1'b0;
            present_done <= 1'b0;
        end else begin
            present_done <= 1'b0;
            acknowledgement_sync_1 <= acknowledgement_toggle;
            acknowledgement_sync_2 <= acknowledgement_sync_1;
            if (acknowledgement_sync_2 != acknowledgement_seen) begin
                acknowledgement_seen <= acknowledgement_sync_2;
                present_pending <= 1'b0;
                write_bank <= ~write_bank;
                present_done <= 1'b1;
            end
            if (render_done) begin
                present_pending <= 1'b1;
                request_toggle <= ~request_toggle;
            end
        end
    end

    always_ff @(posedge pixel_clk) begin
        if (!pixel_resetn) begin
            display_bank <= 1'b0;
            swap_pulse <= 1'b0;
            request_sync_1 <= 1'b0;
            request_sync_2 <= 1'b0;
            request_seen <= 1'b0;
            acknowledgement_toggle <= 1'b0;
        end else begin
            swap_pulse <= 1'b0;
            request_sync_1 <= request_toggle;
            request_sync_2 <= request_sync_1;
            if (frame_start && request_sync_2 != request_seen) begin
                request_seen <= request_sync_2;
                display_bank <= ~display_bank;
                acknowledgement_toggle <= ~acknowledgement_toggle;
                swap_pulse <= 1'b1;
            end
        end
    end

endmodule