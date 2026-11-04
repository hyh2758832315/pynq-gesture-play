module axis_rgb_mask_frontend #(
    parameter integer INPUT_WIDTH = 1280,
    parameter integer INPUT_HEIGHT = 720
)(
    input wire aclk,
    input wire aresetn,
    input wire [23:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tuser,
    input wire s_axis_tlast,
    input wire [7:0] cfg_h_lo, cfg_h_hi, cfg_s_lo, cfg_s_hi, cfg_v_lo, cfg_v_hi,
    input wire [31:0] cfg_frame_id, cfg_config_id, cfg_epoch,
    output wire [15:0] m_axis_tdata,
    output wire m_axis_tvalid,
    input wire m_axis_tready,
    output wire m_axis_tuser,
    output wire m_axis_tlast,
    output wire [31:0] m_frame_id, m_config_id, m_epoch,
    output wire [47:0] m_thresholds,
    output wire [15:0] m_width, m_height,
    output reg frame_fault
);
    localparam integer INPUT_PIXELS = INPUT_WIDTH * INPUT_HEIGHT;
    localparam integer INDEX_BITS = $clog2(INPUT_PIXELS);
    reg [INDEX_BITS-1:0] input_index;
    reg [47:0] thresholds;
    reg hsv_frame_pending;
    reg [143:0] contexts [0:3];
    reg [1:0] context_write, context_read;
    reg [2:0] context_count;
    wire [23:0] reduced_rgb;
    wire reduced_valid, reduced_ready, reduced_user, reduced_last, area_fault;
    wire [7:0] skin_mask;
    wire skin_valid, skin_ready, skin_user, skin_last, pair_fault;
    wire pair_valid;
    wire output_pop = m_axis_tvalid && m_axis_tready && m_axis_tlast;
    wire hsv_tail_take = reduced_valid && reduced_ready && reduced_last;
    wire context_space = context_count < 4 || output_pop;
    wire frame_slot = input_index != 0 ||
                      ((!hsv_frame_pending || hsv_tail_take) && context_space);
    wire area_ready;
    wire source_valid = s_axis_tvalid && frame_slot && !frame_fault && !area_fault;
    wire input_take = s_axis_tvalid && s_axis_tready;
    wire context_push = input_take && input_index == 0 && s_axis_tuser;
    wire [143:0] output_context = context_count != 0 ? contexts[context_read] : 144'd0;

    assign s_axis_tready = aresetn && frame_slot && area_ready && !frame_fault && !area_fault;
    assign m_axis_tvalid = pair_valid && context_count != 0;
    assign {m_epoch, m_config_id, m_frame_id, m_thresholds} = output_context;
    assign m_width = INPUT_WIDTH / 2;
    assign m_height = INPUT_HEIGHT / 2;

    initial begin
        if (INPUT_WIDTH < 4 || INPUT_HEIGHT < 4 || INPUT_WIDTH % 2 || INPUT_HEIGHT % 2 ||
            INPUT_WIDTH > 65534 || INPUT_HEIGHT > 65534)
            $fatal(1, "RGB_MASK_FRONTEND requires even dimensions in 4..65534");
    end

    axis_area2x2 #(.INPUT_WIDTH(INPUT_WIDTH), .INPUT_HEIGHT(INPUT_HEIGHT)) area (
        .aclk(aclk), .aresetn(aresetn), .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(source_valid), .s_axis_tready(area_ready),
        .s_axis_tuser(s_axis_tuser), .s_axis_tlast(s_axis_tlast),
        .m_axis_tdata(reduced_rgb), .m_axis_tvalid(reduced_valid),
        .m_axis_tready(reduced_ready), .m_axis_tuser(reduced_user),
        .m_axis_tlast(reduced_last), .frame_fault(area_fault)
    );
    axis_bgr_hsv_skin hsv (
        .aclk(aclk), .aresetn(aresetn),
        .s_axis_tdata({reduced_rgb[7:0], reduced_rgb[15:8], reduced_rgb[23:16]}),
        .s_axis_tvalid(reduced_valid), .s_axis_tready(reduced_ready),
        .s_axis_tuser(reduced_user), .s_axis_tlast(reduced_last),
        .cfg_h_lo(thresholds[7:0]), .cfg_h_hi(thresholds[15:8]),
        .cfg_s_lo(thresholds[23:16]), .cfg_s_hi(thresholds[31:24]),
        .cfg_v_lo(thresholds[39:32]), .cfg_v_hi(thresholds[47:40]),
        .m_axis_hsv(), .m_axis_mask(skin_mask), .m_axis_tvalid(skin_valid),
        .m_axis_tready(skin_ready), .m_axis_tuser(skin_user), .m_axis_tlast(skin_last)
    );
    axis_binary_mask_pair #(.WIDTH(INPUT_WIDTH/2), .HEIGHT(INPUT_HEIGHT/2)) pair (
        .aclk(aclk), .aresetn(aresetn), .s_axis_tdata(skin_mask),
        .s_axis_tvalid(skin_valid), .s_axis_tready(skin_ready),
        .s_axis_tuser(skin_user), .s_axis_tlast(skin_last),
        .m_axis_tdata(m_axis_tdata), .m_axis_tvalid(pair_valid),
        .m_axis_tready(m_axis_tready && context_count != 0),
        .m_axis_tuser(m_axis_tuser), .m_axis_tlast(m_axis_tlast), .frame_fault(pair_fault)
    );

    always @(posedge aclk) begin
        if (!aresetn) begin
            input_index <= 0;
            thresholds <= 0;
            hsv_frame_pending <= 0;
            context_write <= 0;
            context_read <= 0;
            context_count <= 0;
            frame_fault <= 0;
        end else begin
            if (area_fault || pair_fault || (pair_valid && context_count == 0) ||
                (input_take && input_index == 0 && !s_axis_tuser)) frame_fault <= 1;
            if (hsv_tail_take) hsv_frame_pending <= 0;
            if (input_take) input_index <= input_index == INPUT_PIXELS-1 ? 0 : input_index + 1'b1;
            if (context_push) begin
                thresholds <= {cfg_v_hi, cfg_v_lo, cfg_s_hi, cfg_s_lo, cfg_h_hi, cfg_h_lo};
                hsv_frame_pending <= 1;
                contexts[context_write] <= {cfg_epoch, cfg_config_id, cfg_frame_id,
                    cfg_v_hi, cfg_v_lo, cfg_s_hi, cfg_s_lo, cfg_h_hi, cfg_h_lo};
                context_write <= context_write + 1'b1;
            end
            if (output_pop) context_read <= context_read + 1'b1;
            case ({context_push, output_pop})
                2'b10: context_count <= context_count + 1'b1;
                2'b01: context_count <= context_count - 1'b1;
                default: context_count <= context_count;
            endcase
        end
    end
endmodule