`timescale 1ns/1ps
module tb_voice_hybrid_pcm_p1 #(parameter integer SMOKE_ONLY = 0);
    logic clk = 0;
    always #12.5 clk = ~clk;
    logic rst_n = 0;
    logic capture_enable = 0;
    logic pcm_valid = 0;
    logic pcm_ready;
    logic signed [15:0] pcm_s16 = 0;
    logic core_valid, core_ready, core_last, core_error;
    logic [63:0] core_data;
    logic batch_valid, batch_ready, batch_last, batch_done;
    logic [63:0] batch_data;
    integer cycle_count = 0;
    integer accepted_pcm = 0;
    integer accepted_words = 0;
    integer record_count = 0;
    integer stalled_cycles = 0;
    integer expected_records = 0;
    integer pcm_file = 0;
    integer feature_file = 0;
    bit silence_case = 1;
    bit was_stalled = 0;
    logic [63:0] stalled_data;
    logic stalled_last;

    voice_hybrid_pcm_top #(
        .FIR_COEFF_MEM("fir_coeff_q17.mem"),
        .HAMMING_COEFF_MEM("hamming_512_q15.mem")
    ) dut (
        .clk, .rst_n, .pcm_valid, .pcm_ready, .pcm_s16,
        .m_axis_tvalid(core_valid), .m_axis_tready(core_ready),
        .m_axis_tdata(core_data), .m_axis_tlast(core_last),
        .error_sticky(core_error)
    );
    voice_axis_batch_capture #(.RECORDS_PER_BATCH(485)) batch (
        .clk, .rst_n, .capture_enable,
        .s_axis_tvalid(core_valid), .s_axis_tready(core_ready),
        .s_axis_tdata(core_data), .s_axis_tlast(core_last),
        .m_axis_tvalid(batch_valid), .m_axis_tready(batch_ready),
        .m_axis_tdata(batch_data), .m_axis_tlast(batch_last), .batch_done
    );
    always @(negedge clk) batch_ready = (cycle_count % 127 >= 16);

    always @(posedge clk) begin
        if (!rst_n) begin
            cycle_count = 0;
            accepted_pcm = 0;
            accepted_words = 0;
            record_count = 0;
            stalled_cycles = 0;
            was_stalled = 0;
        end else begin
            if (core_error !== 0)
                $fatal(1, "P1 core error at pcm=%0d record=%0d", accepted_pcm, record_count);
            if (pcm_valid) begin
                if (pcm_ready !== 1)
                    $fatal(1, "P1 input cannot sustain 48 kHz at pcm=%0d", accepted_pcm);
                accepted_pcm = accepted_pcm + 1;
                if (accepted_pcm <= 6)
                    $display("VOICE_P1_PCM_BEFORE_WRITE time=%0t sample=%0d", $time, accepted_pcm);
                $fwrite(pcm_file, "%c%c", pcm_s16[7:0], pcm_s16[15:8]);
                if (accepted_pcm <= 6)
                    $display("VOICE_P1_PCM_AFTER_WRITE time=%0t sample=%0d", $time, accepted_pcm);
            end
            if (was_stalled && (core_valid !== 1 || core_data !== stalled_data || core_last !== stalled_last))
                $fatal(1, "P1 unstable AXIS during backpressure");
            was_stalled = core_valid && !core_ready;
            if (was_stalled) begin
                stalled_data = core_data;
                stalled_last = core_last;
                stalled_cycles = stalled_cycles + 1;
            end
            if (batch_valid && batch_ready) begin
                if ($isunknown(batch_data)) $fatal(1, "P1 unknown feature word");
                if (core_last !== (accepted_words % 8 == 7))
                    $fatal(1, "P1 per-record TLAST mismatch at word=%0d", accepted_words);
                if (batch_last !== (accepted_words == 485 * 8 - 1))
                    $fatal(1, "P1 batch TLAST mismatch at word=%0d", accepted_words);
                if (accepted_words % 8 == 0) begin
                    if (batch_data[31:0] != record_count * 32 ||
                        batch_data[33:32] != record_count % 4 ||
                        batch_data[41:34] != 0 || batch_data[49:42] != 1 || batch_data[63:50] != 0)
                        $fatal(1, "P1 header mismatch record=%0d data=%h", record_count, batch_data);
                end else begin
                    if (silence_case && batch_data != 0)
                        $fatal(1, "P1 nonzero silence feature word=%0d data=%h", accepted_words, batch_data);
                    if (accepted_words % 8 == 7) begin
                        if (batch_data[63:56] != 0) $fatal(1, "P1 weighted reserved bits");
                    end else if (batch_data[63:48] != 0) $fatal(1, "P1 reserved bits");
                    if (!silence_case && accepted_words % 8 == 1 && batch_data[31:0] == 0)
                        $fatal(1, "P1 tone has zero power record=%0d", record_count);
                    if (!silence_case && accepted_words % 8 == 6 && batch_data[47:0] == 0)
                        $fatal(1, "P1 tone has zero spectrum record=%0d", record_count);
                end
                for (integer byte_index = 0; byte_index < 8; byte_index = byte_index + 1)
                    $fwrite(feature_file, "%c", batch_data[byte_index * 8 +: 8]);
                accepted_words = accepted_words + 1;
                if (accepted_words % 8 == 0) record_count = record_count + 1;
                if (record_count > expected_records) $fatal(1, "P1 unexpected extra record");
            end
            cycle_count = cycle_count + 1;
        end
    end

    task automatic run_case(input integer sample_count, input integer records, input bit silence, input string tag);
        integer drain_cycles;
        integer sample_interval;
        @(negedge clk);
        rst_n = 0;
        capture_enable = 0;
        pcm_valid = 0;
        silence_case = silence;
        expected_records = records;
        repeat (16) @(negedge clk);
        pcm_file = $fopen({"voice_p1_", tag, "_pcm.bin"}, "wb");
        feature_file = $fopen({"voice_p1_", tag, "_features.bin"}, "wb");
        if (!pcm_file || !feature_file) $fatal(1, "P1 cannot open capture files");
        rst_n = 1;
        capture_enable = 1;
        drain_cycles = 0;
        while (pcm_ready !== 1 && drain_cycles < 4096) begin
            @(negedge clk);
            drain_cycles = drain_cycles + 1;
        end
        if (pcm_ready !== 1) $fatal(1, "P1 FIFO startup timeout");
        $display("VOICE_P1_STARTUP %s ready_wait_cycles=%0d", tag, drain_cycles);
        for (integer sample_index = 0; sample_index < sample_count; sample_index = sample_index + 1) begin
            @(negedge clk);
            pcm_s16 = silence ? 16'sd0 : ((sample_index % 96 < 48) ? 16'sd10000 : -16'sd10000);
            pcm_valid = 1;
            @(negedge clk);
            pcm_valid = 0;
            sample_interval = ((sample_index + 1) * 2500) / 3 - (sample_index * 2500) / 3;
            repeat (sample_interval - 2) @(negedge clk);
        end
        drain_cycles = 0;
        while (record_count < records && drain_cycles < 2000000) begin
            @(negedge clk);
            drain_cycles = drain_cycles + 1;
        end
        if (record_count != records || accepted_words != records * 8 || accepted_pcm != sample_count)
            $fatal(1, "P1 capture mismatch pcm=%0d records=%0d words=%0d", accepted_pcm, record_count, accepted_words);
        repeat (10000) @(negedge clk);
        if (record_count != records || core_valid !== 0) $fatal(1, "P1 extra output after drain");
        if (records == 485 && (batch_done !== 1 || core_ready !== 0 || batch_valid !== 0 || stalled_cycles == 0))
            $fatal(1, "P1 batch completion/backpressure mismatch");
        if (records < 485 && batch_done !== 0) $fatal(1, "P1 premature batch completion");
        $fclose(pcm_file);
        $fclose(feature_file);
        $display("VOICE_P1_CASE_PASS %s pcm=%0d records=%0d bytes=%0d stalls=%0d", tag, accepted_pcm, record_count, accepted_words * 8, stalled_cycles);
    endtask

    initial begin
        if (SMOKE_ONLY) begin
            run_case(6, 0, 1, "bootstrap");
            $display("VOICE_P1_BOOTSTRAP_PASS");
        end else begin
            run_case(3456, 3, 1, "silence");
            run_case(96000, 485, 0, "square500");
            $display("VOICE_P1_PCM_PROTOCOL_PASS");
        end
        $finish;
    end
    initial begin
        #(64'd2200000000);
        $fatal(1, "P1 watchdog pcm=%0d records=%0d", accepted_pcm, record_count);
    end
endmodule

module tb_voice_frontend_profile_p1 #(parameter integer INCLUDE_FEATURE_CORE = 0);
    logic clk = 0;
    always #12.5 clk = ~clk;
    logic rst_n = 0;
    logic pcm_valid = 0;
    logic pcm_ready;
    logic signed [15:0] pcm_s16 = 0;
    logic fifo_valid, fifo_overflow, fir_ready, dc_valid, fir_valid;
    logic signed [15:0] fifo_data;
    logic signed [17:0] dc_sample, fir_sample;
    integer accepted_pcm = 0;
    integer output_samples = 0;
    logic feature_valid, feature_error;

    generate
        if (INCLUDE_FEATURE_CORE) begin : feature_probe
            voice_hybrid_feature_core #(.HAMMING_COEFF_MEM("hamming_512_q15.mem")) core (
                .clk, .rst_n, .s_axis_tvalid(1'b0), .s_axis_tready(),
                .s_axis_tdata(18'sd0), .s_axis_tlast(1'b0),
                .s_axis_frame_start(32'd0), .s_axis_phase_id(2'd0),
                .m_axis_tvalid(feature_valid), .m_axis_tready(1'b1),
                .m_axis_tdata(), .m_axis_tlast(), .error_sticky(feature_error)
            );
        end else begin : frontend_only
            assign feature_valid = 1'b0;
            assign feature_error = 1'b0;
        end
    endgenerate

    voice_pcm_fifo pcm_fifo (
        .clk, .rst_n, .s_valid(pcm_valid), .s_ready(pcm_ready), .s_data(pcm_s16),
        .m_valid(fifo_valid), .m_ready(fir_ready), .m_data(fifo_data),
        .overflow(fifo_overflow)
    );
    voice_dc_blocker dc (
        .clk, .rst_n, .in_valid(fifo_valid && fir_ready),
        .sample_in_q15(fifo_data), .out_valid(dc_valid), .sample_out_q15(dc_sample)
    );
    voice_fir_decimator #(.COEFF_MEM("fir_coeff_q17.mem")) fir (
        .clk, .rst_n, .sample_valid(dc_valid), .sample_ready(fir_ready),
        .sample_in_q15(dc_sample), .output_valid(fir_valid), .sample_out_q15(fir_sample)
    );

    always @(posedge clk) begin
        if (rst_n) begin
            if (fifo_overflow !== 0) $fatal(1, "P1 profile FIFO overflow");
            if (feature_valid !== 0 || feature_error !== 0)
                $fatal(1, "P1 idle feature core unexpected output/error");
            if (pcm_valid) begin
                if (pcm_ready !== 1) $fatal(1, "P1 profile cannot sustain 48 kHz");
                accepted_pcm = accepted_pcm + 1;
            end
            if (fir_valid) begin
                if (fir_sample !== 18'sd0) $fatal(1, "P1 profile nonzero silence output");
                output_samples = output_samples + 1;
            end
        end
    end

    initial begin
        integer ready_wait_cycles;
        integer sample_interval;
        @(negedge clk);
        repeat (16) @(negedge clk);
        rst_n = 1;
        ready_wait_cycles = 0;
        while (pcm_ready !== 1 && ready_wait_cycles < 4096) begin
            @(negedge clk);
            ready_wait_cycles = ready_wait_cycles + 1;
        end
        if (pcm_ready !== 1) $fatal(1, "P1 profile FIFO startup timeout");
        $display("VOICE_P1_PROFILE_STARTUP ready_wait_cycles=%0d", ready_wait_cycles);
        for (integer sample_index = 0; sample_index < 6; sample_index = sample_index + 1) begin
            @(negedge clk);
            pcm_valid = 1;
            @(negedge clk);
            pcm_valid = 0;
            sample_interval = ((sample_index + 1) * 2500) / 3 - (sample_index * 2500) / 3;
            repeat (sample_interval - 2) @(negedge clk);
        end
        repeat (10000) @(negedge clk);
        if (accepted_pcm != 6 || output_samples != 1)
            $fatal(1, "P1 profile count mismatch pcm=%0d output=%0d", accepted_pcm, output_samples);
        if (INCLUDE_FEATURE_CORE)
            $display("VOICE_P1_FEATURE_IDLE_PROFILE_PASS pcm=6 outputs=1 time=%0t", $time);
        else
            $display("VOICE_P1_FRONTEND_PROFILE_PASS pcm=6 outputs=1 time=%0t", $time);
        $finish;
    end
    initial begin
        #1000000;
        $fatal(1, "P1 profile watchdog pcm=%0d outputs=%0d", accepted_pcm, output_samples);
    end
endmodule

module tb_voice_feature_capture_p1;
    logic clk = 0;
    always #12.5 clk = ~clk;
    logic rst_n = 0;
    logic capture_enable = 0;
    logic feature_valid = 0;
    logic feature_ready, input_overrun;
    logic [31:0] frame_start_8k, power_q31;
    logic [1:0] phase_id;
    logic [15:0] zcr_q16;
    logic [47:0] band0, band1, band2, band3, total_l1;
    logic [55:0] weighted_bin_l1;
    logic core_valid, core_ready, core_last;
    logic [63:0] core_data;
    logic batch_valid, batch_ready, batch_last, batch_done;
    logic [63:0] batch_data;
    integer cycle_count = 0;
    integer word_count = 0;
    integer stalls = 0;
    integer capture_file;
    bit was_stalled = 0;
    logic [63:0] stalled_data;
    logic stalled_last;

    voice_feature_axis_packer packer (
        .clk, .rst_n, .feature_valid, .feature_ready, .frame_start_8k,
        .phase_id, .status(8'd0), .power_q31, .zcr_q16,
        .band_80_300_l1(band0), .band_300_800_l1(band1),
        .band_800_2000_l1(band2), .band_2000_4000_l1(band3),
        .total_l1, .weighted_bin_l1, .m_axis_tvalid(core_valid),
        .m_axis_tready(core_ready), .m_axis_tdata(core_data),
        .m_axis_tlast(core_last), .input_overrun
    );
    voice_axis_batch_capture #(.RECORDS_PER_BATCH(485)) batch (
        .clk, .rst_n, .capture_enable,
        .s_axis_tvalid(core_valid), .s_axis_tready(core_ready),
        .s_axis_tdata(core_data), .s_axis_tlast(core_last),
        .m_axis_tvalid(batch_valid), .m_axis_tready(batch_ready),
        .m_axis_tdata(batch_data), .m_axis_tlast(batch_last), .batch_done
    );
    always @(negedge clk) batch_ready = (cycle_count % 23 >= 9);

    function automatic logic [63:0] expected_word(input integer record_index, input integer beat_index);
        logic [63:0] expected;
        expected = 0;
        case (beat_index)
            0: begin
                expected[31:0] = record_index * 32;
                expected[33:32] = record_index % 4;
                expected[49:42] = 1;
            end
            1: begin
                expected[31:0] = 1000 + record_index;
                expected[47:32] = record_index * 13;
            end
            2, 3, 4, 5: expected[47:0] = record_index + beat_index - 1;
            6: expected[47:0] = 10 + record_index * 4;
            7: expected[55:0] = (10 + record_index * 4) * 7;
            default: $fatal(1, "P1 invalid checker beat");
        endcase
        return expected;
    endfunction

    always @(posedge clk) begin
        if (rst_n) begin
            if (input_overrun !== 0) $fatal(1, "P1 packer overrun");
            if (was_stalled && (core_valid !== 1 || core_data !== stalled_data || core_last !== stalled_last))
                $fatal(1, "P1 capture unstable during backpressure");
            was_stalled = core_valid && !core_ready;
            if (was_stalled) begin
                stalled_data = core_data;
                stalled_last = core_last;
                stalls = stalls + 1;
            end
            if (batch_valid && batch_ready) begin
                if (batch_data !== expected_word(word_count / 8, word_count % 8))
                    $fatal(1, "P1 packed word mismatch word=%0d actual=%h", word_count, batch_data);
                if (core_last !== (word_count % 8 == 7) || batch_last !== (word_count == 3879))
                    $fatal(1, "P1 capture TLAST mismatch word=%0d", word_count);
                for (integer byte_index = 0; byte_index < 8; byte_index = byte_index + 1)
                    $fwrite(capture_file, "%c", batch_data[byte_index * 8 +: 8]);
                word_count = word_count + 1;
                if (word_count > 3880) $fatal(1, "P1 extra packed output");
            end
            cycle_count = cycle_count + 1;
        end
    end

    initial begin
        repeat (16) @(negedge clk);
        capture_file = $fopen("voice_p1_capture_features.bin", "wb");
        if (!capture_file) $fatal(1, "P1 capture file open failed");
        rst_n = 1;
        capture_enable = 1;
        for (integer record_index = 0; record_index < 485; record_index = record_index + 1) begin
            @(negedge clk);
            while (feature_ready !== 1) @(negedge clk);
            frame_start_8k = record_index * 32;
            phase_id = record_index % 4;
            power_q31 = 1000 + record_index;
            zcr_q16 = record_index * 13;
            band0 = record_index + 1;
            band1 = record_index + 2;
            band2 = record_index + 3;
            band3 = record_index + 4;
            total_l1 = 10 + record_index * 4;
            weighted_bin_l1 = total_l1 * 7;
            feature_valid = 1;
            @(negedge clk);
            feature_valid = 0;
        end
        wait (batch_done === 1);
        repeat (32) @(negedge clk);
        if (word_count != 3880 || batch_valid !== 0 || core_ready !== 0 || stalls == 0)
            $fatal(1, "P1 capture completion mismatch words=%0d stalls=%0d", word_count, stalls);
        $fclose(capture_file);
        capture_enable = 0;
        repeat (4) @(negedge clk);
        if (batch_done !== 0) $fatal(1, "P1 batch reset failed");
        $display("VOICE_P1_CAPTURE_PROTOCOL_PASS records=485 words=3880 bytes=31040 stalls=%0d", stalls);
        $finish;
    end
    initial begin
        #1000000;
        $fatal(1, "P1 capture watchdog words=%0d", word_count);
    end
endmodule