module sr_top#(
    parameter I_WIDTH = 32,
    parameter O_WIDTH = (I_WIDTH + 1) >> 1'b1,
    parameter NUM     = 16
)(
    input                      clk0,
    input                      clk1,
    input                      clk2,
    input                      clk3,
    input                      clk4,
    input                      clk5,
    input                      clk6,
    input                      rst0_n,
    input                      rst1_n,
    input                      rst2_n,
    input                      rst3_n,
    input                      rst4_n,
    input                      rst5_n,
    input                      rst6_n,
    input                      en,
    input  [I_WIDTH-1:0]       din[0:NUM-1],
    input                      newd[0:NUM-1],
    output [O_WIDTH-1:0]       dout[0:NUM-1],
    output                     done[0:NUM-1]
);

    genvar i;
    generate
        for (i = 0; i < NUM; i = i + 1) begin:u_sr
            if(i < 2) begin
                squareroot #(.I_WIDTH(I_WIDTH)) u_squareroot(
                    .clk    (clk0),
                    .rst    (~rst0_n),
                    .en     (1),
                    .din    (din[i]),
                    .newd   (newd[i]),
                    .dout   (dout[i]),
                    .done   (done[i]));
            end else if (i < 4) begin
                squareroot #(.I_WIDTH(I_WIDTH)) u_squareroot(
                    .clk    (clk1),
                    .rst    (~rst1_n),
                    .en     (1),
                    .din    (din[i]),
                    .newd   (newd[i]),
                    .dout   (dout[i]),
                    .done   (done[i]));
            end else if (i < 6) begin
                squareroot #(.I_WIDTH(I_WIDTH)) u_squareroot(
                    .clk    (clk2),
                    .rst    (~rst2_n),
                    .en     (1),
                    .din    (din[i]),
                    .newd   (newd[i]),
                    .dout   (dout[i]),
                    .done   (done[i]));
            end else if (i < 8) begin
                squareroot #(.I_WIDTH(I_WIDTH)) u_squareroot(
                    .clk    (clk3),
                    .rst    (~rst3_n),
                    .en     (1),
                    .din    (din[i]),
                    .newd   (newd[i]),
                    .dout   (dout[i]),
                    .done   (done[i]));
            end else if (i < 10) begin
                squareroot #(.I_WIDTH(I_WIDTH)) u_squareroot(
                    .clk    (clk4),
                    .rst    (~rst4_n),
                    .en     (1),
                    .din    (din[i]),
                    .newd   (newd[i]),
                    .dout   (dout[i]),
                    .done   (done[i]));
            end else if (i < 13) begin
                squareroot #(.I_WIDTH(I_WIDTH)) u_squareroot(
                    .clk    (clk5),
                    .rst    (~rst5_n),
                    .en     (1),
                    .din    (din[i]),
                    .newd   (newd[i]),
                    .dout   (dout[i]),
                    .done   (done[i]));
            end else begin
                squareroot #(.I_WIDTH(I_WIDTH)) u_squareroot(
                    .clk    (clk6),
                    .rst    (~rst6_n),
                    .en     (1),
                    .din    (din[i]),
                    .newd   (newd[i]),
                    .dout   (dout[i]),
                    .done   (done[i]));
            end
        end
    endgenerate
endmodule
