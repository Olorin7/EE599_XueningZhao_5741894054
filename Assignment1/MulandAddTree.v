`include "Multiply.v"
`include "Adder.v"
module MulandAddTree(clk, rst, in1, in2, out);
    parameter n = 4;
    parameter k = 8;
    parameter D = $clog2(n);

    input clk, rst;
    input [n*k-1:0] in1;
    input [n*k-1:0] in2;
    output [2*k+D-1:0] out;

    wire [k-1:0] tempwire1[0:n-1];
    wire [k-1:0] tempwire2[0:n-1];
    wire [2*k-1:0] mul[0:n-1];

    genvar h;
    generate
        for(h = 0; h < D; h = h + 1) begin:layer
            wire [2*k+h-1:0] add[0:(n>>h)-1];
        end
    endgenerate

    genvar i;
    generate
        for(i = 0; i < n; i = i + 1) begin:multiplier
            assign tempwire1[i] = in1[(n-i)*k-1:(n-i-1)*k];
            assign tempwire2[i] = in2[(n-i)*k-1:(n-i-1)*k];
            assign layer[0].add[i] = mul[i];
            Multiply #(.k(k)) mult(clk, rst, tempwire1[i], tempwire2[i], mul[i]);
        end
    endgenerate

    genvar j, l;
    generate
        for(j = 0; j < D-1; j = j + 1) begin:adderlayer
            for (l = 0; l < (n>>(j+1)); l = l + 1) begin:adder
                Adder #(.k(2*k+j)) adde(clk, rst, layer[j].add[2*l], layer[j].add[2*l+1], layer[j+1].add[l]);
            end
        end
    endgenerate

    Adder #(.k(2*k+D-1)) add(clk, rst, layer[D-1].add[0], layer[D-1].add[1], out);

endmodule