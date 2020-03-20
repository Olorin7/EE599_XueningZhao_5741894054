module tb_systolic_arr();
    parameter k = 8;
    parameter D = 16;

    reg clk, rst;
    reg [k-1:0] m_a[0:D-1][0:D-1], m_b[0:D-1][0:D-1];
    wire [k-1:0] m_aa[0:D-1][0:2*D-2], m_bb[0:D-1][0:2*D-2];
    wire [2*k+D-2:0] out[0:D-1][0:D-1];
    reg [k-1:0] in_l[0:D-1], in_t[0:D-1];
    integer i, h, f;

    genvar j, l;
    for (j = 0; j < D ; j = j + 1) begin
        for (l = 0; l < 2*D-1 ; l = l + 1) begin
            if(l >= j && l < j + D) begin
                assign m_aa[j][l] = m_a[j][l-j];
                assign m_bb[j][l] = m_b[l-j][j];
            end else begin
                assign m_aa[j][l] = 0;
                assign m_bb[j][l] = 0;
            end
        end
    end

    systolic_arr #(.k(k), .D(D)) sa(clk, rst, in_l, in_t, out);

    always #5 clk = ~clk;

    initial begin
        $readmemh("data1616_1.txt", m_a);
        $readmemh("data1616_2.txt", m_b);
        //$monitor("At time %g, clk = %b, rst = %b, din = %h, dout = %h", $time, clk, rst, din, dout);
        clk = 0;
        rst = 0;
        #10;
        rst = 1;
        #200;
        $finish;
    end

    initial begin
        #10;
        for(i = 0; i < 2*D-1; i = i + 1) begin
            for (h = 0; h < D ; h = h + 1) begin
                in_l[h] = m_aa[h][i];
                in_t[h] = m_bb[h][i];
            end
            #10;
        end
        for (f = 0; f < D ; f = f + 1) begin
                in_l[f] = 0;
                in_t[f] = 0;
        end
    end
endmodule