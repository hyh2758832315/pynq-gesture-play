module axi_vision_capture_status (
    input wire s_axi_aclk, s_axi_aresetn,
    input wire [11:0] s_axi_awaddr,
    input wire s_axi_awvalid,
    output wire s_axi_awready,
    input wire [31:0] s_axi_wdata,
    input wire [3:0] s_axi_wstrb,
    input wire s_axi_wvalid,
    output wire s_axi_wready,
    output wire [1:0] s_axi_bresp,
    output reg s_axi_bvalid,
    input wire s_axi_bready,
    input wire [11:0] s_axi_araddr,
    input wire s_axi_arvalid,
    output wire s_axi_arready,
    output reg [31:0] s_axi_rdata,
    output reg [1:0] s_axi_rresp,
    output reg s_axi_rvalid,
    input wire s_axi_rready,
    input wire monitor_ready,
    input wire capture_armed,
    input wire epoch_sealed,
    input wire [31:0] capture_epoch,
    input wire [2:0] fault_causes
);
    reg aw_held, w_held, epoch_seen;
    reg [31:0] epoch_held;
    reg [2:0] faults_held;
    wire protocol_fault = epoch_seen && (!monitor_ready || !capture_armed || capture_epoch != epoch_held);
    wire [2:0] faults = faults_held | fault_causes | {protocol_fault, 2'b00};
    wire ready = monitor_ready && epoch_seen;
    assign s_axi_awready = s_axi_aresetn && !aw_held && !s_axi_bvalid;
    assign s_axi_wready = s_axi_aresetn && !w_held && !s_axi_bvalid;
    assign s_axi_bresp = 2'b10;
    assign s_axi_arready = s_axi_aresetn && !s_axi_rvalid;

    always @(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            aw_held <= 0;
            w_held <= 0;
            s_axi_bvalid <= 0;
            s_axi_rvalid <= 0;
            s_axi_rdata <= 0;
            s_axi_rresp <= 0;
            epoch_seen <= 0;
            epoch_held <= 0;
            faults_held <= 0;
        end else begin
            faults_held <= faults;
            if (monitor_ready && capture_armed && !epoch_seen) begin
                epoch_held <= capture_epoch;
                epoch_seen <= 1;
            end
            if (s_axi_awvalid && s_axi_awready) aw_held <= 1;
            if (s_axi_wvalid && s_axi_wready) w_held <= 1;
            if (s_axi_bvalid && s_axi_bready) s_axi_bvalid <= 0;
            if (aw_held && w_held && !s_axi_bvalid) begin
                aw_held <= 0;
                w_held <= 0;
                s_axi_bvalid <= 1;
            end
            if (s_axi_rvalid && s_axi_rready) s_axi_rvalid <= 0;
            if (s_axi_arvalid && s_axi_arready) begin
                s_axi_rvalid <= 1;
                s_axi_rdata <= 0;
                s_axi_rresp <= 0;
                case (s_axi_araddr)
                    12'h000: s_axi_rdata <= 32'h31545356;
                    12'h004: s_axi_rdata <= 32'h00010000;
                    12'h008: s_axi_rdata <= {29'd0, |faults, epoch_sealed && ready, ready};
                    12'h00c: s_axi_rdata <= {29'd0, faults};
                    12'h010: s_axi_rdata <= epoch_held;
                    default: s_axi_rresp <= 2'b10;
                endcase
            end
        end
    end
endmodule