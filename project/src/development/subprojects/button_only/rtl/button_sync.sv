// Synchronize PYNQ-Z2 BTN0/BTN1 into the 100 MHz AXI GPIO clock domain.
// The PS debounces and emits one event per rising edge.
module button_sync (
    input wire aclk,
    input wire aresetn,
    input wire [1:0] btn,
    output wire [1:0] btn_sync
);
    (* ASYNC_REG = "TRUE" *) reg [1:0] meta;
    (* ASYNC_REG = "TRUE" *) reg [1:0] stable;
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            meta <= 2'b00;
            stable <= 2'b00;
        end else begin
            meta <= btn;
            stable <= meta;
        end
    end
    assign btn_sync = stable;
endmodule
