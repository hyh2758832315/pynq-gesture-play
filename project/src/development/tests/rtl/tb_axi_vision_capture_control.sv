`timescale 1ns/1ps
module tb_axi_vision_capture_control #(parameter CHECK_SOFTWARE_RESET = 0, parameter TEST_OWNER_PROTOCOL = 0);
    reg clock = 0, clock_enable = 1;
    always #5 if (clock_enable) clock = !clock;
    reg resetn = 0, awvalid = 0, wvalid = 0, bready = 0, arvalid = 0, rready = 0;
    reg software_resetn = 1;
    reg [11:0] awaddr = 0, araddr = 0;
    reg [31:0] wdata = 0;
    reg [3:0] wstrb = 0;
    wire awready, wready, bvalid, arready, rvalid;
    wire [1:0] bresp, rresp;
    wire [31:0] rdata;
    wire [143:0] context_data;
    wire capture_resetn, armed, abort_requested, barrier_request;
    integer reads = 0, writes = 0, word_index;
    integer status_snapshot_changes = 0;
    reg [31:0] words [0:4];
    reg [143:0] frozen_context;
    reg owner_grant_request = 0, owner_source_closed = 0;
    reg [31:0] owner_rgb_frames = 0, owner_packet_frames = 0, owner_status_frames = 0, owner_closed_frames = 0;
    wire owner_available, owner_cpu_held, owner_drained, owner_fault, owner_claim_accepted, owner_release_accepted;
    wire owner_cpu_claim, owner_cpu_release, owner_command_fault, owner_grant_ready;
    wire [31:0] owner_epoch, owner_frame_id, owner_granted_frames, owner_released_frames;
    wire [31:0] owner_cpu_epoch, owner_cpu_frame_id;
    wire [1:0] owner_slot;
    wire [3:0] owner_fault_causes;
    reg [159:0] desired_context;
    axi_vision_capture_control #(.OWNER_PROTOCOL(TEST_OWNER_PROTOCOL)) dut (
        .s_axi_aclk(clock), .s_axi_aresetn(resetn && software_resetn), .common_aresetn(resetn),
        .s_axi_awaddr(awaddr), .s_axi_awvalid(awvalid), .s_axi_awready(awready),
        .s_axi_wdata(wdata), .s_axi_wstrb(wstrb), .s_axi_wvalid(wvalid), .s_axi_wready(wready),
        .s_axi_bresp(bresp), .s_axi_bvalid(bvalid), .s_axi_bready(bready),
        .s_axi_araddr(araddr), .s_axi_arvalid(arvalid), .s_axi_arready(arready),
        .s_axi_rdata(rdata), .s_axi_rresp(rresp), .s_axi_rvalid(rvalid), .s_axi_rready(rready),
        .cfg_frame_context(context_data), .capture_aresetn(capture_resetn),
        .armed(armed), .abort_requested(abort_requested), .barrier_request(barrier_request),
        .owner_available(owner_available), .owner_cpu_held(owner_cpu_held), .owner_drained(owner_drained), .owner_fault(owner_fault),
        .owner_claim_accepted(owner_claim_accepted), .owner_release_accepted(owner_release_accepted),
        .owner_epoch(owner_epoch), .owner_frame_id(owner_frame_id), .owner_slot({30'd0,owner_slot}),
        .owner_granted_frames(owner_granted_frames), .owner_released_frames(owner_released_frames),
        .owner_fault_causes(owner_fault_causes), .owner_cpu_claim(owner_cpu_claim), .owner_cpu_release(owner_cpu_release),
        .owner_cpu_epoch(owner_cpu_epoch), .owner_cpu_frame_id(owner_cpu_frame_id), .owner_command_fault(owner_command_fault)
    );
    if (TEST_OWNER_PROTOCOL) begin : owner_mode
        vision_frame_owner owner (
            .aclk(clock), .common_aresetn(resetn), .enabled(armed), .upstream_fault(owner_command_fault),
            .cfg_epoch(context_data[143:112]), .cfg_first_frame_id(context_data[79:48]),
            .grant_request(owner_grant_request), .grant_ready(owner_grant_ready), .grant_frame_id(), .grant_slot(),
            .rgb_completed_frames(owner_rgb_frames), .packet_completed_frames(owner_packet_frames), .status_completed_frames(owner_status_frames),
            .source_closed(owner_source_closed), .closed_frame_count(owner_closed_frames),
            .cpu_claim(owner_cpu_claim), .cpu_release(owner_cpu_release), .cpu_epoch(owner_cpu_epoch), .cpu_frame_id(owner_cpu_frame_id),
            .cpu_available(owner_available), .available_epoch(owner_epoch), .available_frame_id(owner_frame_id), .available_slot(owner_slot),
            .cpu_held(owner_cpu_held), .claim_accepted(owner_claim_accepted), .release_accepted(owner_release_accepted),
            .granted_frames(owner_granted_frames), .released_frames(owner_released_frames), .owner_drained(owner_drained),
            .owner_fault(owner_fault), .fault_causes(owner_fault_causes)
        );
    end else begin : legacy_owner_disabled
        assign owner_available = 0;
        assign owner_cpu_held = 0;
        assign owner_drained = 0;
        assign owner_fault = 0;
        assign owner_claim_accepted = 0;
        assign owner_release_accepted = 0;
        assign owner_epoch = 0;
        assign owner_frame_id = 0;
        assign owner_slot = 0;
        assign owner_granted_frames = 0;
        assign owner_released_frames = 0;
        assign owner_fault_causes = 0;
        assign owner_grant_ready = 0;
    end
    task automatic common_reset;
        begin
            @(negedge clock);
            resetn = 0; awvalid = 0; wvalid = 0; arvalid = 0; bready = 0; rready = 0;
            repeat (4) @(negedge clock);
            if (rvalid || bvalid || awready || wready || arready || capture_resetn ||
                armed || abort_requested || barrier_request || context_data !== 0)
                $fatal(1, "CONTROL reset contract failed");
            resetn = 1;
            repeat (2) @(negedge clock);
        end
    endtask
    task automatic send_aw;
        begin
            @(negedge clock); awvalid = 1;
            do @(posedge clock); while (!awready);
            @(negedge clock); awvalid = 0; awaddr = 12'hffc;
        end
    endtask
    task automatic send_w;
        begin
            @(negedge clock); wvalid = 1;
            do @(posedge clock); while (!wready);
            @(negedge clock); wvalid = 0; wdata = 32'hdeadbeef; wstrb = 0;
        end
    endtask
    task automatic finish_write(input [1:0] expected_response);
        begin
            wait (bvalid);
            repeat (3) begin
                @(negedge clock);
                if (!bvalid || bresp !== expected_response || awready || wready)
                    $fatal(1, "CONTROL write response mismatch write=%0d resp=%b", writes, bresp);
            end
            bready = 1;
            @(posedge clock);
            @(negedge clock); bready = 0;
            writes = writes + 1;
        end
    endtask
    task automatic write_word(input [11:0] address, input [31:0] value,
                              input [3:0] strobes, input [1:0] expected_response);
        begin
            awaddr = address; wdata = value; wstrb = strobes;
            if (writes % 2) begin send_aw(); repeat (3) @(negedge clock); send_w(); end
            else begin send_w(); repeat (3) @(negedge clock); send_aw(); end
            finish_write(expected_response);
        end
    endtask
    task automatic read_word(input [11:0] address, input [31:0] expected, input [1:0] expected_response);
        reg [33:0] held;
        begin
            @(negedge clock); araddr = address; arvalid = 1;
            do @(posedge clock); while (!arready);
            @(negedge clock); arvalid = 0; araddr = 12'hffc;
            if (TEST_OWNER_PROTOCOL && address == 12'h04c) begin
                if (rvalid || arready) $fatal(1,"OWNER_CONTROL status pipeline accepted or responded early");
                if (owner_status_frames == 0 && owner_rgb_frames == 3 && owner_packet_frames == 3) begin
                    owner_status_frames = 3;
                    status_snapshot_changes = status_snapshot_changes + 1;
                end
            end
            wait (rvalid); held = {rresp, rdata};
            repeat (3) begin
                @(negedge clock);
                if (!rvalid || arready || {rresp, rdata} !== held)
                    $fatal(1, "CONTROL stalled read response changed");
            end
            if (rdata !== expected || rresp !== expected_response)
                $fatal(1, "CONTROL read mismatch addr=%h actual=%h expected=%h resp=%b", address, rdata, expected, rresp);
            rready = 1;
            @(posedge clock);
            @(negedge clock); rready = 0;
            reads = reads + 1;
        end
    endtask
    task automatic owner_arm;
        begin
            owner_grant_request = 0; owner_source_closed = 0;
            owner_rgb_frames = 0; owner_packet_frames = 0; owner_status_frames = 0; owner_closed_frames = 0;
            software_resetn = 1;
            common_reset();
            desired_context = {16'd0,32'd31,32'd23,32'd1,48'hff00ff00ff00};
            for (integer index = 0; index < 5; index = index+1)
                write_word(32+4*index,desired_context[index*32 +: 32],15,0);
            write_word(16,1,15,0);
            read_word(4,32'h00020000,0); read_word(12'h068,3,0);
            owner_grant_request = 1;
            repeat (3) @(negedge clock);
            owner_grant_request = 0;
            read_word(12'h05c,3,0);
        end
    endtask
    task automatic owner_command(input [31:0] identity, epoch_value, command, input [1:0] response);
        begin
            write_word(12'h040,epoch_value,15,0);
            write_word(12'h044,identity,15,0);
            write_word(12'h048,command,15,response);
        end
    endtask
    initial begin
        if (TEST_OWNER_PROTOCOL) begin
            owner_arm(); owner_rgb_frames = 3; owner_packet_frames = 3;
            read_word(12'h04c,0,0);
            if (status_snapshot_changes != 1 || !owner_available)
                $fatal(1,"OWNER_CONTROL status AR snapshot stimulus missing");
            owner_status_frames = 3; owner_source_closed = 1; owner_closed_frames = 3;
            read_word(12'h04c,1,0);
            for (integer identity = 1; identity <= 3; identity = identity+1) begin
                read_word(12'h050,31,0); read_word(12'h054,identity,0); read_word(12'h058,identity-1,0);
                owner_command(identity,31,1,0); read_word(12'h04c,2,0);
                repeat (64) begin
                    @(negedge clock);
                    if (!owner_cpu_held || owner_fault || owner_released_frames != identity-1)
                        $fatal(1,"OWNER_CONTROL CPU hold escaped");
                end
                owner_command(identity,31,2,0);
                read_word(12'h060,identity,0);
            end
            read_word(12'h04c,4,0);

            owner_arm(); owner_rgb_frames = 3; owner_packet_frames = 3; owner_status_frames = 3;
            owner_command(1,32,1,2); read_word(12'h04c,32'h68,0);
            if (!owner_fault || owner_released_frames != 0) $fatal(1,"OWNER_CONTROL wrong epoch freed owner");

            owner_arm(); owner_command(1,31,1,2); read_word(12'h04c,32'h68,0);
            if (!owner_fault || owner_released_frames != 0) $fatal(1,"OWNER_CONTROL early claim freed owner");

            owner_arm(); owner_rgb_frames = 3; owner_packet_frames = 3; owner_status_frames = 3;
            owner_command(1,31,1,0); owner_command(2,31,2,2); read_word(12'h04c,32'h6a,0);
            if (!owner_fault || !owner_cpu_held || owner_released_frames != 0) $fatal(1,"OWNER_CONTROL wrong frame released slot");

            owner_arm(); owner_rgb_frames = 3; owner_packet_frames = 3; owner_status_frames = 3;
            owner_command(1,31,1,0);
            @(negedge clock); software_resetn = 0;
            repeat (4) @(negedge clock);
            if (!owner_fault || !owner_cpu_held || owner_released_frames != 0 || armed || capture_resetn)
                $fatal(1,"OWNER_CONTROL software reset recycled held buffer");
            software_resetn = 1; repeat (4) @(negedge clock);
            if (!owner_fault || !owner_cpu_held || armed) $fatal(1,"OWNER_CONTROL reset release reopened owner");
            @(negedge clock); araddr = 12'h04c; arvalid = 1;
            do @(posedge clock); while (!arready);
            @(negedge clock); arvalid = 0; araddr = 12'hffc;
            if (rvalid || arready) $fatal(1,"OWNER_CONTROL pending reset stimulus missing");
            resetn = 0;
            repeat (4) @(negedge clock);
            if (rvalid || arready || owner_cpu_held) $fatal(1,"OWNER_CONTROL common reset retained pending read");
            resetn = 1;
            repeat (4) @(negedge clock);
            if (rvalid) $fatal(1,"OWNER_CONTROL orphan response after reset");
            read_word(4,32'h00020000,0);
            $display("TEST_PASS OWNER_STATUS_READ_PIPELINE AR_SNAPSHOT PENDING_NO_NEW_AR R_STALL COMMON_RESET_PENDING_CLEAR");
            $display("TEST_PASS AXI_VISION_OWNER_CONTROL scenarios=5 reads=%0d writes=%0d ABI2 THREE_ACK CPU_HOLD64 TOKENS_WRONG_EPOCH_EARLY_CLAIM_WRONG_RELEASE RESET_RETAINS AW_W_B_R_STALL",reads,writes);
            $finish;
        end else begin
        words[0] = 32'h44332211; words[1] = 32'h88776655; words[2] = 32'hccbbaa99;
        words[3] = 0; words[4] = 0;
        common_reset();
        read_word(0, 32'h31435456, 0); read_word(4, 32'h00010000, 0);
        read_word(8, 0, 0); read_word(12, 0, 0);
        write_word(16, 1, 15, 2); write_word(16, 4, 15, 2);
        write_word(32, 32'hffffffff, 3, 2);
        read_word(12, 0, 0); read_word(32, 0, 0);
        write_word(1, 0, 15, 2); write_word(0, 0, 15, 2);
        for (word_index = 0; word_index < 5; word_index = word_index + 1) begin
            write_word(32 + 4*word_index, words[word_index], 15, 0);
            read_word(32 + 4*word_index, words[word_index], 0);
        end
        read_word(12, 31, 0);
        write_word(48, 32'h10000, 15, 2); read_word(48, 0, 0);
        write_word(16, 1, 15, 2);
        if (capture_resetn || armed) $fatal(1, "CONTROL zero epoch armed");
        words[3] = 32'h00010000;
        write_word(44, words[3], 15, 0);
        write_word(16, 1, 15, 0);
        frozen_context = {16'd0, words[3], words[2], words[1], words[0]};
        if (!armed || !capture_resetn || context_data !== frozen_context)
            $fatal(1, "CONTROL arm/context mismatch");
        read_word(8, 1, 0);
        write_word(16, 1, 15, 2);
        write_word(32, 0, 15, 2);
        write_word(16, 2, 15, 0); read_word(8, 3, 0);
        if (!capture_resetn) $fatal(1, "CONTROL abort reset accepted pipeline work");
        write_word(16, 4, 15, 0); read_word(8, 7, 0);
        write_word(16, 4, 15, 2); write_word(16, 2, 15, 2);
        write_word(16, 3, 15, 2); write_word(16, 2, 0, 2);
        for (word_index = 0; word_index < 5; word_index = word_index + 1) begin
            write_word(32 + 4*word_index, 0, 15, 2);
            read_word(32 + 4*word_index, words[word_index], 0);
        end
        write_word(16, 0, 15, 2);
        if (context_data !== frozen_context || !armed || !abort_requested || !barrier_request || !capture_resetn)
            $fatal(1, "CONTROL post-arm mutation");
        read_word(16, 0, 2); read_word(1, 0, 2); read_word(12'hffc, 0, 2);
        @(negedge clock); clock_enable = 0;
        #2; resetn = 0;
        #1;
        if (capture_resetn !== 0) $fatal(1, "CONTROL stopped-clock reset did not assert asynchronously");
        #20;
        if (capture_resetn !== 0) $fatal(1, "CONTROL stopped-clock reset permission escaped");
        clock_enable = 1;
        common_reset();
        read_word(8, 0, 0); read_word(12, 0, 0);
        awaddr = 32; send_aw(); common_reset();
        wdata = 32'hfedcba98; wstrb = 15; send_w();
        repeat (4) @(negedge clock);
        if (bvalid) $fatal(1, "CONTROL AW survived reset");
        awaddr = 32; send_aw(); finish_write(0);
        read_word(32, 32'hfedcba98, 0); read_word(12, 1, 0);
        common_reset();
        wdata = 32'hffffffff; wstrb = 15; send_w(); common_reset();
        awaddr = 36; send_aw();
        repeat (4) @(negedge clock);
        if (bvalid) $fatal(1, "CONTROL W survived reset");
        wdata = 32'h12345678; wstrb = 15; send_w(); finish_write(0);
        read_word(36, 32'h12345678, 0); read_word(12, 2, 0);
        @(negedge clock); araddr = 0; arvalid = 1;
        do @(posedge clock); while (!arready);
        @(negedge clock); arvalid = 0;
        wait (rvalid); common_reset();
        if (writes != 30 || reads != 30) $fatal(1, "CONTROL transaction count differs writes=%0d reads=%0d", writes, reads);
        if (CHECK_SOFTWARE_RESET) begin
            for (word_index = 0; word_index < 5; word_index = word_index + 1)
                write_word(32 + 4*word_index, words[word_index], 15, 0);
            write_word(16, 1, 15, 0);
            if (!armed || !capture_resetn) $fatal(1, "CONTROL software reset fixture did not arm");
            @(negedge clock); software_resetn = 0;
            @(posedge clock); #1;
            if (capture_resetn || armed || abort_requested || barrier_request || context_data !== 0)
                $fatal(1, "CONTROL software reset did not synchronously revoke epoch");
            @(negedge clock); software_resetn = 1;
            repeat (4) @(negedge clock);
            if (capture_resetn || armed) $fatal(1, "CONTROL software reset release rearmed old epoch");
            read_word(12, 0, 0);
            if (writes != 36 || reads != 31) $fatal(1, "CONTROL software reset transaction count differs");
            $display("TEST_PASS AXI_VISION_CAPTURE_CONTROL_SOFTWARE_RESET original_reads=30 original_writes=30 final_reads=%0d final_writes=%0d NO_IMPLICIT_REARM", reads, writes);
        end else begin
            $display("TEST_PASS AXI_VISION_CAPTURE_CONTROL reads=%0d writes=%0d ONE_SHOT_CONTEXT_STALL_ABORT_RESET STOPPED_CLOCK_ASYNC_ASSERT", reads, writes);
        end
        $finish;
        end
    end
    initial begin
        #100000;
        $fatal(1, "CONTROL watchdog expired");
    end
endmodule

module tb_axi_vision_capture_control_software_reset;
    tb_axi_vision_capture_control #(.CHECK_SOFTWARE_RESET(1)) test();
endmodule

module tb_axi_vision_owner_control;
    tb_axi_vision_capture_control #(.TEST_OWNER_PROTOCOL(1)) cases ();
endmodule