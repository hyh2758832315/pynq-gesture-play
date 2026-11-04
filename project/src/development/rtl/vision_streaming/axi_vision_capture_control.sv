module axi_vision_capture_control #(parameter integer OWNER_PROTOCOL = 0)(
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn:common_aresetn:capture_aresetn" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK" *)
    input wire s_axi_aclk,
    input wire s_axi_aresetn, common_aresetn,
    input wire [11:0] s_axi_awaddr,
    input wire s_axi_awvalid,
    output wire s_axi_awready,
    input wire [31:0] s_axi_wdata,
    input wire [3:0] s_axi_wstrb,
    input wire s_axi_wvalid,
    output wire s_axi_wready,
    output reg [1:0] s_axi_bresp,
    output reg s_axi_bvalid,
    input wire s_axi_bready,
    input wire [11:0] s_axi_araddr,
    input wire s_axi_arvalid,
    output wire s_axi_arready,
    output reg [31:0] s_axi_rdata,
    output reg [1:0] s_axi_rresp,
    output reg s_axi_rvalid,
    input wire s_axi_rready,
    output reg [143:0] cfg_frame_context,
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 capture_aresetn RST" *)
    output reg capture_aresetn,
    output reg armed, abort_requested, barrier_request,
    input wire owner_available, owner_cpu_held, owner_drained, owner_fault,
    input wire owner_claim_accepted, owner_release_accepted,
    input wire [31:0] owner_epoch, owner_frame_id, owner_slot, owner_granted_frames, owner_released_frames,
    input wire [3:0] owner_fault_causes,
    output reg owner_cpu_claim, owner_cpu_release, owner_command_fault,
    output reg [31:0] owner_cpu_epoch, owner_cpu_frame_id
);
    reg aw_held, w_held;
    reg [11:0] address_held;
    reg [31:0] data_held;
    reg [3:0] strobes_held;
    reg [4:0] configured;
    reg [1:0] owner_token_configured, owner_command_wait;
    reg owner_command_pending, owner_command_is_release;
    reg owner_status_pending;
    reg [6:0] owner_status_held;
    assign s_axi_awready = s_axi_aresetn && !aw_held && !s_axi_bvalid && !owner_command_pending;
    assign s_axi_wready = s_axi_aresetn && !w_held && !s_axi_bvalid && !owner_command_pending;
    assign s_axi_arready = s_axi_aresetn && !s_axi_rvalid && !owner_status_pending;
    always @(posedge s_axi_aclk or negedge common_aresetn) begin
        if (!common_aresetn) capture_aresetn <= 0;
        else capture_aresetn <= s_axi_aresetn && armed;
    end

    always @(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            aw_held <= 0;
            w_held <= 0;
            address_held <= 0;
            data_held <= 0;
            strobes_held <= 0;
            configured <= 0;
            cfg_frame_context <= 0;
            armed <= 0;
            abort_requested <= 0;
            barrier_request <= 0;
            owner_cpu_claim <= 0;
            owner_cpu_release <= 0;
            owner_cpu_epoch <= 0;
            owner_cpu_frame_id <= 0;
            owner_command_fault <= 0;
            owner_token_configured <= 0;
            owner_command_pending <= 0;
            owner_command_is_release <= 0;
            owner_command_wait <= 0;
            owner_status_pending <= 0;
            owner_status_held <= 0;
            s_axi_bvalid <= 0;
            s_axi_bresp <= 0;
            s_axi_rvalid <= 0;
            s_axi_rdata <= 0;
            s_axi_rresp <= 0;
        end else begin
            owner_cpu_claim <= 0;
            owner_cpu_release <= 0;
            if (owner_command_pending) begin
                if ((owner_command_is_release ? owner_release_accepted : owner_claim_accepted) && !owner_fault) begin
                    owner_command_pending <= 0;
                    owner_token_configured <= 0;
                    s_axi_bvalid <= 1;
                    s_axi_bresp <= 0;
                end else if (owner_fault || owner_command_wait == 3) begin
                    owner_command_pending <= 0;
                    owner_command_fault <= 1;
                    s_axi_bvalid <= 1;
                    s_axi_bresp <= 2'b10;
                end else owner_command_wait <= owner_command_wait + 1'b1;
            end
            if (s_axi_awvalid && s_axi_awready) begin
                aw_held <= 1;
                address_held <= s_axi_awaddr;
            end
            if (s_axi_wvalid && s_axi_wready) begin
                w_held <= 1;
                data_held <= s_axi_wdata;
                strobes_held <= s_axi_wstrb;
            end
            if (s_axi_bvalid && s_axi_bready) s_axi_bvalid <= 0;
            if (aw_held && w_held && !s_axi_bvalid) begin
                aw_held <= 0;
                w_held <= 0;
                s_axi_bvalid <= 1;
                s_axi_bresp <= 2'b10;
                if (strobes_held == 4'hf) begin
                    case (address_held)
                        12'h010: begin
                            if (data_held == 1 && !armed && (&configured) && cfg_frame_context[143:112] != 0 &&
                                (!OWNER_PROTOCOL || cfg_frame_context[79:48] != 0)) begin
                                armed <= 1;
                                s_axi_bresp <= 0;
                            end else if (data_held == 2 && armed && !abort_requested) begin
                                abort_requested <= 1;
                                s_axi_bresp <= 0;
                            end else if (data_held == 4 && armed && !barrier_request) begin
                                barrier_request <= 1;
                                s_axi_bresp <= 0;
                            end
                        end
                        12'h020, 12'h024, 12'h028, 12'h02c: begin
                            if (!armed) begin
                                cfg_frame_context[(address_held[3:2]*32) +: 32] <= data_held;
                                configured[address_held[3:2]] <= 1;
                                s_axi_bresp <= 0;
                            end
                        end
                        12'h030: begin
                            if (!armed && data_held[31:16] == 0) begin
                                cfg_frame_context[143:128] <= data_held[15:0];
                                configured[4] <= 1;
                                s_axi_bresp <= 0;
                            end
                        end
                        12'h040, 12'h044: begin
                            if (OWNER_PROTOCOL && armed && !owner_fault && !owner_command_fault) begin
                                if (address_held == 12'h040) owner_cpu_epoch <= data_held;
                                else owner_cpu_frame_id <= data_held;
                                owner_token_configured[address_held[2]] <= 1;
                                s_axi_bresp <= 0;
                            end
                        end
                        12'h048: begin
                            if (OWNER_PROTOCOL && armed && (&owner_token_configured) && !owner_fault &&
                                !owner_command_fault && (data_held == 1 || data_held == 2)) begin
                                owner_cpu_claim <= data_held == 1;
                                owner_cpu_release <= data_held == 2;
                                owner_command_pending <= 1;
                                owner_command_is_release <= data_held == 2;
                                owner_command_wait <= 0;
                                s_axi_bvalid <= 0;
                            end
                        end
                        default: begin end
                    endcase
                end
            end
            if (s_axi_rvalid && s_axi_rready) s_axi_rvalid <= 0;
            if (owner_status_pending) begin
                s_axi_rvalid <= 1;
                s_axi_rdata <= {25'd0,owner_status_held};
                s_axi_rresp <= 0;
                owner_status_pending <= 0;
            end
            if (s_axi_arvalid && s_axi_arready) begin
                s_axi_rvalid <= 1;
                s_axi_rdata <= 0;
                s_axi_rresp <= 0;
                case (s_axi_araddr)
                    12'h000: s_axi_rdata <= 32'h31435456;
                    12'h004: s_axi_rdata <= OWNER_PROTOCOL ? 32'h00020000 : 32'h00010000;
                    12'h008: s_axi_rdata <= {29'd0, barrier_request, abort_requested, armed};
                    12'h00c: s_axi_rdata <= {27'd0, configured};
                    12'h020, 12'h024, 12'h028, 12'h02c:
                        s_axi_rdata <= cfg_frame_context[(s_axi_araddr[3:2]*32) +: 32];
                    12'h030: s_axi_rdata <= {16'd0, cfg_frame_context[143:128]};
                    12'h040, 12'h044, 12'h04c, 12'h050, 12'h054, 12'h058, 12'h05c, 12'h060, 12'h064, 12'h068: begin
                        if (!OWNER_PROTOCOL) s_axi_rresp <= 2'b10;
                        else case (s_axi_araddr)
                            12'h040: s_axi_rdata <= owner_cpu_epoch;
                            12'h044: s_axi_rdata <= owner_cpu_frame_id;
                            12'h04c: begin
                                owner_status_held <= {owner_token_configured,owner_command_pending,
                                    owner_fault || owner_command_fault,owner_drained,owner_cpu_held,owner_available};
                                owner_status_pending <= 1;
                                s_axi_rvalid <= 0;
                            end
                            12'h050: s_axi_rdata <= owner_epoch;
                            12'h054: s_axi_rdata <= owner_frame_id;
                            12'h058: s_axi_rdata <= owner_slot;
                            12'h05c: s_axi_rdata <= owner_granted_frames;
                            12'h060: s_axi_rdata <= owner_released_frames;
                            12'h064: s_axi_rdata <= {27'd0,owner_command_fault,owner_fault_causes};
                            12'h068: s_axi_rdata <= 3;
                            default: s_axi_rresp <= 2'b10;
                        endcase
                    end
                    default: s_axi_rresp <= 2'b10;
                endcase
            end
        end
    end
endmodule