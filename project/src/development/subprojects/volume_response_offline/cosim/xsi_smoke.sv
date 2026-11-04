`timescale 1ns/1ps
module xsi_smoke(input wire enable, output reg [31:0] count=0);
    reg clk=0;
    always #5 clk=~clk;
    always @(posedge clk) if(enable) count<=count+1;
endmodule
