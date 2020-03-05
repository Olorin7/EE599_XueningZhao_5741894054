`timescale 1ns/1ps
module tb_odd_even_sort();
    parameter n = 16;
    reg clk, rst;
    reg [8*n-1:0] din;
    wire [8*n-1:0] dout;

    odd_even_sort #(.n(n)) st(clk, rst, din, dout);

    always #5 clk = ~clk;

    initial begin
        $dumpfile("ts.vcd");
        $dumpvars(0, tb_odd_even_sort);
        // $readmemh("data16.txt", din);
        $monitor("At time %g, clk = %b, rst = %b, din = %h, dout = %h", $time, clk, rst, din, dout);
        clk = 0;
        rst = 0;
        din = 128'h3c4d5a1a6f31147b3e016e7b1111337a;
        #10;
        rst = 1;
        #200;
        $finish;
    end
endmodule