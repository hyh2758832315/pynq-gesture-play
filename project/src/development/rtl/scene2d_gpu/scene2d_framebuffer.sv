module scene2d_framebuffer #(
    parameter bit DUAL_PIXEL_WRITE_ENABLE = 1'b0
) (
    input  logic        write_clk,
    input  logic        write_resetn,
    input  logic        write_bank,
    input  logic        write_enable,
    input  logic [15:0] write_address,
    input  logic [7:0]  write_token,
    input  logic        write_second_enable,
    input  logic [7:0]  write_second_token,
    input  logic        read_clk,
    input  logic        read_resetn,
    input  logic        read_bank,
    input  logic [15:0] read_address,
    output logic [7:0]  read_token
);

    logic [7:0] bank_0_token;
    logic [7:0] bank_1_token;
    localparam integer WRITE_WIDTH = DUAL_PIXEL_WRITE_ENABLE ? 16 : 8;
    localparam integer WRITE_ADDRESS_WIDTH = DUAL_PIXEL_WRITE_ENABLE ? 15 : 16;
    logic [WRITE_WIDTH-1:0] write_data;
    logic [WRITE_WIDTH/8-1:0] write_mask;
    logic [WRITE_ADDRESS_WIDTH-1:0] memory_write_address;

    generate
        if (DUAL_PIXEL_WRITE_ENABLE) begin : dual_write
            assign memory_write_address = write_address[15:1];
            assign write_data = write_address[0] ? {write_token, 8'b0} :
                                {write_second_token, write_token};
            assign write_mask = write_address[0] ? {write_enable, 1'b0} :
                                {write_second_enable, write_enable};
        end else begin : single_write
            assign memory_write_address = write_address;
            assign write_data = write_token;
            assign write_mask = write_enable;
        end
    endgenerate

    xpm_memory_sdpram #(
        .ADDR_WIDTH_A(WRITE_ADDRESS_WIDTH),
        .ADDR_WIDTH_B(16),
        .AUTO_SLEEP_TIME(0),
        .BYTE_WRITE_WIDTH_A(8),
        .CLOCKING_MODE("independent_clock"),
        .ECC_MODE("no_ecc"),
        .MEMORY_INIT_FILE("none"),
        .MEMORY_INIT_PARAM("0"),
        .MEMORY_OPTIMIZATION("true"),
        .MEMORY_PRIMITIVE("block"),
        .MEMORY_SIZE(460800),
        .MESSAGE_CONTROL(0),
        .READ_DATA_WIDTH_B(8),
        .READ_LATENCY_B(1),
        .READ_RESET_VALUE_B("0"),
        .RST_MODE_A("SYNC"),
        .RST_MODE_B("SYNC"),
        .USE_EMBEDDED_CONSTRAINT(0),
        .USE_MEM_INIT(1),
        .WAKEUP_TIME("disable_sleep"),
        .WRITE_DATA_WIDTH_A(WRITE_WIDTH),
        .WRITE_MODE_B("read_first")
    ) bank_0 (
        .clka(write_clk),
        .ena((|write_mask) && !write_bank),
        .wea(write_mask & {(WRITE_WIDTH/8){!write_bank}}),
        .addra(memory_write_address),
        .dina(write_data),
        .injectdbiterra(1'b0),
        .injectsbiterra(1'b0),
        .clkb(read_clk),
        .enb(!read_bank),
        .addrb(read_address),
        .doutb(bank_0_token),
        .rstb(!read_resetn),
        .regceb(1'b1),
        .sleep(1'b0),
        .dbiterrb(),
        .sbiterrb()
    );

    xpm_memory_sdpram #(
        .ADDR_WIDTH_A(WRITE_ADDRESS_WIDTH),
        .ADDR_WIDTH_B(16),
        .AUTO_SLEEP_TIME(0),
        .BYTE_WRITE_WIDTH_A(8),
        .CLOCKING_MODE("independent_clock"),
        .ECC_MODE("no_ecc"),
        .MEMORY_INIT_FILE("none"),
        .MEMORY_INIT_PARAM("0"),
        .MEMORY_OPTIMIZATION("true"),
        .MEMORY_PRIMITIVE("block"),
        .MEMORY_SIZE(460800),
        .MESSAGE_CONTROL(0),
        .READ_DATA_WIDTH_B(8),
        .READ_LATENCY_B(1),
        .READ_RESET_VALUE_B("0"),
        .RST_MODE_A("SYNC"),
        .RST_MODE_B("SYNC"),
        .USE_EMBEDDED_CONSTRAINT(0),
        .USE_MEM_INIT(1),
        .WAKEUP_TIME("disable_sleep"),
        .WRITE_DATA_WIDTH_A(WRITE_WIDTH),
        .WRITE_MODE_B("read_first")
    ) bank_1 (
        .clka(write_clk),
        .ena((|write_mask) && write_bank),
        .wea(write_mask & {(WRITE_WIDTH/8){write_bank}}),
        .addra(memory_write_address),
        .dina(write_data),
        .injectdbiterra(1'b0),
        .injectsbiterra(1'b0),
        .clkb(read_clk),
        .enb(read_bank),
        .addrb(read_address),
        .doutb(bank_1_token),
        .rstb(!read_resetn),
        .regceb(1'b1),
        .sleep(1'b0),
        .dbiterrb(),
        .sbiterrb()
    );

    always_ff @(posedge read_clk) begin
        if (!read_resetn) begin
            read_token <= '0;
        end else begin
            read_token <= read_bank ? bank_1_token : bank_0_token;
        end
    end

endmodule