`timescale 1ns/1ps
module tb_barrel_shifter();
    parameter n = 16;
    parameter d = $clog2(n);

    reg clk, rst;
    reg [0:d-1] ctl;
    reg [7:0] din[0:n-1];
    wire [7:0] dout[0:n-1];

    integer i;

    barrel_shifter #(.n(n)) st(clk, rst, ctl, din, dout);

    always #5 clk = ~clk;

    initial begin
    //    $dumpfile("ts.vcd");
    //    $dumpvars(0, tb_barrel_shifter);
        $readmemh("data16.txt", din);
        for (i = 0; i < n; i = i + 1) begin
            $monitor("At time %g, clk = %b, rst = %b, ctl = %b, din = %h, dout = %h", $time, clk, rst, ctl, din[i], dout[i]);
        end
        //$monitor("At time %g, clk = %b, rst = %b, ctl = %b, din = %h, dout = %h", $time, clk, rst, ctl, din, dout);
        clk = 0;
        rst = 0;
        ctl = 3'b0000;
        #10;
        rst = 1;
        #10;
        ctl = 4'b1000;
        #10;
        ctl = 4'b0100;
        #10;
        ctl = 4'b1100;
        #10;
        ctl = 4'b0010;
        #10;
        ctl = 4'b1010;
        #10;
        ctl = 4'b0110;
        #10;
        ctl = 4'b1110;
        #10;
        ctl = 4'b0001;
        #10;
        ctl = 4'b1001;
        #10;
        ctl = 4'b0101;
        #10;
        ctl = 4'b1101;
        #10;
        ctl = 4'b0011;
        #10;
        ctl = 4'b1011;
        #10;
        ctl = 4'b0111;
        #10;
        ctl = 4'b1111;
        #50;
        $finish;
    end
endmodule