module scene2d_index4_atlas #(
    parameter integer PIXEL_COUNT = 65536,
    parameter integer PIXEL_ADDRESS_WIDTH = 16,
    parameter integer BYTE_ADDRESS_WIDTH = 15,
    parameter string INIT_FILE = "none"
) (
    input  logic                           clk,
    input  logic                           resetn,
    input  logic [PIXEL_ADDRESS_WIDTH-1:0] pixel_address,
    output logic [3:0]                     color_index
);

    logic [7:0] packed_byte;
    logic select_high_nibble;

    xpm_memory_sdpram #(
        .ADDR_WIDTH_A(BYTE_ADDRESS_WIDTH),
        .ADDR_WIDTH_B(BYTE_ADDRESS_WIDTH),
        .AUTO_SLEEP_TIME(0),
        .BYTE_WRITE_WIDTH_A(8),
        .CLOCKING_MODE("common_clock"),
        .ECC_MODE("no_ecc"),
        .MEMORY_INIT_FILE(INIT_FILE),
        .MEMORY_INIT_PARAM("0"),
        .MEMORY_OPTIMIZATION("true"),
        .MEMORY_PRIMITIVE("block"),
        .MEMORY_SIZE(PIXEL_COUNT * 4),
        .MESSAGE_CONTROL(0),
        .READ_DATA_WIDTH_B(8),
        .READ_LATENCY_B(1),
        .READ_RESET_VALUE_B("0"),
        .RST_MODE_A("SYNC"),
        .RST_MODE_B("SYNC"),
        .USE_EMBEDDED_CONSTRAINT(0),
        .USE_MEM_INIT(1),
        .WAKEUP_TIME("disable_sleep"),
        .WRITE_DATA_WIDTH_A(8),
        .WRITE_MODE_B("read_first")
    ) memory (
        .clka(clk),
        .ena(1'b0),
        .wea(1'b0),
        .addra('0),
        .dina('0),
        .injectdbiterra(1'b0),
        .injectsbiterra(1'b0),
        .clkb(clk),
        .enb(1'b1),
        .addrb(pixel_address[PIXEL_ADDRESS_WIDTH-1:1]),
        .doutb(packed_byte),
        .rstb(!resetn),
        .regceb(1'b1),
        .sleep(1'b0),
        .dbiterrb(),
        .sbiterrb()
    );

    always_ff @(posedge clk) begin
        if (!resetn) begin
            select_high_nibble <= 1'b0;
        end else begin
            select_high_nibble <= pixel_address[0];
        end
    end

    assign color_index = select_high_nibble ? packed_byte[7:4] : packed_byte[3:0];

endmodule