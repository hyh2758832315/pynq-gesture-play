`timescale 1ns/1ps
module tb_vision_frame_owner;
    reg aclk = 0, common_aresetn = 0, enabled = 0, upstream_fault = 0;
    always #5 aclk = ~aclk;
    reg [31:0] cfg_epoch = 31, cfg_first_frame_id = 1;
    reg grant_request = 0, source_closed = 0, cpu_claim = 0, cpu_release = 0;
    reg [31:0] rgb_completed_frames = 0, packet_completed_frames = 0, status_completed_frames = 0;
    reg [31:0] closed_frame_count = 0, cpu_epoch = 31, cpu_frame_id = 1;
    wire grant_ready, cpu_available, cpu_held, claim_accepted, release_accepted, owner_drained, owner_fault;
    wire [31:0] grant_frame_id, available_epoch, available_frame_id, granted_frames, released_frames;
    wire [1:0] grant_slot, available_slot;
    wire [3:0] fault_causes;
    integer checks = 0, scenarios = 0;
    vision_frame_owner dut (.*);
    task automatic tick;
        @(posedge aclk); #0.001; @(negedge aclk);
    endtask
    task automatic check(input bit condition, input string message);
        checks = checks + 1;
        if (!condition) $fatal(1,"FRAME_OWNER_FAIL %s granted=%0d released=%0d held=%b causes=%h",message,granted_frames,released_frames,cpu_held,fault_causes);
    endtask
    task automatic reset_case;
        @(negedge aclk);
        common_aresetn = 0; enabled = 0; upstream_fault = 0; cfg_epoch = 31; cfg_first_frame_id = 1;
        grant_request = 0; source_closed = 0; cpu_claim = 0; cpu_release = 0;
        rgb_completed_frames = 0; packet_completed_frames = 0; status_completed_frames = 0;
        closed_frame_count = 0; cpu_epoch = 31; cpu_frame_id = 1;
        repeat (3) tick(); common_aresetn = 1; tick();
        check(!owner_fault && !grant_ready && !cpu_available && !owner_drained,"unarmed owner");
        enabled = 1; tick();
        check(!owner_fault && grant_ready && granted_frames == 0 && released_frames == 0,"armed fresh owner");
        scenarios = scenarios + 1;
    endtask
    task automatic reserve(input [31:0] identity);
        check(grant_ready && grant_frame_id == identity && grant_slot == (identity-cfg_first_frame_id)%3,"grant identity or slot");
        grant_request = 1; tick(); grant_request = 0;
        #0.001;
        check(!owner_fault,"reservation fault");
    endtask
    task automatic complete_all;
        rgb_completed_frames = granted_frames;
        packet_completed_frames = granted_frames;
        status_completed_frames = granted_frames;
        tick();
    endtask
    task automatic claim_next;
        check(cpu_available && available_epoch == cfg_epoch && available_frame_id == cfg_first_frame_id+released_frames &&
            available_slot == released_frames%3,"available identity or slot");
        cpu_frame_id = available_frame_id; cpu_epoch = available_epoch; cpu_claim = 1; tick(); cpu_claim = 0;
        check(cpu_held && claim_accepted && !owner_fault && !cpu_available,"claim failed");
    endtask
    task automatic release_next;
        cpu_release = 1; tick(); cpu_release = 0;
        check(!cpu_held && release_accepted && !owner_fault,"release failed");
    endtask
    task automatic expect_fault;
        tick(); tick();
        check(owner_fault && !grant_ready && !cpu_available && !owner_drained,"fault did not retain owner");
        repeat (8) tick(); check(owner_fault,"fault not sticky");
    endtask
    initial begin
        reset_case(); reserve(1); reserve(2); reserve(3);
        source_closed = 1; closed_frame_count = 7; tick();
        rgb_completed_frames = 3; packet_completed_frames = 3; status_completed_frames = 0; tick();
        check(!cpu_available && !grant_ready,"SG status not acknowledged or CPU credit exceeded");
        status_completed_frames = 3; tick(); claim_next();
        repeat (64) begin tick(); check(cpu_held && !grant_ready && !owner_drained && !owner_fault,"held slot reused"); end
        release_next(); reserve(4); complete_all();
        for (integer identity = 5; identity <= 7; identity = identity+1) begin
            claim_next(); release_next(); reserve(identity); complete_all();
        end
        while (released_frames < 7) begin claim_next(); release_next(); end
        tick(); check(owner_drained && granted_frames == 7 && released_frames == 7 && !owner_fault,"seven frames final closure");

        reset_case(); reserve(1); cpu_claim = 1; tick(); cpu_claim = 0; expect_fault();
        reset_case(); reserve(1); complete_all(); claim_next(); cpu_claim = 1; tick(); cpu_claim = 0; expect_fault();
        reset_case(); reserve(1); complete_all(); claim_next(); cpu_epoch = 32; cpu_release = 1; tick(); cpu_release = 0; expect_fault();
        reset_case(); reserve(1); complete_all(); claim_next(); cpu_frame_id = 2; cpu_release = 1; tick(); cpu_release = 0; expect_fault();
        reset_case(); cpu_release = 1; tick(); cpu_release = 0; expect_fault();
        reset_case(); reserve(1); complete_all(); claim_next(); release_next(); cpu_release = 1; tick(); cpu_release = 0; expect_fault();
        reset_case(); reserve(1); complete_all(); rgb_completed_frames = 0; expect_fault();
        reset_case(); reserve(1); packet_completed_frames = 2; expect_fault();
        reset_case(); reserve(1); source_closed = 1; closed_frame_count = 1; tick(); closed_frame_count = 2; expect_fault();
        reset_case(); cfg_epoch = 32; expect_fault();
        reset_case(); upstream_fault = 1; tick(); upstream_fault = 0; expect_fault();
        reset_case(); common_aresetn = 0; enabled = 0; tick(); cfg_first_frame_id = 32'hfffffffe;
        common_aresetn = 1; enabled = 1; tick(); reserve(32'hfffffffe); reserve(32'hffffffff);
        grant_request = 1; expect_fault(); grant_request = 0;
        reset_case(); source_closed = 1; closed_frame_count = 0; tick();
        check(owner_drained && !owner_fault && !grant_ready,"empty cancellation recovery");
        check(scenarios == 14,"scenario count");
        $display("TEST_PASS VISION_FRAME_OWNER scenarios=14 checks=%0d SLOTS3 CONTINUOUS7 CPU_HOLD64 THREE_B_ACK TOKEN_EPOCH FRAME_ID NO_REUSE NO_WRAP STICKY RESET",checks);
        $finish;
    end
    initial begin #1000000; $fatal(1,"FRAME_OWNER watchdog"); end
endmodule