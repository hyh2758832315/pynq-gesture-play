`timescale 1ns/1ps
module axi_voice_volume #(
    parameter integer WINDOW_SAMPLES = 977,
    parameter integer SAMPLE_TIMEOUT_CLKS = 1000000,
    parameter integer EVENT_TIMEOUT_CLKS = 10000000
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
    output reg [1:0] s_axi_bresp,
    output reg s_axi_bvalid,
    input wire s_axi_bready,
    input wire [11:0] s_axi_araddr,
    input wire [2:0] s_axi_arprot,
    input wire s_axi_arvalid,
    output wire s_axi_arready,
    output reg [31:0] s_axi_rdata,
    output reg [1:0] s_axi_rresp,
    output reg s_axi_rvalid,
    input wire s_axi_rready,
    input wire pcm_valid,
    input wire signed [15:0] pcm_s16,
    input wire input_fault,
    input wire clock_locked
);
    reg aw_held, w_held;
    reg [11:0] write_address;
    reg [31:0] write_data;
    reg [3:0] write_strobe;
    reg [31:0] shadow_soft, shadow_loud, shadow_quiet, shadow_enable;
    reg [31:0] soft_sum, loud_sum, quiet_sum, config_epoch;
    reg enable, configure, ack_valid;
    reg [31:0] ack_epoch, ack_sequence;
    wire [2:0] state;
    wire [7:0] faults;
    wire ack_error, window_valid, event_pending;
    wire [63:0] sample_count, event_sample;
    wire [31:0] window_count, last_sum, event_sequence, event_epoch, event_window, event_age;
    wire [1:0] event_kind;
    wire [31:0] status = {21'd0, state, 3'd0, ack_error, clock_locked, (|faults), event_pending, enable};
    reg [31:0] snapshot [0:16];
    reg [31:0] snapshot_sequence;
    reg snapshot_valid;
    integer index;
    assign s_axi_awready = s_axi_aresetn && !aw_held && !s_axi_bvalid;
    assign s_axi_wready = s_axi_aresetn && !w_held && !s_axi_bvalid;
    assign s_axi_arready = s_axi_aresetn && !s_axi_rvalid;
    voice_volume_core #(.WINDOW_SAMPLES(WINDOW_SAMPLES), .SAMPLE_TIMEOUT_CLKS(SAMPLE_TIMEOUT_CLKS),
                        .EVENT_TIMEOUT_CLKS(EVENT_TIMEOUT_CLKS)) core (
        .clk(s_axi_aclk), .rst_n(s_axi_aresetn), .enable(enable), .configure(configure),
        .config_epoch(config_epoch), .soft_sum(soft_sum), .loud_sum(loud_sum), .quiet_sum(quiet_sum),
        .pcm_valid(pcm_valid), .pcm_s16(pcm_s16), .input_fault(input_fault || !clock_locked),
        .ack_valid(ack_valid), .ack_epoch(ack_epoch), .ack_sequence(ack_sequence),
        .state(state), .faults(faults), .ack_error(ack_error), .sample_count(sample_count),
        .window_count(window_count), .last_sum(last_sum), .window_valid(window_valid),
        .event_pending(event_pending), .event_kind(event_kind), .event_sequence(event_sequence),
        .event_epoch(event_epoch), .event_sample(event_sample), .event_window(event_window), .event_age(event_age)
    );
    always @(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            aw_held <= 0; w_held <= 0; write_address <= 0; write_data <= 0; write_strobe <= 0;
            s_axi_bvalid <= 0; s_axi_bresp <= 0; s_axi_rvalid <= 0; s_axi_rresp <= 0; s_axi_rdata <= 0;
            shadow_soft <= 1000000; shadow_loud <= 4000000; shadow_quiet <= 500000; shadow_enable <= 0;
            soft_sum <= 1000000; loud_sum <= 4000000; quiet_sum <= 500000;
            enable <= 0; configure <= 0; config_epoch <= 0;
            ack_valid <= 0; ack_epoch <= 0; ack_sequence <= 0;
            snapshot_sequence <= 0; snapshot_valid <= 0;
            for (index = 0; index < 17; index = index + 1) snapshot[index] <= 0;
        end else begin
            configure <= 0; ack_valid <= 0;
            if (s_axi_bvalid && s_axi_bready) s_axi_bvalid <= 0;
            if (s_axi_rvalid && s_axi_rready) s_axi_rvalid <= 0;
            if (s_axi_awvalid && s_axi_awready) begin aw_held <= 1; write_address <= s_axi_awaddr; end
            if (s_axi_wvalid && s_axi_wready) begin
                w_held <= 1; write_data <= s_axi_wdata; write_strobe <= s_axi_wstrb;
            end
            if (aw_held && w_held && !s_axi_bvalid) begin
                aw_held <= 0; w_held <= 0; s_axi_bvalid <= 1; s_axi_bresp <= 0;
                if (write_strobe != 4'hf || write_address[1:0] != 0) s_axi_bresp <= 2;
                else case (write_address)
                    12'h020: shadow_soft <= write_data;
                    12'h024: shadow_loud <= write_data;
                    12'h028: shadow_quiet <= write_data;
                    12'h02c: if (write_data <= 1) shadow_enable <= write_data; else s_axi_bresp <= 2;
                    12'h034: ack_epoch <= write_data;
                    12'h038: ack_sequence <= write_data;
                    12'h030: case (write_data)
                        1: if (shadow_soft == 0 || shadow_loud <= shadow_soft || shadow_quiet >= shadow_soft || config_epoch == 32'hffffffff)
                            s_axi_bresp <= 2;
                        else begin
                            soft_sum <= shadow_soft; loud_sum <= shadow_loud; quiet_sum <= shadow_quiet;
                            enable <= shadow_enable[0]; config_epoch <= config_epoch + 1; configure <= 1;
                            snapshot_valid <= 0;
                        end
                        2: begin
                            snapshot_valid <= 1; snapshot_sequence <= snapshot_sequence + 1;
                            snapshot[0] <= status; snapshot[1] <= {24'd0, faults}; snapshot[2] <= config_epoch;
                            snapshot[3] <= sample_count[31:0]; snapshot[4] <= sample_count[63:32];
                            snapshot[5] <= window_count; snapshot[6] <= last_sum;
                            snapshot[7] <= event_sequence; snapshot[8] <= event_epoch;
                            snapshot[9] <= {29'd0, event_pending, event_kind};
                            snapshot[10] <= event_sample[31:0]; snapshot[11] <= event_sample[63:32];
                            snapshot[12] <= event_window; snapshot[13] <= event_age;
                            snapshot[14] <= soft_sum; snapshot[15] <= loud_sum; snapshot[16] <= quiet_sum;
                        end
                        4: begin ack_valid <= 1; snapshot_valid <= 0; end
                        default: s_axi_bresp <= 2;
                    endcase
                    default: s_axi_bresp <= 2;
                endcase
            end
            if (configure || faults != 0 || !enable) snapshot_valid <= 0;
            if (s_axi_arvalid && s_axi_arready) begin
                s_axi_rvalid <= 1; s_axi_rresp <= 0; s_axi_rdata <= 0;
                case (s_axi_araddr)
                    12'h000: s_axi_rdata <= 32'h564f4c31;
                    12'h004: s_axi_rdata <= 32'hc00c0001;
                    12'h008: s_axi_rdata <= 32'h00010000;
                    12'h010: s_axi_rdata <= status;
                    12'h014: s_axi_rdata <= {24'd0, faults};
                    12'h018: s_axi_rdata <= config_epoch;
                    12'h01c: s_axi_rdata <= WINDOW_SAMPLES;
                    12'h020: s_axi_rdata <= shadow_soft;
                    12'h024: s_axi_rdata <= shadow_loud;
                    12'h028: s_axi_rdata <= shadow_quiet;
                    12'h02c: s_axi_rdata <= shadow_enable;
                    12'h034: s_axi_rdata <= ack_epoch;
                    12'h038: s_axi_rdata <= ack_sequence;
                    12'h03c: s_axi_rdata <= snapshot_sequence;
                    12'h084: s_axi_rdata <= {31'd0, snapshot_valid};
                    default: if (s_axi_araddr >= 12'h040 && s_axi_araddr <= 12'h080 && s_axi_araddr[1:0] == 0)
                        s_axi_rdata <= snapshot[(s_axi_araddr - 12'h040) >> 2];
                    else s_axi_rresp <= 2;
                endcase
            end
        end
    end
endmodule