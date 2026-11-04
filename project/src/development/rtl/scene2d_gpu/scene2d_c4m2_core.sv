module scene2d_c4m2_core (
    input  logic        aclk,
    input  logic        aresetn,
    input  logic [63:0] s_axis_tdata,
    input  logic [7:0]  s_axis_tkeep,
    input  logic        s_axis_tlast,
    input  logic        s_axis_tvalid,
    output logic        s_axis_tready,
    input  logic [8:0]  debug_command_read_address,
    output logic [31:0] debug_command_read_data_low,
    output logic [31:0] debug_command_read_data_high,
    output logic [31:0] upload_crc32,
    output logic [31:0] upload_byte_count,
    output logic [31:0] upload_packet_count,
    output logic [31:0] accepted_packet_count,
    output logic [31:0] rejected_packet_count,
    output logic [31:0] accepted_seq,
    output logic [31:0] accepted_status,
    output logic [5:0]  upload_error_flags,
    output logic [31:0] render_completed_seq,
    output logic [31:0] render_completed_count,
    output logic [31:0] render_write_count,
    output logic [31:0] render_trace_crc32,
    output logic [31:0] render_cycles,
    output logic [31:0] render_maximum_cycles,
    output logic [31:0] render_status
);

    logic upload_axis_ready;
    logic upload_axis_valid;
    logic [8:0] accepted_command_count;
    logic active_command_bank;
    logic command_bank_valid;
    logic [8:0] command_read_address;
    logic [63:0] command_read_data;
    logic [8:0] renderer_command_read_address;
    logic renderer_start;
    logic renderer_busy;
    logic renderer_done;
    logic [3:0] renderer_last_errors;
    logic [3:0] renderer_sticky_errors;
    logic [7:0] renderer_first_error_command;
    logic [31:0] observed_accepted_count;
    logic render_pending;
    logic upload_enabled;

    assign render_pending = accepted_packet_count != observed_accepted_count;
    assign renderer_start = render_pending && !renderer_busy;
    assign upload_enabled = !renderer_busy && !render_pending;
    assign upload_axis_valid = s_axis_tvalid && upload_enabled;
    assign s_axis_tready = upload_axis_ready && upload_enabled;
    assign command_read_address = (renderer_busy || renderer_start)
        ? renderer_command_read_address
        : debug_command_read_address;
    assign debug_command_read_data_low = command_read_data[31:0];
    assign debug_command_read_data_high = command_read_data[63:32];
    assign render_status = {
        8'd0,
        renderer_first_error_command,
        4'd0,
        renderer_sticky_errors,
        renderer_last_errors,
        3'd0,
        renderer_busy
    };

    scene2d_command_upload command_upload (
        .aclk,
        .aresetn,
        .s_axis_tdata,
        .s_axis_tkeep,
        .s_axis_tlast,
        .s_axis_tvalid(upload_axis_valid),
        .s_axis_tready(upload_axis_ready),
        .command_read_address,
        .command_read_data,
        .command_read_data_low(),
        .command_read_data_high(),
        .completed_crc32(upload_crc32),
        .completed_byte_count(upload_byte_count),
        .completed_packet_count(upload_packet_count),
        .accepted_packet_count,
        .rejected_packet_count,
        .accepted_seq,
        .accepted_command_count,
        .accepted_status,
        .sticky_error_flags(upload_error_flags),
        .active_bank(active_command_bank),
        .bank_valid(command_bank_valid)
    );

    scene2d_clear_fill_renderer renderer (
        .aclk,
        .aresetn,
        .start(renderer_start),
        .submit_seq(accepted_seq),
        .command_count(accepted_command_count),
        .command_read_address(renderer_command_read_address),
        .command_read_data,
        .atlas_read_address(),
        .atlas_read_index(4'd0),
        .write_valid(),
        .write_address(),
        .write_token(),
        .busy(renderer_busy),
        .done(renderer_done),
        .completed_seq(render_completed_seq),
        .completed_write_count(render_write_count),
        .completed_trace_crc32(render_trace_crc32),
        .completed_cycles(render_cycles),
        .maximum_cycles(render_maximum_cycles),
        .last_error_flags(renderer_last_errors),
        .sticky_error_flags(renderer_sticky_errors),
        .first_error_command(renderer_first_error_command)
    );

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            observed_accepted_count <= '0;
            render_completed_count <= '0;
        end else begin
            if (renderer_start) begin
                observed_accepted_count <= accepted_packet_count;
            end
            if (renderer_done) begin
                render_completed_count <= render_completed_count + 1'b1;
            end
        end
    end

endmodule