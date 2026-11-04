module example_counter (
    input wire aclk,
    input wire aresetn,
    input wire enable,
    output reg [7:0] count
);
    wire [7:0] next_count = count + 8'd1;
    always @(posedge aclk) begin
        if (!aresetn) count <= 8'd0;
        else if (enable) count <= next_count;
    end
endmodule
