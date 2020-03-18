module barrel_shifter(clk, rst, ctl, in, out);
    parameter n = 16;
    parameter d = $clog2(n);

    input clk, rst;
    input [0:d-1] ctl;
    input [7:0] in[0:n-1];
    output [7:0] out[0:n-1];

    reg [7:0] stage[0:d-1][0:n-1];
    reg [0:d-1] ctl_stage[0:d-2];
    reg [d:0] i;

    genvar k;
    generate
        for (k = 0; k < n; k = k + 1) begin:number
            assign out[k] = stage[d-1][k];
        end
    endgenerate

    genvar j;
    generate
        for (j = 0; j < d; j = j + 1) begin:layer
            always@(posedge clk) begin
                if(!rst) begin
                    if (j < d-1) begin
                        ctl_stage[j] <= 0;
                    end

                    for (i = 0; i < n; i = i + 1) begin
                        stage[j][i] <= 0;
                    end
                end else begin
                    if(j == 0) begin
                        ctl_stage[0] <= ctl;
                        for (i = 0; i < n; i = i + 1) begin
                            case(ctl[j])
                                1'b0: begin
                                    stage[j][i] <= in[i];
                                end
                                1'b1:begin
                                    stage[j][i] <= (1 << j) > i ? in[i+n-(1<<j)] : in[i-(1<<j)];
                                end
                                default: begin
                                    stage[j][i] <= in[i];
                                end
                            endcase
                        end
                    end else if(j < d-1) begin
                        ctl_stage[j] <= ctl_stage[j-1];
                        for (i = 0; i < n; i = i + 1) begin
                            case(ctl_stage[j-1][j])
                                1'b0: begin
                                    stage[j][i] <= stage[j-1][i];
                                end
                                1'b1:begin
                                    stage[j][i] <= (1 << j) > i ? stage[j-1][i+n-(1<<j)] : stage[j-1][i-(1<<j)];
                                end
                                default: begin
                                    stage[j][i] <= stage[j-1][i];
                                end
                            endcase
                        end
                    end else begin
                        for (i = 0; i < n; i = i + 1) begin
                            case(ctl_stage[j-1][j])
                                1'b0: begin
                                    stage[j][i] <= stage[j-1][i];
                                end
                                1'b1:begin
                                    stage[j][i] <= (1 << j) > i ? stage[j-1][i+n-(1<<j)] : stage[j-1][i-(1<<j)];
                                end
                                default: begin
                                    stage[j][i] <= stage[j-1][i];
                                end
                            endcase
                        end
                    end
                end
            end
        end
    endgenerate
endmodule