module tb_scene2d_return_source;

    timeunit 1ns;
    timeprecision 1ps;

    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic start = 1'b0;
    logic [31:0] requested_byte_count = '0;
    logic [31:0] seed = '0;
    logic [63:0] tdata;
    logic [7:0] tkeep;
    logic tlast;
    logic tvalid;
    logic tready = 1'b0;
    logic busy;
    logic [31:0] completed_byte_count;
    logic [31:0] completed_packet_count;
    logic [31:0] rejected_start_count;

    logic automatic_backpressure = 1'b1;
    integer cycle_count = 0;
    integer observed_bytes = 0;
    logic [31:0] expected_seed = '0;
    logic [31:0] expected_length = '0;
    logic stalled = 1'b0;
    logic [63:0] stalled_data = '0;
    logic [7:0] stalled_keep = '0;
    logic stalled_last = 1'b0;

    always #5ns clk = ~clk;

    scene2d_return_source dut (
        .aclk(clk),
        .aresetn(resetn),
        .start,
        .requested_byte_count,
        .seed,
        .m_axis_tdata(tdata),
        .m_axis_tkeep(tkeep),
        .m_axis_tlast(tlast),
        .m_axis_tvalid(tvalid),
        .m_axis_tready(tready),
        .busy,
        .completed_byte_count,
        .completed_packet_count,
        .rejected_start_count
    );

    function automatic logic [7:0] expected_byte(
        input logic [31:0] pattern_seed,
        input logic [31:0] byte_index
    );
        logic [31:0] mixed;
        begin
            mixed = pattern_seed ^ byte_index;
            return mixed[7:0] ^ mixed[15:8] ^ mixed[23:16] ^ mixed[31:24];
        end
    endfunction

    always @(negedge clk) begin
        if (!resetn) begin
            cycle_count = 0;
            tready = 1'b0;
        end else begin
            cycle_count = cycle_count + 1;
            if (automatic_backpressure) begin
                tready = cycle_count % 5 != 1 && cycle_count % 7 != 3;
            end
        end
    end

    integer lane;
    integer valid_lanes;
    always @(posedge clk) begin
        if (resetn) begin
            if (stalled) begin
                if (!tvalid || tdata != stalled_data || tkeep != stalled_keep || tlast != stalled_last) begin
                    $fatal(1, "AXI output changed while stalled");
                end
            end
            stalled = tvalid && !tready;
            stalled_data = tdata;
            stalled_keep = tkeep;
            stalled_last = tlast;

            if (tvalid && tready) begin
                valid_lanes = 0;
                for (lane = 0; lane < 8; lane = lane + 1) begin
                    if (tkeep[lane]) begin
                        if (lane != valid_lanes) begin
                            $fatal(1, "TKEEP is not contiguous: %02x", tkeep);
                        end
                        if (tdata[lane * 8 +: 8] != expected_byte(expected_seed, observed_bytes)) begin
                            $fatal(
                                1,
                                "payload mismatch at byte %0d: %02x != %02x",
                                observed_bytes,
                                tdata[lane * 8 +: 8],
                                expected_byte(expected_seed, observed_bytes)
                            );
                        end
                        observed_bytes = observed_bytes + 1;
                        valid_lanes = valid_lanes + 1;
                    end
                end
                if (valid_lanes == 0) begin
                    $fatal(1, "accepted beat has no valid bytes");
                end
                if (tlast != (observed_bytes == expected_length)) begin
                    $fatal(
                        1,
                        "TLAST mismatch after %0d/%0d bytes",
                        observed_bytes,
                        expected_length
                    );
                end
            end
        end
    end

    task automatic pulse_start(
        input logic [31:0] length,
        input logic [31:0] pattern_seed
    );
        @(negedge clk);
        requested_byte_count = length;
        seed = pattern_seed;
        start = 1'b1;
        @(negedge clk);
        start = 1'b0;
    endtask

    task automatic run_case(
        input logic [31:0] length,
        input logic [31:0] pattern_seed
    );
        logic [31:0] initial_packets;
        integer timeout_cycles;
        begin
            expected_length = length;
            expected_seed = pattern_seed;
            observed_bytes = 0;
            initial_packets = completed_packet_count;
            pulse_start(length, pattern_seed);
            timeout_cycles = 0;
            while (completed_packet_count == initial_packets && timeout_cycles < 200) begin
                @(posedge clk);
                timeout_cycles = timeout_cycles + 1;
            end
            if (completed_packet_count != initial_packets + 1) begin
                $fatal(1, "transfer timeout at length %0d", length);
            end
            if (completed_byte_count != length || observed_bytes != length) begin
                $fatal(
                    1,
                    "length mismatch for %0d: completed=%0d observed=%0d",
                    length,
                    completed_byte_count,
                    observed_bytes
                );
            end
            @(posedge clk);
        end
    endtask

    initial begin
        repeat (5) @(posedge clk);
        @(negedge clk);
        resetn = 1'b1;

        run_case(1, 32'h10203040);
        run_case(7, 32'h55667788);
        run_case(8, 32'h89ABCDEF);
        run_case(9, 32'h13579BDF);
        run_case(17, 32'h2468ACE0);

        pulse_start(0, 32'h00000000);
        repeat (2) @(posedge clk);
        if (rejected_start_count != 1) begin
            $fatal(1, "zero-length start was not rejected");
        end

        automatic_backpressure = 1'b0;
        tready = 1'b0;
        expected_length = 17;
        expected_seed = 32'hCAFEBABE;
        observed_bytes = 0;
        pulse_start(expected_length, expected_seed);
        pulse_start(4, 32'hDEADBEEF);
        if (rejected_start_count != 2) begin
            $fatal(1, "busy start was not rejected");
        end
        tready = 1'b1;
        wait (completed_packet_count == 6);
        @(posedge clk);
        if (completed_byte_count != 17 || observed_bytes != 17) begin
            $fatal(1, "busy-start rejection corrupted the active transfer");
        end

        $display(
            "SCENE2D_RETURN_SOURCE=PASS packets=%0d rejected=%0d",
            completed_packet_count,
            rejected_start_count
        );
        $finish;
    end

endmodule