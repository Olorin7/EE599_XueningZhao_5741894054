module odd_even_sort(clk, rst, in, out);
    parameter n = 16;
    parameter D = $clog2(n);

    input [8*n-1:0] in;
    input clk, rst;
    output [8*n-1:0] out;

    integer i;
    wire [7:0] tempwire[0:n-1];
    reg [7:0] temp[0:n-1];
    reg [D-1:0] j;
    genvar k;

    generate
        for(k = n; k > 0; k = k - 1) begin
            assign out[k*8-1:k*8-8] = temp[n-k];
            assign tempwire[n-k] = in[k*8-1:k*8-8];
        end
    endgenerate

    always @(posedge clk) begin
        if (!rst) begin
            j <= 0;
            for (i = 0; i < n; i = i + 1) begin
                temp[i] <= tempwire[i];
            end
        end else begin
            j <= j + 1;
            if(j[0] == 0) begin
                for(i = 0; i < n; i = i + 2) begin
                    if(temp[i] > temp[i+1]) begin
                        temp[i] <= temp[i+1];
                        temp[i+1] <= temp[i];
                    end else begin
                    end
                end
            end else begin
                for(i = 1; i < n-1; i = i + 2) begin
                    if(temp[i] > temp[i+1]) begin
                        temp[i] <= temp[i+1];
                        temp[i+1] <= temp[i];
                    end else begin
                    end
                end
            end

        end
    end
endmodule
