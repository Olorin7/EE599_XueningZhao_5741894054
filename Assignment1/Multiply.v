module Multiply(clk, rst, in1, in2, out);
    parameter k = 8;

    input clk, rst;
    input [k-1:0] in1, in2;
    output reg [2*k-1:0] out;

    always @(posedge clk) begin
        if(!rst) begin
            out <= 0;
        end else begin
            out <= in1 * in2;
        end
    end
endmodule