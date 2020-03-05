`timescale 1ns/1ps
module tb_muladdtree();
    parameter n = 4;
    parameter k = 8;
    parameter D = $clog2(n);

    reg clk, rst;
    reg [k*n-1:0] din1[0:n-1];
    reg [k*n-1:0] din2[0:n-1];
    wire [2*k+D-1:0] dout[0:n-1][0:n-1];

    genvar i, j;
    generate
        for(i = 0; i < n; i = i + 1) begin
            for(j = 0; j < n; j = j + 1) begin:muladd
                MulandAddTree #(.k(k), .n(n)) muladd(clk, rst, din1[i], din2[j], dout[i][j]);
            end
        end
    endgenerate

    always #5 clk = ~clk;

    initial begin
        $dumpfile("mat.vcd");
        $dumpvars(0, tb_muladdtree);
        $readmemh("data41.txt", din1);
        $readmemh("data42.txt", din2);
        //$monitor("At time %g, clk = %b, rst = %b, din = %h, dout = %h", $time, clk, rst, din, dout);
        clk = 0;
        rst = 0;
        #10;
        rst = 1;
        #200;
        $finish;
    end
endmodule