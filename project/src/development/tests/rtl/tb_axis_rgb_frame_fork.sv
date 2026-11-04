`timescale 1ns/1ps
module tb_axis_rgb_frame_fork;
    reg clock = 0;
    always #5 clock = !clock;
    reg resetn = 0;
    reg [23:0] source_data = 0;
    reg source_valid = 0, source_user = 0, source_last = 0;
    reg [143:0] source_context = 0;
    wire source_ready;
    wire [23:0] rgb_data, mask_data;
    wire rgb_valid, mask_valid, rgb_user, mask_user, rgb_last, mask_last;
    wire [143:0] frame_context;
    reg rgb_ready = 0, mask_ready = 0;
    integer cycles = 0, rgb_count = 0, mask_count = 0, source_stalls = 0;
    integer word_index, mode = 0;
    reg rgb_blocked = 0, mask_blocked = 0, rgb_first = 0, mask_first = 0;
    reg [169:0] held_rgb, held_mask;
    wire [169:0] rgb_word = {frame_context, rgb_data, rgb_user, rgb_last};
    wire [169:0] mask_word = {frame_context, mask_data, mask_user, mask_last};

    function automatic [23:0] pixel(input integer index_value);
        pixel = (index_value * 7919) ^ 24'h543210;
    endfunction
    function automatic [143:0] context_for(input integer frame_number);
        reg [31:0] expected_frame, expected_config, expected_epoch;
        reg [47:0] expected_thresholds;
        begin
            expected_frame = 32'h10203000 + frame_number;
            expected_config = 32'h40506000 + frame_number;
            expected_epoch = 32'h70809000 + frame_number;
            expected_thresholds = 48'hfedcba987654 ^ frame_number;
            context_for = {expected_epoch, expected_config, expected_frame, expected_thresholds};
        end
    endfunction

    axis_rgb_frame_fork dut (
        .aclk(clock), .aresetn(resetn), .s_axis_tdata(source_data), .s_axis_tvalid(source_valid),
        .s_axis_tready(source_ready), .s_axis_tuser(source_user), .s_axis_tlast(source_last),
        .s_frame_context(source_context), .m_rgb_tdata(rgb_data), .m_rgb_tvalid(rgb_valid),
        .m_rgb_tready(rgb_ready), .m_rgb_tuser(rgb_user), .m_rgb_tlast(rgb_last),
        .m_mask_tdata(mask_data), .m_mask_tvalid(mask_valid), .m_mask_tready(mask_ready),
        .m_mask_tuser(mask_user), .m_mask_tlast(mask_last), .m_frame_context(frame_context)
    );
    always @(negedge clock) begin
        cycles = cycles + 1;
        rgb_ready = mode == 1 || mode == 2 || (cycles % 17 < 11 && cycles % 1091 >= 200);
        mask_ready = mode == 2 || (mode == 0 && cycles % 11 < 7 && cycles % 557 >= 73);
    end
    always @(posedge clock) begin
        if (!resetn) begin
            rgb_count = 0;
            mask_count = 0;
            rgb_blocked = 0;
            mask_blocked = 0;
        end else begin
            if (rgb_blocked && (!rgb_valid || rgb_word !== held_rgb)) $fatal(1, "FORK RGB stall changed");
            if (mask_blocked && (!mask_valid || mask_word !== held_mask)) $fatal(1, "FORK mask stall changed");
            rgb_blocked = rgb_valid && !rgb_ready;
            mask_blocked = mask_valid && !mask_ready;
            held_rgb = rgb_word;
            held_mask = mask_word;
            if (source_valid && !source_ready) source_stalls = source_stalls + 1;
            if (rgb_valid && rgb_ready && mask_valid && !mask_ready) rgb_first = 1;
            if (mask_valid && mask_ready && rgb_valid && !rgb_ready) mask_first = 1;
            if (rgb_valid && rgb_ready) begin
                if (rgb_data !== pixel(rgb_count) || rgb_user !== (rgb_count % 64 == 0) ||
                    rgb_last !== (rgb_count % 16 == 15) || frame_context !== context_for(rgb_count / 64))
                    $fatal(1, "FORK RGB mismatch %0d", rgb_count);
                rgb_count = rgb_count + 1;
            end
            if (mask_valid && mask_ready) begin
                if (mask_data !== pixel(mask_count) || mask_user !== (mask_count % 64 == 0) ||
                    mask_last !== (mask_count % 16 == 15) || frame_context !== context_for(mask_count / 64))
                    $fatal(1, "FORK mask mismatch %0d", mask_count);
                mask_count = mask_count + 1;
            end
        end
    end
    task automatic send_word(input integer index_value);
        begin
            @(negedge clock);
            source_data = pixel(index_value);
            source_user = index_value % 64 == 0;
            source_last = index_value % 16 == 15;
            source_context = source_user ? context_for(index_value / 64) : 144'hbad;
            source_valid = 1;
            do @(posedge clock); while (!source_ready);
            @(negedge clock);
            source_valid = 0;
        end
    endtask
    task automatic reset_case;
        begin
            @(negedge clock);
            resetn = 0;
            source_valid = 0;
            repeat (4) @(negedge clock);
            resetn = 1;
        end
    endtask
    initial begin
        reset_case();
        for (word_index = 0; word_index < 512; word_index = word_index + 1) send_word(word_index);
        wait (rgb_count == 512 && mask_count == 512);
        repeat (5) @(negedge clock);
        if (rgb_valid || mask_valid || !rgb_first || !mask_first || source_stalls == 0)
            $fatal(1, "FORK independent handshake coverage incomplete");
        mode = 1;
        reset_case();
        send_word(0);
        repeat (5) @(negedge clock);
        if (rgb_count != 1 || mask_count != 0 || !mask_valid || rgb_valid)
            $fatal(1, "FORK partial consumption not reached");
        reset_case();
        mode = 2;
        send_word(0);
        send_word(1);
        wait (rgb_count == 2 && mask_count == 2);
        repeat (5) @(negedge clock);
        if (rgb_valid || mask_valid) $fatal(1, "FORK stale data after reset");
        $display("TEST_PASS RGB_FRAME_FORK INDEPENDENT_READY_CONFIG_SNAPSHOT_STALL_RESET words=512 recovery_words=2 source_stalls=%0d", source_stalls);
        $finish;
    end
    initial begin
        #2000000;
        $fatal(1, "FORK watchdog");
    end
endmodule

module tb_axis_rgb_frame_sequence;
    reg clock = 0;
    always #5 clock = ~clock;
    reg resetn = 0, source_valid = 0, source_user = 0, source_last = 0;
    reg [23:0] source_data = 0;
    reg [143:0] source_context = 0;
    reg [31:0] base_id = 32'd17;
    wire source_ready, rgb_valid, mask_valid, rgb_user, mask_user, rgb_last, mask_last;
    wire identity_fault, identity_exhausted;
    wire [23:0] rgb_data, mask_data;
    wire [143:0] frame_context;
    reg rgb_ready = 0, mask_ready = 0;
    integer cycles = 0, rgb_count = 0, mask_count = 0, checks = 0, word_index;
    reg rgb_stalled = 0, mask_stalled = 0;
    reg [169:0] held_rgb, held_mask;

    function automatic [143:0] context_for(input [31:0] frame_id);
        context_for = {32'd31, 32'd23, frame_id, 48'hff208014c800};
    endfunction
    task automatic check(input bit condition, input string message);
        begin
            checks = checks + 1;
            if (!condition) $fatal(1, "FRAME_SEQUENCE_FAIL %s rgb=%0d mask=%0d", message, rgb_count, mask_count);
        end
    endtask
    axis_rgb_frame_fork #(.SEQUENCE_FRAME_IDS(1)) dut (
        .aclk(clock), .aresetn(resetn), .s_axis_tdata(source_data), .s_axis_tvalid(source_valid),
        .s_axis_tready(source_ready), .s_axis_tuser(source_user), .s_axis_tlast(source_last),
        .s_frame_context(source_context), .m_rgb_tdata(rgb_data), .m_rgb_tvalid(rgb_valid),
        .m_rgb_tready(rgb_ready), .m_rgb_tuser(rgb_user), .m_rgb_tlast(rgb_last),
        .m_mask_tdata(mask_data), .m_mask_tvalid(mask_valid), .m_mask_tready(mask_ready),
        .m_mask_tuser(mask_user), .m_mask_tlast(mask_last), .m_frame_context(frame_context),
        .identity_fault(identity_fault), .identity_exhausted(identity_exhausted)
    );
    always @(negedge clock) begin
        cycles = cycles + 1;
        rgb_ready = cycles % 13 < 8;
        mask_ready = cycles % 17 < 10;
    end
    always @(posedge clock) begin
        if (!resetn) begin
            rgb_count = 0;
            mask_count = 0;
            rgb_stalled = 0;
            mask_stalled = 0;
        end else begin
            if (rgb_stalled) check(rgb_valid && {frame_context, rgb_data, rgb_user, rgb_last} === held_rgb, "RGB stall/context changed");
            if (mask_stalled) check(mask_valid && {frame_context, mask_data, mask_user, mask_last} === held_mask, "mask stall/context changed");
            rgb_stalled = rgb_valid && !rgb_ready;
            mask_stalled = mask_valid && !mask_ready;
            held_rgb = {frame_context, rgb_data, rgb_user, rgb_last};
            held_mask = {frame_context, mask_data, mask_user, mask_last};
            if (rgb_valid && rgb_ready) begin
                check(rgb_data == rgb_count && rgb_user == (rgb_count % 64 == 0) && rgb_last == (rgb_count % 16 == 15) &&
                    frame_context === context_for(base_id + rgb_count / 64), "RGB identity/content mismatch");
                rgb_count = rgb_count + 1;
            end
            if (mask_valid && mask_ready) begin
                check(mask_data == mask_count && mask_user == (mask_count % 64 == 0) && mask_last == (mask_count % 16 == 15) &&
                    frame_context === context_for(base_id + mask_count / 64), "mask identity/content mismatch");
                mask_count = mask_count + 1;
            end
        end
    end
    task automatic reset_case(input [31:0] first_id);
        begin
            @(negedge clock);
            resetn = 0;
            source_valid = 0;
            source_user = 0;
            base_id = first_id;
            source_context = context_for(first_id);
            repeat (4) @(negedge clock);
            resetn = 1;
        end
    endtask
    task automatic send_words(input integer count);
        integer position;
        begin
            for (position = 0; position < count; position = position + 1) begin
                @(negedge clock);
                source_valid = 1;
                source_data = position;
                source_user = position % 64 == 0;
                source_last = position % 16 == 15;
                do @(posedge clock); while (!source_ready);
            end
            @(negedge clock);
            source_valid = 0;
            source_user = 0;
            wait (rgb_count == count && mask_count == count);
            repeat (4) @(negedge clock);
        end
    endtask
    task automatic reject_next(input bit changed_config);
        begin
            @(negedge clock);
            if (changed_config) source_context[111:80] = 32'd24;
            source_valid = 1;
            source_user = 1;
            source_last = 0;
            repeat (8) begin
                @(negedge clock);
                check(!source_ready, "invalid next context was admitted");
            end
            check(identity_fault, "identity failure not sticky");
            source_valid = 0;
            source_user = 0;
            repeat (8) @(negedge clock);
            check(identity_fault && !source_ready && !rgb_valid && !mask_valid, "identity fault recovered without reset");
        end
    endtask
    initial begin
        reset_case(17);
        send_words(512);
        check(!identity_fault && !identity_exhausted, "continuous eight-frame sequence fault");
        reset_case(32'hffffffff);
        send_words(64);
        check(!identity_fault && identity_exhausted, "maximum ID frame did not complete");
        reject_next(0);
        check(rgb_count == 64 && mask_count == 64 && frame_context[79:48] == 32'hffffffff, "ID wrapped");
        reset_case(32'hfffffffe);
        send_words(128);
        check(!identity_fault && identity_exhausted, "last two IDs did not complete");
        reject_next(0);
        check(rgb_count == 128 && mask_count == 128, "exhaustion admitted data");
        reset_case(17);
        send_words(64);
        reject_next(1);
        check(rgb_count == 64 && mask_count == 64 && !identity_exhausted, "changed config admitted data");
        reset_case(17);
        send_words(128);
        check(!identity_fault && !identity_exhausted, "reset recovery failed");
        $display("TEST_PASS RGB_FRAME_SEQUENCE scenarios=5 checks=%0d", checks);
        $finish;
    end
    initial begin
        #2000000;
        $fatal(1, "FRAME_SEQUENCE watchdog");
    end
endmodule