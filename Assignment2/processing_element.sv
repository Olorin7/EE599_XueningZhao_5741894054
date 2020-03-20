module processing_element(clk, rst, in_l, in_t, out_r, out_b, out);
    parameter k = 8;
    parameter D = 16;

    input clk, rst;
    input [k-1:0] in_l, in_t;
    output reg [k-1:0] out_r, out_b;
    output reg [2*k+D-2:0] out;

    always@(posedge clk) begin
        if(!rst) begin
            out_b <= 0;
            out_r <= 0;
            out <= 0;
        end else begin
            out_b <= in_t;
            out_r <= in_l;
            out <= in_l * in_t + out;
        end
    end

endmodule