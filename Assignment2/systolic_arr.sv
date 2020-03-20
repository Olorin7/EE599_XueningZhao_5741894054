module systolic_arr(clk, rst, in_l, in_t, out);
    parameter k = 8;
    parameter D = 16;

    input clk, rst;
    input [k-1:0] in_l[0:D-1], in_t[0:D-1];
    output [2*k+D-2:0] out[0:D-1][0:D-1];

    wire [k-1:0] out_r[0:D-1][0:D-1], out_b[0:D-1][0:D-1];

    genvar i, j;
    generate
        for (i = 0; i < D; i = i + 1) begin:row
            for (j = 0; j < D; j = j + 1) begin:col
                if(i == 0 && j == 0) begin
                    processing_element #(.k(k), .D(D)) PE(clk, rst, in_l[i], in_t[j], out_r[i][j], out_b[i][j], out[i][j]);
                end else if(i == 0) begin
                    processing_element #(.k(k), .D(D)) PE(clk, rst, out_r[i][j-1], in_t[j], out_r[i][j], out_b[i][j], out[i][j]);
                end else if(j == 0) begin
                    processing_element #(.k(k), .D(D)) PE(clk, rst, in_l[i], out_b[i-1][j], out_r[i][j], out_b[i][j], out[i][j]);
                end else begin
                    processing_element #(.k(k), .D(D)) PE(clk, rst, out_r[i][j-1], out_b[i-1][j], out_r[i][j], out_b[i][j], out[i][j]);
                end
            end
        end
    endgenerate

endmodule