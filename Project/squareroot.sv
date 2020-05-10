// use method of trial (also called DIGIT RECURRENCE METHOD), everytime copmare two bit of the number, so need 8 cycles to get the integer answer
// if higher precision is required, just need to add more cycles and registers
module squareroot(clk, rst, en, din, newd, dout, done);
    parameter I_WIDTH = 16;
    parameter O_WIDTH = (I_WIDTH + 1) >> 1'b1;

    input clk, rst, en, newd;
    input [I_WIDTH-1:0] din;
    output reg[O_WIDTH-1:0] dout;
    output reg done;

    reg [I_WIDTH-1:0] compare[0:O_WIDTH-2]; // the number to be calculated for sqrt
    reg [O_WIDTH-1:0] sqrt[0:O_WIDTH-2]; // store results of every step
    reg [O_WIDTH-1:0] remainder[0:O_WIDTH-2]; // to be compared in every step
    reg cur_done[0:O_WIDTH-2];

    wire [O_WIDTH+1:0] subtracted[0:O_WIDTH-2];
    wire [O_WIDTH:0] subtractor[0:O_WIDTH-2];

    integer i;
    parameter ini_sqrt = 1'b1;

    genvar j;
    generate
        for(j = 0; j <= O_WIDTH-2; j = j + 1) begin
            assign subtracted[j] = {remainder[j], compare[j][((j << 1'b1) + 1'b1):(j << 1'b1)]};
        end
    endgenerate

    genvar k;
    generate
        for(k = 0; k <= O_WIDTH-2; k = k + 1) begin
            assign subtractor[k] = sqrt[k][O_WIDTH-1:k+1] << 2;
        end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin
            dout <= 0;
            done <= 0;
            for (i = O_WIDTH-2; i >= 0; i = i - 1) begin
                compare[i] <= 0;
                sqrt[i] <= 0;
                remainder[i] <= 0;
                cur_done[i] <= 0;
            end
        end else if(!en) begin // if not enable, every register will not refresh its value
            dout <= dout;
            done <= done;
            for (i = O_WIDTH-2; i >= 0; i = i - 1) begin
                compare[i] <= compare[i];
                sqrt[i] <= sqrt[i];
                remainder[i] <= remainder[i];
                cur_done[i] <= cur_done[i];
            end
        end else begin
            // compare the first two bits of the number, and get the first bit of sqrt
            compare[O_WIDTH-2] <= din;
            cur_done[O_WIDTH-2] <= newd;
            if (ini_sqrt * ini_sqrt > din[I_WIDTH-1:I_WIDTH-2]) begin
                sqrt[O_WIDTH-2] <= {O_WIDTH{1'b0}};
                remainder[O_WIDTH-2] <= din[I_WIDTH-1:I_WIDTH-2];
            end else begin
                sqrt[O_WIDTH-2] <= {{1'b1}, {(O_WIDTH-1){1'b0}}};
                remainder[O_WIDTH-2] <= din[I_WIDTH-1:I_WIDTH-2] - 1'b1;
            end
            // compare the (4 * current sqrt + 1) with {current remainder, next two bits of number} to determine one more bit of sqrt
            for (i = O_WIDTH-3; i >= 0; i = i - 1) begin
                compare[i] <= compare[i + 1];
                cur_done[i] <= cur_done[i + 1];
                if(subtractor[i + 1] + 1 > subtracted[i + 1]) begin // if not larger, the next bit is 0
                    sqrt[i] <= sqrt[i + 1];
                    remainder[i] <= subtracted[i + 1];
                end else begin // otherwise is 1, and remainder should minus (4 * current sqrt + 1)
                    sqrt[i] <= sqrt[i + 1] ^ (1'b1 << (i + 1));
                    remainder[i] <= subtracted[i + 1] - subtractor[i + 1] - 1;
                end
            end
            // calculate last bit and get the output
            dout <= subtractor[0] + 1 > subtracted[0] ? sqrt[0]: sqrt[0] + 1;
            done <= cur_done[0];
        end
    end
endmodule
