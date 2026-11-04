module example_counter (
    input wire aclk,
    input wire aresetn,
    input wire enable,
    output reg [7:0] count
);
    always @(posedge aclk) begin
        if (!aresetn) count <= 8'd1;
        else if (enable) count <= count + 8'd1;
    end
endmodule
