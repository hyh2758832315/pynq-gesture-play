module scene2d_return_source (
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF M_AXIS, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000" *)
    input  logic        aclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW" *)
    input  logic        aresetn,
    input  logic        start,
    input  logic [31:0] requested_byte_count,
    input  logic [31:0] seed,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TDATA" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS, TDATA_NUM_BYTES 8, HAS_TKEEP 1, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 0" *)
    output logic [63:0] m_axis_tdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TKEEP" *)
    output logic [7:0]  m_axis_tkeep,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TLAST" *)
    output logic        m_axis_tlast,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TVALID" *)
    output logic        m_axis_tvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TREADY" *)
    input  logic        m_axis_tready,
    output logic        busy,
    output logic [31:0] completed_byte_count,
    output logic [31:0] completed_packet_count,
    output logic [31:0] rejected_start_count
);

    logic        start_delayed;
    logic [31:0] active_byte_count;
    logic [31:0] active_seed;
    logic [31:0] byte_offset;
    logic [31:0] remaining_bytes;

    function automatic logic [7:0] pattern_byte(
        input logic [31:0] pattern_seed,
        input logic [31:0] byte_index
    );
        logic [31:0] mixed;
        begin
            mixed = pattern_seed ^ byte_index;
            return mixed[7:0] ^ mixed[15:8] ^ mixed[23:16] ^ mixed[31:24];
        end
    endfunction

    function automatic logic [63:0] pattern_beat(
        input logic [31:0] pattern_seed,
        input logic [31:0] first_byte_index
    );
        logic [63:0] data;
        integer lane;
        begin
            data = '0;
            for (lane = 0; lane < 8; lane = lane + 1) begin
                data[lane * 8 +: 8] = pattern_byte(
                    pattern_seed,
                    first_byte_index + lane
                );
            end
            return data;
        end
    endfunction

    always_comb begin
        remaining_bytes = active_byte_count - byte_offset;
        m_axis_tdata = pattern_beat(active_seed, byte_offset);
        if (remaining_bytes >= 8) begin
            m_axis_tkeep = 8'hFF;
        end else begin
            m_axis_tkeep = (9'b1 << remaining_bytes) - 1'b1;
        end
        m_axis_tlast = busy && remaining_bytes <= 8;
        m_axis_tvalid = busy;
    end

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            start_delayed <= 1'b0;
            active_byte_count <= '0;
            active_seed <= '0;
            byte_offset <= '0;
            busy <= 1'b0;
            completed_byte_count <= '0;
            completed_packet_count <= '0;
            rejected_start_count <= '0;
        end else begin
            start_delayed <= start;
            if (start && !start_delayed) begin
                if (busy || requested_byte_count == 0) begin
                    rejected_start_count <= rejected_start_count + 1'b1;
                end else begin
                    active_byte_count <= requested_byte_count;
                    active_seed <= seed;
                    byte_offset <= '0;
                    busy <= 1'b1;
                end
            end else if (m_axis_tvalid && m_axis_tready) begin
                if (m_axis_tlast) begin
                    busy <= 1'b0;
                    completed_byte_count <= active_byte_count;
                    completed_packet_count <= completed_packet_count + 1'b1;
                end else begin
                    byte_offset <= byte_offset + 8;
                end
            end
        end
    end

endmodule