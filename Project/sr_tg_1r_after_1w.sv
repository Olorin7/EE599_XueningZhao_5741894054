`timescale 1ps / 1ps
module sr_tg #(
    parameter APP_DATA_WIDTH   = 64,        // DDR data bus width.
    parameter APP_ADDR_WIDTH   = 33,        // Address bus width of the
    parameter LOG_GAP_NUM      = 6
)(
    input                           clk,
    input                           rst,
    input                           init_calib_complete,
    output [APP_DATA_WIDTH-1:0]     sr_din,
    output                          sr_newd,
	input                           sr_done,
	input  [APP_DATA_WIDTH-1:0]     sr_dout,
    input 				                    app_rdy, // cmd fifo ready signal coming from MC UI.
    input 				                    app_wdf_rdy, // write data fifo ready signal coming from MC UI.
    input  		                            app_rd_data_valid, // read data valid signal coming from MC UI
    input  [APP_DATA_WIDTH-1 : 0] 	        app_rd_data, // read data bus coming from MC UI
    output [2 : 0] 	        app_cmd, // command bus to the MC UI
    output [APP_ADDR_WIDTH-1 : 0] 	        app_addr, // address bus to the MC UI
    output 				                    app_en, // command enable signal to MC UI.
    output [(APP_DATA_WIDTH/8)-1 : 0]       app_wdf_mask, // write data mask signal which
                                                // is tied to 0 in this example.
    output [APP_DATA_WIDTH-1: 0] 	        app_wdf_data, // write data bus to MC UI.
    output 				       app_wdf_end, // write burst end signal to MC UI
    output 				       app_wdf_wren, // write enable signal to MC UI
    output                     sim_status,
    input  [APP_ADDR_WIDTH-1 : 0]           glb_start_addr
    );

    reg [APP_DATA_WIDTH-1:0]     data;
    reg                          newd;
    reg [2 : 0] 	        cmd;
    reg [APP_ADDR_WIDTH-1 : 0] 	        rd_addr;
    reg [APP_ADDR_WIDTH-1 : 0] 	        wt_addr;
    reg 				                en;
    reg [APP_DATA_WIDTH-1: 0] 	        wdf_data;
    reg 				       wdf_wren;
    reg                        status;
    reg [LOG_GAP_NUM-1:0]      wait_time;
    reg [LOG_GAP_NUM-1:0]      write_time;
    reg [LOG_GAP_NUM+2:0]      wait_done;
    reg                        switch;

    wire [APP_DATA_WIDTH-1: 0]          start_data;
    wire                       write_done;
    wire                       read_done;
    wire [APP_ADDR_WIDTH-1 : 0]         loc_start_addr;
    wire                       ID;

    assign ID = glb_start_addr[28];
    assign loc_start_addr = glb_start_addr >> 2;

	assign app_wdf_mask = 8'h0;
	assign sr_din = data;
	assign sr_newd = newd;
	assign app_cmd = cmd;
	assign app_addr = cmd ? rd_addr : wt_addr;
	assign app_en = en;
	assign app_wdf_data = wdf_data;
	assign app_wdf_end = app_wdf_wren;
	assign app_wdf_wren = wdf_wren;
	assign sim_status = status;
    assign start_data = {{{32{1'b0}}, ID}, {31{1'b0}}};

    assign write_done = (wt_addr > (loc_start_addr + (32'h8 << 7))) ? 1 : 0;
    assign read_done = (rd_addr > (loc_start_addr + (32'h8 << 7))) ? 1 : 0;

    always @(posedge clk or posedge rst) begin
        if(rst == 1'b0) begin
            if(init_calib_complete == 1'b1) begin
                if(!write_done && !switch) begin // write
                    newd <= 1;
                    data <= data + 64'h100000;
                    wt_addr <= (app_rdy && app_wdf_rdy && sr_done) ? (wt_addr + 4'h8) : wt_addr;
                    rd_addr <= rd_addr;
                    cmd <= (app_rdy && sr_done) ? 0 : 1;
                    en <= app_rdy && sr_done;
                    wdf_data <= (app_rdy && app_wdf_rdy && sr_done) ? sr_dout : 0;
                    wdf_wren <= app_rdy && app_wdf_rdy && sr_done;
                    status <= 0;
                    wait_time <= 0;
                    wait_done <= 0;
                    switch <= (sr_done && app_rdy && app_wdf_rdy && (write_time > 15)) ? 1 : 0;
                    write_time <= (sr_done && app_rdy && app_wdf_rdy && (write_time < 16)) ? write_time + 1 : write_time;
                end else if (!read_done && switch)begin // read
                    newd <= 1;
                    wt_addr <= wt_addr;
                    cmd <= 1;
                    wdf_data <= 0;
                    wdf_wren <= 0;
                    status <= 0;
                    wait_done <= 0;
                    write_time <= write_time;
                    if(wait_time < 0) begin
                        data <= data;
                        rd_addr <= rd_addr;
                        en <= 0;
                        wait_time <= wait_time + 1;
                        switch <= switch;
                    end else begin
                        data <= app_rd_data_valid ? app_rd_data : data;
                        rd_addr <= app_rdy ? (rd_addr + 4'h8) : rd_addr;
                        en <= app_rdy;
                        wait_time <= wait_time;
                        switch <= app_rdy ? 0 : 1;
                    end
                end else begin
                    if(write_done && !read_done && !switch) begin
                        newd <= 0;
                        wt_addr <= wt_addr;
                        cmd <= 1;
                        wdf_data <= 0;
                        wdf_wren <= 0;
                        status <= 0;
                        wait_done <= 0;
                        write_time <= write_time;
                        if(wait_time < 0) begin
                            data <= start_data;
                            rd_addr <= rd_addr;
                            en <= 0;
                            wait_time <= wait_time + 1;
                            switch <= switch;
                        end else begin
                            data <= app_rd_data_valid ? app_rd_data : start_data;
                            rd_addr <= app_rdy ? (rd_addr + 4'h8) : rd_addr;
                            en <= app_rdy;
                            wait_time <= wait_time;
                            switch <= app_rdy ? 0 : 1;
                        end
                    end else begin
                        newd <= 0;
                        data <= app_rd_data_valid ? app_rd_data : start_data;
                        wt_addr <= wt_addr;
                        rd_addr <= rd_addr;
                        cmd <= 1;
                        en <= 0;
                        wdf_data <= 0;
                        wdf_wren <= 0;
                        status <= (wait_done <= 400 || app_rd_data_valid) ? 0 : 1;
                        wait_time <= 0;
                        write_time <= 0;
                        wait_done <= (wait_done > 400) ? 0 : (wait_done + 1);
                    end
                end
            end else begin
                data <= start_data;
                newd <= 0;
                wt_addr <= loc_start_addr;
                rd_addr <= loc_start_addr;
                cmd <= 1;
                en <= 1'h0;
                wdf_data <= 0;
                wdf_wren <= 0;
                status <= 0;
                wait_time <= 0;
                wait_done <= 0;
                switch <= 0;
                write_time <= 0;
            end
        end else begin
            data <= start_data;
            newd <= 0;
            wt_addr <= loc_start_addr;
            rd_addr <= loc_start_addr;
            cmd <= 1;
            en <= 1'h0;
            wdf_data <= 0;
            wdf_wren <= 0;
            status <= 0;
            wait_time <= 0;
            wait_done <= 0;
            switch <= 0;
            write_time <= 0;
        end
    end
endmodule
