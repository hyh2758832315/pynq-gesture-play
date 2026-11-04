module vision_frame_owner #(
    parameter integer BUFFER_SLOTS = 3
)(
    input wire aclk, common_aresetn, enabled, upstream_fault,
    input wire [31:0] cfg_epoch, cfg_first_frame_id,
    input wire grant_request,
    output wire grant_ready,
    output wire [31:0] grant_frame_id,
    output wire [$clog2(BUFFER_SLOTS)-1:0] grant_slot,
    input wire [31:0] rgb_completed_frames, packet_completed_frames, status_completed_frames,
    input wire source_closed,
    input wire [31:0] closed_frame_count,
    input wire cpu_claim, cpu_release,
    input wire [31:0] cpu_epoch, cpu_frame_id,
    output wire cpu_available,
    output wire [31:0] available_epoch, available_frame_id,
    output wire [$clog2(BUFFER_SLOTS)-1:0] available_slot,
    output reg cpu_held,
    output reg claim_accepted, release_accepted,
    output reg [31:0] granted_frames, released_frames,
    output wire owner_drained, owner_fault,
    output reg [3:0] fault_causes
);
    localparam integer SLOT_BITS = $clog2(BUFFER_SLOTS);
    reg configuration_locked, closure_held;
    reg [31:0] epoch, first_frame_id, final_frame_count;
    reg [31:0] previous_rgb, previous_packet, previous_status;
    reg [SLOT_BITS-1:0] producer_slot, consumer_slot;
    wire [32:0] next_identity = {1'b0,first_frame_id} + granted_frames;
    wire [32:0] consumer_identity = {1'b0,first_frame_id} + released_frames;
    wire configuration_bad = configuration_locked &&
        (!enabled || cfg_epoch != epoch || cfg_first_frame_id != first_frame_id);
    wire counters_bad = configuration_locked &&
        (rgb_completed_frames < previous_rgb || packet_completed_frames < previous_packet ||
         status_completed_frames < previous_status || rgb_completed_frames > granted_frames ||
         packet_completed_frames > granted_frames || status_completed_frames > granted_frames);
    wire closure_bad = (closure_held && (!source_closed || closed_frame_count != final_frame_count)) ||
        (source_closed && closed_frame_count < granted_frames);
    wire exhausted_request = grant_request && next_identity[32];
    assign owner_fault = upstream_fault || (|fault_causes) || configuration_bad || counters_bad ||
        (configuration_locked && closure_bad);
    assign grant_ready = common_aresetn && configuration_locked && enabled && !owner_fault &&
        granted_frames - released_frames < BUFFER_SLOTS && !next_identity[32] &&
        granted_frames != 32'hffffffff && (!source_closed || granted_frames < closed_frame_count);
    assign grant_frame_id = next_identity[31:0];
    assign grant_slot = producer_slot;
    assign cpu_available = common_aresetn && configuration_locked && enabled && !owner_fault && !cpu_held &&
        released_frames < granted_frames && released_frames < rgb_completed_frames &&
        released_frames < packet_completed_frames && released_frames < status_completed_frames;
    assign available_epoch = epoch;
    assign available_frame_id = consumer_identity[31:0];
    assign available_slot = consumer_slot;
    wire token_matches = cpu_epoch == epoch && cpu_frame_id == available_frame_id;
    assign owner_drained = common_aresetn && configuration_locked && enabled && !owner_fault && closure_held &&
        granted_frames == final_frame_count && released_frames == granted_frames &&
        rgb_completed_frames == granted_frames && packet_completed_frames == granted_frames &&
        status_completed_frames == granted_frames && !cpu_held && !grant_request && !cpu_claim && !cpu_release;
    initial begin
        if (BUFFER_SLOTS < 2 || BUFFER_SLOTS > 16) $fatal(1,"FRAME_OWNER buffer capacity outside capability");
    end
    always @(posedge aclk) begin
        if (!common_aresetn) begin
            configuration_locked <= 0;
            closure_held <= 0;
            epoch <= 0;
            first_frame_id <= 0;
            final_frame_count <= 0;
            previous_rgb <= 0;
            previous_packet <= 0;
            previous_status <= 0;
            producer_slot <= 0;
            consumer_slot <= 0;
            granted_frames <= 0;
            released_frames <= 0;
            cpu_held <= 0;
            claim_accepted <= 0;
            release_accepted <= 0;
            fault_causes <= 0;
        end else begin
            claim_accepted <= 0;
            release_accepted <= 0;
            if (upstream_fault) fault_causes[0] <= 1;
            if (enabled && !configuration_locked) begin
                if (cfg_epoch == 0 || cfg_first_frame_id == 0 || rgb_completed_frames != 0 ||
                    packet_completed_frames != 0 || status_completed_frames != 0 || cpu_claim || cpu_release)
                    fault_causes[3] <= 1;
                else begin
                    configuration_locked <= 1;
                    epoch <= cfg_epoch;
                    first_frame_id <= cfg_first_frame_id;
                end
            end
            if (configuration_locked) begin
                previous_rgb <= rgb_completed_frames;
                previous_packet <= packet_completed_frames;
                previous_status <= status_completed_frames;
                if (configuration_bad) fault_causes[3] <= 1;
                if (counters_bad || closure_bad || exhausted_request) fault_causes[2] <= 1;
                if (source_closed && !closure_held) begin
                    closure_held <= 1;
                    final_frame_count <= closed_frame_count;
                end
                if (!owner_fault) begin
                    if (grant_request && grant_ready) begin
                        granted_frames <= granted_frames + 1'b1;
                        producer_slot <= producer_slot == BUFFER_SLOTS-1 ? 0 : producer_slot + 1'b1;
                    end
                    if (cpu_claim && cpu_release) fault_causes[1] <= 1;
                    else if (cpu_claim) begin
                        if (!cpu_available || !token_matches) fault_causes[1] <= 1;
                        else begin cpu_held <= 1; claim_accepted <= 1; end
                    end else if (cpu_release) begin
                        if (!cpu_held || !token_matches) fault_causes[1] <= 1;
                        else begin
                            cpu_held <= 0;
                            release_accepted <= 1;
                            released_frames <= released_frames + 1'b1;
                            consumer_slot <= consumer_slot == BUFFER_SLOTS-1 ? 0 : consumer_slot + 1'b1;
                        end
                    end
                end
            end else if (!enabled && (cpu_claim || cpu_release)) fault_causes[1] <= 1;
        end
    end
endmodule