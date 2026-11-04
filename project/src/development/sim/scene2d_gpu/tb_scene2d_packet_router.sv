module tb_scene2d_packet_router;

    timeunit 1ns;
    timeprecision 1ps;

    localparam logic [31:0] MAGIC [0:5] = '{
        32'h47443253,
        32'h41443253,
        32'h54443253,
        32'h50443253,
        32'h46443253,
        32'hDEADBEEF
    };

    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic [63:0] s_tdata = '0;
    logic [7:0] s_tkeep = '0;
    logic s_tlast = 1'b0;
    logic s_tvalid = 1'b0;
    logic s_tready;
    logic [319:0] m_tdata;
    logic [39:0] m_tkeep;
    logic [4:0] m_tlast;
    logic [4:0] m_tvalid;
    logic [4:0] m_tready = '1;
    logic [31:0] dropped_packet_count;
    logic [63:0] observed_data [0:63];
    logic [7:0] observed_keep [0:63];
    logic observed_last [0:63];
    int observed_route [0:63];
    logic [63:0] expected_data [0:63];
    logic [7:0] expected_keep [0:63];
    logic expected_last [0:63];
    int expected_route [0:63];
    int observed_count = 0;
    int expected_count = 0;

    always #5ns clk = ~clk;

    scene2d_packet_router dut (
        .aclk(clk),
        .aresetn(resetn),
        .s_axis_tdata(s_tdata),
        .s_axis_tkeep(s_tkeep),
        .s_axis_tlast(s_tlast),
        .s_axis_tvalid(s_tvalid),
        .s_axis_tready(s_tready),
        .m_axis_tdata(m_tdata),
        .m_axis_tkeep(m_tkeep),
        .m_axis_tlast(m_tlast),
        .m_axis_tvalid(m_tvalid),
        .m_axis_tready(m_tready),
        .dropped_packet_count
    );

    always_ff @(posedge clk) begin
        for (int route = 0; route < 5; route = route + 1) begin
            if (m_tvalid[route] && m_tready[route]) begin
                if ((m_tvalid & ~(5'b00001 << route)) != 0) begin
                    $fatal(1, "more than one route asserted valid");
                end
                observed_data[observed_count] <= m_tdata[route * 64 +: 64];
                observed_keep[observed_count] <= m_tkeep[route * 8 +: 8];
                observed_last[observed_count] <= m_tlast[route];
                observed_route[observed_count] <= route;
                observed_count <= observed_count + 1;
            end
        end
    end

    task automatic expect_packet(input int route, input int packet_id, input int beats);
        logic [63:0] beat_data;
        begin
            for (int beat = 0; beat < beats; beat = beat + 1) begin
                beat_data = beat == 0
                    ? {packet_id[31:0], MAGIC[route]}
                    : {packet_id[31:0], MAGIC[(route + beat) % 6]};
                expected_route[expected_count] = route;
                expected_data[expected_count] = beat_data;
                expected_keep[expected_count] = beat == beats - 1 ? 8'h0F : 8'hFF;
                expected_last[expected_count] = beat == beats - 1;
                expected_count = expected_count + 1;
            end
        end
    endtask

    task automatic send_packet(input int route, input int packet_id, input int beats);
        logic [63:0] beat_data;
        begin
            for (int beat = 0; beat < beats; beat = beat + 1) begin
                beat_data = beat == 0
                    ? {packet_id[31:0], MAGIC[route]}
                    : {packet_id[31:0], MAGIC[(route + beat) % 6]};
                @(negedge clk);
                s_tdata = beat_data;
                s_tkeep = beat == beats - 1 ? 8'h0F : 8'hFF;
                s_tlast = beat == beats - 1;
                s_tvalid = 1'b1;
                do @(posedge clk); while (!s_tready);
            end
            @(negedge clk);
            s_tvalid = 1'b0;
            s_tlast = 1'b0;
            s_tkeep = '0;
            s_tdata = '0;
        end
    endtask

    initial begin
        repeat (5) @(posedge clk);
        @(negedge clk);
        resetn = 1'b1;

        for (int route = 0; route < 5; route = route + 1) begin
            expect_packet(route, 16 + route, 3);
            send_packet(route, 16 + route, 3);
        end

        expect_packet(2, 32, 6);
        @(negedge clk);
        m_tready[2] = 1'b0;
        fork
            send_packet(2, 32, 6);
            begin
                repeat (6) @(posedge clk);
                @(negedge clk);
                m_tready[2] = 1'b1;
            end
        join

        send_packet(5, 48, 4);

        expect_packet(0, 64, 2);
        expect_packet(4, 65, 2);
        send_packet(0, 64, 2);
        send_packet(4, 65, 2);

        wait (observed_count == expected_count);
        repeat (3) @(posedge clk);
        if (dropped_packet_count != 1) begin
            $fatal(1, "dropped_packet_count=%0d expected=1", dropped_packet_count);
        end
        if (observed_count != expected_count) begin
            for (int index = 0; index < observed_count; index = index + 1) begin
                $display(
                    "observed[%0d] route=%0d data=%016x keep=%02x last=%0d",
                    index,
                    observed_route[index],
                    observed_data[index],
                    observed_keep[index],
                    observed_last[index]
                );
            end
            $fatal(1, "observed=%0d expected=%0d", observed_count, expected_count);
        end
        for (int index = 0; index < expected_count; index = index + 1) begin
            if (observed_route[index] != expected_route[index] ||
                observed_data[index] != expected_data[index] ||
                observed_keep[index] != expected_keep[index] ||
                observed_last[index] != expected_last[index]) begin
                $fatal(1, "route mismatch at beat %0d", index);
            end
        end

        $display(
            "SCENE2D_PACKET_ROUTER=PASS beats=%0d dropped=%0d",
            observed_count,
            dropped_packet_count
        );
        $finish;
    end

endmodule