/******************************************************************************
// (c) Copyright 2017 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
******************************************************************************/
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor             : Xilinx
// \   \   \/     Version            : 1.0
//  \   \         Application        : MIG
//  /   /         Filename           : example_top_syn.sv
// /___/   /\     Date Last Modified : $Date$
// \   \  /  \    Date Created       : Tue Jan 3 2017
//  \___\/\___\
//
//Device: UltraScale+ HBM
//Design Name: HBM
//*****************************************************************************

`ifdef MODEL_TECH
  `define SIMULATION_MODE
`elsif INCA
  `define SIMULATION_MODE
`elsif VCS
  `define SIMULATION_MODE
`elsif XILINX_SIMULATOR
  `define SIMULATION_MODE
`elsif _VCP
  `define SIMULATION_MODE
`endif
`include "defines_h.vh"
`timescale 1ps/1ps
////////////////////////////////////////////////////////////////////////////////
// Module Delcaration
////////////////////////////////////////////////////////////////////////////////
module example_top_syn # (
  parameter APP_DATA_WIDTH   = 256,
  parameter APP_ADDR_WIDTH   = 33,
`ifdef SIMULATION_MODE
  parameter SIMULATION            = "TRUE"
`else
  parameter SIMULATION            = "FALSE"
`endif
  ) (
   input               APB_0_PCLK
  ,input               APB_0_PRESET_N
  ,input               AXI_ACLK_IN_0
  ,input               AXI_ARESET_N_0

`ifdef SIMULATION_MODE
  ,input      [ 31:0]  APB_0_PWDATA
  ,input      [ 21:0]  APB_0_PADDR
  ,input               APB_0_PENABLE
  ,input               APB_0_PSEL
  ,input               APB_0_PWRITE
  ,output     [ 31:0]  APB_0_PRDATA
  ,output              APB_0_PREADY
  ,output              APB_0_PSLVERR
`endif
  ,input               HBM_REF_CLK_0
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_0
  ,output              axi_00_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_1
  ,output              axi_01_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_2
  ,output              axi_02_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_3
  ,output              axi_03_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_4
  ,output              axi_04_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_5
  ,output              axi_05_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_6
  ,output              axi_06_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_7
  ,output              axi_07_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_8
  ,output              axi_08_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_9
  ,output              axi_09_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_10
  ,output              axi_10_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_11
  ,output              axi_11_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_12
  ,output              axi_12_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_13
  ,output              axi_13_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_14
  ,output              axi_14_data_msmatch_err
`endif
`ifdef SIMULATION_MODE
  ,output              boot_mode_done_15
  ,output              axi_15_data_msmatch_err
`endif
`ifndef SIMULATION_MODE
  ,output              axi_trans_err
`endif
);
`ifdef OPT_DATA_W
	parameter APP_DATA_WIDTH_4D = APP_DATA_WIDTH/4;
`else
	parameter APP_DATA_WIDTH_4D = APP_DATA_WIDTH;
`endif

  parameter I_WIDTH = 32;
  parameter O_WIDTH = (I_WIDTH + 1) >> 1'b1;

////////////////////////////////////////////////////////////////////////////////
// Localparams
////////////////////////////////////////////////////////////////////////////////
  localparam MMCM_CLKFBOUT_MULT_F  = 18;
  localparam MMCM_CLKOUT0_DIVIDE_F = 2;
  localparam MMCM_DIVCLK_DIVIDE    = 2;
  localparam MMCM_CLKIN1_PERIOD    = 10.000;

  localparam MMCM1_CLKFBOUT_MULT_F  = 18;
  localparam MMCM1_CLKOUT0_DIVIDE_F = 2;
  localparam MMCM1_DIVCLK_DIVIDE    = 2;
  localparam MMCM1_CLKIN1_PERIOD    = 10.000;

////////////////////////////////////////////////////////////////////////////////
// Wire Delcaration
////////////////////////////////////////////////////////////////////////////////
(* keep = "TRUE" *)   wire          AXI_ACLK_IN_0_buf;
(* keep = "TRUE" *)   wire          AXI_ACLK_IN_0_iobuf;
(* keep = "TRUE" *)   wire          AXI_ACLK0_st0;
(* keep = "TRUE" *)   wire          AXI_ACLK1_st0;
(* keep = "TRUE" *)   wire          AXI_ACLK2_st0;
(* keep = "TRUE" *)   wire          AXI_ACLK3_st0;
(* keep = "TRUE" *)   wire          AXI_ACLK4_st0;
(* keep = "TRUE" *)   wire          AXI_ACLK5_st0;
(* keep = "TRUE" *)   wire          AXI_ACLK6_st0;
(* keep = "TRUE" *)   wire          AXI_ACLK0_st0_buf;
(* keep = "TRUE" *)   wire          AXI_ACLK1_st0_buf;
(* keep = "TRUE" *)   wire          AXI_ACLK2_st0_buf;
(* keep = "TRUE" *)   wire          AXI_ACLK3_st0_buf;
(* keep = "TRUE" *)   wire          AXI_ACLK4_st0_buf;
(* keep = "TRUE" *)   wire          AXI_ACLK5_st0_buf;
(* keep = "TRUE" *)   wire          AXI_ACLK6_st0_buf;
(* keep = "TRUE" *)  wire          i_clk_atg_axi_vio_st0;
  wire          MMCM_LOCK_0;
  wire          apb_seq_complete_0_s;
  (* ASYNC_REG = "TRUE" *) reg           apb_seq_complete_0_st0_r0, apb_seq_complete_0_st0_r1, apb_seq_complete_0_st0_r2;
  wire          tg_start_st0_0;
  (* ASYNC_REG = "TRUE" *) reg           apb_seq_complete_1_st0_r0, apb_seq_complete_1_st0_r1, apb_seq_complete_1_st0_r2;
  wire          tg_start_st0_1;
  (* ASYNC_REG = "TRUE" *) reg           apb_seq_complete_2_st0_r0, apb_seq_complete_2_st0_r1, apb_seq_complete_2_st0_r2;
  wire          tg_start_st0_2;
  (* ASYNC_REG = "TRUE" *) reg           apb_seq_complete_3_st0_r0, apb_seq_complete_3_st0_r1, apb_seq_complete_3_st0_r2;
  wire          tg_start_st0_3;
  (* ASYNC_REG = "TRUE" *) reg           apb_seq_complete_4_st0_r0, apb_seq_complete_4_st0_r1, apb_seq_complete_4_st0_r2;
  wire          tg_start_st0_4;
  (* ASYNC_REG = "TRUE" *) reg           apb_seq_complete_5_st0_r0, apb_seq_complete_5_st0_r1, apb_seq_complete_5_st0_r2;
  wire          tg_start_st0_5;
  (* ASYNC_REG = "TRUE" *) reg           apb_seq_complete_6_st0_r0, apb_seq_complete_6_st0_r1, apb_seq_complete_6_st0_r2;
  wire          tg_start_st0_6;

  wire              ext_apb_seq_complete_s;
  wire              ext_apb_seq_complete_0_int_s;
  wire              ext_apb_seq_complete_0_s;
`ifndef SIMULATION_MODE
  wire     [ 31:0]  APB_0_PWDATA = 32'b0;
  wire     [ 21:0]  APB_0_PADDR  = 22'b0;
  wire              APB_0_PENABLE = 1'b0;
  wire              APB_0_PSEL = 1'b0;
  wire              APB_0_PWRITE = 1'b0;
  wire     [ 31:0]  APB_0_PRDATA;
  wire              APB_0_PREADY;
  wire              APB_0_PSLVERR;
`endif
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_0;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_0;
  wire [ 32:0]  AXI_00_ARADDR;
  wire [  1:0]  AXI_00_ARBURST;
  wire [  5:0]  AXI_00_ARID;
  wire [  7:0]  AXI_00_ARLEN;
  wire [  2:0]  AXI_00_ARSIZE;
  wire          AXI_00_ARVALID;
  wire [ 32:0]  AXI_00_AWADDR;
  wire [  1:0]  AXI_00_AWBURST;
  wire [  5:0]  AXI_00_AWID;
  wire [  7:0]  AXI_00_AWLEN;
  wire [  2:0]  AXI_00_AWSIZE;
  wire          AXI_00_AWVALID;
  wire          AXI_00_RREADY;
  wire          AXI_00_BREADY;
  wire [255:0]  AXI_00_WDATA;
  wire          AXI_00_WLAST;
  wire [ 31:0]  AXI_00_WSTRB;
  wire [ 31:0]  AXI_00_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_00_WDATA_PARITY;
  wire          AXI_00_WVALID;
  wire [3:0]    AXI_00_ARCACHE;
  wire [3:0]    AXI_00_AWCACHE;
  wire [2:0]    AXI_00_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_0;
`endif
  wire      [31:0]  prbs_mode_seed_0 = 32'habcd_1234;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_1;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_1;
  wire [ 32:0]  AXI_01_ARADDR;
  wire [  1:0]  AXI_01_ARBURST;
  wire [  5:0]  AXI_01_ARID;
  wire [  7:0]  AXI_01_ARLEN;
  wire [  2:0]  AXI_01_ARSIZE;
  wire          AXI_01_ARVALID;
  wire [ 32:0]  AXI_01_AWADDR;
  wire [  1:0]  AXI_01_AWBURST;
  wire [  5:0]  AXI_01_AWID;
  wire [  7:0]  AXI_01_AWLEN;
  wire [  2:0]  AXI_01_AWSIZE;
  wire          AXI_01_AWVALID;
  wire          AXI_01_RREADY;
  wire          AXI_01_BREADY;
  wire [255:0]  AXI_01_WDATA;
  wire          AXI_01_WLAST;
  wire [ 31:0]  AXI_01_WSTRB;
  wire [ 31:0]  AXI_01_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_01_WDATA_PARITY;
  wire          AXI_01_WVALID;
  wire [3:0]    AXI_01_ARCACHE;
  wire [3:0]    AXI_01_AWCACHE;
  wire [2:0]    AXI_01_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_1;
`endif
  wire      [31:0]  prbs_mode_seed_1 = 32'habcd_1234;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_2;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_2;
  wire [ 32:0]  AXI_02_ARADDR;
  wire [  1:0]  AXI_02_ARBURST;
  wire [  5:0]  AXI_02_ARID;
  wire [  7:0]  AXI_02_ARLEN;
  wire [  2:0]  AXI_02_ARSIZE;
  wire          AXI_02_ARVALID;
  wire [ 32:0]  AXI_02_AWADDR;
  wire [  1:0]  AXI_02_AWBURST;
  wire [  5:0]  AXI_02_AWID;
  wire [  7:0]  AXI_02_AWLEN;
  wire [  2:0]  AXI_02_AWSIZE;
  wire          AXI_02_AWVALID;
  wire          AXI_02_RREADY;
  wire          AXI_02_BREADY;
  wire [255:0]  AXI_02_WDATA;
  wire          AXI_02_WLAST;
  wire [ 31:0]  AXI_02_WSTRB;
  wire [ 31:0]  AXI_02_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_02_WDATA_PARITY;
  wire          AXI_02_WVALID;
  wire [3:0]    AXI_02_ARCACHE;
  wire [3:0]    AXI_02_AWCACHE;
  wire [2:0]    AXI_02_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_2;
`endif
  wire      [31:0]  prbs_mode_seed_2 = 32'habcd_1234;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_3;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_3;
  wire [ 32:0]  AXI_03_ARADDR;
  wire [  1:0]  AXI_03_ARBURST;
  wire [  5:0]  AXI_03_ARID;
  wire [  7:0]  AXI_03_ARLEN;
  wire [  2:0]  AXI_03_ARSIZE;
  wire          AXI_03_ARVALID;
  wire [ 32:0]  AXI_03_AWADDR;
  wire [  1:0]  AXI_03_AWBURST;
  wire [  5:0]  AXI_03_AWID;
  wire [  7:0]  AXI_03_AWLEN;
  wire [  2:0]  AXI_03_AWSIZE;
  wire          AXI_03_AWVALID;
  wire          AXI_03_RREADY;
  wire          AXI_03_BREADY;
  wire [255:0]  AXI_03_WDATA;
  wire          AXI_03_WLAST;
  wire [ 31:0]  AXI_03_WSTRB;
  wire [ 31:0]  AXI_03_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_03_WDATA_PARITY;
  wire          AXI_03_WVALID;
  wire [3:0]    AXI_03_ARCACHE;
  wire [3:0]    AXI_03_AWCACHE;
  wire [2:0]    AXI_03_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_3;
`endif
  wire      [31:0]  prbs_mode_seed_3 = 32'habcd_1234;

  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_4;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_4;
  wire [ 32:0]  AXI_04_ARADDR;
  wire [  1:0]  AXI_04_ARBURST;
  wire [  5:0]  AXI_04_ARID;
  wire [  7:0]  AXI_04_ARLEN;
  wire [  2:0]  AXI_04_ARSIZE;
  wire          AXI_04_ARVALID;
  wire [ 32:0]  AXI_04_AWADDR;
  wire [  1:0]  AXI_04_AWBURST;
  wire [  5:0]  AXI_04_AWID;
  wire [  7:0]  AXI_04_AWLEN;
  wire [  2:0]  AXI_04_AWSIZE;
  wire          AXI_04_AWVALID;
  wire          AXI_04_RREADY;
  wire          AXI_04_BREADY;
  wire [255:0]  AXI_04_WDATA;
  wire          AXI_04_WLAST;
  wire [ 31:0]  AXI_04_WSTRB;
  wire [ 31:0]  AXI_04_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_04_WDATA_PARITY;
  wire          AXI_04_WVALID;
  wire [3:0]    AXI_04_ARCACHE;
  wire [3:0]    AXI_04_AWCACHE;
  wire [2:0]    AXI_04_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_4;
`endif
  wire      [31:0]  prbs_mode_seed_4 = 32'habcd_1234;

  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_5;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_5;
  wire [ 32:0]  AXI_05_ARADDR;
  wire [  1:0]  AXI_05_ARBURST;
  wire [  5:0]  AXI_05_ARID;
  wire [  7:0]  AXI_05_ARLEN;
  wire [  2:0]  AXI_05_ARSIZE;
  wire          AXI_05_ARVALID;
  wire [ 32:0]  AXI_05_AWADDR;
  wire [  1:0]  AXI_05_AWBURST;
  wire [  5:0]  AXI_05_AWID;
  wire [  7:0]  AXI_05_AWLEN;
  wire [  2:0]  AXI_05_AWSIZE;
  wire          AXI_05_AWVALID;
  wire          AXI_05_RREADY;
  wire          AXI_05_BREADY;
  wire [255:0]  AXI_05_WDATA;
  wire          AXI_05_WLAST;
  wire [ 31:0]  AXI_05_WSTRB;
  wire [ 31:0]  AXI_05_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_05_WDATA_PARITY;
  wire          AXI_05_WVALID;
  wire [3:0]    AXI_05_ARCACHE;
  wire [3:0]    AXI_05_AWCACHE;
  wire [2:0]    AXI_05_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_5;
`endif
  wire      [31:0]  prbs_mode_seed_5 = 32'habcd_1234;

  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_6;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_6;
  wire [ 32:0]  AXI_06_ARADDR;
  wire [  1:0]  AXI_06_ARBURST;
  wire [  5:0]  AXI_06_ARID;
  wire [  7:0]  AXI_06_ARLEN;
  wire [  2:0]  AXI_06_ARSIZE;
  wire          AXI_06_ARVALID;
  wire [ 32:0]  AXI_06_AWADDR;
  wire [  1:0]  AXI_06_AWBURST;
  wire [  5:0]  AXI_06_AWID;
  wire [  7:0]  AXI_06_AWLEN;
  wire [  2:0]  AXI_06_AWSIZE;
  wire          AXI_06_AWVALID;
  wire          AXI_06_RREADY;
  wire          AXI_06_BREADY;
  wire [255:0]  AXI_06_WDATA;
  wire          AXI_06_WLAST;
  wire [ 31:0]  AXI_06_WSTRB;
  wire [ 31:0]  AXI_06_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_06_WDATA_PARITY;
  wire          AXI_06_WVALID;
  wire [3:0]    AXI_06_ARCACHE;
  wire [3:0]    AXI_06_AWCACHE;
  wire [2:0]    AXI_06_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_6;
`endif
  wire      [31:0]  prbs_mode_seed_6 = 32'habcd_1234;

  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_7;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_7;
  wire [ 32:0]  AXI_07_ARADDR;
  wire [  1:0]  AXI_07_ARBURST;
  wire [  5:0]  AXI_07_ARID;
  wire [  7:0]  AXI_07_ARLEN;
  wire [  2:0]  AXI_07_ARSIZE;
  wire          AXI_07_ARVALID;
  wire [ 32:0]  AXI_07_AWADDR;
  wire [  1:0]  AXI_07_AWBURST;
  wire [  5:0]  AXI_07_AWID;
  wire [  7:0]  AXI_07_AWLEN;
  wire [  2:0]  AXI_07_AWSIZE;
  wire          AXI_07_AWVALID;
  wire          AXI_07_RREADY;
  wire          AXI_07_BREADY;
  wire [255:0]  AXI_07_WDATA;
  wire          AXI_07_WLAST;
  wire [ 31:0]  AXI_07_WSTRB;
  wire [ 31:0]  AXI_07_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_07_WDATA_PARITY;
  wire          AXI_07_WVALID;
  wire [3:0]    AXI_07_ARCACHE;
  wire [3:0]    AXI_07_AWCACHE;
  wire [2:0]    AXI_07_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_7;
`endif
  wire      [31:0]  prbs_mode_seed_7 = 32'habcd_1234;

  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_8;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_8;
  wire [ 32:0]  AXI_08_ARADDR;
  wire [  1:0]  AXI_08_ARBURST;
  wire [  5:0]  AXI_08_ARID;
  wire [  7:0]  AXI_08_ARLEN;
  wire [  2:0]  AXI_08_ARSIZE;
  wire          AXI_08_ARVALID;
  wire [ 32:0]  AXI_08_AWADDR;
  wire [  1:0]  AXI_08_AWBURST;
  wire [  5:0]  AXI_08_AWID;
  wire [  7:0]  AXI_08_AWLEN;
  wire [  2:0]  AXI_08_AWSIZE;
  wire          AXI_08_AWVALID;
  wire          AXI_08_RREADY;
  wire          AXI_08_BREADY;
  wire [255:0]  AXI_08_WDATA;
  wire          AXI_08_WLAST;
  wire [ 31:0]  AXI_08_WSTRB;
  wire [ 31:0]  AXI_08_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_08_WDATA_PARITY;
  wire          AXI_08_WVALID;
  wire [3:0]    AXI_08_ARCACHE;
  wire [3:0]    AXI_08_AWCACHE;
  wire [2:0]    AXI_08_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_8;
`endif
  wire      [31:0]  prbs_mode_seed_8 = 32'habcd_1234;

  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_9;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_9;
  wire [ 32:0]  AXI_09_ARADDR;
  wire [  1:0]  AXI_09_ARBURST;
  wire [  5:0]  AXI_09_ARID;
  wire [  7:0]  AXI_09_ARLEN;
  wire [  2:0]  AXI_09_ARSIZE;
  wire          AXI_09_ARVALID;
  wire [ 32:0]  AXI_09_AWADDR;
  wire [  1:0]  AXI_09_AWBURST;
  wire [  5:0]  AXI_09_AWID;
  wire [  7:0]  AXI_09_AWLEN;
  wire [  2:0]  AXI_09_AWSIZE;
  wire          AXI_09_AWVALID;
  wire          AXI_09_RREADY;
  wire          AXI_09_BREADY;
  wire [255:0]  AXI_09_WDATA;
  wire          AXI_09_WLAST;
  wire [ 31:0]  AXI_09_WSTRB;
  wire [ 31:0]  AXI_09_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_09_WDATA_PARITY;
  wire          AXI_09_WVALID;
  wire [3:0]    AXI_09_ARCACHE;
  wire [3:0]    AXI_09_AWCACHE;
  wire [2:0]    AXI_09_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_9;
`endif
  wire      [31:0]  prbs_mode_seed_9 = 32'habcd_1234;

  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_10;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_10;
  wire [ 32:0]  AXI_10_ARADDR;
  wire [  1:0]  AXI_10_ARBURST;
  wire [  5:0]  AXI_10_ARID;
  wire [  7:0]  AXI_10_ARLEN;
  wire [  2:0]  AXI_10_ARSIZE;
  wire          AXI_10_ARVALID;
  wire [ 32:0]  AXI_10_AWADDR;
  wire [  1:0]  AXI_10_AWBURST;
  wire [  5:0]  AXI_10_AWID;
  wire [  7:0]  AXI_10_AWLEN;
  wire [  2:0]  AXI_10_AWSIZE;
  wire          AXI_10_AWVALID;
  wire          AXI_10_RREADY;
  wire          AXI_10_BREADY;
  wire [255:0]  AXI_10_WDATA;
  wire          AXI_10_WLAST;
  wire [ 31:0]  AXI_10_WSTRB;
  wire [ 31:0]  AXI_10_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_10_WDATA_PARITY;
  wire          AXI_10_WVALID;
  wire [3:0]    AXI_10_ARCACHE;
  wire [3:0]    AXI_10_AWCACHE;
  wire [2:0]    AXI_10_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_10;
`endif
  wire      [31:0]  prbs_mode_seed_10 = 32'habcd_1234;

  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_11;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_11;
  wire [ 32:0]  AXI_11_ARADDR;
  wire [  1:0]  AXI_11_ARBURST;
  wire [  5:0]  AXI_11_ARID;
  wire [  7:0]  AXI_11_ARLEN;
  wire [  2:0]  AXI_11_ARSIZE;
  wire          AXI_11_ARVALID;
  wire [ 32:0]  AXI_11_AWADDR;
  wire [  1:0]  AXI_11_AWBURST;
  wire [  5:0]  AXI_11_AWID;
  wire [  7:0]  AXI_11_AWLEN;
  wire [  2:0]  AXI_11_AWSIZE;
  wire          AXI_11_AWVALID;
  wire          AXI_11_RREADY;
  wire          AXI_11_BREADY;
  wire [255:0]  AXI_11_WDATA;
  wire          AXI_11_WLAST;
  wire [ 31:0]  AXI_11_WSTRB;
  wire [ 31:0]  AXI_11_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_11_WDATA_PARITY;
  wire          AXI_11_WVALID;
  wire [3:0]    AXI_11_ARCACHE;
  wire [3:0]    AXI_11_AWCACHE;
  wire [2:0]    AXI_11_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_11;
`endif
  wire      [31:0]  prbs_mode_seed_11 = 32'habcd_1234;

  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_12;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_12;
  wire [ 32:0]  AXI_12_ARADDR;
  wire [  1:0]  AXI_12_ARBURST;
  wire [  5:0]  AXI_12_ARID;
  wire [  7:0]  AXI_12_ARLEN;
  wire [  2:0]  AXI_12_ARSIZE;
  wire          AXI_12_ARVALID;
  wire [ 32:0]  AXI_12_AWADDR;
  wire [  1:0]  AXI_12_AWBURST;
  wire [  5:0]  AXI_12_AWID;
  wire [  7:0]  AXI_12_AWLEN;
  wire [  2:0]  AXI_12_AWSIZE;
  wire          AXI_12_AWVALID;
  wire          AXI_12_RREADY;
  wire          AXI_12_BREADY;
  wire [255:0]  AXI_12_WDATA;
  wire          AXI_12_WLAST;
  wire [ 31:0]  AXI_12_WSTRB;
  wire [ 31:0]  AXI_12_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_12_WDATA_PARITY;
  wire          AXI_12_WVALID;
  wire [3:0]    AXI_12_ARCACHE;
  wire [3:0]    AXI_12_AWCACHE;
  wire [2:0]    AXI_12_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_12;
`endif
  wire      [31:0]  prbs_mode_seed_12 = 32'habcd_1234;

  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_13;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_13;
  wire [ 32:0]  AXI_13_ARADDR;
  wire [  1:0]  AXI_13_ARBURST;
  wire [  5:0]  AXI_13_ARID;
  wire [  7:0]  AXI_13_ARLEN;
  wire [  2:0]  AXI_13_ARSIZE;
  wire          AXI_13_ARVALID;
  wire [ 32:0]  AXI_13_AWADDR;
  wire [  1:0]  AXI_13_AWBURST;
  wire [  5:0]  AXI_13_AWID;
  wire [  7:0]  AXI_13_AWLEN;
  wire [  2:0]  AXI_13_AWSIZE;
  wire          AXI_13_AWVALID;
  wire          AXI_13_RREADY;
  wire          AXI_13_BREADY;
  wire [255:0]  AXI_13_WDATA;
  wire          AXI_13_WLAST;
  wire [ 31:0]  AXI_13_WSTRB;
  wire [ 31:0]  AXI_13_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_13_WDATA_PARITY;
  wire          AXI_13_WVALID;
  wire [3:0]    AXI_13_ARCACHE;
  wire [3:0]    AXI_13_AWCACHE;
  wire [2:0]    AXI_13_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_13;
`endif
  wire      [31:0]  prbs_mode_seed_13 = 32'habcd_1234;

  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_14;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_14;
  wire [ 32:0]  AXI_14_ARADDR;
  wire [  1:0]  AXI_14_ARBURST;
  wire [  5:0]  AXI_14_ARID;
  wire [  7:0]  AXI_14_ARLEN;
  wire [  2:0]  AXI_14_ARSIZE;
  wire          AXI_14_ARVALID;
  wire [ 32:0]  AXI_14_AWADDR;
  wire [  1:0]  AXI_14_AWBURST;
  wire [  5:0]  AXI_14_AWID;
  wire [  7:0]  AXI_14_AWLEN;
  wire [  2:0]  AXI_14_AWSIZE;
  wire          AXI_14_AWVALID;
  wire          AXI_14_RREADY;
  wire          AXI_14_BREADY;
  wire [255:0]  AXI_14_WDATA;
  wire          AXI_14_WLAST;
  wire [ 31:0]  AXI_14_WSTRB;
  wire [ 31:0]  AXI_14_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_14_WDATA_PARITY;
  wire          AXI_14_WVALID;
  wire [3:0]    AXI_14_ARCACHE;
  wire [3:0]    AXI_14_AWCACHE;
  wire [2:0]    AXI_14_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_14;
`endif
  wire      [31:0]  prbs_mode_seed_14 = 32'habcd_1234;

  wire [APP_ADDR_WIDTH-1:0] o_m_axi_awaddr_15;
  wire [APP_ADDR_WIDTH-1:0] o_m_axi_araddr_15;
  wire [ 32:0]  AXI_15_ARADDR;
  wire [  1:0]  AXI_15_ARBURST;
  wire [  5:0]  AXI_15_ARID;
  wire [  7:0]  AXI_15_ARLEN;
  wire [  2:0]  AXI_15_ARSIZE;
  wire          AXI_15_ARVALID;
  wire [ 32:0]  AXI_15_AWADDR;
  wire [  1:0]  AXI_15_AWBURST;
  wire [  5:0]  AXI_15_AWID;
  wire [  7:0]  AXI_15_AWLEN;
  wire [  2:0]  AXI_15_AWSIZE;
  wire          AXI_15_AWVALID;
  wire          AXI_15_RREADY;
  wire          AXI_15_BREADY;
  wire [255:0]  AXI_15_WDATA;
  wire          AXI_15_WLAST;
  wire [ 31:0]  AXI_15_WSTRB;
  wire [ 31:0]  AXI_15_WDATA_PARITY_i;
  reg  [ 31:0]  AXI_15_WDATA_PARITY;
  wire          AXI_15_WVALID;
  wire [3:0]    AXI_15_ARCACHE;
  wire [3:0]    AXI_15_AWCACHE;
  wire [2:0]    AXI_15_AWPROT;
`ifndef SIMULATION_MODE
  wire              boot_mode_done_15;
`endif
  wire      [31:0]  prbs_mode_seed_15 = 32'habcd_1234;


  wire          AXI_00_ARREADY;
  wire          AXI_00_AWREADY;
  wire [ 31:0]  AXI_00_RDATA_PARITY;
  wire [255:0]  AXI_00_RDATA;
  wire [  5:0]  AXI_00_RID;
  wire          AXI_00_RLAST;
  wire [  1:0]  AXI_00_RRESP;
  wire          AXI_00_RVALID;
  wire          AXI_00_WREADY;
  wire [  5:0]  AXI_00_BID;
  wire [  1:0]  AXI_00_BRESP;
  wire          AXI_00_BVALID;
  wire          AXI_01_ARREADY;
  wire          AXI_01_AWREADY;
  wire [ 31:0]  AXI_01_RDATA_PARITY;
  wire [255:0]  AXI_01_RDATA;
  wire [  5:0]  AXI_01_RID;
  wire          AXI_01_RLAST;
  wire [  1:0]  AXI_01_RRESP;
  wire          AXI_01_RVALID;
  wire          AXI_01_WREADY;
  wire [  5:0]  AXI_01_BID;
  wire [  1:0]  AXI_01_BRESP;
  wire          AXI_01_BVALID;
  wire          AXI_02_ARREADY;
  wire          AXI_02_AWREADY;
  wire [ 31:0]  AXI_02_RDATA_PARITY;
  wire [255:0]  AXI_02_RDATA;
  wire [  5:0]  AXI_02_RID;
  wire          AXI_02_RLAST;
  wire [  1:0]  AXI_02_RRESP;
  wire          AXI_02_RVALID;
  wire          AXI_02_WREADY;
  wire [  5:0]  AXI_02_BID;
  wire [  1:0]  AXI_02_BRESP;
  wire          AXI_02_BVALID;
  wire          AXI_03_ARREADY;
  wire          AXI_03_AWREADY;
  wire [ 31:0]  AXI_03_RDATA_PARITY;
  wire [255:0]  AXI_03_RDATA;
  wire [  5:0]  AXI_03_RID;
  wire          AXI_03_RLAST;
  wire [  1:0]  AXI_03_RRESP;
  wire          AXI_03_RVALID;
  wire          AXI_03_WREADY;
  wire [  5:0]  AXI_03_BID;
  wire [  1:0]  AXI_03_BRESP;
  wire          AXI_03_BVALID;
  wire          AXI_04_ARREADY;
  wire          AXI_04_AWREADY;
  wire [ 31:0]  AXI_04_RDATA_PARITY;
  wire [255:0]  AXI_04_RDATA;
  wire [  5:0]  AXI_04_RID;
  wire          AXI_04_RLAST;
  wire [  1:0]  AXI_04_RRESP;
  wire          AXI_04_RVALID;
  wire          AXI_04_WREADY;
  wire [  5:0]  AXI_04_BID;
  wire [  1:0]  AXI_04_BRESP;
  wire          AXI_04_BVALID;
  wire          AXI_05_ARREADY;
  wire          AXI_05_AWREADY;
  wire [ 31:0]  AXI_05_RDATA_PARITY;
  wire [255:0]  AXI_05_RDATA;
  wire [  5:0]  AXI_05_RID;
  wire          AXI_05_RLAST;
  wire [  1:0]  AXI_05_RRESP;
  wire          AXI_05_RVALID;
  wire          AXI_05_WREADY;
  wire [  5:0]  AXI_05_BID;
  wire [  1:0]  AXI_05_BRESP;
  wire          AXI_05_BVALID;
  wire          AXI_06_ARREADY;
  wire          AXI_06_AWREADY;
  wire [ 31:0]  AXI_06_RDATA_PARITY;
  wire [255:0]  AXI_06_RDATA;
  wire [  5:0]  AXI_06_RID;
  wire          AXI_06_RLAST;
  wire [  1:0]  AXI_06_RRESP;
  wire          AXI_06_RVALID;
  wire          AXI_06_WREADY;
  wire [  5:0]  AXI_06_BID;
  wire [  1:0]  AXI_06_BRESP;
  wire          AXI_06_BVALID;
  wire          AXI_07_ARREADY;
  wire          AXI_07_AWREADY;
  wire [ 31:0]  AXI_07_RDATA_PARITY;
  wire [255:0]  AXI_07_RDATA;
  wire [  5:0]  AXI_07_RID;
  wire          AXI_07_RLAST;
  wire [  1:0]  AXI_07_RRESP;
  wire          AXI_07_RVALID;
  wire          AXI_07_WREADY;
  wire [  5:0]  AXI_07_BID;
  wire [  1:0]  AXI_07_BRESP;
  wire          AXI_07_BVALID;
  wire          AXI_08_ARREADY;
  wire          AXI_08_AWREADY;
  wire [ 31:0]  AXI_08_RDATA_PARITY;
  wire [255:0]  AXI_08_RDATA;
  wire [  5:0]  AXI_08_RID;
  wire          AXI_08_RLAST;
  wire [  1:0]  AXI_08_RRESP;
  wire          AXI_08_RVALID;
  wire          AXI_08_WREADY;
  wire [  5:0]  AXI_08_BID;
  wire [  1:0]  AXI_08_BRESP;
  wire          AXI_08_BVALID;
  wire          AXI_09_ARREADY;
  wire          AXI_09_AWREADY;
  wire [ 31:0]  AXI_09_RDATA_PARITY;
  wire [255:0]  AXI_09_RDATA;
  wire [  5:0]  AXI_09_RID;
  wire          AXI_09_RLAST;
  wire [  1:0]  AXI_09_RRESP;
  wire          AXI_09_RVALID;
  wire          AXI_09_WREADY;
  wire [  5:0]  AXI_09_BID;
  wire [  1:0]  AXI_09_BRESP;
  wire          AXI_09_BVALID;
  wire          AXI_10_ARREADY;
  wire          AXI_10_AWREADY;
  wire [ 31:0]  AXI_10_RDATA_PARITY;
  wire [255:0]  AXI_10_RDATA;
  wire [  5:0]  AXI_10_RID;
  wire          AXI_10_RLAST;
  wire [  1:0]  AXI_10_RRESP;
  wire          AXI_10_RVALID;
  wire          AXI_10_WREADY;
  wire [  5:0]  AXI_10_BID;
  wire [  1:0]  AXI_10_BRESP;
  wire          AXI_10_BVALID;
  wire          AXI_11_ARREADY;
  wire          AXI_11_AWREADY;
  wire [ 31:0]  AXI_11_RDATA_PARITY;
  wire [255:0]  AXI_11_RDATA;
  wire [  5:0]  AXI_11_RID;
  wire          AXI_11_RLAST;
  wire [  1:0]  AXI_11_RRESP;
  wire          AXI_11_RVALID;
  wire          AXI_11_WREADY;
  wire [  5:0]  AXI_11_BID;
  wire [  1:0]  AXI_11_BRESP;
  wire          AXI_11_BVALID;
  wire          AXI_12_ARREADY;
  wire          AXI_12_AWREADY;
  wire [ 31:0]  AXI_12_RDATA_PARITY;
  wire [255:0]  AXI_12_RDATA;
  wire [  5:0]  AXI_12_RID;
  wire          AXI_12_RLAST;
  wire [  1:0]  AXI_12_RRESP;
  wire          AXI_12_RVALID;
  wire          AXI_12_WREADY;
  wire [  5:0]  AXI_12_BID;
  wire [  1:0]  AXI_12_BRESP;
  wire          AXI_12_BVALID;
  wire          AXI_13_ARREADY;
  wire          AXI_13_AWREADY;
  wire [ 31:0]  AXI_13_RDATA_PARITY;
  wire [255:0]  AXI_13_RDATA;
  wire [  5:0]  AXI_13_RID;
  wire          AXI_13_RLAST;
  wire [  1:0]  AXI_13_RRESP;
  wire          AXI_13_RVALID;
  wire          AXI_13_WREADY;
  wire [  5:0]  AXI_13_BID;
  wire [  1:0]  AXI_13_BRESP;
  wire          AXI_13_BVALID;
  wire          AXI_14_ARREADY;
  wire          AXI_14_AWREADY;
  wire [ 31:0]  AXI_14_RDATA_PARITY;
  wire [255:0]  AXI_14_RDATA;
  wire [  5:0]  AXI_14_RID;
  wire          AXI_14_RLAST;
  wire [  1:0]  AXI_14_RRESP;
  wire          AXI_14_RVALID;
  wire          AXI_14_WREADY;
  wire [  5:0]  AXI_14_BID;
  wire [  1:0]  AXI_14_BRESP;
  wire          AXI_14_BVALID;
  wire          AXI_15_ARREADY;
  wire          AXI_15_AWREADY;
  wire [ 31:0]  AXI_15_RDATA_PARITY;
  wire [255:0]  AXI_15_RDATA;
  wire [  5:0]  AXI_15_RID;
  wire          AXI_15_RLAST;
  wire [  1:0]  AXI_15_RRESP;
  wire          AXI_15_RVALID;
  wire          AXI_15_WREADY;
  wire [  5:0]  AXI_15_BID;
  wire [  1:0]  AXI_15_BRESP;
  wire          AXI_15_BVALID;

  wire          DRAM_0_STAT_CATTRIP;
  wire [  6:0]  DRAM_0_STAT_TEMP;


`ifndef SIMULATION_MODE
  wire          axi_00_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_01_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_02_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_03_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_04_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_05_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_06_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_07_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_08_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_09_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_10_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_11_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_12_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_13_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_14_data_msmatch_err;
`endif
`ifndef SIMULATION_MODE
  wire          axi_15_data_msmatch_err;
`endif
  wire          axi_16_data_msmatch_err = 1'b0;
  wire          axi_17_data_msmatch_err = 1'b0;
  wire          axi_18_data_msmatch_err = 1'b0;
  wire          axi_19_data_msmatch_err = 1'b0;
  wire          axi_20_data_msmatch_err = 1'b0;
  wire          axi_21_data_msmatch_err = 1'b0;
  wire          axi_22_data_msmatch_err = 1'b0;
  wire          axi_23_data_msmatch_err = 1'b0;
  wire          axi_24_data_msmatch_err = 1'b0;
  wire          axi_25_data_msmatch_err = 1'b0;
  wire          axi_26_data_msmatch_err = 1'b0;
  wire          axi_27_data_msmatch_err = 1'b0;
  wire          axi_28_data_msmatch_err = 1'b0;
  wire          axi_29_data_msmatch_err = 1'b0;
  wire          axi_30_data_msmatch_err = 1'b0;
  wire          axi_31_data_msmatch_err = 1'b0;
  wire                        vio_tg_rst_0;
  wire                        vio_tg_start_0;
  wire                        vio_tg_err_chk_en_0;
  wire                        vio_tg_err_clear_0;
  wire [3:0]                  vio_tg_instr_addr_mode_0;
  wire [3:0]                  vio_tg_instr_data_mode_0;
  wire [3:0]                  vio_tg_instr_rw_mode_0;
  wire [1:0]                  vio_tg_instr_rw_submode_0;
  wire [31:0]                 vio_tg_instr_num_of_iter_0;
  wire [5:0]                  vio_tg_instr_nxt_instr_0;
  wire                        vio_tg_restart_0;
  wire                        vio_tg_pause_0;
  wire                        vio_tg_err_clear_all_0;
  wire                        vio_tg_err_continue_0;
  wire                        vio_tg_instr_program_en_0;
  wire                        vio_tg_direct_instr_en_0;
  wire [4:0]                  vio_tg_instr_num_0;
  wire [2:0]                  vio_tg_instr_victim_mode_0;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_0;
  wire [2:0]                  vio_tg_instr_victim_select_0;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_0;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_0;
  wire                        vio_tg_seed_program_en_0;
  wire [7:0]                  vio_tg_seed_num_0;
  wire [22:0]                 vio_tg_seed_0;
  wire [7:0]                  vio_tg_glb_victim_bit_0;
  wire [32:0]                 vio_tg_glb_start_addr_0;
  wire [3:0]                  vio_tg_status_state_0;
  wire                        vio_tg_status_err_bit_valid_0;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_0;
  wire [31:0]                 vio_tg_status_err_cnt_0;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_0;
  wire                        vio_tg_status_exp_bit_valid_0;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_0;
  wire                        vio_tg_status_read_bit_valid_0;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_0;
  wire                        vio_tg_status_first_err_bit_valid_0;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_0;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_0;
  wire                        vio_tg_status_first_exp_bit_valid_0;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_0;
  wire                        vio_tg_status_first_read_bit_valid_0;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_0;
  wire                        vio_tg_status_err_bit_sticky_valid_0;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_0;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_0;
  wire                        vio_tg_status_err_type_valid_0;
  wire                        vio_tg_status_err_type_0;
  wire                        vio_tg_status_wr_done_0;
  wire                        vio_tg_status_watch_dog_hang_0;
  wire                        tg_ila_debug_0;
  reg  [4:0]                  wr_cnt_00;
  reg  [4:0]                  rd_cnt_00;

  wire                        vio_tg_rst_1;
  wire                        vio_tg_start_1;
  wire                        vio_tg_err_chk_en_1;
  wire                        vio_tg_err_clear_1;
  wire [3:0]                  vio_tg_instr_addr_mode_1;
  wire [3:0]                  vio_tg_instr_data_mode_1;
  wire [3:0]                  vio_tg_instr_rw_mode_1;
  wire [1:0]                  vio_tg_instr_rw_submode_1;
  wire [31:0]                 vio_tg_instr_num_of_iter_1;
  wire [5:0]                  vio_tg_instr_nxt_instr_1;
  wire                        vio_tg_restart_1;
  wire                        vio_tg_pause_1;
  wire                        vio_tg_err_clear_all_1;
  wire                        vio_tg_err_continue_1;
  wire                        vio_tg_instr_program_en_1;
  wire                        vio_tg_direct_instr_en_1;
  wire [4:0]                  vio_tg_instr_num_1;
  wire [2:0]                  vio_tg_instr_victim_mode_1;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_1;
  wire [2:0]                  vio_tg_instr_victim_select_1;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_1;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_1;
  wire                        vio_tg_seed_program_en_1;
  wire [7:0]                  vio_tg_seed_num_1;
  wire [22:0]                 vio_tg_seed_1;
  wire [7:0]                  vio_tg_glb_victim_bit_1;
  wire [32:0]                 vio_tg_glb_start_addr_1;
  wire [3:0]                  vio_tg_status_state_1;
  wire                        vio_tg_status_err_bit_valid_1;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_1;
  wire [31:0]                 vio_tg_status_err_cnt_1;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_1;
  wire                        vio_tg_status_exp_bit_valid_1;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_1;
  wire                        vio_tg_status_read_bit_valid_1;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_1;
  wire                        vio_tg_status_first_err_bit_valid_1;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_1;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_1;
  wire                        vio_tg_status_first_exp_bit_valid_1;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_1;
  wire                        vio_tg_status_first_read_bit_valid_1;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_1;
  wire                        vio_tg_status_err_bit_sticky_valid_1;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_1;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_1;
  wire                        vio_tg_status_err_type_valid_1;
  wire                        vio_tg_status_err_type_1;
  wire                        vio_tg_status_wr_done_1;
  wire                        vio_tg_status_watch_dog_hang_1;
  wire                        tg_ila_debug_1;
  reg  [4:0]                  wr_cnt_01;
  reg  [4:0]                  rd_cnt_01;

  wire                        vio_tg_rst_2;
  wire                        vio_tg_start_2;
  wire                        vio_tg_err_chk_en_2;
  wire                        vio_tg_err_clear_2;
  wire [3:0]                  vio_tg_instr_addr_mode_2;
  wire [3:0]                  vio_tg_instr_data_mode_2;
  wire [3:0]                  vio_tg_instr_rw_mode_2;
  wire [1:0]                  vio_tg_instr_rw_submode_2;
  wire [31:0]                 vio_tg_instr_num_of_iter_2;
  wire [5:0]                  vio_tg_instr_nxt_instr_2;
  wire                        vio_tg_restart_2;
  wire                        vio_tg_pause_2;
  wire                        vio_tg_err_clear_all_2;
  wire                        vio_tg_err_continue_2;
  wire                        vio_tg_instr_program_en_2;
  wire                        vio_tg_direct_instr_en_2;
  wire [4:0]                  vio_tg_instr_num_2;
  wire [2:0]                  vio_tg_instr_victim_mode_2;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_2;
  wire [2:0]                  vio_tg_instr_victim_select_2;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_2;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_2;
  wire                        vio_tg_seed_program_en_2;
  wire [7:0]                  vio_tg_seed_num_2;
  wire [22:0]                 vio_tg_seed_2;
  wire [7:0]                  vio_tg_glb_victim_bit_2;
  wire [32:0]                 vio_tg_glb_start_addr_2;
  wire [3:0]                  vio_tg_status_state_2;
  wire                        vio_tg_status_err_bit_valid_2;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_2;
  wire [31:0]                 vio_tg_status_err_cnt_2;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_2;
  wire                        vio_tg_status_exp_bit_valid_2;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_2;
  wire                        vio_tg_status_read_bit_valid_2;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_2;
  wire                        vio_tg_status_first_err_bit_valid_2;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_2;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_2;
  wire                        vio_tg_status_first_exp_bit_valid_2;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_2;
  wire                        vio_tg_status_first_read_bit_valid_2;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_2;
  wire                        vio_tg_status_err_bit_sticky_valid_2;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_2;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_2;
  wire                        vio_tg_status_err_type_valid_2;
  wire                        vio_tg_status_err_type_2;
  wire                        vio_tg_status_wr_done_2;
  wire                        vio_tg_status_watch_dog_hang_2;
  wire                        tg_ila_debug_2;
  reg  [4:0]                  wr_cnt_02;
  reg  [4:0]                  rd_cnt_02;

  wire                        vio_tg_rst_3;
  wire                        vio_tg_start_3;
  wire                        vio_tg_err_chk_en_3;
  wire                        vio_tg_err_clear_3;
  wire [3:0]                  vio_tg_instr_addr_mode_3;
  wire [3:0]                  vio_tg_instr_data_mode_3;
  wire [3:0]                  vio_tg_instr_rw_mode_3;
  wire [1:0]                  vio_tg_instr_rw_submode_3;
  wire [31:0]                 vio_tg_instr_num_of_iter_3;
  wire [5:0]                  vio_tg_instr_nxt_instr_3;
  wire                        vio_tg_restart_3;
  wire                        vio_tg_pause_3;
  wire                        vio_tg_err_clear_all_3;
  wire                        vio_tg_err_continue_3;
  wire                        vio_tg_instr_program_en_3;
  wire                        vio_tg_direct_instr_en_3;
  wire [4:0]                  vio_tg_instr_num_3;
  wire [2:0]                  vio_tg_instr_victim_mode_3;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_3;
  wire [2:0]                  vio_tg_instr_victim_select_3;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_3;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_3;
  wire                        vio_tg_seed_program_en_3;
  wire [7:0]                  vio_tg_seed_num_3;
  wire [22:0]                 vio_tg_seed_3;
  wire [7:0]                  vio_tg_glb_victim_bit_3;
  wire [32:0]                 vio_tg_glb_start_addr_3;
  wire [3:0]                  vio_tg_status_state_3;
  wire                        vio_tg_status_err_bit_valid_3;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_3;
  wire [31:0]                 vio_tg_status_err_cnt_3;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_3;
  wire                        vio_tg_status_exp_bit_valid_3;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_3;
  wire                        vio_tg_status_read_bit_valid_3;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_3;
  wire                        vio_tg_status_first_err_bit_valid_3;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_3;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_3;
  wire                        vio_tg_status_first_exp_bit_valid_3;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_3;
  wire                        vio_tg_status_first_read_bit_valid_3;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_3;
  wire                        vio_tg_status_err_bit_sticky_valid_3;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_3;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_3;
  wire                        vio_tg_status_err_type_valid_3;
  wire                        vio_tg_status_err_type_3;
  wire                        vio_tg_status_wr_done_3;
  wire                        vio_tg_status_watch_dog_hang_3;
  wire                        tg_ila_debug_3;
  reg  [4:0]                  wr_cnt_03;
  reg  [4:0]                  rd_cnt_03;

  wire                        vio_tg_rst_4;
  wire                        vio_tg_start_4;
  wire                        vio_tg_err_chk_en_4;
  wire                        vio_tg_err_clear_4;
  wire [3:0]                  vio_tg_instr_addr_mode_4;
  wire [3:0]                  vio_tg_instr_data_mode_4;
  wire [3:0]                  vio_tg_instr_rw_mode_4;
  wire [1:0]                  vio_tg_instr_rw_submode_4;
  wire [31:0]                 vio_tg_instr_num_of_iter_4;
  wire [5:0]                  vio_tg_instr_nxt_instr_4;
  wire                        vio_tg_restart_4;
  wire                        vio_tg_pause_4;
  wire                        vio_tg_err_clear_all_4;
  wire                        vio_tg_err_continue_4;
  wire                        vio_tg_instr_program_en_4;
  wire                        vio_tg_direct_instr_en_4;
  wire [4:0]                  vio_tg_instr_num_4;
  wire [2:0]                  vio_tg_instr_victim_mode_4;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_4;
  wire [2:0]                  vio_tg_instr_victim_select_4;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_4;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_4;
  wire                        vio_tg_seed_program_en_4;
  wire [7:0]                  vio_tg_seed_num_4;
  wire [22:0]                 vio_tg_seed_4;
  wire [7:0]                  vio_tg_glb_victim_bit_4;
  wire [32:0]                 vio_tg_glb_start_addr_4;
  wire [3:0]                  vio_tg_status_state_4;
  wire                        vio_tg_status_err_bit_valid_4;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_4;
  wire [31:0]                 vio_tg_status_err_cnt_4;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_4;
  wire                        vio_tg_status_exp_bit_valid_4;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_4;
  wire                        vio_tg_status_read_bit_valid_4;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_4;
  wire                        vio_tg_status_first_err_bit_valid_4;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_4;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_4;
  wire                        vio_tg_status_first_exp_bit_valid_4;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_4;
  wire                        vio_tg_status_first_read_bit_valid_4;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_4;
  wire                        vio_tg_status_err_bit_sticky_valid_4;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_4;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_4;
  wire                        vio_tg_status_err_type_valid_4;
  wire                        vio_tg_status_err_type_4;
  wire                        vio_tg_status_wr_done_4;
  wire                        vio_tg_status_watch_dog_hang_4;
  wire                        tg_ila_debug_4;
  reg  [4:0]                  wr_cnt_04;
  reg  [4:0]                  rd_cnt_04;

  wire                        vio_tg_rst_5;
  wire                        vio_tg_start_5;
  wire                        vio_tg_err_chk_en_5;
  wire                        vio_tg_err_clear_5;
  wire [3:0]                  vio_tg_instr_addr_mode_5;
  wire [3:0]                  vio_tg_instr_data_mode_5;
  wire [3:0]                  vio_tg_instr_rw_mode_5;
  wire [1:0]                  vio_tg_instr_rw_submode_5;
  wire [31:0]                 vio_tg_instr_num_of_iter_5;
  wire [5:0]                  vio_tg_instr_nxt_instr_5;
  wire                        vio_tg_restart_5;
  wire                        vio_tg_pause_5;
  wire                        vio_tg_err_clear_all_5;
  wire                        vio_tg_err_continue_5;
  wire                        vio_tg_instr_program_en_5;
  wire                        vio_tg_direct_instr_en_5;
  wire [4:0]                  vio_tg_instr_num_5;
  wire [2:0]                  vio_tg_instr_victim_mode_5;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_5;
  wire [2:0]                  vio_tg_instr_victim_select_5;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_5;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_5;
  wire                        vio_tg_seed_program_en_5;
  wire [7:0]                  vio_tg_seed_num_5;
  wire [22:0]                 vio_tg_seed_5;
  wire [7:0]                  vio_tg_glb_victim_bit_5;
  wire [32:0]                 vio_tg_glb_start_addr_5;
  wire [3:0]                  vio_tg_status_state_5;
  wire                        vio_tg_status_err_bit_valid_5;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_5;
  wire [31:0]                 vio_tg_status_err_cnt_5;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_5;
  wire                        vio_tg_status_exp_bit_valid_5;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_5;
  wire                        vio_tg_status_read_bit_valid_5;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_5;
  wire                        vio_tg_status_first_err_bit_valid_5;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_5;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_5;
  wire                        vio_tg_status_first_exp_bit_valid_5;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_5;
  wire                        vio_tg_status_first_read_bit_valid_5;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_5;
  wire                        vio_tg_status_err_bit_sticky_valid_5;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_5;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_5;
  wire                        vio_tg_status_err_type_valid_5;
  wire                        vio_tg_status_err_type_5;
  wire                        vio_tg_status_wr_done_5;
  wire                        vio_tg_status_watch_dog_hang_5;
  wire                        tg_ila_debug_5;
  reg  [4:0]                  wr_cnt_05;
  reg  [4:0]                  rd_cnt_05;

  wire                        vio_tg_rst_6;
  wire                        vio_tg_start_6;
  wire                        vio_tg_err_chk_en_6;
  wire                        vio_tg_err_clear_6;
  wire [3:0]                  vio_tg_instr_addr_mode_6;
  wire [3:0]                  vio_tg_instr_data_mode_6;
  wire [3:0]                  vio_tg_instr_rw_mode_6;
  wire [1:0]                  vio_tg_instr_rw_submode_6;
  wire [31:0]                 vio_tg_instr_num_of_iter_6;
  wire [5:0]                  vio_tg_instr_nxt_instr_6;
  wire                        vio_tg_restart_6;
  wire                        vio_tg_pause_6;
  wire                        vio_tg_err_clear_all_6;
  wire                        vio_tg_err_continue_6;
  wire                        vio_tg_instr_program_en_6;
  wire                        vio_tg_direct_instr_en_6;
  wire [4:0]                  vio_tg_instr_num_6;
  wire [2:0]                  vio_tg_instr_victim_mode_6;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_6;
  wire [2:0]                  vio_tg_instr_victim_select_6;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_6;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_6;
  wire                        vio_tg_seed_program_en_6;
  wire [7:0]                  vio_tg_seed_num_6;
  wire [22:0]                 vio_tg_seed_6;
  wire [7:0]                  vio_tg_glb_victim_bit_6;
  wire [32:0]                 vio_tg_glb_start_addr_6;
  wire [3:0]                  vio_tg_status_state_6;
  wire                        vio_tg_status_err_bit_valid_6;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_6;
  wire [31:0]                 vio_tg_status_err_cnt_6;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_6;
  wire                        vio_tg_status_exp_bit_valid_6;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_6;
  wire                        vio_tg_status_read_bit_valid_6;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_6;
  wire                        vio_tg_status_first_err_bit_valid_6;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_6;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_6;
  wire                        vio_tg_status_first_exp_bit_valid_6;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_6;
  wire                        vio_tg_status_first_read_bit_valid_6;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_6;
  wire                        vio_tg_status_err_bit_sticky_valid_6;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_6;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_6;
  wire                        vio_tg_status_err_type_valid_6;
  wire                        vio_tg_status_err_type_6;
  wire                        vio_tg_status_wr_done_6;
  wire                        vio_tg_status_watch_dog_hang_6;
  wire                        tg_ila_debug_6;
  reg  [4:0]                  wr_cnt_06;
  reg  [4:0]                  rd_cnt_06;

  wire                        vio_tg_rst_7;
  wire                        vio_tg_start_7;
  wire                        vio_tg_err_chk_en_7;
  wire                        vio_tg_err_clear_7;
  wire [3:0]                  vio_tg_instr_addr_mode_7;
  wire [3:0]                  vio_tg_instr_data_mode_7;
  wire [3:0]                  vio_tg_instr_rw_mode_7;
  wire [1:0]                  vio_tg_instr_rw_submode_7;
  wire [31:0]                 vio_tg_instr_num_of_iter_7;
  wire [5:0]                  vio_tg_instr_nxt_instr_7;
  wire                        vio_tg_restart_7;
  wire                        vio_tg_pause_7;
  wire                        vio_tg_err_clear_all_7;
  wire                        vio_tg_err_continue_7;
  wire                        vio_tg_instr_program_en_7;
  wire                        vio_tg_direct_instr_en_7;
  wire [4:0]                  vio_tg_instr_num_7;
  wire [2:0]                  vio_tg_instr_victim_mode_7;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_7;
  wire [2:0]                  vio_tg_instr_victim_select_7;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_7;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_7;
  wire                        vio_tg_seed_program_en_7;
  wire [7:0]                  vio_tg_seed_num_7;
  wire [22:0]                 vio_tg_seed_7;
  wire [7:0]                  vio_tg_glb_victim_bit_7;
  wire [32:0]                 vio_tg_glb_start_addr_7;
  wire [3:0]                  vio_tg_status_state_7;
  wire                        vio_tg_status_err_bit_valid_7;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_7;
  wire [31:0]                 vio_tg_status_err_cnt_7;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_7;
  wire                        vio_tg_status_exp_bit_valid_7;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_7;
  wire                        vio_tg_status_read_bit_valid_7;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_7;
  wire                        vio_tg_status_first_err_bit_valid_7;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_7;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_7;
  wire                        vio_tg_status_first_exp_bit_valid_7;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_7;
  wire                        vio_tg_status_first_read_bit_valid_7;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_7;
  wire                        vio_tg_status_err_bit_sticky_valid_7;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_7;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_7;
  wire                        vio_tg_status_err_type_valid_7;
  wire                        vio_tg_status_err_type_7;
  wire                        vio_tg_status_wr_done_7;
  wire                        vio_tg_status_watch_dog_hang_7;
  wire                        tg_ila_debug_7;
  reg  [4:0]                  wr_cnt_07;
  reg  [4:0]                  rd_cnt_07;

  wire                        vio_tg_rst_8;
  wire                        vio_tg_start_8;
  wire                        vio_tg_err_chk_en_8;
  wire                        vio_tg_err_clear_8;
  wire [3:0]                  vio_tg_instr_addr_mode_8;
  wire [3:0]                  vio_tg_instr_data_mode_8;
  wire [3:0]                  vio_tg_instr_rw_mode_8;
  wire [1:0]                  vio_tg_instr_rw_submode_8;
  wire [31:0]                 vio_tg_instr_num_of_iter_8;
  wire [5:0]                  vio_tg_instr_nxt_instr_8;
  wire                        vio_tg_restart_8;
  wire                        vio_tg_pause_8;
  wire                        vio_tg_err_clear_all_8;
  wire                        vio_tg_err_continue_8;
  wire                        vio_tg_instr_program_en_8;
  wire                        vio_tg_direct_instr_en_8;
  wire [4:0]                  vio_tg_instr_num_8;
  wire [2:0]                  vio_tg_instr_victim_mode_8;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_8;
  wire [2:0]                  vio_tg_instr_victim_select_8;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_8;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_8;
  wire                        vio_tg_seed_program_en_8;
  wire [7:0]                  vio_tg_seed_num_8;
  wire [22:0]                 vio_tg_seed_8;
  wire [7:0]                  vio_tg_glb_victim_bit_8;
  wire [32:0]                 vio_tg_glb_start_addr_8;
  wire [3:0]                  vio_tg_status_state_8;
  wire                        vio_tg_status_err_bit_valid_8;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_8;
  wire [31:0]                 vio_tg_status_err_cnt_8;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_8;
  wire                        vio_tg_status_exp_bit_valid_8;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_8;
  wire                        vio_tg_status_read_bit_valid_8;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_8;
  wire                        vio_tg_status_first_err_bit_valid_8;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_8;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_8;
  wire                        vio_tg_status_first_exp_bit_valid_8;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_8;
  wire                        vio_tg_status_first_read_bit_valid_8;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_8;
  wire                        vio_tg_status_err_bit_sticky_valid_8;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_8;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_8;
  wire                        vio_tg_status_err_type_valid_8;
  wire                        vio_tg_status_err_type_8;
  wire                        vio_tg_status_wr_done_8;
  wire                        vio_tg_status_watch_dog_hang_8;
  wire                        tg_ila_debug_8;
  reg  [4:0]                  wr_cnt_08;
  reg  [4:0]                  rd_cnt_08;

  wire                        vio_tg_rst_9;
  wire                        vio_tg_start_9;
  wire                        vio_tg_err_chk_en_9;
  wire                        vio_tg_err_clear_9;
  wire [3:0]                  vio_tg_instr_addr_mode_9;
  wire [3:0]                  vio_tg_instr_data_mode_9;
  wire [3:0]                  vio_tg_instr_rw_mode_9;
  wire [1:0]                  vio_tg_instr_rw_submode_9;
  wire [31:0]                 vio_tg_instr_num_of_iter_9;
  wire [5:0]                  vio_tg_instr_nxt_instr_9;
  wire                        vio_tg_restart_9;
  wire                        vio_tg_pause_9;
  wire                        vio_tg_err_clear_all_9;
  wire                        vio_tg_err_continue_9;
  wire                        vio_tg_instr_program_en_9;
  wire                        vio_tg_direct_instr_en_9;
  wire [4:0]                  vio_tg_instr_num_9;
  wire [2:0]                  vio_tg_instr_victim_mode_9;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_9;
  wire [2:0]                  vio_tg_instr_victim_select_9;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_9;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_9;
  wire                        vio_tg_seed_program_en_9;
  wire [7:0]                  vio_tg_seed_num_9;
  wire [22:0]                 vio_tg_seed_9;
  wire [7:0]                  vio_tg_glb_victim_bit_9;
  wire [32:0]                 vio_tg_glb_start_addr_9;
  wire [3:0]                  vio_tg_status_state_9;
  wire                        vio_tg_status_err_bit_valid_9;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_9;
  wire [31:0]                 vio_tg_status_err_cnt_9;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_9;
  wire                        vio_tg_status_exp_bit_valid_9;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_9;
  wire                        vio_tg_status_read_bit_valid_9;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_9;
  wire                        vio_tg_status_first_err_bit_valid_9;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_9;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_9;
  wire                        vio_tg_status_first_exp_bit_valid_9;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_9;
  wire                        vio_tg_status_first_read_bit_valid_9;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_9;
  wire                        vio_tg_status_err_bit_sticky_valid_9;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_9;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_9;
  wire                        vio_tg_status_err_type_valid_9;
  wire                        vio_tg_status_err_type_9;
  wire                        vio_tg_status_wr_done_9;
  wire                        vio_tg_status_watch_dog_hang_9;
  wire                        tg_ila_debug_9;
  reg  [4:0]                  wr_cnt_09;
  reg  [4:0]                  rd_cnt_09;

  wire                        vio_tg_rst_10;
  wire                        vio_tg_start_10;
  wire                        vio_tg_err_chk_en_10;
  wire                        vio_tg_err_clear_10;
  wire [3:0]                  vio_tg_instr_addr_mode_10;
  wire [3:0]                  vio_tg_instr_data_mode_10;
  wire [3:0]                  vio_tg_instr_rw_mode_10;
  wire [1:0]                  vio_tg_instr_rw_submode_10;
  wire [31:0]                 vio_tg_instr_num_of_iter_10;
  wire [5:0]                  vio_tg_instr_nxt_instr_10;
  wire                        vio_tg_restart_10;
  wire                        vio_tg_pause_10;
  wire                        vio_tg_err_clear_all_10;
  wire                        vio_tg_err_continue_10;
  wire                        vio_tg_instr_program_en_10;
  wire                        vio_tg_direct_instr_en_10;
  wire [4:0]                  vio_tg_instr_num_10;
  wire [2:0]                  vio_tg_instr_victim_mode_10;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_10;
  wire [2:0]                  vio_tg_instr_victim_select_10;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_10;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_10;
  wire                        vio_tg_seed_program_en_10;
  wire [7:0]                  vio_tg_seed_num_10;
  wire [22:0]                 vio_tg_seed_10;
  wire [7:0]                  vio_tg_glb_victim_bit_10;
  wire [32:0]                 vio_tg_glb_start_addr_10;
  wire [3:0]                  vio_tg_status_state_10;
  wire                        vio_tg_status_err_bit_valid_10;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_10;
  wire [31:0]                 vio_tg_status_err_cnt_10;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_10;
  wire                        vio_tg_status_exp_bit_valid_10;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_10;
  wire                        vio_tg_status_read_bit_valid_10;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_10;
  wire                        vio_tg_status_first_err_bit_valid_10;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_10;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_10;
  wire                        vio_tg_status_first_exp_bit_valid_10;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_10;
  wire                        vio_tg_status_first_read_bit_valid_10;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_10;
  wire                        vio_tg_status_err_bit_sticky_valid_10;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_10;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_10;
  wire                        vio_tg_status_err_type_valid_10;
  wire                        vio_tg_status_err_type_10;
  wire                        vio_tg_status_wr_done_10;
  wire                        vio_tg_status_watch_dog_hang_10;
  wire                        tg_ila_debug_10;
  reg  [4:0]                  wr_cnt_10;
  reg  [4:0]                  rd_cnt_10;

  wire                        vio_tg_rst_11;
  wire                        vio_tg_start_11;
  wire                        vio_tg_err_chk_en_11;
  wire                        vio_tg_err_clear_11;
  wire [3:0]                  vio_tg_instr_addr_mode_11;
  wire [3:0]                  vio_tg_instr_data_mode_11;
  wire [3:0]                  vio_tg_instr_rw_mode_11;
  wire [1:0]                  vio_tg_instr_rw_submode_11;
  wire [31:0]                 vio_tg_instr_num_of_iter_11;
  wire [5:0]                  vio_tg_instr_nxt_instr_11;
  wire                        vio_tg_restart_11;
  wire                        vio_tg_pause_11;
  wire                        vio_tg_err_clear_all_11;
  wire                        vio_tg_err_continue_11;
  wire                        vio_tg_instr_program_en_11;
  wire                        vio_tg_direct_instr_en_11;
  wire [4:0]                  vio_tg_instr_num_11;
  wire [2:0]                  vio_tg_instr_victim_mode_11;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_11;
  wire [2:0]                  vio_tg_instr_victim_select_11;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_11;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_11;
  wire                        vio_tg_seed_program_en_11;
  wire [7:0]                  vio_tg_seed_num_11;
  wire [22:0]                 vio_tg_seed_11;
  wire [7:0]                  vio_tg_glb_victim_bit_11;
  wire [32:0]                 vio_tg_glb_start_addr_11;
  wire [3:0]                  vio_tg_status_state_11;
  wire                        vio_tg_status_err_bit_valid_11;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_11;
  wire [31:0]                 vio_tg_status_err_cnt_11;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_11;
  wire                        vio_tg_status_exp_bit_valid_11;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_11;
  wire                        vio_tg_status_read_bit_valid_11;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_11;
  wire                        vio_tg_status_first_err_bit_valid_11;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_11;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_11;
  wire                        vio_tg_status_first_exp_bit_valid_11;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_11;
  wire                        vio_tg_status_first_read_bit_valid_11;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_11;
  wire                        vio_tg_status_err_bit_sticky_valid_11;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_11;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_11;
  wire                        vio_tg_status_err_type_valid_11;
  wire                        vio_tg_status_err_type_11;
  wire                        vio_tg_status_wr_done_11;
  wire                        vio_tg_status_watch_dog_hang_11;
  wire                        tg_ila_debug_11;
  reg  [4:0]                  wr_cnt_11;
  reg  [4:0]                  rd_cnt_11;

  wire                        vio_tg_rst_12;
  wire                        vio_tg_start_12;
  wire                        vio_tg_err_chk_en_12;
  wire                        vio_tg_err_clear_12;
  wire [3:0]                  vio_tg_instr_addr_mode_12;
  wire [3:0]                  vio_tg_instr_data_mode_12;
  wire [3:0]                  vio_tg_instr_rw_mode_12;
  wire [1:0]                  vio_tg_instr_rw_submode_12;
  wire [31:0]                 vio_tg_instr_num_of_iter_12;
  wire [5:0]                  vio_tg_instr_nxt_instr_12;
  wire                        vio_tg_restart_12;
  wire                        vio_tg_pause_12;
  wire                        vio_tg_err_clear_all_12;
  wire                        vio_tg_err_continue_12;
  wire                        vio_tg_instr_program_en_12;
  wire                        vio_tg_direct_instr_en_12;
  wire [4:0]                  vio_tg_instr_num_12;
  wire [2:0]                  vio_tg_instr_victim_mode_12;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_12;
  wire [2:0]                  vio_tg_instr_victim_select_12;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_12;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_12;
  wire                        vio_tg_seed_program_en_12;
  wire [7:0]                  vio_tg_seed_num_12;
  wire [22:0]                 vio_tg_seed_12;
  wire [7:0]                  vio_tg_glb_victim_bit_12;
  wire [32:0]                 vio_tg_glb_start_addr_12;
  wire [3:0]                  vio_tg_status_state_12;
  wire                        vio_tg_status_err_bit_valid_12;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_12;
  wire [31:0]                 vio_tg_status_err_cnt_12;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_12;
  wire                        vio_tg_status_exp_bit_valid_12;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_12;
  wire                        vio_tg_status_read_bit_valid_12;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_12;
  wire                        vio_tg_status_first_err_bit_valid_12;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_12;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_12;
  wire                        vio_tg_status_first_exp_bit_valid_12;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_12;
  wire                        vio_tg_status_first_read_bit_valid_12;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_12;
  wire                        vio_tg_status_err_bit_sticky_valid_12;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_12;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_12;
  wire                        vio_tg_status_err_type_valid_12;
  wire                        vio_tg_status_err_type_12;
  wire                        vio_tg_status_wr_done_12;
  wire                        vio_tg_status_watch_dog_hang_12;
  wire                        tg_ila_debug_12;
  reg  [4:0]                  wr_cnt_12;
  reg  [4:0]                  rd_cnt_12;

  wire                        vio_tg_rst_13;
  wire                        vio_tg_start_13;
  wire                        vio_tg_err_chk_en_13;
  wire                        vio_tg_err_clear_13;
  wire [3:0]                  vio_tg_instr_addr_mode_13;
  wire [3:0]                  vio_tg_instr_data_mode_13;
  wire [3:0]                  vio_tg_instr_rw_mode_13;
  wire [1:0]                  vio_tg_instr_rw_submode_13;
  wire [31:0]                 vio_tg_instr_num_of_iter_13;
  wire [5:0]                  vio_tg_instr_nxt_instr_13;
  wire                        vio_tg_restart_13;
  wire                        vio_tg_pause_13;
  wire                        vio_tg_err_clear_all_13;
  wire                        vio_tg_err_continue_13;
  wire                        vio_tg_instr_program_en_13;
  wire                        vio_tg_direct_instr_en_13;
  wire [4:0]                  vio_tg_instr_num_13;
  wire [2:0]                  vio_tg_instr_victim_mode_13;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_13;
  wire [2:0]                  vio_tg_instr_victim_select_13;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_13;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_13;
  wire                        vio_tg_seed_program_en_13;
  wire [7:0]                  vio_tg_seed_num_13;
  wire [22:0]                 vio_tg_seed_13;
  wire [7:0]                  vio_tg_glb_victim_bit_13;
  wire [32:0]                 vio_tg_glb_start_addr_13;
  wire [3:0]                  vio_tg_status_state_13;
  wire                        vio_tg_status_err_bit_valid_13;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_13;
  wire [31:0]                 vio_tg_status_err_cnt_13;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_13;
  wire                        vio_tg_status_exp_bit_valid_13;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_13;
  wire                        vio_tg_status_read_bit_valid_13;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_13;
  wire                        vio_tg_status_first_err_bit_valid_13;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_13;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_13;
  wire                        vio_tg_status_first_exp_bit_valid_13;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_13;
  wire                        vio_tg_status_first_read_bit_valid_13;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_13;
  wire                        vio_tg_status_err_bit_sticky_valid_13;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_13;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_13;
  wire                        vio_tg_status_err_type_valid_13;
  wire                        vio_tg_status_err_type_13;
  wire                        vio_tg_status_wr_done_13;
  wire                        vio_tg_status_watch_dog_hang_13;
  wire                        tg_ila_debug_13;
  reg  [4:0]                  wr_cnt_13;
  reg  [4:0]                  rd_cnt_13;

  wire                        vio_tg_rst_14;
  wire                        vio_tg_start_14;
  wire                        vio_tg_err_chk_en_14;
  wire                        vio_tg_err_clear_14;
  wire [3:0]                  vio_tg_instr_addr_mode_14;
  wire [3:0]                  vio_tg_instr_data_mode_14;
  wire [3:0]                  vio_tg_instr_rw_mode_14;
  wire [1:0]                  vio_tg_instr_rw_submode_14;
  wire [31:0]                 vio_tg_instr_num_of_iter_14;
  wire [5:0]                  vio_tg_instr_nxt_instr_14;
  wire                        vio_tg_restart_14;
  wire                        vio_tg_pause_14;
  wire                        vio_tg_err_clear_all_14;
  wire                        vio_tg_err_continue_14;
  wire                        vio_tg_instr_program_en_14;
  wire                        vio_tg_direct_instr_en_14;
  wire [4:0]                  vio_tg_instr_num_14;
  wire [2:0]                  vio_tg_instr_victim_mode_14;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_14;
  wire [2:0]                  vio_tg_instr_victim_select_14;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_14;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_14;
  wire                        vio_tg_seed_program_en_14;
  wire [7:0]                  vio_tg_seed_num_14;
  wire [22:0]                 vio_tg_seed_14;
  wire [7:0]                  vio_tg_glb_victim_bit_14;
  wire [32:0]                 vio_tg_glb_start_addr_14;
  wire [3:0]                  vio_tg_status_state_14;
  wire                        vio_tg_status_err_bit_valid_14;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_14;
  wire [31:0]                 vio_tg_status_err_cnt_14;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_14;
  wire                        vio_tg_status_exp_bit_valid_14;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_14;
  wire                        vio_tg_status_read_bit_valid_14;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_14;
  wire                        vio_tg_status_first_err_bit_valid_14;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_14;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_14;
  wire                        vio_tg_status_first_exp_bit_valid_14;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_14;
  wire                        vio_tg_status_first_read_bit_valid_14;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_14;
  wire                        vio_tg_status_err_bit_sticky_valid_14;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_14;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_14;
  wire                        vio_tg_status_err_type_valid_14;
  wire                        vio_tg_status_err_type_14;
  wire                        vio_tg_status_wr_done_14;
  wire                        vio_tg_status_watch_dog_hang_14;
  wire                        tg_ila_debug_14;
  reg  [4:0]                  wr_cnt_14;
  reg  [4:0]                  rd_cnt_14;

  wire                        vio_tg_rst_15;
  wire                        vio_tg_start_15;
  wire                        vio_tg_err_chk_en_15;
  wire                        vio_tg_err_clear_15;
  wire [3:0]                  vio_tg_instr_addr_mode_15;
  wire [3:0]                  vio_tg_instr_data_mode_15;
  wire [3:0]                  vio_tg_instr_rw_mode_15;
  wire [1:0]                  vio_tg_instr_rw_submode_15;
  wire [31:0]                 vio_tg_instr_num_of_iter_15;
  wire [5:0]                  vio_tg_instr_nxt_instr_15;
  wire                        vio_tg_restart_15;
  wire                        vio_tg_pause_15;
  wire                        vio_tg_err_clear_all_15;
  wire                        vio_tg_err_continue_15;
  wire                        vio_tg_instr_program_en_15;
  wire                        vio_tg_direct_instr_en_15;
  wire [4:0]                  vio_tg_instr_num_15;
  wire [2:0]                  vio_tg_instr_victim_mode_15;
  wire [4:0]                  vio_tg_instr_victim_aggr_delay_15;
  wire [2:0]                  vio_tg_instr_victim_select_15;
  wire [9:0]                  vio_tg_instr_m_nops_btw_n_burst_m_15;
  wire [31:0]                 vio_tg_instr_m_nops_btw_n_burst_n_15;
  wire                        vio_tg_seed_program_en_15;
  wire [7:0]                  vio_tg_seed_num_15;
  wire [22:0]                 vio_tg_seed_15;
  wire [7:0]                  vio_tg_glb_victim_bit_15;
  wire [32:0]                 vio_tg_glb_start_addr_15;
  wire [3:0]                  vio_tg_status_state_15;
  wire                        vio_tg_status_err_bit_valid_15;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_15;
  wire [31:0]                 vio_tg_status_err_cnt_15;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_err_addr_15;
  wire                        vio_tg_status_exp_bit_valid_15;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_exp_bit_15;
  wire                        vio_tg_status_read_bit_valid_15;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_read_bit_15;
  wire                        vio_tg_status_first_err_bit_valid_15;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_err_bit_15;
  wire [APP_ADDR_WIDTH-1:0]   vio_tg_status_first_err_addr_15;
  wire                        vio_tg_status_first_exp_bit_valid_15;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_exp_bit_15;
  wire                        vio_tg_status_first_read_bit_valid_15;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_first_read_bit_15;
  wire                        vio_tg_status_err_bit_sticky_valid_15;
  wire [APP_DATA_WIDTH_4D-1:0]   vio_tg_status_err_bit_sticky_15;
  wire [31:0]                 vio_tg_status_err_cnt_sticky_15;
  wire                        vio_tg_status_err_type_valid_15;
  wire                        vio_tg_status_err_type_15;
  wire                        vio_tg_status_wr_done_15;
  wire                        vio_tg_status_watch_dog_hang_15;
  wire                        tg_ila_debug_15;
  reg  [4:0]                  wr_cnt_15;
  reg  [4:0]                  rd_cnt_15;

















////////////////////////////////////////////////////////////////////////////////
// Reg declaration
////////////////////////////////////////////////////////////////////////////////
reg  [3:0]                                          cnt_rst_0;
reg           axi_rst_0_r1_n;
reg           axi_rst_0_mmcm_n;
(* keep = "TRUE" *) reg           axi_rst_st0_n;
(* ASYNC_REG = "TRUE" *) reg           axi_rst0_st0_r1_n, axi_rst0_st0_r2_n;
(* keep = "TRUE" *) reg           axi_rst0_st0_n;
(* ASYNC_REG = "TRUE" *) reg           axi_rst1_st0_r1_n, axi_rst1_st0_r2_n;
(* keep = "TRUE" *) reg           axi_rst1_st0_n;
(* ASYNC_REG = "TRUE" *) reg           axi_rst2_st0_r1_n, axi_rst2_st0_r2_n;
(* keep = "TRUE" *) reg           axi_rst2_st0_n;
(* ASYNC_REG = "TRUE" *) reg           axi_rst3_st0_r1_n, axi_rst3_st0_r2_n;
(* keep = "TRUE" *) reg           axi_rst3_st0_n;
(* ASYNC_REG = "TRUE" *) reg           axi_rst4_st0_r1_n, axi_rst4_st0_r2_n;
(* keep = "TRUE" *) reg           axi_rst4_st0_n;
(* ASYNC_REG = "TRUE" *) reg           axi_rst5_st0_r1_n, axi_rst5_st0_r2_n;
(* keep = "TRUE" *) reg           axi_rst5_st0_n;
(* ASYNC_REG = "TRUE" *) reg           axi_rst6_st0_r1_n, axi_rst6_st0_r2_n;
(* keep = "TRUE" *) reg           axi_rst6_st0_n;


////////////////////////////////////////////////////////////////////////////////
// Instantiating BUFG for AXI Clock
////////////////////////////////////////////////////////////////////////////////
(* keep = "TRUE" *) wire      APB_0_PCLK_IBUF;
(* keep = "TRUE" *) wire      APB_0_PCLK_BUF;

IBUF u_APB_0_PCLK_IBUF  (
  .I (APB_0_PCLK),
  .O (APB_0_PCLK_IBUF)
);

BUFG u_APB_0_PCLK_BUFG  (
  .I (APB_0_PCLK_IBUF),
  .O (APB_0_PCLK_BUF)
);

BUFG u_AXI_ACLK_IN_0  (
  .I (AXI_ACLK_IN_0),
  .O (AXI_ACLK_IN_0_buf)
);

////////////////////////////////////////////////////////////////////////////////
// Reset logic for AXI_0
////////////////////////////////////////////////////////////////////////////////
always @ (posedge AXI_ACLK_IN_0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    axi_rst_0_r1_n <= 1'b0;
  end else begin
    axi_rst_0_r1_n <= 1'b1;
  end
end

always @ (posedge AXI_ACLK_IN_0_buf) begin
  if (~axi_rst_0_r1_n) begin
    cnt_rst_0 <= 4'hA;
  end else if (cnt_rst_0 != 4'h0) begin
    cnt_rst_0 <= cnt_rst_0 - 1'b1;
  end else begin
    cnt_rst_0 <= cnt_rst_0;
  end
end

always @ (posedge AXI_ACLK_IN_0_buf) begin
  if (cnt_rst_0 != 4'h0) begin
    axi_rst_0_mmcm_n <= 1'b0;
  end else begin
    axi_rst_0_mmcm_n <= 1'b1;
  end
end

always @ (posedge AXI_ACLK_IN_0_buf) begin
  axi_rst_st0_n <= axi_rst_0_mmcm_n & MMCM_LOCK_0;
end

always @ (posedge AXI_ACLK0_st0_buf) begin
  axi_rst0_st0_r1_n <= axi_rst_st0_n;
  axi_rst0_st0_r2_n <= axi_rst0_st0_r1_n;
end

always @ (posedge AXI_ACLK0_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    axi_rst0_st0_n <= 1'b0;
  end else begin
    axi_rst0_st0_n <= axi_rst0_st0_r2_n;
  end
end

always @ (posedge AXI_ACLK1_st0_buf) begin
  axi_rst1_st0_r1_n <= axi_rst_st0_n;
  axi_rst1_st0_r2_n <= axi_rst1_st0_r1_n;
end

always @ (posedge AXI_ACLK1_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    axi_rst1_st0_n <= 1'b0;
  end else begin
    axi_rst1_st0_n <= axi_rst1_st0_r2_n;
  end
end

always @ (posedge AXI_ACLK2_st0_buf) begin
  axi_rst2_st0_r1_n <= axi_rst_st0_n;
  axi_rst2_st0_r2_n <= axi_rst2_st0_r1_n;
end

always @ (posedge AXI_ACLK2_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    axi_rst2_st0_n <= 1'b0;
  end else begin
    axi_rst2_st0_n <= axi_rst2_st0_r2_n;
  end
end

always @ (posedge AXI_ACLK3_st0_buf) begin
  axi_rst3_st0_r1_n <= axi_rst_st0_n;
  axi_rst3_st0_r2_n <= axi_rst3_st0_r1_n;
end

always @ (posedge AXI_ACLK3_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    axi_rst3_st0_n <= 1'b0;
  end else begin
    axi_rst3_st0_n <= axi_rst3_st0_r2_n;
  end
end

always @ (posedge AXI_ACLK4_st0_buf) begin
  axi_rst4_st0_r1_n <= axi_rst_st0_n;
  axi_rst4_st0_r2_n <= axi_rst4_st0_r1_n;
end

always @ (posedge AXI_ACLK4_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    axi_rst4_st0_n <= 1'b0;
  end else begin
    axi_rst4_st0_n <= axi_rst4_st0_r2_n;
  end
end

always @ (posedge AXI_ACLK5_st0_buf) begin
  axi_rst5_st0_r1_n <= axi_rst_st0_n;
  axi_rst5_st0_r2_n <= axi_rst5_st0_r1_n;
end

always @ (posedge AXI_ACLK5_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    axi_rst5_st0_n <= 1'b0;
  end else begin
    axi_rst5_st0_n <= axi_rst5_st0_r2_n;
  end
end

always @ (posedge AXI_ACLK6_st0_buf) begin
  axi_rst6_st0_r1_n <= axi_rst_st0_n;
  axi_rst6_st0_r2_n <= axi_rst6_st0_r1_n;
end

always @ (posedge AXI_ACLK6_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    axi_rst6_st0_n <= 1'b0;
  end else begin
    axi_rst6_st0_n <= axi_rst6_st0_r2_n;
  end
end

reg  [7:0]    cnt_rst_0_0;
reg           axi_rst_0_mmcm_n_0;

always @ (posedge AXI_ACLK_IN_0_buf) begin
  if (~axi_rst_0_r1_n) begin
	  if( cnt_rst_0_0 >= 8'd100 )
	  begin
      cnt_rst_0_0 <= cnt_rst_0_0;
      axi_rst_0_mmcm_n_0 <= 1'b0;
	  end
	  else
	  begin
      cnt_rst_0_0 <= cnt_rst_0_0 + 1;
      axi_rst_0_mmcm_n_0 <= axi_rst_0_mmcm_n_0;
	  end
  end else begin
    cnt_rst_0_0 <= 'd0;
    axi_rst_0_mmcm_n_0 <= 1'b1;
  end
end


////////////////////////////////////////////////////////////////////////////////
// Instantiating MMCM for AXI clock generation
////////////////////////////////////////////////////////////////////////////////
MMCME4_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("INTERNAL"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (MMCM_DIVCLK_DIVIDE),
    .CLKFBOUT_MULT_F      (MMCM_CLKFBOUT_MULT_F),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKOUT1_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT2_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT3_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT4_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT5_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT6_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
    .CLKIN1_PERIOD        (MMCM_CLKIN1_PERIOD),
    .REF_JITTER1          (0.010))
  u_mmcm_0
    // Output clocks
   (
    .CLKFBOUT            (),
    .CLKFBOUTB           (),
    .CLKOUT0             (AXI_ACLK0_st0),

    .CLKOUT0B            (),
    .CLKOUT1             (AXI_ACLK1_st0),
    .CLKOUT1B            (),
    .CLKOUT2             (AXI_ACLK2_st0),
    .CLKOUT2B            (),
    .CLKOUT3             (AXI_ACLK3_st0),
    .CLKOUT3B            (),
    .CLKOUT4             (AXI_ACLK4_st0),
    .CLKOUT5             (AXI_ACLK5_st0),
    .CLKOUT6             (AXI_ACLK6_st0),
     // Input clock control
    .CLKFBIN             (), //mmcm_fb
    .CLKIN1              (AXI_ACLK_IN_0_buf),
    .CLKIN2              (1'b0),
    // Other control and status signals
    .LOCKED              (MMCM_LOCK_0),
    .PWRDWN              (1'b0),
    .RST                 (~axi_rst_0_mmcm_n_0),

    .CDDCDONE            (),
    .CLKFBSTOPPED        (),
    .CLKINSTOPPED        (),
    .DO                  (),
    .DRDY                (),
    .PSDONE              (),
    .CDDCREQ             (1'b0),
    .CLKINSEL            (1'b1),
    .DADDR               (7'b0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'b0),
    .DWE                 (1'b0),
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0)
  );

BUFG u_AXI_ACLK0_st0  (
  .I (AXI_ACLK0_st0),
  .O (AXI_ACLK0_st0_buf)
);

BUFG u_AXI_ACLK1_st0  (
  .I (AXI_ACLK1_st0),
  .O (AXI_ACLK1_st0_buf)
);

BUFG u_AXI_ACLK2_st0  (
  .I (AXI_ACLK2_st0),
  .O (AXI_ACLK2_st0_buf)
);

BUFG u_AXI_ACLK3_st0  (
  .I (AXI_ACLK3_st0),
  .O (AXI_ACLK3_st0_buf)
);

BUFG u_AXI_ACLK4_st0  (
  .I (AXI_ACLK4_st0),
  .O (AXI_ACLK4_st0_buf)
);

BUFG u_AXI_ACLK5_st0  (
  .I (AXI_ACLK5_st0),
  .O (AXI_ACLK5_st0_buf)
);

BUFG u_AXI_ACLK6_st0  (
  .I (AXI_ACLK6_st0),
  .O (AXI_ACLK6_st0_buf)
);

BUFGCE_DIV #(
      .BUFGCE_DIVIDE(2),
      .SIM_DEVICE("ULTRASCALE_PLUS")
   )
    u_AXI_vio_CLK_st0  (
  .I (AXI_ACLK0_st0),
  .CE (1'b1),
  .CLR (1'b0),
  .O (i_clk_atg_axi_vio_st0)
);


////////////////////////////////////////////////////////////////////////////////
// Calculating Write Data Parity
////////////////////////////////////////////////////////////////////////////////
assign AXI_00_WDATA_PARITY_i = {{^(AXI_00_WDATA[255:248])},{^(AXI_00_WDATA[247:240])},{^(AXI_00_WDATA[239:232])},{^(AXI_00_WDATA[231:224])},
                              {^(AXI_00_WDATA[223:216])},{^(AXI_00_WDATA[215:208])},{^(AXI_00_WDATA[207:200])},{^(AXI_00_WDATA[199:192])},
                              {^(AXI_00_WDATA[191:184])},{^(AXI_00_WDATA[183:176])},{^(AXI_00_WDATA[175:168])},{^(AXI_00_WDATA[167:160])},
                              {^(AXI_00_WDATA[159:152])},{^(AXI_00_WDATA[151:144])},{^(AXI_00_WDATA[143:136])},{^(AXI_00_WDATA[135:128])},
                              {^(AXI_00_WDATA[127:120])},{^(AXI_00_WDATA[119:112])},{^(AXI_00_WDATA[111:104])},{^(AXI_00_WDATA[103:96])},
                              {^(AXI_00_WDATA[95:88])},  {^(AXI_00_WDATA[87:80])},  {^(AXI_00_WDATA[79:72])},  {^(AXI_00_WDATA[71:64])},
                              {^(AXI_00_WDATA[63:56])},  {^(AXI_00_WDATA[55:48])},  {^(AXI_00_WDATA[47:40])},  {^(AXI_00_WDATA[39:32])},
                              {^(AXI_00_WDATA[31:24])},  {^(AXI_00_WDATA[23:16])},  {^(AXI_00_WDATA[15:8])},   {^(AXI_00_WDATA[7:0])}};

always @(posedge AXI_ACLK0_st0_buf)
  AXI_00_WDATA_PARITY <= AXI_00_WDATA_PARITY_i;

assign AXI_01_WDATA_PARITY_i = {{^(AXI_01_WDATA[255:248])},{^(AXI_01_WDATA[247:240])},{^(AXI_01_WDATA[239:232])},{^(AXI_01_WDATA[231:224])},
                              {^(AXI_01_WDATA[223:216])},{^(AXI_01_WDATA[215:208])},{^(AXI_01_WDATA[207:200])},{^(AXI_01_WDATA[199:192])},
                              {^(AXI_01_WDATA[191:184])},{^(AXI_01_WDATA[183:176])},{^(AXI_01_WDATA[175:168])},{^(AXI_01_WDATA[167:160])},
                              {^(AXI_01_WDATA[159:152])},{^(AXI_01_WDATA[151:144])},{^(AXI_01_WDATA[143:136])},{^(AXI_01_WDATA[135:128])},
                              {^(AXI_01_WDATA[127:120])},{^(AXI_01_WDATA[119:112])},{^(AXI_01_WDATA[111:104])},{^(AXI_01_WDATA[103:96])},
                              {^(AXI_01_WDATA[95:88])},  {^(AXI_01_WDATA[87:80])},  {^(AXI_01_WDATA[79:72])},  {^(AXI_01_WDATA[71:64])},
                              {^(AXI_01_WDATA[63:56])},  {^(AXI_01_WDATA[55:48])},  {^(AXI_01_WDATA[47:40])},  {^(AXI_01_WDATA[39:32])},
                              {^(AXI_01_WDATA[31:24])},  {^(AXI_01_WDATA[23:16])},  {^(AXI_01_WDATA[15:8])},   {^(AXI_01_WDATA[7:0])}};

always @(posedge AXI_ACLK0_st0_buf)
  AXI_01_WDATA_PARITY <= AXI_01_WDATA_PARITY_i;
assign AXI_02_WDATA_PARITY_i = {{^(AXI_02_WDATA[255:248])},{^(AXI_02_WDATA[247:240])},{^(AXI_02_WDATA[239:232])},{^(AXI_02_WDATA[231:224])},
                              {^(AXI_02_WDATA[223:216])},{^(AXI_02_WDATA[215:208])},{^(AXI_02_WDATA[207:200])},{^(AXI_02_WDATA[199:192])},
                              {^(AXI_02_WDATA[191:184])},{^(AXI_02_WDATA[183:176])},{^(AXI_02_WDATA[175:168])},{^(AXI_02_WDATA[167:160])},
                              {^(AXI_02_WDATA[159:152])},{^(AXI_02_WDATA[151:144])},{^(AXI_02_WDATA[143:136])},{^(AXI_02_WDATA[135:128])},
                              {^(AXI_02_WDATA[127:120])},{^(AXI_02_WDATA[119:112])},{^(AXI_02_WDATA[111:104])},{^(AXI_02_WDATA[103:96])},
                              {^(AXI_02_WDATA[95:88])},  {^(AXI_02_WDATA[87:80])},  {^(AXI_02_WDATA[79:72])},  {^(AXI_02_WDATA[71:64])},
                              {^(AXI_02_WDATA[63:56])},  {^(AXI_02_WDATA[55:48])},  {^(AXI_02_WDATA[47:40])},  {^(AXI_02_WDATA[39:32])},
                              {^(AXI_02_WDATA[31:24])},  {^(AXI_02_WDATA[23:16])},  {^(AXI_02_WDATA[15:8])},   {^(AXI_02_WDATA[7:0])}};

always @(posedge AXI_ACLK1_st0_buf)
  AXI_02_WDATA_PARITY <= AXI_02_WDATA_PARITY_i;
assign AXI_03_WDATA_PARITY_i = {{^(AXI_03_WDATA[255:248])},{^(AXI_03_WDATA[247:240])},{^(AXI_03_WDATA[239:232])},{^(AXI_03_WDATA[231:224])},
                              {^(AXI_03_WDATA[223:216])},{^(AXI_03_WDATA[215:208])},{^(AXI_03_WDATA[207:200])},{^(AXI_03_WDATA[199:192])},
                              {^(AXI_03_WDATA[191:184])},{^(AXI_03_WDATA[183:176])},{^(AXI_03_WDATA[175:168])},{^(AXI_03_WDATA[167:160])},
                              {^(AXI_03_WDATA[159:152])},{^(AXI_03_WDATA[151:144])},{^(AXI_03_WDATA[143:136])},{^(AXI_03_WDATA[135:128])},
                              {^(AXI_03_WDATA[127:120])},{^(AXI_03_WDATA[119:112])},{^(AXI_03_WDATA[111:104])},{^(AXI_03_WDATA[103:96])},
                              {^(AXI_03_WDATA[95:88])},  {^(AXI_03_WDATA[87:80])},  {^(AXI_03_WDATA[79:72])},  {^(AXI_03_WDATA[71:64])},
                              {^(AXI_03_WDATA[63:56])},  {^(AXI_03_WDATA[55:48])},  {^(AXI_03_WDATA[47:40])},  {^(AXI_03_WDATA[39:32])},
                              {^(AXI_03_WDATA[31:24])},  {^(AXI_03_WDATA[23:16])},  {^(AXI_03_WDATA[15:8])},   {^(AXI_03_WDATA[7:0])}};

always @(posedge AXI_ACLK1_st0_buf)
  AXI_03_WDATA_PARITY <= AXI_03_WDATA_PARITY_i;
assign AXI_04_WDATA_PARITY_i = {{^(AXI_04_WDATA[255:248])},{^(AXI_04_WDATA[247:240])},{^(AXI_04_WDATA[239:232])},{^(AXI_04_WDATA[231:224])},
                              {^(AXI_04_WDATA[223:216])},{^(AXI_04_WDATA[215:208])},{^(AXI_04_WDATA[207:200])},{^(AXI_04_WDATA[199:192])},
                              {^(AXI_04_WDATA[191:184])},{^(AXI_04_WDATA[183:176])},{^(AXI_04_WDATA[175:168])},{^(AXI_04_WDATA[167:160])},
                              {^(AXI_04_WDATA[159:152])},{^(AXI_04_WDATA[151:144])},{^(AXI_04_WDATA[143:136])},{^(AXI_04_WDATA[135:128])},
                              {^(AXI_04_WDATA[127:120])},{^(AXI_04_WDATA[119:112])},{^(AXI_04_WDATA[111:104])},{^(AXI_04_WDATA[103:96])},
                              {^(AXI_04_WDATA[95:88])},  {^(AXI_04_WDATA[87:80])},  {^(AXI_04_WDATA[79:72])},  {^(AXI_04_WDATA[71:64])},
                              {^(AXI_04_WDATA[63:56])},  {^(AXI_04_WDATA[55:48])},  {^(AXI_04_WDATA[47:40])},  {^(AXI_04_WDATA[39:32])},
                              {^(AXI_04_WDATA[31:24])},  {^(AXI_04_WDATA[23:16])},  {^(AXI_04_WDATA[15:8])},   {^(AXI_04_WDATA[7:0])}};

always @(posedge AXI_ACLK2_st0_buf)
  AXI_04_WDATA_PARITY <= AXI_04_WDATA_PARITY_i;
assign AXI_05_WDATA_PARITY_i = {{^(AXI_05_WDATA[255:248])},{^(AXI_05_WDATA[247:240])},{^(AXI_05_WDATA[239:232])},{^(AXI_05_WDATA[231:224])},
                              {^(AXI_05_WDATA[223:216])},{^(AXI_05_WDATA[215:208])},{^(AXI_05_WDATA[207:200])},{^(AXI_05_WDATA[199:192])},
                              {^(AXI_05_WDATA[191:184])},{^(AXI_05_WDATA[183:176])},{^(AXI_05_WDATA[175:168])},{^(AXI_05_WDATA[167:160])},
                              {^(AXI_05_WDATA[159:152])},{^(AXI_05_WDATA[151:144])},{^(AXI_05_WDATA[143:136])},{^(AXI_05_WDATA[135:128])},
                              {^(AXI_05_WDATA[127:120])},{^(AXI_05_WDATA[119:112])},{^(AXI_05_WDATA[111:104])},{^(AXI_05_WDATA[103:96])},
                              {^(AXI_05_WDATA[95:88])},  {^(AXI_05_WDATA[87:80])},  {^(AXI_05_WDATA[79:72])},  {^(AXI_05_WDATA[71:64])},
                              {^(AXI_05_WDATA[63:56])},  {^(AXI_05_WDATA[55:48])},  {^(AXI_05_WDATA[47:40])},  {^(AXI_05_WDATA[39:32])},
                              {^(AXI_05_WDATA[31:24])},  {^(AXI_05_WDATA[23:16])},  {^(AXI_05_WDATA[15:8])},   {^(AXI_05_WDATA[7:0])}};

always @(posedge AXI_ACLK2_st0_buf)
  AXI_05_WDATA_PARITY <= AXI_05_WDATA_PARITY_i;
assign AXI_06_WDATA_PARITY_i = {{^(AXI_06_WDATA[255:248])},{^(AXI_06_WDATA[247:240])},{^(AXI_06_WDATA[239:232])},{^(AXI_06_WDATA[231:224])},
                              {^(AXI_06_WDATA[223:216])},{^(AXI_06_WDATA[215:208])},{^(AXI_06_WDATA[207:200])},{^(AXI_06_WDATA[199:192])},
                              {^(AXI_06_WDATA[191:184])},{^(AXI_06_WDATA[183:176])},{^(AXI_06_WDATA[175:168])},{^(AXI_06_WDATA[167:160])},
                              {^(AXI_06_WDATA[159:152])},{^(AXI_06_WDATA[151:144])},{^(AXI_06_WDATA[143:136])},{^(AXI_06_WDATA[135:128])},
                              {^(AXI_06_WDATA[127:120])},{^(AXI_06_WDATA[119:112])},{^(AXI_06_WDATA[111:104])},{^(AXI_06_WDATA[103:96])},
                              {^(AXI_06_WDATA[95:88])},  {^(AXI_06_WDATA[87:80])},  {^(AXI_06_WDATA[79:72])},  {^(AXI_06_WDATA[71:64])},
                              {^(AXI_06_WDATA[63:56])},  {^(AXI_06_WDATA[55:48])},  {^(AXI_06_WDATA[47:40])},  {^(AXI_06_WDATA[39:32])},
                              {^(AXI_06_WDATA[31:24])},  {^(AXI_06_WDATA[23:16])},  {^(AXI_06_WDATA[15:8])},   {^(AXI_06_WDATA[7:0])}};

always @(posedge AXI_ACLK3_st0_buf)
  AXI_06_WDATA_PARITY <= AXI_06_WDATA_PARITY_i;
assign AXI_07_WDATA_PARITY_i = {{^(AXI_07_WDATA[255:248])},{^(AXI_07_WDATA[247:240])},{^(AXI_07_WDATA[239:232])},{^(AXI_07_WDATA[231:224])},
                              {^(AXI_07_WDATA[223:216])},{^(AXI_07_WDATA[215:208])},{^(AXI_07_WDATA[207:200])},{^(AXI_07_WDATA[199:192])},
                              {^(AXI_07_WDATA[191:184])},{^(AXI_07_WDATA[183:176])},{^(AXI_07_WDATA[175:168])},{^(AXI_07_WDATA[167:160])},
                              {^(AXI_07_WDATA[159:152])},{^(AXI_07_WDATA[151:144])},{^(AXI_07_WDATA[143:136])},{^(AXI_07_WDATA[135:128])},
                              {^(AXI_07_WDATA[127:120])},{^(AXI_07_WDATA[119:112])},{^(AXI_07_WDATA[111:104])},{^(AXI_07_WDATA[103:96])},
                              {^(AXI_07_WDATA[95:88])},  {^(AXI_07_WDATA[87:80])},  {^(AXI_07_WDATA[79:72])},  {^(AXI_07_WDATA[71:64])},
                              {^(AXI_07_WDATA[63:56])},  {^(AXI_07_WDATA[55:48])},  {^(AXI_07_WDATA[47:40])},  {^(AXI_07_WDATA[39:32])},
                              {^(AXI_07_WDATA[31:24])},  {^(AXI_07_WDATA[23:16])},  {^(AXI_07_WDATA[15:8])},   {^(AXI_07_WDATA[7:0])}};

always @(posedge AXI_ACLK3_st0_buf)
  AXI_07_WDATA_PARITY <= AXI_07_WDATA_PARITY_i;
assign AXI_08_WDATA_PARITY_i = {{^(AXI_08_WDATA[255:248])},{^(AXI_08_WDATA[247:240])},{^(AXI_08_WDATA[239:232])},{^(AXI_08_WDATA[231:224])},
                              {^(AXI_08_WDATA[223:216])},{^(AXI_08_WDATA[215:208])},{^(AXI_08_WDATA[207:200])},{^(AXI_08_WDATA[199:192])},
                              {^(AXI_08_WDATA[191:184])},{^(AXI_08_WDATA[183:176])},{^(AXI_08_WDATA[175:168])},{^(AXI_08_WDATA[167:160])},
                              {^(AXI_08_WDATA[159:152])},{^(AXI_08_WDATA[151:144])},{^(AXI_08_WDATA[143:136])},{^(AXI_08_WDATA[135:128])},
                              {^(AXI_08_WDATA[127:120])},{^(AXI_08_WDATA[119:112])},{^(AXI_08_WDATA[111:104])},{^(AXI_08_WDATA[103:96])},
                              {^(AXI_08_WDATA[95:88])},  {^(AXI_08_WDATA[87:80])},  {^(AXI_08_WDATA[79:72])},  {^(AXI_08_WDATA[71:64])},
                              {^(AXI_08_WDATA[63:56])},  {^(AXI_08_WDATA[55:48])},  {^(AXI_08_WDATA[47:40])},  {^(AXI_08_WDATA[39:32])},
                              {^(AXI_08_WDATA[31:24])},  {^(AXI_08_WDATA[23:16])},  {^(AXI_08_WDATA[15:8])},   {^(AXI_08_WDATA[7:0])}};

always @(posedge AXI_ACLK4_st0_buf)
  AXI_08_WDATA_PARITY <= AXI_08_WDATA_PARITY_i;
assign AXI_09_WDATA_PARITY_i = {{^(AXI_09_WDATA[255:248])},{^(AXI_09_WDATA[247:240])},{^(AXI_09_WDATA[239:232])},{^(AXI_09_WDATA[231:224])},
                              {^(AXI_09_WDATA[223:216])},{^(AXI_09_WDATA[215:208])},{^(AXI_09_WDATA[207:200])},{^(AXI_09_WDATA[199:192])},
                              {^(AXI_09_WDATA[191:184])},{^(AXI_09_WDATA[183:176])},{^(AXI_09_WDATA[175:168])},{^(AXI_09_WDATA[167:160])},
                              {^(AXI_09_WDATA[159:152])},{^(AXI_09_WDATA[151:144])},{^(AXI_09_WDATA[143:136])},{^(AXI_09_WDATA[135:128])},
                              {^(AXI_09_WDATA[127:120])},{^(AXI_09_WDATA[119:112])},{^(AXI_09_WDATA[111:104])},{^(AXI_09_WDATA[103:96])},
                              {^(AXI_09_WDATA[95:88])},  {^(AXI_09_WDATA[87:80])},  {^(AXI_09_WDATA[79:72])},  {^(AXI_09_WDATA[71:64])},
                              {^(AXI_09_WDATA[63:56])},  {^(AXI_09_WDATA[55:48])},  {^(AXI_09_WDATA[47:40])},  {^(AXI_09_WDATA[39:32])},
                              {^(AXI_09_WDATA[31:24])},  {^(AXI_09_WDATA[23:16])},  {^(AXI_09_WDATA[15:8])},   {^(AXI_09_WDATA[7:0])}};

always @(posedge AXI_ACLK4_st0_buf)
  AXI_09_WDATA_PARITY <= AXI_09_WDATA_PARITY_i;
assign AXI_10_WDATA_PARITY_i = {{^(AXI_10_WDATA[255:248])},{^(AXI_10_WDATA[247:240])},{^(AXI_10_WDATA[239:232])},{^(AXI_10_WDATA[231:224])},
                              {^(AXI_10_WDATA[223:216])},{^(AXI_10_WDATA[215:208])},{^(AXI_10_WDATA[207:200])},{^(AXI_10_WDATA[199:192])},
                              {^(AXI_10_WDATA[191:184])},{^(AXI_10_WDATA[183:176])},{^(AXI_10_WDATA[175:168])},{^(AXI_10_WDATA[167:160])},
                              {^(AXI_10_WDATA[159:152])},{^(AXI_10_WDATA[151:144])},{^(AXI_10_WDATA[143:136])},{^(AXI_10_WDATA[135:128])},
                              {^(AXI_10_WDATA[127:120])},{^(AXI_10_WDATA[119:112])},{^(AXI_10_WDATA[111:104])},{^(AXI_10_WDATA[103:96])},
                              {^(AXI_10_WDATA[95:88])},  {^(AXI_10_WDATA[87:80])},  {^(AXI_10_WDATA[79:72])},  {^(AXI_10_WDATA[71:64])},
                              {^(AXI_10_WDATA[63:56])},  {^(AXI_10_WDATA[55:48])},  {^(AXI_10_WDATA[47:40])},  {^(AXI_10_WDATA[39:32])},
                              {^(AXI_10_WDATA[31:24])},  {^(AXI_10_WDATA[23:16])},  {^(AXI_10_WDATA[15:8])},   {^(AXI_10_WDATA[7:0])}};

always @(posedge AXI_ACLK5_st0_buf)
  AXI_10_WDATA_PARITY <= AXI_10_WDATA_PARITY_i;
assign AXI_11_WDATA_PARITY_i = {{^(AXI_11_WDATA[255:248])},{^(AXI_11_WDATA[247:240])},{^(AXI_11_WDATA[239:232])},{^(AXI_11_WDATA[231:224])},
                              {^(AXI_11_WDATA[223:216])},{^(AXI_11_WDATA[215:208])},{^(AXI_11_WDATA[207:200])},{^(AXI_11_WDATA[199:192])},
                              {^(AXI_11_WDATA[191:184])},{^(AXI_11_WDATA[183:176])},{^(AXI_11_WDATA[175:168])},{^(AXI_11_WDATA[167:160])},
                              {^(AXI_11_WDATA[159:152])},{^(AXI_11_WDATA[151:144])},{^(AXI_11_WDATA[143:136])},{^(AXI_11_WDATA[135:128])},
                              {^(AXI_11_WDATA[127:120])},{^(AXI_11_WDATA[119:112])},{^(AXI_11_WDATA[111:104])},{^(AXI_11_WDATA[103:96])},
                              {^(AXI_11_WDATA[95:88])},  {^(AXI_11_WDATA[87:80])},  {^(AXI_11_WDATA[79:72])},  {^(AXI_11_WDATA[71:64])},
                              {^(AXI_11_WDATA[63:56])},  {^(AXI_11_WDATA[55:48])},  {^(AXI_11_WDATA[47:40])},  {^(AXI_11_WDATA[39:32])},
                              {^(AXI_11_WDATA[31:24])},  {^(AXI_11_WDATA[23:16])},  {^(AXI_11_WDATA[15:8])},   {^(AXI_11_WDATA[7:0])}};

always @(posedge AXI_ACLK5_st0_buf)
  AXI_11_WDATA_PARITY <= AXI_11_WDATA_PARITY_i;
assign AXI_12_WDATA_PARITY_i = {{^(AXI_12_WDATA[255:248])},{^(AXI_12_WDATA[247:240])},{^(AXI_12_WDATA[239:232])},{^(AXI_12_WDATA[231:224])},
                              {^(AXI_12_WDATA[223:216])},{^(AXI_12_WDATA[215:208])},{^(AXI_12_WDATA[207:200])},{^(AXI_12_WDATA[199:192])},
                              {^(AXI_12_WDATA[191:184])},{^(AXI_12_WDATA[183:176])},{^(AXI_12_WDATA[175:168])},{^(AXI_12_WDATA[167:160])},
                              {^(AXI_12_WDATA[159:152])},{^(AXI_12_WDATA[151:144])},{^(AXI_12_WDATA[143:136])},{^(AXI_12_WDATA[135:128])},
                              {^(AXI_12_WDATA[127:120])},{^(AXI_12_WDATA[119:112])},{^(AXI_12_WDATA[111:104])},{^(AXI_12_WDATA[103:96])},
                              {^(AXI_12_WDATA[95:88])},  {^(AXI_12_WDATA[87:80])},  {^(AXI_12_WDATA[79:72])},  {^(AXI_12_WDATA[71:64])},
                              {^(AXI_12_WDATA[63:56])},  {^(AXI_12_WDATA[55:48])},  {^(AXI_12_WDATA[47:40])},  {^(AXI_12_WDATA[39:32])},
                              {^(AXI_12_WDATA[31:24])},  {^(AXI_12_WDATA[23:16])},  {^(AXI_12_WDATA[15:8])},   {^(AXI_12_WDATA[7:0])}};

always @(posedge AXI_ACLK5_st0_buf)
  AXI_12_WDATA_PARITY <= AXI_12_WDATA_PARITY_i;
assign AXI_13_WDATA_PARITY_i = {{^(AXI_13_WDATA[255:248])},{^(AXI_13_WDATA[247:240])},{^(AXI_13_WDATA[239:232])},{^(AXI_13_WDATA[231:224])},
                              {^(AXI_13_WDATA[223:216])},{^(AXI_13_WDATA[215:208])},{^(AXI_13_WDATA[207:200])},{^(AXI_13_WDATA[199:192])},
                              {^(AXI_13_WDATA[191:184])},{^(AXI_13_WDATA[183:176])},{^(AXI_13_WDATA[175:168])},{^(AXI_13_WDATA[167:160])},
                              {^(AXI_13_WDATA[159:152])},{^(AXI_13_WDATA[151:144])},{^(AXI_13_WDATA[143:136])},{^(AXI_13_WDATA[135:128])},
                              {^(AXI_13_WDATA[127:120])},{^(AXI_13_WDATA[119:112])},{^(AXI_13_WDATA[111:104])},{^(AXI_13_WDATA[103:96])},
                              {^(AXI_13_WDATA[95:88])},  {^(AXI_13_WDATA[87:80])},  {^(AXI_13_WDATA[79:72])},  {^(AXI_13_WDATA[71:64])},
                              {^(AXI_13_WDATA[63:56])},  {^(AXI_13_WDATA[55:48])},  {^(AXI_13_WDATA[47:40])},  {^(AXI_13_WDATA[39:32])},
                              {^(AXI_13_WDATA[31:24])},  {^(AXI_13_WDATA[23:16])},  {^(AXI_13_WDATA[15:8])},   {^(AXI_13_WDATA[7:0])}};

always @(posedge AXI_ACLK6_st0_buf)
  AXI_13_WDATA_PARITY <= AXI_13_WDATA_PARITY_i;
assign AXI_14_WDATA_PARITY_i = {{^(AXI_14_WDATA[255:248])},{^(AXI_14_WDATA[247:240])},{^(AXI_14_WDATA[239:232])},{^(AXI_14_WDATA[231:224])},
                              {^(AXI_14_WDATA[223:216])},{^(AXI_14_WDATA[215:208])},{^(AXI_14_WDATA[207:200])},{^(AXI_14_WDATA[199:192])},
                              {^(AXI_14_WDATA[191:184])},{^(AXI_14_WDATA[183:176])},{^(AXI_14_WDATA[175:168])},{^(AXI_14_WDATA[167:160])},
                              {^(AXI_14_WDATA[159:152])},{^(AXI_14_WDATA[151:144])},{^(AXI_14_WDATA[143:136])},{^(AXI_14_WDATA[135:128])},
                              {^(AXI_14_WDATA[127:120])},{^(AXI_14_WDATA[119:112])},{^(AXI_14_WDATA[111:104])},{^(AXI_14_WDATA[103:96])},
                              {^(AXI_14_WDATA[95:88])},  {^(AXI_14_WDATA[87:80])},  {^(AXI_14_WDATA[79:72])},  {^(AXI_14_WDATA[71:64])},
                              {^(AXI_14_WDATA[63:56])},  {^(AXI_14_WDATA[55:48])},  {^(AXI_14_WDATA[47:40])},  {^(AXI_14_WDATA[39:32])},
                              {^(AXI_14_WDATA[31:24])},  {^(AXI_14_WDATA[23:16])},  {^(AXI_14_WDATA[15:8])},   {^(AXI_14_WDATA[7:0])}};

always @(posedge AXI_ACLK6_st0_buf)
  AXI_14_WDATA_PARITY <= AXI_14_WDATA_PARITY_i;
assign AXI_15_WDATA_PARITY_i = {{^(AXI_15_WDATA[255:248])},{^(AXI_15_WDATA[247:240])},{^(AXI_15_WDATA[239:232])},{^(AXI_15_WDATA[231:224])},
                              {^(AXI_15_WDATA[223:216])},{^(AXI_15_WDATA[215:208])},{^(AXI_15_WDATA[207:200])},{^(AXI_15_WDATA[199:192])},
                              {^(AXI_15_WDATA[191:184])},{^(AXI_15_WDATA[183:176])},{^(AXI_15_WDATA[175:168])},{^(AXI_15_WDATA[167:160])},
                              {^(AXI_15_WDATA[159:152])},{^(AXI_15_WDATA[151:144])},{^(AXI_15_WDATA[143:136])},{^(AXI_15_WDATA[135:128])},
                              {^(AXI_15_WDATA[127:120])},{^(AXI_15_WDATA[119:112])},{^(AXI_15_WDATA[111:104])},{^(AXI_15_WDATA[103:96])},
                              {^(AXI_15_WDATA[95:88])},  {^(AXI_15_WDATA[87:80])},  {^(AXI_15_WDATA[79:72])},  {^(AXI_15_WDATA[71:64])},
                              {^(AXI_15_WDATA[63:56])},  {^(AXI_15_WDATA[55:48])},  {^(AXI_15_WDATA[47:40])},  {^(AXI_15_WDATA[39:32])},
                              {^(AXI_15_WDATA[31:24])},  {^(AXI_15_WDATA[23:16])},  {^(AXI_15_WDATA[15:8])},   {^(AXI_15_WDATA[7:0])}};

always @(posedge AXI_ACLK6_st0_buf)
  AXI_15_WDATA_PARITY <= AXI_15_WDATA_PARITY_i;

////////////////////////////////////////////////////////////////////////////////
// Instantiating User Design
////////////////////////////////////////////////////////////////////////////////
hbm_mem_controller u_hbm_mem_controller
(
  .HBM_REF_CLK_0                 (HBM_REF_CLK_0)

  ,.AXI_00_ACLK                  (AXI_ACLK0_st0_buf     )
  ,.AXI_00_ARESET_N              (axi_rst0_st0_n        )
  ,.AXI_00_ARADDR                (AXI_00_ARADDR      )
  ,.AXI_00_ARBURST               (AXI_00_ARBURST     )
  ,.AXI_00_ARID                  (AXI_00_ARID        )
  ,.AXI_00_ARLEN                 (AXI_00_ARLEN[3:0]  )
  ,.AXI_00_ARSIZE                (AXI_00_ARSIZE      )
  ,.AXI_00_ARVALID               (AXI_00_ARVALID     )
  ,.AXI_00_AWADDR                (AXI_00_AWADDR      )
  ,.AXI_00_AWBURST               (AXI_00_AWBURST     )
  ,.AXI_00_AWID                  (AXI_00_AWID        )
  ,.AXI_00_AWLEN                 (AXI_00_AWLEN[3:0]  )
  ,.AXI_00_AWSIZE                (AXI_00_AWSIZE      )
  ,.AXI_00_AWVALID               (AXI_00_AWVALID     )
  ,.AXI_00_RREADY                (AXI_00_RREADY      )
  ,.AXI_00_BREADY                (AXI_00_BREADY      )
  ,.AXI_00_WDATA                 (AXI_00_WDATA       )
  ,.AXI_00_WLAST                 (AXI_00_WLAST       )
  ,.AXI_00_WSTRB                 (AXI_00_WSTRB       )
  ,.AXI_00_WDATA_PARITY          (AXI_00_WDATA_PARITY_i)
  ,.AXI_00_WVALID                (AXI_00_WVALID      )

  ,.AXI_01_ACLK                  (AXI_ACLK0_st0_buf     )
  ,.AXI_01_ARESET_N              (axi_rst0_st0_n        )
  ,.AXI_01_ARADDR                (AXI_01_ARADDR      )
  ,.AXI_01_ARBURST               (AXI_01_ARBURST     )
  ,.AXI_01_ARID                  (AXI_01_ARID        )
  ,.AXI_01_ARLEN                 (AXI_01_ARLEN[3:0]  )
  ,.AXI_01_ARSIZE                (AXI_01_ARSIZE      )
  ,.AXI_01_ARVALID               (AXI_01_ARVALID     )
  ,.AXI_01_AWADDR                (AXI_01_AWADDR      )
  ,.AXI_01_AWBURST               (AXI_01_AWBURST     )
  ,.AXI_01_AWID                  (AXI_01_AWID        )
  ,.AXI_01_AWLEN                 (AXI_01_AWLEN[3:0]  )
  ,.AXI_01_AWSIZE                (AXI_01_AWSIZE      )
  ,.AXI_01_AWVALID               (AXI_01_AWVALID     )
  ,.AXI_01_RREADY                (AXI_01_RREADY      )
  ,.AXI_01_BREADY                (AXI_01_BREADY      )
  ,.AXI_01_WDATA                 (AXI_01_WDATA       )
  ,.AXI_01_WLAST                 (AXI_01_WLAST       )
  ,.AXI_01_WSTRB                 (AXI_01_WSTRB       )
  ,.AXI_01_WDATA_PARITY          (AXI_01_WDATA_PARITY_i)
  ,.AXI_01_WVALID                (AXI_01_WVALID      )

  ,.AXI_02_ACLK                  (AXI_ACLK1_st0_buf     )
  ,.AXI_02_ARESET_N              (axi_rst1_st0_n        )
  ,.AXI_02_ARADDR                (AXI_02_ARADDR      )
  ,.AXI_02_ARBURST               (AXI_02_ARBURST     )
  ,.AXI_02_ARID                  (AXI_02_ARID        )
  ,.AXI_02_ARLEN                 (AXI_02_ARLEN[3:0]  )
  ,.AXI_02_ARSIZE                (AXI_02_ARSIZE      )
  ,.AXI_02_ARVALID               (AXI_02_ARVALID     )
  ,.AXI_02_AWADDR                (AXI_02_AWADDR      )
  ,.AXI_02_AWBURST               (AXI_02_AWBURST     )
  ,.AXI_02_AWID                  (AXI_02_AWID        )
  ,.AXI_02_AWLEN                 (AXI_02_AWLEN[3:0]  )
  ,.AXI_02_AWSIZE                (AXI_02_AWSIZE      )
  ,.AXI_02_AWVALID               (AXI_02_AWVALID     )
  ,.AXI_02_RREADY                (AXI_02_RREADY      )
  ,.AXI_02_BREADY                (AXI_02_BREADY      )
  ,.AXI_02_WDATA                 (AXI_02_WDATA       )
  ,.AXI_02_WLAST                 (AXI_02_WLAST       )
  ,.AXI_02_WSTRB                 (AXI_02_WSTRB       )
  ,.AXI_02_WDATA_PARITY          (AXI_02_WDATA_PARITY_i)
  ,.AXI_02_WVALID                (AXI_02_WVALID      )
  ,.AXI_03_ACLK                  (AXI_ACLK1_st0_buf     )
  ,.AXI_03_ARESET_N              (axi_rst1_st0_n        )
  ,.AXI_03_ARADDR                (AXI_03_ARADDR      )
  ,.AXI_03_ARBURST               (AXI_03_ARBURST     )
  ,.AXI_03_ARID                  (AXI_03_ARID        )
  ,.AXI_03_ARLEN                 (AXI_03_ARLEN[3:0]  )
  ,.AXI_03_ARSIZE                (AXI_03_ARSIZE      )
  ,.AXI_03_ARVALID               (AXI_03_ARVALID     )
  ,.AXI_03_AWADDR                (AXI_03_AWADDR      )
  ,.AXI_03_AWBURST               (AXI_03_AWBURST     )
  ,.AXI_03_AWID                  (AXI_03_AWID        )
  ,.AXI_03_AWLEN                 (AXI_03_AWLEN[3:0]  )
  ,.AXI_03_AWSIZE                (AXI_03_AWSIZE      )
  ,.AXI_03_AWVALID               (AXI_03_AWVALID     )
  ,.AXI_03_RREADY                (AXI_03_RREADY      )
  ,.AXI_03_BREADY                (AXI_03_BREADY      )
  ,.AXI_03_WDATA                 (AXI_03_WDATA       )
  ,.AXI_03_WLAST                 (AXI_03_WLAST       )
  ,.AXI_03_WSTRB                 (AXI_03_WSTRB       )
  ,.AXI_03_WDATA_PARITY          (AXI_03_WDATA_PARITY_i)
  ,.AXI_03_WVALID                (AXI_03_WVALID      )
  ,.AXI_04_ACLK                  (AXI_ACLK2_st0_buf     )
  ,.AXI_04_ARESET_N              (axi_rst2_st0_n        )
  ,.AXI_04_ARADDR                (AXI_04_ARADDR      )
  ,.AXI_04_ARBURST               (AXI_04_ARBURST     )
  ,.AXI_04_ARID                  (AXI_04_ARID        )
  ,.AXI_04_ARLEN                 (AXI_04_ARLEN[3:0]  )
  ,.AXI_04_ARSIZE                (AXI_04_ARSIZE      )
  ,.AXI_04_ARVALID               (AXI_04_ARVALID     )
  ,.AXI_04_AWADDR                (AXI_04_AWADDR      )
  ,.AXI_04_AWBURST               (AXI_04_AWBURST     )
  ,.AXI_04_AWID                  (AXI_04_AWID        )
  ,.AXI_04_AWLEN                 (AXI_04_AWLEN[3:0]  )
  ,.AXI_04_AWSIZE                (AXI_04_AWSIZE      )
  ,.AXI_04_AWVALID               (AXI_04_AWVALID     )
  ,.AXI_04_RREADY                (AXI_04_RREADY      )
  ,.AXI_04_BREADY                (AXI_04_BREADY      )
  ,.AXI_04_WDATA                 (AXI_04_WDATA       )
  ,.AXI_04_WLAST                 (AXI_04_WLAST       )
  ,.AXI_04_WSTRB                 (AXI_04_WSTRB       )
  ,.AXI_04_WDATA_PARITY          (AXI_04_WDATA_PARITY_i)
  ,.AXI_04_WVALID                (AXI_04_WVALID      )
  ,.AXI_05_ACLK                  (AXI_ACLK2_st0_buf     )
  ,.AXI_05_ARESET_N              (axi_rst2_st0_n        )
  ,.AXI_05_ARADDR                (AXI_05_ARADDR      )
  ,.AXI_05_ARBURST               (AXI_05_ARBURST     )
  ,.AXI_05_ARID                  (AXI_05_ARID        )
  ,.AXI_05_ARLEN                 (AXI_05_ARLEN[3:0]  )
  ,.AXI_05_ARSIZE                (AXI_05_ARSIZE      )
  ,.AXI_05_ARVALID               (AXI_05_ARVALID     )
  ,.AXI_05_AWADDR                (AXI_05_AWADDR      )
  ,.AXI_05_AWBURST               (AXI_05_AWBURST     )
  ,.AXI_05_AWID                  (AXI_05_AWID        )
  ,.AXI_05_AWLEN                 (AXI_05_AWLEN[3:0]  )
  ,.AXI_05_AWSIZE                (AXI_05_AWSIZE      )
  ,.AXI_05_AWVALID               (AXI_05_AWVALID     )
  ,.AXI_05_RREADY                (AXI_05_RREADY      )
  ,.AXI_05_BREADY                (AXI_05_BREADY      )
  ,.AXI_05_WDATA                 (AXI_05_WDATA       )
  ,.AXI_05_WLAST                 (AXI_05_WLAST       )
  ,.AXI_05_WSTRB                 (AXI_05_WSTRB       )
  ,.AXI_05_WDATA_PARITY          (AXI_05_WDATA_PARITY_i)
  ,.AXI_05_WVALID                (AXI_05_WVALID      )
  ,.AXI_06_ACLK                  (AXI_ACLK3_st0_buf     )
  ,.AXI_06_ARESET_N              (axi_rst3_st0_n        )
  ,.AXI_06_ARADDR                (AXI_06_ARADDR      )
  ,.AXI_06_ARBURST               (AXI_06_ARBURST     )
  ,.AXI_06_ARID                  (AXI_06_ARID        )
  ,.AXI_06_ARLEN                 (AXI_06_ARLEN[3:0]  )
  ,.AXI_06_ARSIZE                (AXI_06_ARSIZE      )
  ,.AXI_06_ARVALID               (AXI_06_ARVALID     )
  ,.AXI_06_AWADDR                (AXI_06_AWADDR      )
  ,.AXI_06_AWBURST               (AXI_06_AWBURST     )
  ,.AXI_06_AWID                  (AXI_06_AWID        )
  ,.AXI_06_AWLEN                 (AXI_06_AWLEN[3:0]  )
  ,.AXI_06_AWSIZE                (AXI_06_AWSIZE      )
  ,.AXI_06_AWVALID               (AXI_06_AWVALID     )
  ,.AXI_06_RREADY                (AXI_06_RREADY      )
  ,.AXI_06_BREADY                (AXI_06_BREADY      )
  ,.AXI_06_WDATA                 (AXI_06_WDATA       )
  ,.AXI_06_WLAST                 (AXI_06_WLAST       )
  ,.AXI_06_WSTRB                 (AXI_06_WSTRB       )
  ,.AXI_06_WDATA_PARITY          (AXI_06_WDATA_PARITY_i)
  ,.AXI_06_WVALID                (AXI_06_WVALID      )
  ,.AXI_07_ACLK                  (AXI_ACLK3_st0_buf     )
  ,.AXI_07_ARESET_N              (axi_rst3_st0_n        )
  ,.AXI_07_ARADDR                (AXI_07_ARADDR      )
  ,.AXI_07_ARBURST               (AXI_07_ARBURST     )
  ,.AXI_07_ARID                  (AXI_07_ARID        )
  ,.AXI_07_ARLEN                 (AXI_07_ARLEN[3:0]  )
  ,.AXI_07_ARSIZE                (AXI_07_ARSIZE      )
  ,.AXI_07_ARVALID               (AXI_07_ARVALID     )
  ,.AXI_07_AWADDR                (AXI_07_AWADDR      )
  ,.AXI_07_AWBURST               (AXI_07_AWBURST     )
  ,.AXI_07_AWID                  (AXI_07_AWID        )
  ,.AXI_07_AWLEN                 (AXI_07_AWLEN[3:0]  )
  ,.AXI_07_AWSIZE                (AXI_07_AWSIZE      )
  ,.AXI_07_AWVALID               (AXI_07_AWVALID     )
  ,.AXI_07_RREADY                (AXI_07_RREADY      )
  ,.AXI_07_BREADY                (AXI_07_BREADY      )
  ,.AXI_07_WDATA                 (AXI_07_WDATA       )
  ,.AXI_07_WLAST                 (AXI_07_WLAST       )
  ,.AXI_07_WSTRB                 (AXI_07_WSTRB       )
  ,.AXI_07_WDATA_PARITY          (AXI_07_WDATA_PARITY_i)
  ,.AXI_07_WVALID                (AXI_07_WVALID      )
  ,.AXI_08_ACLK                  (AXI_ACLK4_st0_buf     )
  ,.AXI_08_ARESET_N              (axi_rst4_st0_n        )
  ,.AXI_08_ARADDR                (AXI_08_ARADDR      )
  ,.AXI_08_ARBURST               (AXI_08_ARBURST     )
  ,.AXI_08_ARID                  (AXI_08_ARID        )
  ,.AXI_08_ARLEN                 (AXI_08_ARLEN[3:0]  )
  ,.AXI_08_ARSIZE                (AXI_08_ARSIZE      )
  ,.AXI_08_ARVALID               (AXI_08_ARVALID     )
  ,.AXI_08_AWADDR                (AXI_08_AWADDR      )
  ,.AXI_08_AWBURST               (AXI_08_AWBURST     )
  ,.AXI_08_AWID                  (AXI_08_AWID        )
  ,.AXI_08_AWLEN                 (AXI_08_AWLEN[3:0]  )
  ,.AXI_08_AWSIZE                (AXI_08_AWSIZE      )
  ,.AXI_08_AWVALID               (AXI_08_AWVALID     )
  ,.AXI_08_RREADY                (AXI_08_RREADY      )
  ,.AXI_08_BREADY                (AXI_08_BREADY      )
  ,.AXI_08_WDATA                 (AXI_08_WDATA       )
  ,.AXI_08_WLAST                 (AXI_08_WLAST       )
  ,.AXI_08_WSTRB                 (AXI_08_WSTRB       )
  ,.AXI_08_WDATA_PARITY          (AXI_08_WDATA_PARITY_i)
  ,.AXI_08_WVALID                (AXI_08_WVALID      )
  ,.AXI_09_ACLK                  (AXI_ACLK4_st0_buf     )
  ,.AXI_09_ARESET_N              (axi_rst4_st0_n        )
  ,.AXI_09_ARADDR                (AXI_09_ARADDR      )
  ,.AXI_09_ARBURST               (AXI_09_ARBURST     )
  ,.AXI_09_ARID                  (AXI_09_ARID        )
  ,.AXI_09_ARLEN                 (AXI_09_ARLEN[3:0]  )
  ,.AXI_09_ARSIZE                (AXI_09_ARSIZE      )
  ,.AXI_09_ARVALID               (AXI_09_ARVALID     )
  ,.AXI_09_AWADDR                (AXI_09_AWADDR      )
  ,.AXI_09_AWBURST               (AXI_09_AWBURST     )
  ,.AXI_09_AWID                  (AXI_09_AWID        )
  ,.AXI_09_AWLEN                 (AXI_09_AWLEN[3:0]  )
  ,.AXI_09_AWSIZE                (AXI_09_AWSIZE      )
  ,.AXI_09_AWVALID               (AXI_09_AWVALID     )
  ,.AXI_09_RREADY                (AXI_09_RREADY      )
  ,.AXI_09_BREADY                (AXI_09_BREADY      )
  ,.AXI_09_WDATA                 (AXI_09_WDATA       )
  ,.AXI_09_WLAST                 (AXI_09_WLAST       )
  ,.AXI_09_WSTRB                 (AXI_09_WSTRB       )
  ,.AXI_09_WDATA_PARITY          (AXI_09_WDATA_PARITY_i)
  ,.AXI_09_WVALID                (AXI_09_WVALID      )
  ,.AXI_10_ACLK                  (AXI_ACLK5_st0_buf     )
  ,.AXI_10_ARESET_N              (axi_rst5_st0_n        )
  ,.AXI_10_ARADDR                (AXI_10_ARADDR      )
  ,.AXI_10_ARBURST               (AXI_10_ARBURST     )
  ,.AXI_10_ARID                  (AXI_10_ARID        )
  ,.AXI_10_ARLEN                 (AXI_10_ARLEN[3:0]  )
  ,.AXI_10_ARSIZE                (AXI_10_ARSIZE      )
  ,.AXI_10_ARVALID               (AXI_10_ARVALID     )
  ,.AXI_10_AWADDR                (AXI_10_AWADDR      )
  ,.AXI_10_AWBURST               (AXI_10_AWBURST     )
  ,.AXI_10_AWID                  (AXI_10_AWID        )
  ,.AXI_10_AWLEN                 (AXI_10_AWLEN[3:0]  )
  ,.AXI_10_AWSIZE                (AXI_10_AWSIZE      )
  ,.AXI_10_AWVALID               (AXI_10_AWVALID     )
  ,.AXI_10_RREADY                (AXI_10_RREADY      )
  ,.AXI_10_BREADY                (AXI_10_BREADY      )
  ,.AXI_10_WDATA                 (AXI_10_WDATA       )
  ,.AXI_10_WLAST                 (AXI_10_WLAST       )
  ,.AXI_10_WSTRB                 (AXI_10_WSTRB       )
  ,.AXI_10_WDATA_PARITY          (AXI_10_WDATA_PARITY_i)
  ,.AXI_10_WVALID                (AXI_10_WVALID      )
  ,.AXI_11_ACLK                  (AXI_ACLK5_st0_buf     )
  ,.AXI_11_ARESET_N              (axi_rst5_st0_n        )
  ,.AXI_11_ARADDR                (AXI_11_ARADDR      )
  ,.AXI_11_ARBURST               (AXI_11_ARBURST     )
  ,.AXI_11_ARID                  (AXI_11_ARID        )
  ,.AXI_11_ARLEN                 (AXI_11_ARLEN[3:0]  )
  ,.AXI_11_ARSIZE                (AXI_11_ARSIZE      )
  ,.AXI_11_ARVALID               (AXI_11_ARVALID     )
  ,.AXI_11_AWADDR                (AXI_11_AWADDR      )
  ,.AXI_11_AWBURST               (AXI_11_AWBURST     )
  ,.AXI_11_AWID                  (AXI_11_AWID        )
  ,.AXI_11_AWLEN                 (AXI_11_AWLEN[3:0]  )
  ,.AXI_11_AWSIZE                (AXI_11_AWSIZE      )
  ,.AXI_11_AWVALID               (AXI_11_AWVALID     )
  ,.AXI_11_RREADY                (AXI_11_RREADY      )
  ,.AXI_11_BREADY                (AXI_11_BREADY      )
  ,.AXI_11_WDATA                 (AXI_11_WDATA       )
  ,.AXI_11_WLAST                 (AXI_11_WLAST       )
  ,.AXI_11_WSTRB                 (AXI_11_WSTRB       )
  ,.AXI_11_WDATA_PARITY          (AXI_11_WDATA_PARITY_i)
  ,.AXI_11_WVALID                (AXI_11_WVALID      )
  ,.AXI_12_ACLK                  (AXI_ACLK5_st0_buf     )
  ,.AXI_12_ARESET_N              (axi_rst5_st0_n        )
  ,.AXI_12_ARADDR                (AXI_12_ARADDR      )
  ,.AXI_12_ARBURST               (AXI_12_ARBURST     )
  ,.AXI_12_ARID                  (AXI_12_ARID        )
  ,.AXI_12_ARLEN                 (AXI_12_ARLEN[3:0]  )
  ,.AXI_12_ARSIZE                (AXI_12_ARSIZE      )
  ,.AXI_12_ARVALID               (AXI_12_ARVALID     )
  ,.AXI_12_AWADDR                (AXI_12_AWADDR      )
  ,.AXI_12_AWBURST               (AXI_12_AWBURST     )
  ,.AXI_12_AWID                  (AXI_12_AWID        )
  ,.AXI_12_AWLEN                 (AXI_12_AWLEN[3:0]  )
  ,.AXI_12_AWSIZE                (AXI_12_AWSIZE      )
  ,.AXI_12_AWVALID               (AXI_12_AWVALID     )
  ,.AXI_12_RREADY                (AXI_12_RREADY      )
  ,.AXI_12_BREADY                (AXI_12_BREADY      )
  ,.AXI_12_WDATA                 (AXI_12_WDATA       )
  ,.AXI_12_WLAST                 (AXI_12_WLAST       )
  ,.AXI_12_WSTRB                 (AXI_12_WSTRB       )
  ,.AXI_12_WDATA_PARITY          (AXI_12_WDATA_PARITY_i)
  ,.AXI_12_WVALID                (AXI_12_WVALID      )
  ,.AXI_13_ACLK                  (AXI_ACLK6_st0_buf     )
  ,.AXI_13_ARESET_N              (axi_rst6_st0_n        )
  ,.AXI_13_ARADDR                (AXI_13_ARADDR      )
  ,.AXI_13_ARBURST               (AXI_13_ARBURST     )
  ,.AXI_13_ARID                  (AXI_13_ARID        )
  ,.AXI_13_ARLEN                 (AXI_13_ARLEN[3:0]  )
  ,.AXI_13_ARSIZE                (AXI_13_ARSIZE      )
  ,.AXI_13_ARVALID               (AXI_13_ARVALID     )
  ,.AXI_13_AWADDR                (AXI_13_AWADDR      )
  ,.AXI_13_AWBURST               (AXI_13_AWBURST     )
  ,.AXI_13_AWID                  (AXI_13_AWID        )
  ,.AXI_13_AWLEN                 (AXI_13_AWLEN[3:0]  )
  ,.AXI_13_AWSIZE                (AXI_13_AWSIZE      )
  ,.AXI_13_AWVALID               (AXI_13_AWVALID     )
  ,.AXI_13_RREADY                (AXI_13_RREADY      )
  ,.AXI_13_BREADY                (AXI_13_BREADY      )
  ,.AXI_13_WDATA                 (AXI_13_WDATA       )
  ,.AXI_13_WLAST                 (AXI_13_WLAST       )
  ,.AXI_13_WSTRB                 (AXI_13_WSTRB       )
  ,.AXI_13_WDATA_PARITY          (AXI_13_WDATA_PARITY_i)
  ,.AXI_13_WVALID                (AXI_13_WVALID      )
  ,.AXI_14_ACLK                  (AXI_ACLK6_st0_buf     )
  ,.AXI_14_ARESET_N              (axi_rst6_st0_n        )
  ,.AXI_14_ARADDR                (AXI_14_ARADDR      )
  ,.AXI_14_ARBURST               (AXI_14_ARBURST     )
  ,.AXI_14_ARID                  (AXI_14_ARID        )
  ,.AXI_14_ARLEN                 (AXI_14_ARLEN[3:0]  )
  ,.AXI_14_ARSIZE                (AXI_14_ARSIZE      )
  ,.AXI_14_ARVALID               (AXI_14_ARVALID     )
  ,.AXI_14_AWADDR                (AXI_14_AWADDR      )
  ,.AXI_14_AWBURST               (AXI_14_AWBURST     )
  ,.AXI_14_AWID                  (AXI_14_AWID        )
  ,.AXI_14_AWLEN                 (AXI_14_AWLEN[3:0]  )
  ,.AXI_14_AWSIZE                (AXI_14_AWSIZE      )
  ,.AXI_14_AWVALID               (AXI_14_AWVALID     )
  ,.AXI_14_RREADY                (AXI_14_RREADY      )
  ,.AXI_14_BREADY                (AXI_14_BREADY      )
  ,.AXI_14_WDATA                 (AXI_14_WDATA       )
  ,.AXI_14_WLAST                 (AXI_14_WLAST       )
  ,.AXI_14_WSTRB                 (AXI_14_WSTRB       )
  ,.AXI_14_WDATA_PARITY          (AXI_14_WDATA_PARITY_i)
  ,.AXI_14_WVALID                (AXI_14_WVALID      )
  ,.AXI_15_ACLK                  (AXI_ACLK6_st0_buf     )
  ,.AXI_15_ARESET_N              (axi_rst6_st0_n        )
  ,.AXI_15_ARADDR                (AXI_15_ARADDR      )
  ,.AXI_15_ARBURST               (AXI_15_ARBURST     )
  ,.AXI_15_ARID                  (AXI_15_ARID        )
  ,.AXI_15_ARLEN                 (AXI_15_ARLEN[3:0]  )
  ,.AXI_15_ARSIZE                (AXI_15_ARSIZE      )
  ,.AXI_15_ARVALID               (AXI_15_ARVALID     )
  ,.AXI_15_AWADDR                (AXI_15_AWADDR      )
  ,.AXI_15_AWBURST               (AXI_15_AWBURST     )
  ,.AXI_15_AWID                  (AXI_15_AWID        )
  ,.AXI_15_AWLEN                 (AXI_15_AWLEN[3:0]  )
  ,.AXI_15_AWSIZE                (AXI_15_AWSIZE      )
  ,.AXI_15_AWVALID               (AXI_15_AWVALID     )
  ,.AXI_15_RREADY                (AXI_15_RREADY      )
  ,.AXI_15_BREADY                (AXI_15_BREADY      )
  ,.AXI_15_WDATA                 (AXI_15_WDATA       )
  ,.AXI_15_WLAST                 (AXI_15_WLAST       )
  ,.AXI_15_WSTRB                 (AXI_15_WSTRB       )
  ,.AXI_15_WDATA_PARITY          (AXI_15_WDATA_PARITY_i)
  ,.AXI_15_WVALID                (AXI_15_WVALID      )

  ,.APB_0_PCLK                   (APB_0_PCLK_BUF)
  ,.APB_0_PRESET_N               (APB_0_PRESET_N)
  ,.APB_0_PWDATA                 (APB_0_PWDATA  )
  ,.APB_0_PADDR                  (APB_0_PADDR   )
  ,.APB_0_PENABLE                (APB_0_PENABLE )
  ,.APB_0_PSEL                   (APB_0_PSEL    )
  ,.APB_0_PWRITE                 (APB_0_PWRITE  )
  ,.AXI_00_ARREADY               (AXI_00_ARREADY     )
  ,.AXI_00_AWREADY               (AXI_00_AWREADY     )
  ,.AXI_00_RDATA_PARITY          (AXI_00_RDATA_PARITY)
  ,.AXI_00_RDATA                 (AXI_00_RDATA       )
  ,.AXI_00_RID                   (AXI_00_RID         )
  ,.AXI_00_RLAST                 (AXI_00_RLAST       )
  ,.AXI_00_RRESP                 (AXI_00_RRESP       )
  ,.AXI_00_RVALID                (AXI_00_RVALID      )
  ,.AXI_00_WREADY                (AXI_00_WREADY      )
  ,.AXI_00_BID                   (AXI_00_BID         )
  ,.AXI_00_BRESP                 (AXI_00_BRESP       )
  ,.AXI_00_BVALID                (AXI_00_BVALID      )
  ,.AXI_01_ARREADY               (AXI_01_ARREADY     )
  ,.AXI_01_AWREADY               (AXI_01_AWREADY     )
  ,.AXI_01_RDATA_PARITY          (AXI_01_RDATA_PARITY)
  ,.AXI_01_RDATA                 (AXI_01_RDATA       )
  ,.AXI_01_RID                   (AXI_01_RID         )
  ,.AXI_01_RLAST                 (AXI_01_RLAST       )
  ,.AXI_01_RRESP                 (AXI_01_RRESP       )
  ,.AXI_01_RVALID                (AXI_01_RVALID      )
  ,.AXI_01_WREADY                (AXI_01_WREADY      )
  ,.AXI_01_BID                   (AXI_01_BID         )
  ,.AXI_01_BRESP                 (AXI_01_BRESP       )
  ,.AXI_01_BVALID                (AXI_01_BVALID      )
  ,.AXI_02_ARREADY               (AXI_02_ARREADY     )
  ,.AXI_02_AWREADY               (AXI_02_AWREADY     )
  ,.AXI_02_RDATA_PARITY          (AXI_02_RDATA_PARITY)
  ,.AXI_02_RDATA                 (AXI_02_RDATA       )
  ,.AXI_02_RID                   (AXI_02_RID         )
  ,.AXI_02_RLAST                 (AXI_02_RLAST       )
  ,.AXI_02_RRESP                 (AXI_02_RRESP       )
  ,.AXI_02_RVALID                (AXI_02_RVALID      )
  ,.AXI_02_WREADY                (AXI_02_WREADY      )
  ,.AXI_02_BID                   (AXI_02_BID         )
  ,.AXI_02_BRESP                 (AXI_02_BRESP       )
  ,.AXI_02_BVALID                (AXI_02_BVALID      )
  ,.AXI_03_ARREADY               (AXI_03_ARREADY     )
  ,.AXI_03_AWREADY               (AXI_03_AWREADY     )
  ,.AXI_03_RDATA_PARITY          (AXI_03_RDATA_PARITY)
  ,.AXI_03_RDATA                 (AXI_03_RDATA       )
  ,.AXI_03_RID                   (AXI_03_RID         )
  ,.AXI_03_RLAST                 (AXI_03_RLAST       )
  ,.AXI_03_RRESP                 (AXI_03_RRESP       )
  ,.AXI_03_RVALID                (AXI_03_RVALID      )
  ,.AXI_03_WREADY                (AXI_03_WREADY      )
  ,.AXI_03_BID                   (AXI_03_BID         )
  ,.AXI_03_BRESP                 (AXI_03_BRESP       )
  ,.AXI_03_BVALID                (AXI_03_BVALID      )
  ,.AXI_04_ARREADY               (AXI_04_ARREADY     )
  ,.AXI_04_AWREADY               (AXI_04_AWREADY     )
  ,.AXI_04_RDATA_PARITY          (AXI_04_RDATA_PARITY)
  ,.AXI_04_RDATA                 (AXI_04_RDATA       )
  ,.AXI_04_RID                   (AXI_04_RID         )
  ,.AXI_04_RLAST                 (AXI_04_RLAST       )
  ,.AXI_04_RRESP                 (AXI_04_RRESP       )
  ,.AXI_04_RVALID                (AXI_04_RVALID      )
  ,.AXI_04_WREADY                (AXI_04_WREADY      )
  ,.AXI_04_BID                   (AXI_04_BID         )
  ,.AXI_04_BRESP                 (AXI_04_BRESP       )
  ,.AXI_04_BVALID                (AXI_04_BVALID      )
  ,.AXI_05_ARREADY               (AXI_05_ARREADY     )
  ,.AXI_05_AWREADY               (AXI_05_AWREADY     )
  ,.AXI_05_RDATA_PARITY          (AXI_05_RDATA_PARITY)
  ,.AXI_05_RDATA                 (AXI_05_RDATA       )
  ,.AXI_05_RID                   (AXI_05_RID         )
  ,.AXI_05_RLAST                 (AXI_05_RLAST       )
  ,.AXI_05_RRESP                 (AXI_05_RRESP       )
  ,.AXI_05_RVALID                (AXI_05_RVALID      )
  ,.AXI_05_WREADY                (AXI_05_WREADY      )
  ,.AXI_05_BID                   (AXI_05_BID         )
  ,.AXI_05_BRESP                 (AXI_05_BRESP       )
  ,.AXI_05_BVALID                (AXI_05_BVALID      )
  ,.AXI_06_ARREADY               (AXI_06_ARREADY     )
  ,.AXI_06_AWREADY               (AXI_06_AWREADY     )
  ,.AXI_06_RDATA_PARITY          (AXI_06_RDATA_PARITY)
  ,.AXI_06_RDATA                 (AXI_06_RDATA       )
  ,.AXI_06_RID                   (AXI_06_RID         )
  ,.AXI_06_RLAST                 (AXI_06_RLAST       )
  ,.AXI_06_RRESP                 (AXI_06_RRESP       )
  ,.AXI_06_RVALID                (AXI_06_RVALID      )
  ,.AXI_06_WREADY                (AXI_06_WREADY      )
  ,.AXI_06_BID                   (AXI_06_BID         )
  ,.AXI_06_BRESP                 (AXI_06_BRESP       )
  ,.AXI_06_BVALID                (AXI_06_BVALID      )
  ,.AXI_07_ARREADY               (AXI_07_ARREADY     )
  ,.AXI_07_AWREADY               (AXI_07_AWREADY     )
  ,.AXI_07_RDATA_PARITY          (AXI_07_RDATA_PARITY)
  ,.AXI_07_RDATA                 (AXI_07_RDATA       )
  ,.AXI_07_RID                   (AXI_07_RID         )
  ,.AXI_07_RLAST                 (AXI_07_RLAST       )
  ,.AXI_07_RRESP                 (AXI_07_RRESP       )
  ,.AXI_07_RVALID                (AXI_07_RVALID      )
  ,.AXI_07_WREADY                (AXI_07_WREADY      )
  ,.AXI_07_BID                   (AXI_07_BID         )
  ,.AXI_07_BRESP                 (AXI_07_BRESP       )
  ,.AXI_07_BVALID                (AXI_07_BVALID      )
  ,.AXI_08_ARREADY               (AXI_08_ARREADY     )
  ,.AXI_08_AWREADY               (AXI_08_AWREADY     )
  ,.AXI_08_RDATA_PARITY          (AXI_08_RDATA_PARITY)
  ,.AXI_08_RDATA                 (AXI_08_RDATA       )
  ,.AXI_08_RID                   (AXI_08_RID         )
  ,.AXI_08_RLAST                 (AXI_08_RLAST       )
  ,.AXI_08_RRESP                 (AXI_08_RRESP       )
  ,.AXI_08_RVALID                (AXI_08_RVALID      )
  ,.AXI_08_WREADY                (AXI_08_WREADY      )
  ,.AXI_08_BID                   (AXI_08_BID         )
  ,.AXI_08_BRESP                 (AXI_08_BRESP       )
  ,.AXI_08_BVALID                (AXI_08_BVALID      )
  ,.AXI_09_ARREADY               (AXI_09_ARREADY     )
  ,.AXI_09_AWREADY               (AXI_09_AWREADY     )
  ,.AXI_09_RDATA_PARITY          (AXI_09_RDATA_PARITY)
  ,.AXI_09_RDATA                 (AXI_09_RDATA       )
  ,.AXI_09_RID                   (AXI_09_RID         )
  ,.AXI_09_RLAST                 (AXI_09_RLAST       )
  ,.AXI_09_RRESP                 (AXI_09_RRESP       )
  ,.AXI_09_RVALID                (AXI_09_RVALID      )
  ,.AXI_09_WREADY                (AXI_09_WREADY      )
  ,.AXI_09_BID                   (AXI_09_BID         )
  ,.AXI_09_BRESP                 (AXI_09_BRESP       )
  ,.AXI_09_BVALID                (AXI_09_BVALID      )
  ,.AXI_10_ARREADY               (AXI_10_ARREADY     )
  ,.AXI_10_AWREADY               (AXI_10_AWREADY     )
  ,.AXI_10_RDATA_PARITY          (AXI_10_RDATA_PARITY)
  ,.AXI_10_RDATA                 (AXI_10_RDATA       )
  ,.AXI_10_RID                   (AXI_10_RID         )
  ,.AXI_10_RLAST                 (AXI_10_RLAST       )
  ,.AXI_10_RRESP                 (AXI_10_RRESP       )
  ,.AXI_10_RVALID                (AXI_10_RVALID      )
  ,.AXI_10_WREADY                (AXI_10_WREADY      )
  ,.AXI_10_BID                   (AXI_10_BID         )
  ,.AXI_10_BRESP                 (AXI_10_BRESP       )
  ,.AXI_10_BVALID                (AXI_10_BVALID      )
  ,.AXI_11_ARREADY               (AXI_11_ARREADY     )
  ,.AXI_11_AWREADY               (AXI_11_AWREADY     )
  ,.AXI_11_RDATA_PARITY          (AXI_11_RDATA_PARITY)
  ,.AXI_11_RDATA                 (AXI_11_RDATA       )
  ,.AXI_11_RID                   (AXI_11_RID         )
  ,.AXI_11_RLAST                 (AXI_11_RLAST       )
  ,.AXI_11_RRESP                 (AXI_11_RRESP       )
  ,.AXI_11_RVALID                (AXI_11_RVALID      )
  ,.AXI_11_WREADY                (AXI_11_WREADY      )
  ,.AXI_11_BID                   (AXI_11_BID         )
  ,.AXI_11_BRESP                 (AXI_11_BRESP       )
  ,.AXI_11_BVALID                (AXI_11_BVALID      )
  ,.AXI_12_ARREADY               (AXI_12_ARREADY     )
  ,.AXI_12_AWREADY               (AXI_12_AWREADY     )
  ,.AXI_12_RDATA_PARITY          (AXI_12_RDATA_PARITY)
  ,.AXI_12_RDATA                 (AXI_12_RDATA       )
  ,.AXI_12_RID                   (AXI_12_RID         )
  ,.AXI_12_RLAST                 (AXI_12_RLAST       )
  ,.AXI_12_RRESP                 (AXI_12_RRESP       )
  ,.AXI_12_RVALID                (AXI_12_RVALID      )
  ,.AXI_12_WREADY                (AXI_12_WREADY      )
  ,.AXI_12_BID                   (AXI_12_BID         )
  ,.AXI_12_BRESP                 (AXI_12_BRESP       )
  ,.AXI_12_BVALID                (AXI_12_BVALID      )
  ,.AXI_13_ARREADY               (AXI_13_ARREADY     )
  ,.AXI_13_AWREADY               (AXI_13_AWREADY     )
  ,.AXI_13_RDATA_PARITY          (AXI_13_RDATA_PARITY)
  ,.AXI_13_RDATA                 (AXI_13_RDATA       )
  ,.AXI_13_RID                   (AXI_13_RID         )
  ,.AXI_13_RLAST                 (AXI_13_RLAST       )
  ,.AXI_13_RRESP                 (AXI_13_RRESP       )
  ,.AXI_13_RVALID                (AXI_13_RVALID      )
  ,.AXI_13_WREADY                (AXI_13_WREADY      )
  ,.AXI_13_BID                   (AXI_13_BID         )
  ,.AXI_13_BRESP                 (AXI_13_BRESP       )
  ,.AXI_13_BVALID                (AXI_13_BVALID      )
  ,.AXI_14_ARREADY               (AXI_14_ARREADY     )
  ,.AXI_14_AWREADY               (AXI_14_AWREADY     )
  ,.AXI_14_RDATA_PARITY          (AXI_14_RDATA_PARITY)
  ,.AXI_14_RDATA                 (AXI_14_RDATA       )
  ,.AXI_14_RID                   (AXI_14_RID         )
  ,.AXI_14_RLAST                 (AXI_14_RLAST       )
  ,.AXI_14_RRESP                 (AXI_14_RRESP       )
  ,.AXI_14_RVALID                (AXI_14_RVALID      )
  ,.AXI_14_WREADY                (AXI_14_WREADY      )
  ,.AXI_14_BID                   (AXI_14_BID         )
  ,.AXI_14_BRESP                 (AXI_14_BRESP       )
  ,.AXI_14_BVALID                (AXI_14_BVALID      )
  ,.AXI_15_ARREADY               (AXI_15_ARREADY     )
  ,.AXI_15_AWREADY               (AXI_15_AWREADY     )
  ,.AXI_15_RDATA_PARITY          (AXI_15_RDATA_PARITY)
  ,.AXI_15_RDATA                 (AXI_15_RDATA       )
  ,.AXI_15_RID                   (AXI_15_RID         )
  ,.AXI_15_RLAST                 (AXI_15_RLAST       )
  ,.AXI_15_RRESP                 (AXI_15_RRESP       )
  ,.AXI_15_RVALID                (AXI_15_RVALID      )
  ,.AXI_15_WREADY                (AXI_15_WREADY      )
  ,.AXI_15_BID                   (AXI_15_BID         )
  ,.AXI_15_BRESP                 (AXI_15_BRESP       )
  ,.AXI_15_BVALID                (AXI_15_BVALID      )
  ,.apb_complete_0               (apb_seq_complete_0_s)
  ,.APB_0_PRDATA                 (APB_0_PRDATA )
  ,.APB_0_PREADY                 (APB_0_PREADY )
  ,.APB_0_PSLVERR                (APB_0_PSLVERR)

  ,.DRAM_0_STAT_CATTRIP          (DRAM_0_STAT_CATTRIP)
  ,.DRAM_0_STAT_TEMP             (DRAM_0_STAT_TEMP   )
);

////////////////////////////////////////////////////////////////////////////////
// Instantiating Square root Design
////////////////////////////////////////////////////////////////////////////////
wire [63:0]                   sr_din[0:15];
wire [63:0]                   sr_dout[0:15];
wire                          sr_done[0:15];
wire                          sr_newd[0:15];
wire [I_WIDTH-1:0]            sr_din_0[0:15];
wire [O_WIDTH-1:0]            sr_dout_0[0:15];

genvar num_sr;
generate
  for (num_sr = 0; num_sr < 16; num_sr = num_sr + 1) begin
    assign sr_dout[num_sr] = {{(64-O_WIDTH){1'b0}}, sr_dout_0[num_sr]};
    assign sr_din_0[num_sr] = sr_din[num_sr][I_WIDTH-1:0];
  end
endgenerate

sr_top #(
  .I_WIDTH(I_WIDTH)
) u_sr_top(
  .clk0         (AXI_ACLK0_st0_buf),
  .clk1         (AXI_ACLK1_st0_buf),
  .clk2         (AXI_ACLK2_st0_buf),
  .clk3         (AXI_ACLK3_st0_buf),
  .clk4         (AXI_ACLK4_st0_buf),
  .clk5         (AXI_ACLK5_st0_buf),
  .clk6         (AXI_ACLK6_st0_buf),
  .rst0_n       (axi_rst0_st0_n),
  .rst1_n       (axi_rst1_st0_n),
  .rst2_n       (axi_rst2_st0_n),
  .rst3_n       (axi_rst3_st0_n),
  .rst4_n       (axi_rst4_st0_n),
  .rst5_n       (axi_rst5_st0_n),
  .rst6_n       (axi_rst6_st0_n),
  .en           (1),
  .din          (sr_din_0),
  .newd         (sr_newd),
  .dout         (sr_dout_0),
  .done         (sr_done)
);
// squareroot #(.I_WIDTH(I_WIDTH)) u_squareroot(.clk(AXI_ACLK0_st0_buf), .rst(~axi_rst0_st0_n), .en(1), .din(sr_din[I_WIDTH-1:0]),.newd(sr_newd), .dout(sr_dout_0), .done(sr_done));

always @ (posedge AXI_ACLK0_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    apb_seq_complete_0_st0_r0 <= 1'b0;
    apb_seq_complete_0_st0_r1 <= 1'b0;
    apb_seq_complete_0_st0_r2 <= 1'b0;
  end else begin
    apb_seq_complete_0_st0_r0 <= apb_seq_complete_0_s;
    apb_seq_complete_0_st0_r1 <= apb_seq_complete_0_st0_r0;
    apb_seq_complete_0_st0_r2 <= apb_seq_complete_0_st0_r1;
  end
end

assign tg_start_st0_0 = apb_seq_complete_0_st0_r1 && ~(apb_seq_complete_0_st0_r2);

always @ (posedge AXI_ACLK1_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    apb_seq_complete_1_st0_r0 <= 1'b0;
    apb_seq_complete_1_st0_r1 <= 1'b0;
    apb_seq_complete_1_st0_r2 <= 1'b0;
  end else begin
    apb_seq_complete_1_st0_r0 <= apb_seq_complete_0_s;
    apb_seq_complete_1_st0_r1 <= apb_seq_complete_1_st0_r0;
    apb_seq_complete_1_st0_r2 <= apb_seq_complete_1_st0_r1;
  end
end

assign tg_start_st0_1 = apb_seq_complete_1_st0_r1 && ~(apb_seq_complete_1_st0_r2);

always @ (posedge AXI_ACLK2_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    apb_seq_complete_2_st0_r0 <= 1'b0;
    apb_seq_complete_2_st0_r1 <= 1'b0;
    apb_seq_complete_2_st0_r2 <= 1'b0;
  end else begin
    apb_seq_complete_2_st0_r0 <= apb_seq_complete_0_s;
    apb_seq_complete_2_st0_r1 <= apb_seq_complete_2_st0_r0;
    apb_seq_complete_2_st0_r2 <= apb_seq_complete_2_st0_r1;
  end
end

assign tg_start_st0_2 = apb_seq_complete_2_st0_r1 && ~(apb_seq_complete_2_st0_r2);

always @ (posedge AXI_ACLK3_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    apb_seq_complete_3_st0_r0 <= 1'b0;
    apb_seq_complete_3_st0_r1 <= 1'b0;
    apb_seq_complete_3_st0_r2 <= 1'b0;
  end else begin
    apb_seq_complete_3_st0_r0 <= apb_seq_complete_0_s;
    apb_seq_complete_3_st0_r1 <= apb_seq_complete_3_st0_r0;
    apb_seq_complete_3_st0_r2 <= apb_seq_complete_3_st0_r1;
  end
end

assign tg_start_st0_3 = apb_seq_complete_3_st0_r1 && ~(apb_seq_complete_3_st0_r2);

always @ (posedge AXI_ACLK4_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    apb_seq_complete_4_st0_r0 <= 1'b0;
    apb_seq_complete_4_st0_r1 <= 1'b0;
    apb_seq_complete_4_st0_r2 <= 1'b0;
  end else begin
    apb_seq_complete_4_st0_r0 <= apb_seq_complete_0_s;
    apb_seq_complete_4_st0_r1 <= apb_seq_complete_4_st0_r0;
    apb_seq_complete_4_st0_r2 <= apb_seq_complete_4_st0_r1;
  end
end

assign tg_start_st0_4 = apb_seq_complete_4_st0_r1 && ~(apb_seq_complete_4_st0_r2);

always @ (posedge AXI_ACLK5_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    apb_seq_complete_5_st0_r0 <= 1'b0;
    apb_seq_complete_5_st0_r1 <= 1'b0;
    apb_seq_complete_5_st0_r2 <= 1'b0;
  end else begin
    apb_seq_complete_5_st0_r0 <= apb_seq_complete_0_s;
    apb_seq_complete_5_st0_r1 <= apb_seq_complete_5_st0_r0;
    apb_seq_complete_5_st0_r2 <= apb_seq_complete_5_st0_r1;
  end
end

assign tg_start_st0_5 = apb_seq_complete_5_st0_r1 && ~(apb_seq_complete_5_st0_r2);

always @ (posedge AXI_ACLK6_st0_buf or negedge AXI_ARESET_N_0) begin
  if (~AXI_ARESET_N_0) begin
    apb_seq_complete_6_st0_r0 <= 1'b0;
    apb_seq_complete_6_st0_r1 <= 1'b0;
    apb_seq_complete_6_st0_r2 <= 1'b0;
  end else begin
    apb_seq_complete_6_st0_r0 <= apb_seq_complete_0_s;
    apb_seq_complete_6_st0_r1 <= apb_seq_complete_6_st0_r0;
    apb_seq_complete_6_st0_r2 <= apb_seq_complete_6_st0_r1;
  end
end

assign tg_start_st0_6 = apb_seq_complete_6_st0_r1 && ~(apb_seq_complete_6_st0_r2);


////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 0
////////////////////////////////////////////////////////////////////////////////
// assign AXI_00_ARADDR = {vio_tg_glb_start_addr_0[32:28],o_m_axi_araddr_0[27:0]};
// assign AXI_00_AWADDR = {vio_tg_glb_start_addr_0[32:28],o_m_axi_awaddr_0[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_0 (
  .sr_done                             (sr_done[0]),
  .sr_newd                             (sr_newd[0]),
  .sr_din                              (sr_din[0]),
  .sr_dout                             (sr_dout[0]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK0_st0_buf),
  .i_rst                               (~axi_rst0_st0_n),
  .i_init_calib_complete               (apb_seq_complete_0_st0_r2),
  .compare_error                       (axi_00_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_0),
  .vio_tg_start                        (vio_tg_start_0),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_0),
  .vio_tg_err_clear                    (vio_tg_err_clear_0),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_0),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_0),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_0),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_0),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_0),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_0),
  .vio_tg_restart                      (vio_tg_restart_0),
  .vio_tg_pause                        (vio_tg_pause_0),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_0),
  .vio_tg_err_continue                 (vio_tg_err_continue_0),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_0),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_0),
  .vio_tg_instr_num                    (vio_tg_instr_num_0),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_0),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_0),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_0),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_0),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_0),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_0),
  .vio_tg_seed_num                     (vio_tg_seed_num_0),
  .vio_tg_seed                         (vio_tg_seed_0),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_0),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_0),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_0),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_0),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_0),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_0),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_0),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_0),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_0),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_0),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_0),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_0),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_0),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_0),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_0),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_0),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_0),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_0),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_0),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_0),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_0),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_0),
  .vio_tg_status_err_type              (vio_tg_status_err_type_0),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_0),
  .vio_tg_status_done                  (boot_mode_done_0),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_0),
  .tg_ila_debug                        (tg_ila_debug_0),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_00_AWREADY),
  .o_m_axi_awid                        (AXI_00_AWID),
  .o_m_axi_awaddr                      (AXI_00_AWADDR),
  .o_m_axi_awlen                       (AXI_00_AWLEN),
  .o_m_axi_awsize                      (AXI_00_AWSIZE),
  .o_m_axi_awburst                     (AXI_00_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_00_AWCACHE),
  .o_m_axi_awprot                      (AXI_00_AWPROT),
  .o_m_axi_awvalid                     (AXI_00_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_00_WREADY),
  .o_m_axi_wdata                       (AXI_00_WDATA),
  .o_m_axi_wstrb                       (AXI_00_WSTRB),
  .o_m_axi_wlast                       (AXI_00_WLAST),
  .o_m_axi_wvalid                      (AXI_00_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_00_BID),
  .i_m_axi_bresp                       (AXI_00_BRESP),
  .i_m_axi_bvalid                      (AXI_00_BVALID),
  .o_m_axi_bready                      (AXI_00_BREADY),
  .i_m_axi_arready                     (AXI_00_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_00_ARID),
  .o_m_axi_araddr                      (AXI_00_ARADDR),
  .o_m_axi_arlen                       (AXI_00_ARLEN),
  .o_m_axi_arsize                      (AXI_00_ARSIZE),
  .o_m_axi_arburst                     (AXI_00_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_00_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_00_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_00_RID),
  .i_m_axi_rresp                       (AXI_00_RRESP),
  .i_m_axi_rvalid                      (AXI_00_RVALID),
  .i_m_axi_rdata                       (AXI_00_RDATA),
  .i_m_axi_rlast                       (AXI_00_RLAST),
  .o_m_axi_rready                      (AXI_00_RREADY)
);

assign  vio_tg_rst_0 =  1'd0;
assign  i_force_vio_tg_status_done_0 = 16'h0000;
assign  i_vio_enable_atg_axi_x_0 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_0 =  16'hffff;
assign  vio_tg_restart_0 =  'd0;
assign  vio_tg_err_chk_en_0 =  'd0;
assign  vio_tg_err_clear_0 =  'd0;
assign  vio_tg_err_clear_all_0 =  'd0;
assign  vio_tg_err_continue_0 =  'd0;
assign  vio_tg_instr_program_en_0 =  'd0;
assign  vio_tg_direct_instr_en_0 =  'd0;
assign  vio_tg_instr_num_0 =  'd0;
assign  vio_tg_instr_addr_mode_0 =  'd0;
assign  vio_tg_instr_data_mode_0 =  'd0;
assign  vio_tg_instr_rw_mode_0 =  'd0;
assign  vio_tg_instr_rw_submode_0 =  'd0;
assign  vio_tg_instr_victim_mode_0 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_0 =  'd0;
assign  vio_tg_instr_victim_select_0 =  'd0;
assign  vio_tg_instr_num_of_iter_0 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_0 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_0 =  'd0;
assign  vio_tg_instr_nxt_instr_0 =  'd0;
assign  vio_tg_seed_program_en_0 =  'd0;
assign  vio_tg_seed_num_0 =  'd0;
assign  vio_tg_seed_0 =  'd0;
assign  vio_tg_glb_victim_bit_0 =  'd0;
assign  vio_tg_glb_start_addr_0 = 33'h0_0000_0000;

always@(posedge AXI_ACLK0_st0_buf or negedge axi_rst0_st0_n) begin
  if (~axi_rst0_st0_n) begin
    rd_cnt_00 <= 5'b0;
  end else if (AXI_00_RVALID && AXI_00_RREADY) begin
    rd_cnt_00 <= rd_cnt_00 + 1'b1;
  end
end

always@(posedge AXI_ACLK0_st0_buf or negedge axi_rst0_st0_n) begin
  if (~axi_rst0_st0_n) begin
    wr_cnt_00 <= 5'b0;
  end else if (AXI_00_BVALID && AXI_00_BREADY) begin
    wr_cnt_00 <= wr_cnt_00 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 0
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (0)
) u_axi_pmon_0 (
  .axi_arst_n              (axi_rst0_st0_n    ),
  .axi_aclk                (AXI_ACLK0_st0_buf ),
  .axi_awid                (AXI_00_AWID),
  .axi_awaddr              (AXI_00_AWADDR),
  .axi_awlen               (AXI_00_AWLEN),
  .axi_awsize              (AXI_00_AWSIZE),
  .axi_awburst             (AXI_00_AWBURST),
  .axi_awcache             (AXI_00_AWCACHE),
  .axi_awprot              (AXI_00_AWPROT),
  .axi_awvalid             (AXI_00_AWVALID),
  .axi_awready             (AXI_00_AWREADY),
  .axi_wdata               (AXI_00_WDATA),
  .axi_wstrb               (AXI_00_WSTRB),
  .axi_wlast               (AXI_00_WLAST),
  .axi_wvalid              (AXI_00_WVALID),
  .axi_wready              (AXI_00_WREADY),
  .axi_bready              (AXI_00_BREADY),
  .axi_bid                 (AXI_00_BID),
  .axi_bresp               (AXI_00_BRESP),
  .axi_bvalid              (AXI_00_BVALID),
  .axi_arid                (AXI_00_ARID),
  .axi_araddr              (AXI_00_ARADDR),
  .axi_arlen               (AXI_00_ARLEN),
  .axi_arsize              (AXI_00_ARSIZE),
  .axi_arburst             (AXI_00_ARBURST),
  .axi_arcache             (AXI_00_ARCACHE),
  .axi_arvalid             (AXI_00_ARVALID),
  .axi_arready             (AXI_00_ARREADY),
  .axi_rready              (AXI_00_RREADY),
  .axi_rid                 (AXI_00_RID),
  .axi_rdata               (AXI_00_RDATA),
  .axi_rresp               (AXI_00_RRESP),
  .axi_rlast               (AXI_00_RLAST),
  .axi_rvalid              (AXI_00_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 1
////////////////////////////////////////////////////////////////////////////////
// assign AXI_01_ARADDR = {vio_tg_glb_start_addr_1[32:28],o_m_axi_araddr_1[27:0]};
// assign AXI_01_AWADDR = {vio_tg_glb_start_addr_1[32:28],o_m_axi_awaddr_1[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_1 (
  .sr_done                             (sr_done[1]),
  .sr_newd                             (sr_newd[1]),
  .sr_din                              (sr_din[1]),
  .sr_dout                             (sr_dout[1]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK0_st0_buf),
  .i_rst                               (~axi_rst0_st0_n),
  .i_init_calib_complete               (apb_seq_complete_0_st0_r2),
  .compare_error                       (axi_01_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_1),
  .vio_tg_start                        (vio_tg_start_1),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_1),
  .vio_tg_err_clear                    (vio_tg_err_clear_1),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_1),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_1),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_1),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_1),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_1),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_1),
  .vio_tg_restart                      (vio_tg_restart_1),
  .vio_tg_pause                        (vio_tg_pause_1),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_1),
  .vio_tg_err_continue                 (vio_tg_err_continue_1),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_1),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_1),
  .vio_tg_instr_num                    (vio_tg_instr_num_1),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_1),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_1),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_1),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_1),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_1),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_1),
  .vio_tg_seed_num                     (vio_tg_seed_num_1),
  .vio_tg_seed                         (vio_tg_seed_1),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_1),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_1),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_1),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_1),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_1),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_1),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_1),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_1),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_1),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_1),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_1),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_1),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_1),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_1),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_1),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_1),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_1),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_1),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_1),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_1),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_1),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_1),
  .vio_tg_status_err_type              (vio_tg_status_err_type_1),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_1),
  .vio_tg_status_done                  (boot_mode_done_1),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_1),
  .tg_ila_debug                        (tg_ila_debug_1),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_01_AWREADY),
  .o_m_axi_awid                        (AXI_01_AWID),
  .o_m_axi_awaddr                      (AXI_01_AWADDR),
  .o_m_axi_awlen                       (AXI_01_AWLEN),
  .o_m_axi_awsize                      (AXI_01_AWSIZE),
  .o_m_axi_awburst                     (AXI_01_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_01_AWCACHE),
  .o_m_axi_awprot                      (AXI_01_AWPROT),
  .o_m_axi_awvalid                     (AXI_01_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_01_WREADY),
  .o_m_axi_wdata                       (AXI_01_WDATA),
  .o_m_axi_wstrb                       (AXI_01_WSTRB),
  .o_m_axi_wlast                       (AXI_01_WLAST),
  .o_m_axi_wvalid                      (AXI_01_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_01_BID),
  .i_m_axi_bresp                       (AXI_01_BRESP),
  .i_m_axi_bvalid                      (AXI_01_BVALID),
  .o_m_axi_bready                      (AXI_01_BREADY),
  .i_m_axi_arready                     (AXI_01_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_01_ARID),
  .o_m_axi_araddr                      (AXI_01_ARADDR),
  .o_m_axi_arlen                       (AXI_01_ARLEN),
  .o_m_axi_arsize                      (AXI_01_ARSIZE),
  .o_m_axi_arburst                     (AXI_01_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_01_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_01_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_01_RID),
  .i_m_axi_rresp                       (AXI_01_RRESP),
  .i_m_axi_rvalid                      (AXI_01_RVALID),
  .i_m_axi_rdata                       (AXI_01_RDATA),
  .i_m_axi_rlast                       (AXI_01_RLAST),
  .o_m_axi_rready                      (AXI_01_RREADY)
);

assign  vio_tg_rst_1 =  1'd0;
assign  i_force_vio_tg_status_done_1 = 16'h0000;
assign  i_vio_enable_atg_axi_x_1 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_1 =  16'hffff;
assign  vio_tg_restart_1 =  'd0;
assign  vio_tg_err_chk_en_1 =  'd0;
assign  vio_tg_err_clear_1 =  'd0;
assign  vio_tg_err_clear_all_1 =  'd0;
assign  vio_tg_err_continue_1 =  'd0;
assign  vio_tg_instr_program_en_1 =  'd0;
assign  vio_tg_direct_instr_en_1 =  'd0;
assign  vio_tg_instr_num_1 =  'd0;
assign  vio_tg_instr_addr_mode_1 =  'd0;
assign  vio_tg_instr_data_mode_1 =  'd0;
assign  vio_tg_instr_rw_mode_1 =  'd0;
assign  vio_tg_instr_rw_submode_1 =  'd0;
assign  vio_tg_instr_victim_mode_1 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_1 =  'd0;
assign  vio_tg_instr_victim_select_1 =  'd0;
assign  vio_tg_instr_num_of_iter_1 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_1 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_1 =  'd0;
assign  vio_tg_instr_nxt_instr_1 =  'd0;
assign  vio_tg_seed_program_en_1 =  'd0;
assign  vio_tg_seed_num_1 =  'd0;
assign  vio_tg_seed_1 =  'd0;
assign  vio_tg_glb_start_addr_1 = 33'h0_1000_0000;

always@(posedge AXI_ACLK0_st0_buf or negedge axi_rst0_st0_n) begin
  if (~axi_rst0_st0_n) begin
    rd_cnt_01 <= 5'b0;
  end else if (AXI_01_RVALID && AXI_01_RREADY) begin
    rd_cnt_01 <= rd_cnt_01 + 1'b1;
  end
end

always@(posedge AXI_ACLK0_st0_buf or negedge axi_rst0_st0_n) begin
  if (~axi_rst0_st0_n) begin
    wr_cnt_01 <= 5'b0;
  end else if (AXI_01_BVALID && AXI_01_BREADY) begin
    wr_cnt_01 <= wr_cnt_01 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 1
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (1)
) u_axi_pmon_1 (
  .axi_arst_n              (axi_rst0_st0_n    ),
  .axi_aclk                (AXI_ACLK0_st0_buf ),
  .axi_awid                (AXI_01_AWID),
  .axi_awaddr              (AXI_01_AWADDR),
  .axi_awlen               (AXI_01_AWLEN),
  .axi_awsize              (AXI_01_AWSIZE),
  .axi_awburst             (AXI_01_AWBURST),
  .axi_awcache             (AXI_01_AWCACHE),
  .axi_awprot              (AXI_01_AWPROT),
  .axi_awvalid             (AXI_01_AWVALID),
  .axi_awready             (AXI_01_AWREADY),
  .axi_wdata               (AXI_01_WDATA),
  .axi_wstrb               (AXI_01_WSTRB),
  .axi_wlast               (AXI_01_WLAST),
  .axi_wvalid              (AXI_01_WVALID),
  .axi_wready              (AXI_01_WREADY),
  .axi_bready              (AXI_01_BREADY),
  .axi_bid                 (AXI_01_BID),
  .axi_bresp               (AXI_01_BRESP),
  .axi_bvalid              (AXI_01_BVALID),
  .axi_arid                (AXI_01_ARID),
  .axi_araddr              (AXI_01_ARADDR),
  .axi_arlen               (AXI_01_ARLEN),
  .axi_arsize              (AXI_01_ARSIZE),
  .axi_arburst             (AXI_01_ARBURST),
  .axi_arcache             (AXI_01_ARCACHE),
  .axi_arvalid             (AXI_01_ARVALID),
  .axi_arready             (AXI_01_ARREADY),
  .axi_rready              (AXI_01_RREADY),
  .axi_rid                 (AXI_01_RID),
  .axi_rdata               (AXI_01_RDATA),
  .axi_rresp               (AXI_01_RRESP),
  .axi_rlast               (AXI_01_RLAST),
  .axi_rvalid              (AXI_01_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 2
////////////////////////////////////////////////////////////////////////////////
// assign AXI_02_ARADDR = {vio_tg_glb_start_addr_2[32:28],o_m_axi_araddr_2[27:0]};
// assign AXI_02_AWADDR = {vio_tg_glb_start_addr_2[32:28],o_m_axi_awaddr_2[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_2 (
  .sr_done                             (sr_done[2]),
  .sr_newd                             (sr_newd[2]),
  .sr_din                              (sr_din[2]),
  .sr_dout                             (sr_dout[2]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK1_st0_buf),
  .i_rst                               (~axi_rst1_st0_n),
  .i_init_calib_complete               (apb_seq_complete_1_st0_r2),
  .compare_error                       (axi_02_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_2),
  .vio_tg_start                        (vio_tg_start_2),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_2),
  .vio_tg_err_clear                    (vio_tg_err_clear_2),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_2),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_2),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_2),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_2),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_2),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_2),
  .vio_tg_restart                      (vio_tg_restart_2),
  .vio_tg_pause                        (vio_tg_pause_2),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_2),
  .vio_tg_err_continue                 (vio_tg_err_continue_2),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_2),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_2),
  .vio_tg_instr_num                    (vio_tg_instr_num_2),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_2),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_2),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_2),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_2),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_2),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_2),
  .vio_tg_seed_num                     (vio_tg_seed_num_2),
  .vio_tg_seed                         (vio_tg_seed_2),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_2),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_2),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_2),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_2),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_2),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_2),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_2),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_2),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_2),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_2),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_2),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_2),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_2),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_2),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_2),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_2),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_2),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_2),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_2),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_2),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_2),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_2),
  .vio_tg_status_err_type              (vio_tg_status_err_type_2),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_2),
  .vio_tg_status_done                  (boot_mode_done_2),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_2),
  .tg_ila_debug                        (tg_ila_debug_2),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_02_AWREADY),
  .o_m_axi_awid                        (AXI_02_AWID),
  .o_m_axi_awaddr                      (AXI_02_AWADDR),
  .o_m_axi_awlen                       (AXI_02_AWLEN),
  .o_m_axi_awsize                      (AXI_02_AWSIZE),
  .o_m_axi_awburst                     (AXI_02_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_02_AWCACHE),
  .o_m_axi_awprot                      (AXI_02_AWPROT),
  .o_m_axi_awvalid                     (AXI_02_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_02_WREADY),
  .o_m_axi_wdata                       (AXI_02_WDATA),
  .o_m_axi_wstrb                       (AXI_02_WSTRB),
  .o_m_axi_wlast                       (AXI_02_WLAST),
  .o_m_axi_wvalid                      (AXI_02_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_02_BID),
  .i_m_axi_bresp                       (AXI_02_BRESP),
  .i_m_axi_bvalid                      (AXI_02_BVALID),
  .o_m_axi_bready                      (AXI_02_BREADY),
  .i_m_axi_arready                     (AXI_02_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_02_ARID),
  .o_m_axi_araddr                      (AXI_02_ARADDR),
  .o_m_axi_arlen                       (AXI_02_ARLEN),
  .o_m_axi_arsize                      (AXI_02_ARSIZE),
  .o_m_axi_arburst                     (AXI_02_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_02_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_02_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_02_RID),
  .i_m_axi_rresp                       (AXI_02_RRESP),
  .i_m_axi_rvalid                      (AXI_02_RVALID),
  .i_m_axi_rdata                       (AXI_02_RDATA),
  .i_m_axi_rlast                       (AXI_02_RLAST),
  .o_m_axi_rready                      (AXI_02_RREADY)
);

assign  vio_tg_rst_2 =  1'd0;
assign  i_force_vio_tg_status_done_2 = 16'h0000;
assign  i_vio_enable_atg_axi_x_2 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_2 =  16'hffff;
assign  vio_tg_restart_2 =  'd0;
assign  vio_tg_err_chk_en_2 =  'd0;
assign  vio_tg_err_clear_2 =  'd0;
assign  vio_tg_err_clear_all_2 =  'd0;
assign  vio_tg_err_continue_2 =  'd0;
assign  vio_tg_instr_program_en_2 =  'd0;
assign  vio_tg_direct_instr_en_2 =  'd0;
assign  vio_tg_instr_num_2 =  'd0;
assign  vio_tg_instr_addr_mode_2 =  'd0;
assign  vio_tg_instr_data_mode_2 =  'd0;
assign  vio_tg_instr_rw_mode_2 =  'd0;
assign  vio_tg_instr_rw_submode_2 =  'd0;
assign  vio_tg_instr_victim_mode_2 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_2 =  'd0;
assign  vio_tg_instr_victim_select_2 =  'd0;
assign  vio_tg_instr_num_of_iter_2 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_2 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_2 =  'd0;
assign  vio_tg_instr_nxt_instr_2 =  'd0;
assign  vio_tg_seed_program_en_2 =  'd0;
assign  vio_tg_seed_num_2 =  'd0;
assign  vio_tg_seed_2 =  'd0;
assign  vio_tg_glb_start_addr_2 = 33'h0_2000_0000;

always@(posedge AXI_ACLK1_st0_buf or negedge axi_rst1_st0_n) begin
  if (~axi_rst1_st0_n) begin
    rd_cnt_02 <= 5'b0;
  end else if (AXI_02_RVALID && AXI_02_RREADY) begin
    rd_cnt_02 <= rd_cnt_02 + 1'b1;
  end
end

always@(posedge AXI_ACLK1_st0_buf or negedge axi_rst1_st0_n) begin
  if (~axi_rst1_st0_n) begin
    wr_cnt_02 <= 5'b0;
  end else if (AXI_02_BVALID && AXI_02_BREADY) begin
    wr_cnt_02 <= wr_cnt_02 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 2
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (2)
) u_axi_pmon_2 (
  .axi_arst_n              (axi_rst1_st0_n    ),
  .axi_aclk                (AXI_ACLK1_st0_buf ),
  .axi_awid                (AXI_02_AWID),
  .axi_awaddr              (AXI_02_AWADDR),
  .axi_awlen               (AXI_02_AWLEN),
  .axi_awsize              (AXI_02_AWSIZE),
  .axi_awburst             (AXI_02_AWBURST),
  .axi_awcache             (AXI_02_AWCACHE),
  .axi_awprot              (AXI_02_AWPROT),
  .axi_awvalid             (AXI_02_AWVALID),
  .axi_awready             (AXI_02_AWREADY),
  .axi_wdata               (AXI_02_WDATA),
  .axi_wstrb               (AXI_02_WSTRB),
  .axi_wlast               (AXI_02_WLAST),
  .axi_wvalid              (AXI_02_WVALID),
  .axi_wready              (AXI_02_WREADY),
  .axi_bready              (AXI_02_BREADY),
  .axi_bid                 (AXI_02_BID),
  .axi_bresp               (AXI_02_BRESP),
  .axi_bvalid              (AXI_02_BVALID),
  .axi_arid                (AXI_02_ARID),
  .axi_araddr              (AXI_02_ARADDR),
  .axi_arlen               (AXI_02_ARLEN),
  .axi_arsize              (AXI_02_ARSIZE),
  .axi_arburst             (AXI_02_ARBURST),
  .axi_arcache             (AXI_02_ARCACHE),
  .axi_arvalid             (AXI_02_ARVALID),
  .axi_arready             (AXI_02_ARREADY),
  .axi_rready              (AXI_02_RREADY),
  .axi_rid                 (AXI_02_RID),
  .axi_rdata               (AXI_02_RDATA),
  .axi_rresp               (AXI_02_RRESP),
  .axi_rlast               (AXI_02_RLAST),
  .axi_rvalid              (AXI_02_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 3
////////////////////////////////////////////////////////////////////////////////
// assign AXI_03_ARADDR = {vio_tg_glb_start_addr_3[32:28],o_m_axi_araddr_3[27:0]};
// assign AXI_03_AWADDR = {vio_tg_glb_start_addr_3[32:28],o_m_axi_awaddr_3[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_3 (
  .sr_done                             (sr_done[3]),
  .sr_newd                             (sr_newd[3]),
  .sr_din                              (sr_din[3]),
  .sr_dout                             (sr_dout[3]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK1_st0_buf),
  .i_rst                               (~axi_rst1_st0_n),
  .i_init_calib_complete               (apb_seq_complete_1_st0_r2),
  .compare_error                       (axi_03_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_3),
  .vio_tg_start                        (vio_tg_start_3),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_3),
  .vio_tg_err_clear                    (vio_tg_err_clear_3),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_3),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_3),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_3),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_3),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_3),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_3),
  .vio_tg_restart                      (vio_tg_restart_3),
  .vio_tg_pause                        (vio_tg_pause_3),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_3),
  .vio_tg_err_continue                 (vio_tg_err_continue_3),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_3),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_3),
  .vio_tg_instr_num                    (vio_tg_instr_num_3),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_3),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_3),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_3),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_3),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_3),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_3),
  .vio_tg_seed_num                     (vio_tg_seed_num_3),
  .vio_tg_seed                         (vio_tg_seed_3),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_3),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_3),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_3),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_3),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_3),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_3),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_3),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_3),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_3),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_3),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_3),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_3),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_3),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_3),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_3),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_3),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_3),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_3),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_3),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_3),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_3),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_3),
  .vio_tg_status_err_type              (vio_tg_status_err_type_3),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_3),
  .vio_tg_status_done                  (boot_mode_done_3),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_3),
  .tg_ila_debug                        (tg_ila_debug_3),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_03_AWREADY),
  .o_m_axi_awid                        (AXI_03_AWID),
  .o_m_axi_awaddr                      (AXI_03_AWADDR),
  .o_m_axi_awlen                       (AXI_03_AWLEN),
  .o_m_axi_awsize                      (AXI_03_AWSIZE),
  .o_m_axi_awburst                     (AXI_03_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_03_AWCACHE),
  .o_m_axi_awprot                      (AXI_03_AWPROT),
  .o_m_axi_awvalid                     (AXI_03_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_03_WREADY),
  .o_m_axi_wdata                       (AXI_03_WDATA),
  .o_m_axi_wstrb                       (AXI_03_WSTRB),
  .o_m_axi_wlast                       (AXI_03_WLAST),
  .o_m_axi_wvalid                      (AXI_03_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_03_BID),
  .i_m_axi_bresp                       (AXI_03_BRESP),
  .i_m_axi_bvalid                      (AXI_03_BVALID),
  .o_m_axi_bready                      (AXI_03_BREADY),
  .i_m_axi_arready                     (AXI_03_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_03_ARID),
  .o_m_axi_araddr                      (AXI_03_ARADDR),
  .o_m_axi_arlen                       (AXI_03_ARLEN),
  .o_m_axi_arsize                      (AXI_03_ARSIZE),
  .o_m_axi_arburst                     (AXI_03_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_03_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_03_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_03_RID),
  .i_m_axi_rresp                       (AXI_03_RRESP),
  .i_m_axi_rvalid                      (AXI_03_RVALID),
  .i_m_axi_rdata                       (AXI_03_RDATA),
  .i_m_axi_rlast                       (AXI_03_RLAST),
  .o_m_axi_rready                      (AXI_03_RREADY)
);

assign  vio_tg_rst_3 =  1'd0;
assign  i_force_vio_tg_status_done_3 = 16'h0000;
assign  i_vio_enable_atg_axi_x_3 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_3 =  16'hffff;
assign  vio_tg_restart_3 =  'd0;
assign  vio_tg_err_chk_en_3 =  'd0;
assign  vio_tg_err_clear_3 =  'd0;
assign  vio_tg_err_clear_all_3 =  'd0;
assign  vio_tg_err_continue_3 =  'd0;
assign  vio_tg_instr_program_en_3 =  'd0;
assign  vio_tg_direct_instr_en_3 =  'd0;
assign  vio_tg_instr_num_3 =  'd0;
assign  vio_tg_instr_addr_mode_3 =  'd0;
assign  vio_tg_instr_data_mode_3 =  'd0;
assign  vio_tg_instr_rw_mode_3 =  'd0;
assign  vio_tg_instr_rw_submode_3 =  'd0;
assign  vio_tg_instr_victim_mode_3 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_3 =  'd0;
assign  vio_tg_instr_victim_select_3 =  'd0;
assign  vio_tg_instr_num_of_iter_3 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_3 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_3 =  'd0;
assign  vio_tg_instr_nxt_instr_3 =  'd0;
assign  vio_tg_seed_program_en_3 =  'd0;
assign  vio_tg_seed_num_3 =  'd0;
assign  vio_tg_seed_3 =  'd0;
assign  vio_tg_glb_start_addr_3 = 33'h0_3000_0000;

always@(posedge AXI_ACLK1_st0_buf or negedge axi_rst1_st0_n) begin
  if (~axi_rst1_st0_n) begin
    rd_cnt_03 <= 5'b0;
  end else if (AXI_03_RVALID && AXI_03_RREADY) begin
    rd_cnt_03 <= rd_cnt_03 + 1'b1;
  end
end

always@(posedge AXI_ACLK1_st0_buf or negedge axi_rst1_st0_n) begin
  if (~axi_rst1_st0_n) begin
    wr_cnt_03 <= 5'b0;
  end else if (AXI_03_BVALID && AXI_03_BREADY) begin
    wr_cnt_03 <= wr_cnt_03 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 3
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (3)
) u_axi_pmon_3 (
  .axi_arst_n              (axi_rst1_st0_n    ),
  .axi_aclk                (AXI_ACLK1_st0_buf ),
  .axi_awid                (AXI_03_AWID),
  .axi_awaddr              (AXI_03_AWADDR),
  .axi_awlen               (AXI_03_AWLEN),
  .axi_awsize              (AXI_03_AWSIZE),
  .axi_awburst             (AXI_03_AWBURST),
  .axi_awcache             (AXI_03_AWCACHE),
  .axi_awprot              (AXI_03_AWPROT),
  .axi_awvalid             (AXI_03_AWVALID),
  .axi_awready             (AXI_03_AWREADY),
  .axi_wdata               (AXI_03_WDATA),
  .axi_wstrb               (AXI_03_WSTRB),
  .axi_wlast               (AXI_03_WLAST),
  .axi_wvalid              (AXI_03_WVALID),
  .axi_wready              (AXI_03_WREADY),
  .axi_bready              (AXI_03_BREADY),
  .axi_bid                 (AXI_03_BID),
  .axi_bresp               (AXI_03_BRESP),
  .axi_bvalid              (AXI_03_BVALID),
  .axi_arid                (AXI_03_ARID),
  .axi_araddr              (AXI_03_ARADDR),
  .axi_arlen               (AXI_03_ARLEN),
  .axi_arsize              (AXI_03_ARSIZE),
  .axi_arburst             (AXI_03_ARBURST),
  .axi_arcache             (AXI_03_ARCACHE),
  .axi_arvalid             (AXI_03_ARVALID),
  .axi_arready             (AXI_03_ARREADY),
  .axi_rready              (AXI_03_RREADY),
  .axi_rid                 (AXI_03_RID),
  .axi_rdata               (AXI_03_RDATA),
  .axi_rresp               (AXI_03_RRESP),
  .axi_rlast               (AXI_03_RLAST),
  .axi_rvalid              (AXI_03_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 4
////////////////////////////////////////////////////////////////////////////////
// assign AXI_04_ARADDR = {vio_tg_glb_start_addr_4[32:28],o_m_axi_araddr_4[27:0]};
// assign AXI_04_AWADDR = {vio_tg_glb_start_addr_4[32:28],o_m_axi_awaddr_4[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_4 (
  .sr_done                             (sr_done[4]),
  .sr_newd                             (sr_newd[4]),
  .sr_din                              (sr_din[4]),
  .sr_dout                             (sr_dout[4]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK2_st0_buf),
  .i_rst                               (~axi_rst2_st0_n),
  .i_init_calib_complete               (apb_seq_complete_2_st0_r2),
  .compare_error                       (axi_04_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_4),
  .vio_tg_start                        (vio_tg_start_4),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_4),
  .vio_tg_err_clear                    (vio_tg_err_clear_4),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_4),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_4),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_4),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_4),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_4),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_4),
  .vio_tg_restart                      (vio_tg_restart_4),
  .vio_tg_pause                        (vio_tg_pause_4),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_4),
  .vio_tg_err_continue                 (vio_tg_err_continue_4),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_4),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_4),
  .vio_tg_instr_num                    (vio_tg_instr_num_4),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_4),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_4),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_4),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_4),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_4),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_4),
  .vio_tg_seed_num                     (vio_tg_seed_num_4),
  .vio_tg_seed                         (vio_tg_seed_4),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_4),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_4),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_4),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_4),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_4),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_4),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_4),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_4),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_4),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_4),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_4),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_4),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_4),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_4),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_4),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_4),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_4),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_4),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_4),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_4),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_4),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_4),
  .vio_tg_status_err_type              (vio_tg_status_err_type_4),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_4),
  .vio_tg_status_done                  (boot_mode_done_4),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_4),
  .tg_ila_debug                        (tg_ila_debug_4),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_04_AWREADY),
  .o_m_axi_awid                        (AXI_04_AWID),
  .o_m_axi_awaddr                      (AXI_04_AWADDR),
  .o_m_axi_awlen                       (AXI_04_AWLEN),
  .o_m_axi_awsize                      (AXI_04_AWSIZE),
  .o_m_axi_awburst                     (AXI_04_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_04_AWCACHE),
  .o_m_axi_awprot                      (AXI_04_AWPROT),
  .o_m_axi_awvalid                     (AXI_04_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_04_WREADY),
  .o_m_axi_wdata                       (AXI_04_WDATA),
  .o_m_axi_wstrb                       (AXI_04_WSTRB),
  .o_m_axi_wlast                       (AXI_04_WLAST),
  .o_m_axi_wvalid                      (AXI_04_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_04_BID),
  .i_m_axi_bresp                       (AXI_04_BRESP),
  .i_m_axi_bvalid                      (AXI_04_BVALID),
  .o_m_axi_bready                      (AXI_04_BREADY),
  .i_m_axi_arready                     (AXI_04_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_04_ARID),
  .o_m_axi_araddr                      (AXI_04_ARADDR),
  .o_m_axi_arlen                       (AXI_04_ARLEN),
  .o_m_axi_arsize                      (AXI_04_ARSIZE),
  .o_m_axi_arburst                     (AXI_04_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_04_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_04_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_04_RID),
  .i_m_axi_rresp                       (AXI_04_RRESP),
  .i_m_axi_rvalid                      (AXI_04_RVALID),
  .i_m_axi_rdata                       (AXI_04_RDATA),
  .i_m_axi_rlast                       (AXI_04_RLAST),
  .o_m_axi_rready                      (AXI_04_RREADY)
);

assign  vio_tg_rst_4 =  1'd0;
assign  i_force_vio_tg_status_done_4 = 16'h0000;
assign  i_vio_enable_atg_axi_x_4 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_4 =  16'hffff;
assign  vio_tg_restart_4 =  'd0;
assign  vio_tg_err_chk_en_4 =  'd0;
assign  vio_tg_err_clear_4 =  'd0;
assign  vio_tg_err_clear_all_4 =  'd0;
assign  vio_tg_err_continue_4 =  'd0;
assign  vio_tg_instr_program_en_4 =  'd0;
assign  vio_tg_direct_instr_en_4 =  'd0;
assign  vio_tg_instr_num_4 =  'd0;
assign  vio_tg_instr_addr_mode_4 =  'd0;
assign  vio_tg_instr_data_mode_4 =  'd0;
assign  vio_tg_instr_rw_mode_4 =  'd0;
assign  vio_tg_instr_rw_submode_4 =  'd0;
assign  vio_tg_instr_victim_mode_4 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_4 =  'd0;
assign  vio_tg_instr_victim_select_4 =  'd0;
assign  vio_tg_instr_num_of_iter_4 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_4 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_4 =  'd0;
assign  vio_tg_instr_nxt_instr_4 =  'd0;
assign  vio_tg_seed_program_en_4 =  'd0;
assign  vio_tg_seed_num_4 =  'd0;
assign  vio_tg_seed_4 =  'd0;
assign  vio_tg_glb_start_addr_4 = 33'h0_4000_0000;

always@(posedge AXI_ACLK2_st0_buf or negedge axi_rst2_st0_n) begin
  if (~axi_rst2_st0_n) begin
    rd_cnt_04 <= 5'b0;
  end else if (AXI_04_RVALID && AXI_04_RREADY) begin
    rd_cnt_04 <= rd_cnt_04 + 1'b1;
  end
end

always@(posedge AXI_ACLK2_st0_buf or negedge axi_rst2_st0_n) begin
  if (~axi_rst2_st0_n) begin
    wr_cnt_04 <= 5'b0;
  end else if (AXI_04_BVALID && AXI_04_BREADY) begin
    wr_cnt_04 <= wr_cnt_04 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 4
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (4)
) u_axi_pmon_4 (
  .axi_arst_n              (axi_rst2_st0_n    ),
  .axi_aclk                (AXI_ACLK2_st0_buf ),
  .axi_awid                (AXI_04_AWID),
  .axi_awaddr              (AXI_04_AWADDR),
  .axi_awlen               (AXI_04_AWLEN),
  .axi_awsize              (AXI_04_AWSIZE),
  .axi_awburst             (AXI_04_AWBURST),
  .axi_awcache             (AXI_04_AWCACHE),
  .axi_awprot              (AXI_04_AWPROT),
  .axi_awvalid             (AXI_04_AWVALID),
  .axi_awready             (AXI_04_AWREADY),
  .axi_wdata               (AXI_04_WDATA),
  .axi_wstrb               (AXI_04_WSTRB),
  .axi_wlast               (AXI_04_WLAST),
  .axi_wvalid              (AXI_04_WVALID),
  .axi_wready              (AXI_04_WREADY),
  .axi_bready              (AXI_04_BREADY),
  .axi_bid                 (AXI_04_BID),
  .axi_bresp               (AXI_04_BRESP),
  .axi_bvalid              (AXI_04_BVALID),
  .axi_arid                (AXI_04_ARID),
  .axi_araddr              (AXI_04_ARADDR),
  .axi_arlen               (AXI_04_ARLEN),
  .axi_arsize              (AXI_04_ARSIZE),
  .axi_arburst             (AXI_04_ARBURST),
  .axi_arcache             (AXI_04_ARCACHE),
  .axi_arvalid             (AXI_04_ARVALID),
  .axi_arready             (AXI_04_ARREADY),
  .axi_rready              (AXI_04_RREADY),
  .axi_rid                 (AXI_04_RID),
  .axi_rdata               (AXI_04_RDATA),
  .axi_rresp               (AXI_04_RRESP),
  .axi_rlast               (AXI_04_RLAST),
  .axi_rvalid              (AXI_04_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 5
////////////////////////////////////////////////////////////////////////////////
// assign AXI_05_ARADDR = {vio_tg_glb_start_addr_5[32:28],o_m_axi_araddr_5[27:0]};
// assign AXI_05_AWADDR = {vio_tg_glb_start_addr_5[32:28],o_m_axi_awaddr_5[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_5 (
  .sr_done                             (sr_done[5]),
  .sr_newd                             (sr_newd[5]),
  .sr_din                              (sr_din[5]),
  .sr_dout                             (sr_dout[5]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK2_st0_buf),
  .i_rst                               (~axi_rst2_st0_n),
  .i_init_calib_complete               (apb_seq_complete_2_st0_r2),
  .compare_error                       (axi_05_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_5),
  .vio_tg_start                        (vio_tg_start_5),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_5),
  .vio_tg_err_clear                    (vio_tg_err_clear_5),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_5),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_5),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_5),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_5),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_5),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_5),
  .vio_tg_restart                      (vio_tg_restart_5),
  .vio_tg_pause                        (vio_tg_pause_5),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_5),
  .vio_tg_err_continue                 (vio_tg_err_continue_5),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_5),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_5),
  .vio_tg_instr_num                    (vio_tg_instr_num_5),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_5),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_5),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_5),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_5),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_5),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_5),
  .vio_tg_seed_num                     (vio_tg_seed_num_5),
  .vio_tg_seed                         (vio_tg_seed_5),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_5),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_5),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_5),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_5),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_5),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_5),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_5),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_5),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_5),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_5),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_5),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_5),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_5),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_5),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_5),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_5),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_5),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_5),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_5),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_5),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_5),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_5),
  .vio_tg_status_err_type              (vio_tg_status_err_type_5),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_5),
  .vio_tg_status_done                  (boot_mode_done_5),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_5),
  .tg_ila_debug                        (tg_ila_debug_5),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_05_AWREADY),
  .o_m_axi_awid                        (AXI_05_AWID),
  .o_m_axi_awaddr                      (AXI_05_AWADDR),
  .o_m_axi_awlen                       (AXI_05_AWLEN),
  .o_m_axi_awsize                      (AXI_05_AWSIZE),
  .o_m_axi_awburst                     (AXI_05_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_05_AWCACHE),
  .o_m_axi_awprot                      (AXI_05_AWPROT),
  .o_m_axi_awvalid                     (AXI_05_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_05_WREADY),
  .o_m_axi_wdata                       (AXI_05_WDATA),
  .o_m_axi_wstrb                       (AXI_05_WSTRB),
  .o_m_axi_wlast                       (AXI_05_WLAST),
  .o_m_axi_wvalid                      (AXI_05_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_05_BID),
  .i_m_axi_bresp                       (AXI_05_BRESP),
  .i_m_axi_bvalid                      (AXI_05_BVALID),
  .o_m_axi_bready                      (AXI_05_BREADY),
  .i_m_axi_arready                     (AXI_05_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_05_ARID),
  .o_m_axi_araddr                      (AXI_05_ARADDR),
  .o_m_axi_arlen                       (AXI_05_ARLEN),
  .o_m_axi_arsize                      (AXI_05_ARSIZE),
  .o_m_axi_arburst                     (AXI_05_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_05_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_05_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_05_RID),
  .i_m_axi_rresp                       (AXI_05_RRESP),
  .i_m_axi_rvalid                      (AXI_05_RVALID),
  .i_m_axi_rdata                       (AXI_05_RDATA),
  .i_m_axi_rlast                       (AXI_05_RLAST),
  .o_m_axi_rready                      (AXI_05_RREADY)
);

assign  vio_tg_rst_5 =  1'd0;
assign  i_force_vio_tg_status_done_5 = 16'h0000;
assign  i_vio_enable_atg_axi_x_5 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_5 =  16'hffff;
assign  vio_tg_restart_5 =  'd0;
assign  vio_tg_err_chk_en_5 =  'd0;
assign  vio_tg_err_clear_5 =  'd0;
assign  vio_tg_err_clear_all_5 =  'd0;
assign  vio_tg_err_continue_5 =  'd0;
assign  vio_tg_instr_program_en_5 =  'd0;
assign  vio_tg_direct_instr_en_5 =  'd0;
assign  vio_tg_instr_num_5 =  'd0;
assign  vio_tg_instr_addr_mode_5 =  'd0;
assign  vio_tg_instr_data_mode_5 =  'd0;
assign  vio_tg_instr_rw_mode_5 =  'd0;
assign  vio_tg_instr_rw_submode_5 =  'd0;
assign  vio_tg_instr_victim_mode_5 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_5 =  'd0;
assign  vio_tg_instr_victim_select_5 =  'd0;
assign  vio_tg_instr_num_of_iter_5 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_5 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_5 =  'd0;
assign  vio_tg_instr_nxt_instr_5 =  'd0;
assign  vio_tg_seed_program_en_5 =  'd0;
assign  vio_tg_seed_num_5 =  'd0;
assign  vio_tg_seed_5 =  'd0;
assign  vio_tg_glb_start_addr_5 = 33'h0_5000_0000;

always@(posedge AXI_ACLK2_st0_buf or negedge axi_rst2_st0_n) begin
  if (~axi_rst2_st0_n) begin
    rd_cnt_05 <= 5'b0;
  end else if (AXI_05_RVALID && AXI_05_RREADY) begin
    rd_cnt_05 <= rd_cnt_05 + 1'b1;
  end
end

always@(posedge AXI_ACLK2_st0_buf or negedge axi_rst2_st0_n) begin
  if (~axi_rst2_st0_n) begin
    wr_cnt_05 <= 5'b0;
  end else if (AXI_05_BVALID && AXI_05_BREADY) begin
    wr_cnt_05 <= wr_cnt_05 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 5
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (5)
) u_axi_pmon_5 (
  .axi_arst_n              (axi_rst2_st0_n    ),
  .axi_aclk                (AXI_ACLK2_st0_buf ),
  .axi_awid                (AXI_05_AWID),
  .axi_awaddr              (AXI_05_AWADDR),
  .axi_awlen               (AXI_05_AWLEN),
  .axi_awsize              (AXI_05_AWSIZE),
  .axi_awburst             (AXI_05_AWBURST),
  .axi_awcache             (AXI_05_AWCACHE),
  .axi_awprot              (AXI_05_AWPROT),
  .axi_awvalid             (AXI_05_AWVALID),
  .axi_awready             (AXI_05_AWREADY),
  .axi_wdata               (AXI_05_WDATA),
  .axi_wstrb               (AXI_05_WSTRB),
  .axi_wlast               (AXI_05_WLAST),
  .axi_wvalid              (AXI_05_WVALID),
  .axi_wready              (AXI_05_WREADY),
  .axi_bready              (AXI_05_BREADY),
  .axi_bid                 (AXI_05_BID),
  .axi_bresp               (AXI_05_BRESP),
  .axi_bvalid              (AXI_05_BVALID),
  .axi_arid                (AXI_05_ARID),
  .axi_araddr              (AXI_05_ARADDR),
  .axi_arlen               (AXI_05_ARLEN),
  .axi_arsize              (AXI_05_ARSIZE),
  .axi_arburst             (AXI_05_ARBURST),
  .axi_arcache             (AXI_05_ARCACHE),
  .axi_arvalid             (AXI_05_ARVALID),
  .axi_arready             (AXI_05_ARREADY),
  .axi_rready              (AXI_05_RREADY),
  .axi_rid                 (AXI_05_RID),
  .axi_rdata               (AXI_05_RDATA),
  .axi_rresp               (AXI_05_RRESP),
  .axi_rlast               (AXI_05_RLAST),
  .axi_rvalid              (AXI_05_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 6
////////////////////////////////////////////////////////////////////////////////
// assign AXI_06_ARADDR = {vio_tg_glb_start_addr_6[32:28],o_m_axi_araddr_6[27:0]};
// assign AXI_06_AWADDR = {vio_tg_glb_start_addr_6[32:28],o_m_axi_awaddr_6[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_6 (
  .sr_done                             (sr_done[6]),
  .sr_newd                             (sr_newd[6]),
  .sr_din                              (sr_din[6]),
  .sr_dout                             (sr_dout[6]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK3_st0_buf),
  .i_rst                               (~axi_rst3_st0_n),
  .i_init_calib_complete               (apb_seq_complete_3_st0_r2),
  .compare_error                       (axi_06_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_6),
  .vio_tg_start                        (vio_tg_start_6),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_6),
  .vio_tg_err_clear                    (vio_tg_err_clear_6),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_6),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_6),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_6),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_6),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_6),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_6),
  .vio_tg_restart                      (vio_tg_restart_6),
  .vio_tg_pause                        (vio_tg_pause_6),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_6),
  .vio_tg_err_continue                 (vio_tg_err_continue_6),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_6),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_6),
  .vio_tg_instr_num                    (vio_tg_instr_num_6),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_6),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_6),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_6),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_6),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_6),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_6),
  .vio_tg_seed_num                     (vio_tg_seed_num_6),
  .vio_tg_seed                         (vio_tg_seed_6),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_6),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_6),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_6),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_6),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_6),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_6),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_6),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_6),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_6),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_6),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_6),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_6),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_6),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_6),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_6),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_6),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_6),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_6),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_6),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_6),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_6),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_6),
  .vio_tg_status_err_type              (vio_tg_status_err_type_6),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_6),
  .vio_tg_status_done                  (boot_mode_done_6),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_6),
  .tg_ila_debug                        (tg_ila_debug_6),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_06_AWREADY),
  .o_m_axi_awid                        (AXI_06_AWID),
  .o_m_axi_awaddr                      (AXI_06_AWADDR),
  .o_m_axi_awlen                       (AXI_06_AWLEN),
  .o_m_axi_awsize                      (AXI_06_AWSIZE),
  .o_m_axi_awburst                     (AXI_06_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_06_AWCACHE),
  .o_m_axi_awprot                      (AXI_06_AWPROT),
  .o_m_axi_awvalid                     (AXI_06_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_06_WREADY),
  .o_m_axi_wdata                       (AXI_06_WDATA),
  .o_m_axi_wstrb                       (AXI_06_WSTRB),
  .o_m_axi_wlast                       (AXI_06_WLAST),
  .o_m_axi_wvalid                      (AXI_06_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_06_BID),
  .i_m_axi_bresp                       (AXI_06_BRESP),
  .i_m_axi_bvalid                      (AXI_06_BVALID),
  .o_m_axi_bready                      (AXI_06_BREADY),
  .i_m_axi_arready                     (AXI_06_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_06_ARID),
  .o_m_axi_araddr                      (AXI_06_ARADDR),
  .o_m_axi_arlen                       (AXI_06_ARLEN),
  .o_m_axi_arsize                      (AXI_06_ARSIZE),
  .o_m_axi_arburst                     (AXI_06_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_06_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_06_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_06_RID),
  .i_m_axi_rresp                       (AXI_06_RRESP),
  .i_m_axi_rvalid                      (AXI_06_RVALID),
  .i_m_axi_rdata                       (AXI_06_RDATA),
  .i_m_axi_rlast                       (AXI_06_RLAST),
  .o_m_axi_rready                      (AXI_06_RREADY)
);

assign  vio_tg_rst_6 =  1'd0;
assign  i_force_vio_tg_status_done_6 = 16'h0000;
assign  i_vio_enable_atg_axi_x_6 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_6 =  16'hffff;
assign  vio_tg_restart_6 =  'd0;
assign  vio_tg_err_chk_en_6 =  'd0;
assign  vio_tg_err_clear_6 =  'd0;
assign  vio_tg_err_clear_all_6 =  'd0;
assign  vio_tg_err_continue_6 =  'd0;
assign  vio_tg_instr_program_en_6 =  'd0;
assign  vio_tg_direct_instr_en_6 =  'd0;
assign  vio_tg_instr_num_6 =  'd0;
assign  vio_tg_instr_addr_mode_6 =  'd0;
assign  vio_tg_instr_data_mode_6 =  'd0;
assign  vio_tg_instr_rw_mode_6 =  'd0;
assign  vio_tg_instr_rw_submode_6 =  'd0;
assign  vio_tg_instr_victim_mode_6 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_6 =  'd0;
assign  vio_tg_instr_victim_select_6 =  'd0;
assign  vio_tg_instr_num_of_iter_6 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_6 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_6 =  'd0;
assign  vio_tg_instr_nxt_instr_6 =  'd0;
assign  vio_tg_seed_program_en_6 =  'd0;
assign  vio_tg_seed_num_6 =  'd0;
assign  vio_tg_seed_6 =  'd0;
assign  vio_tg_glb_start_addr_6 = 33'h0_6000_0000;

always@(posedge AXI_ACLK3_st0_buf or negedge axi_rst3_st0_n) begin
  if (~axi_rst3_st0_n) begin
    rd_cnt_06 <= 5'b0;
  end else if (AXI_06_RVALID && AXI_06_RREADY) begin
    rd_cnt_06 <= rd_cnt_06 + 1'b1;
  end
end

always@(posedge AXI_ACLK3_st0_buf or negedge axi_rst3_st0_n) begin
  if (~axi_rst3_st0_n) begin
    wr_cnt_06 <= 5'b0;
  end else if (AXI_06_BVALID && AXI_06_BREADY) begin
    wr_cnt_06 <= wr_cnt_06 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 6
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (6)
) u_axi_pmon_6 (
  .axi_arst_n              (axi_rst3_st0_n    ),
  .axi_aclk                (AXI_ACLK3_st0_buf ),
  .axi_awid                (AXI_06_AWID),
  .axi_awaddr              (AXI_06_AWADDR),
  .axi_awlen               (AXI_06_AWLEN),
  .axi_awsize              (AXI_06_AWSIZE),
  .axi_awburst             (AXI_06_AWBURST),
  .axi_awcache             (AXI_06_AWCACHE),
  .axi_awprot              (AXI_06_AWPROT),
  .axi_awvalid             (AXI_06_AWVALID),
  .axi_awready             (AXI_06_AWREADY),
  .axi_wdata               (AXI_06_WDATA),
  .axi_wstrb               (AXI_06_WSTRB),
  .axi_wlast               (AXI_06_WLAST),
  .axi_wvalid              (AXI_06_WVALID),
  .axi_wready              (AXI_06_WREADY),
  .axi_bready              (AXI_06_BREADY),
  .axi_bid                 (AXI_06_BID),
  .axi_bresp               (AXI_06_BRESP),
  .axi_bvalid              (AXI_06_BVALID),
  .axi_arid                (AXI_06_ARID),
  .axi_araddr              (AXI_06_ARADDR),
  .axi_arlen               (AXI_06_ARLEN),
  .axi_arsize              (AXI_06_ARSIZE),
  .axi_arburst             (AXI_06_ARBURST),
  .axi_arcache             (AXI_06_ARCACHE),
  .axi_arvalid             (AXI_06_ARVALID),
  .axi_arready             (AXI_06_ARREADY),
  .axi_rready              (AXI_06_RREADY),
  .axi_rid                 (AXI_06_RID),
  .axi_rdata               (AXI_06_RDATA),
  .axi_rresp               (AXI_06_RRESP),
  .axi_rlast               (AXI_06_RLAST),
  .axi_rvalid              (AXI_06_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 7
////////////////////////////////////////////////////////////////////////////////
// assign AXI_07_ARADDR = {vio_tg_glb_start_addr_7[32:28],o_m_axi_araddr_7[27:0]};
// assign AXI_07_AWADDR = {vio_tg_glb_start_addr_7[32:28],o_m_axi_awaddr_7[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_7 (
  .sr_done                             (sr_done[7]),
  .sr_newd                             (sr_newd[7]),
  .sr_din                              (sr_din[7]),
  .sr_dout                             (sr_dout[7]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK3_st0_buf),
  .i_rst                               (~axi_rst3_st0_n),
  .i_init_calib_complete               (apb_seq_complete_3_st0_r2),
  .compare_error                       (axi_07_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_7),
  .vio_tg_start                        (vio_tg_start_7),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_7),
  .vio_tg_err_clear                    (vio_tg_err_clear_7),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_7),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_7),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_7),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_7),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_7),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_7),
  .vio_tg_restart                      (vio_tg_restart_7),
  .vio_tg_pause                        (vio_tg_pause_7),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_7),
  .vio_tg_err_continue                 (vio_tg_err_continue_7),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_7),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_7),
  .vio_tg_instr_num                    (vio_tg_instr_num_7),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_7),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_7),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_7),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_7),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_7),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_7),
  .vio_tg_seed_num                     (vio_tg_seed_num_7),
  .vio_tg_seed                         (vio_tg_seed_7),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_7),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_7),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_7),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_7),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_7),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_7),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_7),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_7),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_7),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_7),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_7),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_7),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_7),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_7),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_7),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_7),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_7),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_7),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_7),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_7),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_7),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_7),
  .vio_tg_status_err_type              (vio_tg_status_err_type_7),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_7),
  .vio_tg_status_done                  (boot_mode_done_7),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_7),
  .tg_ila_debug                        (tg_ila_debug_7),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_07_AWREADY),
  .o_m_axi_awid                        (AXI_07_AWID),
  .o_m_axi_awaddr                      (AXI_07_AWADDR),
  .o_m_axi_awlen                       (AXI_07_AWLEN),
  .o_m_axi_awsize                      (AXI_07_AWSIZE),
  .o_m_axi_awburst                     (AXI_07_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_07_AWCACHE),
  .o_m_axi_awprot                      (AXI_07_AWPROT),
  .o_m_axi_awvalid                     (AXI_07_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_07_WREADY),
  .o_m_axi_wdata                       (AXI_07_WDATA),
  .o_m_axi_wstrb                       (AXI_07_WSTRB),
  .o_m_axi_wlast                       (AXI_07_WLAST),
  .o_m_axi_wvalid                      (AXI_07_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_07_BID),
  .i_m_axi_bresp                       (AXI_07_BRESP),
  .i_m_axi_bvalid                      (AXI_07_BVALID),
  .o_m_axi_bready                      (AXI_07_BREADY),
  .i_m_axi_arready                     (AXI_07_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_07_ARID),
  .o_m_axi_araddr                      (AXI_07_ARADDR),
  .o_m_axi_arlen                       (AXI_07_ARLEN),
  .o_m_axi_arsize                      (AXI_07_ARSIZE),
  .o_m_axi_arburst                     (AXI_07_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_07_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_07_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_07_RID),
  .i_m_axi_rresp                       (AXI_07_RRESP),
  .i_m_axi_rvalid                      (AXI_07_RVALID),
  .i_m_axi_rdata                       (AXI_07_RDATA),
  .i_m_axi_rlast                       (AXI_07_RLAST),
  .o_m_axi_rready                      (AXI_07_RREADY)
);

assign  vio_tg_rst_7 =  1'd0;
assign  i_force_vio_tg_status_done_7 = 16'h0000;
assign  i_vio_enable_atg_axi_x_7 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_7 =  16'hffff;
assign  vio_tg_restart_7 =  'd0;
assign  vio_tg_err_chk_en_7 =  'd0;
assign  vio_tg_err_clear_7 =  'd0;
assign  vio_tg_err_clear_all_7 =  'd0;
assign  vio_tg_err_continue_7 =  'd0;
assign  vio_tg_instr_program_en_7 =  'd0;
assign  vio_tg_direct_instr_en_7 =  'd0;
assign  vio_tg_instr_num_7 =  'd0;
assign  vio_tg_instr_addr_mode_7 =  'd0;
assign  vio_tg_instr_data_mode_7 =  'd0;
assign  vio_tg_instr_rw_mode_7 =  'd0;
assign  vio_tg_instr_rw_submode_7 =  'd0;
assign  vio_tg_instr_victim_mode_7 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_7 =  'd0;
assign  vio_tg_instr_victim_select_7 =  'd0;
assign  vio_tg_instr_num_of_iter_7 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_7 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_7 =  'd0;
assign  vio_tg_instr_nxt_instr_7 =  'd0;
assign  vio_tg_seed_program_en_7 =  'd0;
assign  vio_tg_seed_num_7 =  'd0;
assign  vio_tg_seed_7 =  'd0;
assign  vio_tg_glb_start_addr_7 = 33'h0_7000_0000;

always@(posedge AXI_ACLK3_st0_buf or negedge axi_rst3_st0_n) begin
  if (~axi_rst3_st0_n) begin
    rd_cnt_07 <= 5'b0;
  end else if (AXI_07_RVALID && AXI_07_RREADY) begin
    rd_cnt_07 <= rd_cnt_07 + 1'b1;
  end
end

always@(posedge AXI_ACLK3_st0_buf or negedge axi_rst3_st0_n) begin
  if (~axi_rst3_st0_n) begin
    wr_cnt_07 <= 5'b0;
  end else if (AXI_07_BVALID && AXI_07_BREADY) begin
    wr_cnt_07 <= wr_cnt_07 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 7
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (7)
) u_axi_pmon_7 (
  .axi_arst_n              (axi_rst3_st0_n    ),
  .axi_aclk                (AXI_ACLK3_st0_buf ),
  .axi_awid                (AXI_07_AWID),
  .axi_awaddr              (AXI_07_AWADDR),
  .axi_awlen               (AXI_07_AWLEN),
  .axi_awsize              (AXI_07_AWSIZE),
  .axi_awburst             (AXI_07_AWBURST),
  .axi_awcache             (AXI_07_AWCACHE),
  .axi_awprot              (AXI_07_AWPROT),
  .axi_awvalid             (AXI_07_AWVALID),
  .axi_awready             (AXI_07_AWREADY),
  .axi_wdata               (AXI_07_WDATA),
  .axi_wstrb               (AXI_07_WSTRB),
  .axi_wlast               (AXI_07_WLAST),
  .axi_wvalid              (AXI_07_WVALID),
  .axi_wready              (AXI_07_WREADY),
  .axi_bready              (AXI_07_BREADY),
  .axi_bid                 (AXI_07_BID),
  .axi_bresp               (AXI_07_BRESP),
  .axi_bvalid              (AXI_07_BVALID),
  .axi_arid                (AXI_07_ARID),
  .axi_araddr              (AXI_07_ARADDR),
  .axi_arlen               (AXI_07_ARLEN),
  .axi_arsize              (AXI_07_ARSIZE),
  .axi_arburst             (AXI_07_ARBURST),
  .axi_arcache             (AXI_07_ARCACHE),
  .axi_arvalid             (AXI_07_ARVALID),
  .axi_arready             (AXI_07_ARREADY),
  .axi_rready              (AXI_07_RREADY),
  .axi_rid                 (AXI_07_RID),
  .axi_rdata               (AXI_07_RDATA),
  .axi_rresp               (AXI_07_RRESP),
  .axi_rlast               (AXI_07_RLAST),
  .axi_rvalid              (AXI_07_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 8
////////////////////////////////////////////////////////////////////////////////
// assign AXI_08_ARADDR = {vio_tg_glb_start_addr_8[32:28],o_m_axi_araddr_8[27:0]};
// assign AXI_08_AWADDR = {vio_tg_glb_start_addr_8[32:28],o_m_axi_awaddr_8[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_8 (
  .sr_done                             (sr_done[8]),
  .sr_newd                             (sr_newd[8]),
  .sr_din                              (sr_din[8]),
  .sr_dout                             (sr_dout[8]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK4_st0_buf),
  .i_rst                               (~axi_rst4_st0_n),
  .i_init_calib_complete               (apb_seq_complete_4_st0_r2),
  .compare_error                       (axi_08_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_8),
  .vio_tg_start                        (vio_tg_start_8),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_8),
  .vio_tg_err_clear                    (vio_tg_err_clear_8),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_8),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_8),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_8),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_8),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_8),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_8),
  .vio_tg_restart                      (vio_tg_restart_8),
  .vio_tg_pause                        (vio_tg_pause_8),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_8),
  .vio_tg_err_continue                 (vio_tg_err_continue_8),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_8),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_8),
  .vio_tg_instr_num                    (vio_tg_instr_num_8),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_8),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_8),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_8),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_8),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_8),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_8),
  .vio_tg_seed_num                     (vio_tg_seed_num_8),
  .vio_tg_seed                         (vio_tg_seed_8),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_8),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_8),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_8),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_8),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_8),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_8),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_8),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_8),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_8),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_8),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_8),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_8),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_8),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_8),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_8),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_8),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_8),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_8),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_8),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_8),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_8),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_8),
  .vio_tg_status_err_type              (vio_tg_status_err_type_8),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_8),
  .vio_tg_status_done                  (boot_mode_done_8),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_8),
  .tg_ila_debug                        (tg_ila_debug_8),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_08_AWREADY),
  .o_m_axi_awid                        (AXI_08_AWID),
  .o_m_axi_awaddr                      (AXI_08_AWADDR),
  .o_m_axi_awlen                       (AXI_08_AWLEN),
  .o_m_axi_awsize                      (AXI_08_AWSIZE),
  .o_m_axi_awburst                     (AXI_08_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_08_AWCACHE),
  .o_m_axi_awprot                      (AXI_08_AWPROT),
  .o_m_axi_awvalid                     (AXI_08_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_08_WREADY),
  .o_m_axi_wdata                       (AXI_08_WDATA),
  .o_m_axi_wstrb                       (AXI_08_WSTRB),
  .o_m_axi_wlast                       (AXI_08_WLAST),
  .o_m_axi_wvalid                      (AXI_08_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_08_BID),
  .i_m_axi_bresp                       (AXI_08_BRESP),
  .i_m_axi_bvalid                      (AXI_08_BVALID),
  .o_m_axi_bready                      (AXI_08_BREADY),
  .i_m_axi_arready                     (AXI_08_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_08_ARID),
  .o_m_axi_araddr                      (AXI_08_ARADDR),
  .o_m_axi_arlen                       (AXI_08_ARLEN),
  .o_m_axi_arsize                      (AXI_08_ARSIZE),
  .o_m_axi_arburst                     (AXI_08_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_08_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_08_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_08_RID),
  .i_m_axi_rresp                       (AXI_08_RRESP),
  .i_m_axi_rvalid                      (AXI_08_RVALID),
  .i_m_axi_rdata                       (AXI_08_RDATA),
  .i_m_axi_rlast                       (AXI_08_RLAST),
  .o_m_axi_rready                      (AXI_08_RREADY)
);

assign  vio_tg_rst_8 =  1'd0;
assign  i_force_vio_tg_status_done_8 = 16'h0000;
assign  i_vio_enable_atg_axi_x_8 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_8 =  16'hffff;
assign  vio_tg_restart_8 =  'd0;
assign  vio_tg_err_chk_en_8 =  'd0;
assign  vio_tg_err_clear_8 =  'd0;
assign  vio_tg_err_clear_all_8 =  'd0;
assign  vio_tg_err_continue_8 =  'd0;
assign  vio_tg_instr_program_en_8 =  'd0;
assign  vio_tg_direct_instr_en_8 =  'd0;
assign  vio_tg_instr_num_8 =  'd0;
assign  vio_tg_instr_addr_mode_8 =  'd0;
assign  vio_tg_instr_data_mode_8 =  'd0;
assign  vio_tg_instr_rw_mode_8 =  'd0;
assign  vio_tg_instr_rw_submode_8 =  'd0;
assign  vio_tg_instr_victim_mode_8 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_8 =  'd0;
assign  vio_tg_instr_victim_select_8 =  'd0;
assign  vio_tg_instr_num_of_iter_8 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_8 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_8 =  'd0;
assign  vio_tg_instr_nxt_instr_8 =  'd0;
assign  vio_tg_seed_program_en_8 =  'd0;
assign  vio_tg_seed_num_8 =  'd0;
assign  vio_tg_seed_8 =  'd0;
assign  vio_tg_glb_start_addr_8 = 33'h0_8000_0000;

always@(posedge AXI_ACLK4_st0_buf or negedge axi_rst4_st0_n) begin
  if (~axi_rst4_st0_n) begin
    rd_cnt_08 <= 5'b0;
  end else if (AXI_08_RVALID && AXI_08_RREADY) begin
    rd_cnt_08 <= rd_cnt_08 + 1'b1;
  end
end

always@(posedge AXI_ACLK4_st0_buf or negedge axi_rst4_st0_n) begin
  if (~axi_rst4_st0_n) begin
    wr_cnt_08 <= 5'b0;
  end else if (AXI_08_BVALID && AXI_08_BREADY) begin
    wr_cnt_08 <= wr_cnt_08 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 8
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (8)
) u_axi_pmon_8 (
  .axi_arst_n              (axi_rst4_st0_n    ),
  .axi_aclk                (AXI_ACLK4_st0_buf ),
  .axi_awid                (AXI_08_AWID),
  .axi_awaddr              (AXI_08_AWADDR),
  .axi_awlen               (AXI_08_AWLEN),
  .axi_awsize              (AXI_08_AWSIZE),
  .axi_awburst             (AXI_08_AWBURST),
  .axi_awcache             (AXI_08_AWCACHE),
  .axi_awprot              (AXI_08_AWPROT),
  .axi_awvalid             (AXI_08_AWVALID),
  .axi_awready             (AXI_08_AWREADY),
  .axi_wdata               (AXI_08_WDATA),
  .axi_wstrb               (AXI_08_WSTRB),
  .axi_wlast               (AXI_08_WLAST),
  .axi_wvalid              (AXI_08_WVALID),
  .axi_wready              (AXI_08_WREADY),
  .axi_bready              (AXI_08_BREADY),
  .axi_bid                 (AXI_08_BID),
  .axi_bresp               (AXI_08_BRESP),
  .axi_bvalid              (AXI_08_BVALID),
  .axi_arid                (AXI_08_ARID),
  .axi_araddr              (AXI_08_ARADDR),
  .axi_arlen               (AXI_08_ARLEN),
  .axi_arsize              (AXI_08_ARSIZE),
  .axi_arburst             (AXI_08_ARBURST),
  .axi_arcache             (AXI_08_ARCACHE),
  .axi_arvalid             (AXI_08_ARVALID),
  .axi_arready             (AXI_08_ARREADY),
  .axi_rready              (AXI_08_RREADY),
  .axi_rid                 (AXI_08_RID),
  .axi_rdata               (AXI_08_RDATA),
  .axi_rresp               (AXI_08_RRESP),
  .axi_rlast               (AXI_08_RLAST),
  .axi_rvalid              (AXI_08_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 9
////////////////////////////////////////////////////////////////////////////////
// assign AXI_09_ARADDR = {vio_tg_glb_start_addr_9[32:28],o_m_axi_araddr_9[27:0]};
// assign AXI_09_AWADDR = {vio_tg_glb_start_addr_9[32:28],o_m_axi_awaddr_9[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_9 (
  .sr_done                             (sr_done[9]),
  .sr_newd                             (sr_newd[9]),
  .sr_din                              (sr_din[9]),
  .sr_dout                             (sr_dout[9]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK4_st0_buf),
  .i_rst                               (~axi_rst4_st0_n),
  .i_init_calib_complete               (apb_seq_complete_4_st0_r2),
  .compare_error                       (axi_09_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_9),
  .vio_tg_start                        (vio_tg_start_9),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_9),
  .vio_tg_err_clear                    (vio_tg_err_clear_9),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_9),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_9),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_9),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_9),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_9),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_9),
  .vio_tg_restart                      (vio_tg_restart_9),
  .vio_tg_pause                        (vio_tg_pause_9),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_9),
  .vio_tg_err_continue                 (vio_tg_err_continue_9),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_9),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_9),
  .vio_tg_instr_num                    (vio_tg_instr_num_9),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_9),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_9),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_9),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_9),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_9),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_9),
  .vio_tg_seed_num                     (vio_tg_seed_num_9),
  .vio_tg_seed                         (vio_tg_seed_9),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_9),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_9),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_9),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_9),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_9),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_9),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_9),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_9),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_9),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_9),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_9),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_9),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_9),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_9),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_9),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_9),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_9),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_9),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_9),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_9),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_9),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_9),
  .vio_tg_status_err_type              (vio_tg_status_err_type_9),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_9),
  .vio_tg_status_done                  (boot_mode_done_9),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_9),
  .tg_ila_debug                        (tg_ila_debug_9),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_09_AWREADY),
  .o_m_axi_awid                        (AXI_09_AWID),
  .o_m_axi_awaddr                      (AXI_09_AWADDR),
  .o_m_axi_awlen                       (AXI_09_AWLEN),
  .o_m_axi_awsize                      (AXI_09_AWSIZE),
  .o_m_axi_awburst                     (AXI_09_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_09_AWCACHE),
  .o_m_axi_awprot                      (AXI_09_AWPROT),
  .o_m_axi_awvalid                     (AXI_09_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_09_WREADY),
  .o_m_axi_wdata                       (AXI_09_WDATA),
  .o_m_axi_wstrb                       (AXI_09_WSTRB),
  .o_m_axi_wlast                       (AXI_09_WLAST),
  .o_m_axi_wvalid                      (AXI_09_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_09_BID),
  .i_m_axi_bresp                       (AXI_09_BRESP),
  .i_m_axi_bvalid                      (AXI_09_BVALID),
  .o_m_axi_bready                      (AXI_09_BREADY),
  .i_m_axi_arready                     (AXI_09_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_09_ARID),
  .o_m_axi_araddr                      (AXI_09_ARADDR),
  .o_m_axi_arlen                       (AXI_09_ARLEN),
  .o_m_axi_arsize                      (AXI_09_ARSIZE),
  .o_m_axi_arburst                     (AXI_09_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_09_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_09_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_09_RID),
  .i_m_axi_rresp                       (AXI_09_RRESP),
  .i_m_axi_rvalid                      (AXI_09_RVALID),
  .i_m_axi_rdata                       (AXI_09_RDATA),
  .i_m_axi_rlast                       (AXI_09_RLAST),
  .o_m_axi_rready                      (AXI_09_RREADY)
);

assign  vio_tg_rst_9 =  1'd0;
assign  i_force_vio_tg_status_done_9 = 16'h0000;
assign  i_vio_enable_atg_axi_x_9 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_9 =  16'hffff;
assign  vio_tg_restart_9 =  'd0;
assign  vio_tg_err_chk_en_9 =  'd0;
assign  vio_tg_err_clear_9 =  'd0;
assign  vio_tg_err_clear_all_9 =  'd0;
assign  vio_tg_err_continue_9 =  'd0;
assign  vio_tg_instr_program_en_9 =  'd0;
assign  vio_tg_direct_instr_en_9 =  'd0;
assign  vio_tg_instr_num_9 =  'd0;
assign  vio_tg_instr_addr_mode_9 =  'd0;
assign  vio_tg_instr_data_mode_9 =  'd0;
assign  vio_tg_instr_rw_mode_9 =  'd0;
assign  vio_tg_instr_rw_submode_9 =  'd0;
assign  vio_tg_instr_victim_mode_9 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_9 =  'd0;
assign  vio_tg_instr_victim_select_9 =  'd0;
assign  vio_tg_instr_num_of_iter_9 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_9 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_9 =  'd0;
assign  vio_tg_instr_nxt_instr_9 =  'd0;
assign  vio_tg_seed_program_en_9 =  'd0;
assign  vio_tg_seed_num_9 =  'd0;
assign  vio_tg_seed_9 =  'd0;
assign  vio_tg_glb_start_addr_9 = 33'h0_9000_0000;

always@(posedge AXI_ACLK4_st0_buf or negedge axi_rst4_st0_n) begin
  if (~axi_rst4_st0_n) begin
    rd_cnt_09 <= 5'b0;
  end else if (AXI_09_RVALID && AXI_09_RREADY) begin
    rd_cnt_09 <= rd_cnt_09 + 1'b1;
  end
end

always@(posedge AXI_ACLK4_st0_buf or negedge axi_rst4_st0_n) begin
  if (~axi_rst4_st0_n) begin
    wr_cnt_09 <= 5'b0;
  end else if (AXI_09_BVALID && AXI_09_BREADY) begin
    wr_cnt_09 <= wr_cnt_09 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 9
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (9)
) u_axi_pmon_9 (
  .axi_arst_n              (axi_rst4_st0_n    ),
  .axi_aclk                (AXI_ACLK4_st0_buf ),
  .axi_awid                (AXI_09_AWID),
  .axi_awaddr              (AXI_09_AWADDR),
  .axi_awlen               (AXI_09_AWLEN),
  .axi_awsize              (AXI_09_AWSIZE),
  .axi_awburst             (AXI_09_AWBURST),
  .axi_awcache             (AXI_09_AWCACHE),
  .axi_awprot              (AXI_09_AWPROT),
  .axi_awvalid             (AXI_09_AWVALID),
  .axi_awready             (AXI_09_AWREADY),
  .axi_wdata               (AXI_09_WDATA),
  .axi_wstrb               (AXI_09_WSTRB),
  .axi_wlast               (AXI_09_WLAST),
  .axi_wvalid              (AXI_09_WVALID),
  .axi_wready              (AXI_09_WREADY),
  .axi_bready              (AXI_09_BREADY),
  .axi_bid                 (AXI_09_BID),
  .axi_bresp               (AXI_09_BRESP),
  .axi_bvalid              (AXI_09_BVALID),
  .axi_arid                (AXI_09_ARID),
  .axi_araddr              (AXI_09_ARADDR),
  .axi_arlen               (AXI_09_ARLEN),
  .axi_arsize              (AXI_09_ARSIZE),
  .axi_arburst             (AXI_09_ARBURST),
  .axi_arcache             (AXI_09_ARCACHE),
  .axi_arvalid             (AXI_09_ARVALID),
  .axi_arready             (AXI_09_ARREADY),
  .axi_rready              (AXI_09_RREADY),
  .axi_rid                 (AXI_09_RID),
  .axi_rdata               (AXI_09_RDATA),
  .axi_rresp               (AXI_09_RRESP),
  .axi_rlast               (AXI_09_RLAST),
  .axi_rvalid              (AXI_09_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 10
////////////////////////////////////////////////////////////////////////////////
// assign AXI_10_ARADDR = {vio_tg_glb_start_addr_10[32:28],o_m_axi_araddr_10[27:0]};
// assign AXI_10_AWADDR = {vio_tg_glb_start_addr_10[32:28],o_m_axi_awaddr_10[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_10 (
  .sr_done                             (sr_done[10]),
  .sr_newd                             (sr_newd[10]),
  .sr_din                              (sr_din[10]),
  .sr_dout                             (sr_dout[10]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK5_st0_buf),
  .i_rst                               (~axi_rst5_st0_n),
  .i_init_calib_complete               (apb_seq_complete_5_st0_r2),
  .compare_error                       (axi_10_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_10),
  .vio_tg_start                        (vio_tg_start_10),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_10),
  .vio_tg_err_clear                    (vio_tg_err_clear_10),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_10),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_10),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_10),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_10),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_10),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_10),
  .vio_tg_restart                      (vio_tg_restart_10),
  .vio_tg_pause                        (vio_tg_pause_10),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_10),
  .vio_tg_err_continue                 (vio_tg_err_continue_10),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_10),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_10),
  .vio_tg_instr_num                    (vio_tg_instr_num_10),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_10),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_10),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_10),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_10),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_10),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_10),
  .vio_tg_seed_num                     (vio_tg_seed_num_10),
  .vio_tg_seed                         (vio_tg_seed_10),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_10),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_10),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_10),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_10),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_10),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_10),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_10),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_10),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_10),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_10),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_10),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_10),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_10),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_10),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_10),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_10),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_10),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_10),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_10),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_10),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_10),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_10),
  .vio_tg_status_err_type              (vio_tg_status_err_type_10),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_10),
  .vio_tg_status_done                  (boot_mode_done_10),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_10),
  .tg_ila_debug                        (tg_ila_debug_10),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_10_AWREADY),
  .o_m_axi_awid                        (AXI_10_AWID),
  .o_m_axi_awaddr                      (AXI_10_AWADDR),
  .o_m_axi_awlen                       (AXI_10_AWLEN),
  .o_m_axi_awsize                      (AXI_10_AWSIZE),
  .o_m_axi_awburst                     (AXI_10_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_10_AWCACHE),
  .o_m_axi_awprot                      (AXI_10_AWPROT),
  .o_m_axi_awvalid                     (AXI_10_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_10_WREADY),
  .o_m_axi_wdata                       (AXI_10_WDATA),
  .o_m_axi_wstrb                       (AXI_10_WSTRB),
  .o_m_axi_wlast                       (AXI_10_WLAST),
  .o_m_axi_wvalid                      (AXI_10_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_10_BID),
  .i_m_axi_bresp                       (AXI_10_BRESP),
  .i_m_axi_bvalid                      (AXI_10_BVALID),
  .o_m_axi_bready                      (AXI_10_BREADY),
  .i_m_axi_arready                     (AXI_10_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_10_ARID),
  .o_m_axi_araddr                      (AXI_10_ARADDR),
  .o_m_axi_arlen                       (AXI_10_ARLEN),
  .o_m_axi_arsize                      (AXI_10_ARSIZE),
  .o_m_axi_arburst                     (AXI_10_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_10_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_10_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_10_RID),
  .i_m_axi_rresp                       (AXI_10_RRESP),
  .i_m_axi_rvalid                      (AXI_10_RVALID),
  .i_m_axi_rdata                       (AXI_10_RDATA),
  .i_m_axi_rlast                       (AXI_10_RLAST),
  .o_m_axi_rready                      (AXI_10_RREADY)
);

assign  vio_tg_rst_10 =  1'd0;
assign  i_force_vio_tg_status_done_10 = 16'h0000;
assign  i_vio_enable_atg_axi_x_10 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_10 =  16'hffff;
assign  vio_tg_restart_10 =  'd0;
assign  vio_tg_err_chk_en_10 =  'd0;
assign  vio_tg_err_clear_10 =  'd0;
assign  vio_tg_err_clear_all_10 =  'd0;
assign  vio_tg_err_continue_10 =  'd0;
assign  vio_tg_instr_program_en_10 =  'd0;
assign  vio_tg_direct_instr_en_10 =  'd0;
assign  vio_tg_instr_num_10 =  'd0;
assign  vio_tg_instr_addr_mode_10 =  'd0;
assign  vio_tg_instr_data_mode_10 =  'd0;
assign  vio_tg_instr_rw_mode_10 =  'd0;
assign  vio_tg_instr_rw_submode_10 =  'd0;
assign  vio_tg_instr_victim_mode_10 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_10 =  'd0;
assign  vio_tg_instr_victim_select_10 =  'd0;
assign  vio_tg_instr_num_of_iter_10 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_10 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_10 =  'd0;
assign  vio_tg_instr_nxt_instr_10 =  'd0;
assign  vio_tg_seed_program_en_10 =  'd0;
assign  vio_tg_seed_num_10 =  'd0;
assign  vio_tg_seed_10 =  'd0;
assign  vio_tg_glb_start_addr_10 = 33'h0_A000_0000;

always@(posedge AXI_ACLK5_st0_buf or negedge axi_rst5_st0_n) begin
  if (~axi_rst5_st0_n) begin
    rd_cnt_10 <= 5'b0;
  end else if (AXI_10_RVALID && AXI_10_RREADY) begin
    rd_cnt_10 <= rd_cnt_10 + 1'b1;
  end
end

always@(posedge AXI_ACLK5_st0_buf or negedge axi_rst5_st0_n) begin
  if (~axi_rst5_st0_n) begin
    wr_cnt_10 <= 5'b0;
  end else if (AXI_10_BVALID && AXI_10_BREADY) begin
    wr_cnt_10 <= wr_cnt_10 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 10
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (10)
) u_axi_pmon_10 (
  .axi_arst_n              (axi_rst5_st0_n    ),
  .axi_aclk                (AXI_ACLK5_st0_buf ),
  .axi_awid                (AXI_10_AWID),
  .axi_awaddr              (AXI_10_AWADDR),
  .axi_awlen               (AXI_10_AWLEN),
  .axi_awsize              (AXI_10_AWSIZE),
  .axi_awburst             (AXI_10_AWBURST),
  .axi_awcache             (AXI_10_AWCACHE),
  .axi_awprot              (AXI_10_AWPROT),
  .axi_awvalid             (AXI_10_AWVALID),
  .axi_awready             (AXI_10_AWREADY),
  .axi_wdata               (AXI_10_WDATA),
  .axi_wstrb               (AXI_10_WSTRB),
  .axi_wlast               (AXI_10_WLAST),
  .axi_wvalid              (AXI_10_WVALID),
  .axi_wready              (AXI_10_WREADY),
  .axi_bready              (AXI_10_BREADY),
  .axi_bid                 (AXI_10_BID),
  .axi_bresp               (AXI_10_BRESP),
  .axi_bvalid              (AXI_10_BVALID),
  .axi_arid                (AXI_10_ARID),
  .axi_araddr              (AXI_10_ARADDR),
  .axi_arlen               (AXI_10_ARLEN),
  .axi_arsize              (AXI_10_ARSIZE),
  .axi_arburst             (AXI_10_ARBURST),
  .axi_arcache             (AXI_10_ARCACHE),
  .axi_arvalid             (AXI_10_ARVALID),
  .axi_arready             (AXI_10_ARREADY),
  .axi_rready              (AXI_10_RREADY),
  .axi_rid                 (AXI_10_RID),
  .axi_rdata               (AXI_10_RDATA),
  .axi_rresp               (AXI_10_RRESP),
  .axi_rlast               (AXI_10_RLAST),
  .axi_rvalid              (AXI_10_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 11
////////////////////////////////////////////////////////////////////////////////
// assign AXI_11_ARADDR = {vio_tg_glb_start_addr_11[32:28],o_m_axi_araddr_11[27:0]};
// assign AXI_11_AWADDR = {vio_tg_glb_start_addr_11[32:28],o_m_axi_awaddr_11[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_11 (
  .sr_done                             (sr_done[11]),
  .sr_newd                             (sr_newd[11]),
  .sr_din                              (sr_din[11]),
  .sr_dout                             (sr_dout[11]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK5_st0_buf),
  .i_rst                               (~axi_rst5_st0_n),
  .i_init_calib_complete               (apb_seq_complete_5_st0_r2),
  .compare_error                       (axi_11_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_11),
  .vio_tg_start                        (vio_tg_start_11),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_11),
  .vio_tg_err_clear                    (vio_tg_err_clear_11),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_11),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_11),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_11),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_11),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_11),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_11),
  .vio_tg_restart                      (vio_tg_restart_11),
  .vio_tg_pause                        (vio_tg_pause_11),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_11),
  .vio_tg_err_continue                 (vio_tg_err_continue_11),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_11),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_11),
  .vio_tg_instr_num                    (vio_tg_instr_num_11),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_11),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_11),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_11),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_11),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_11),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_11),
  .vio_tg_seed_num                     (vio_tg_seed_num_11),
  .vio_tg_seed                         (vio_tg_seed_11),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_11),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_11),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_11),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_11),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_11),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_11),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_11),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_11),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_11),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_11),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_11),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_11),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_11),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_11),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_11),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_11),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_11),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_11),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_11),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_11),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_11),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_11),
  .vio_tg_status_err_type              (vio_tg_status_err_type_11),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_11),
  .vio_tg_status_done                  (boot_mode_done_11),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_11),
  .tg_ila_debug                        (tg_ila_debug_11),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_11_AWREADY),
  .o_m_axi_awid                        (AXI_11_AWID),
  .o_m_axi_awaddr                      (AXI_11_AWADDR),
  .o_m_axi_awlen                       (AXI_11_AWLEN),
  .o_m_axi_awsize                      (AXI_11_AWSIZE),
  .o_m_axi_awburst                     (AXI_11_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_11_AWCACHE),
  .o_m_axi_awprot                      (AXI_11_AWPROT),
  .o_m_axi_awvalid                     (AXI_11_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_11_WREADY),
  .o_m_axi_wdata                       (AXI_11_WDATA),
  .o_m_axi_wstrb                       (AXI_11_WSTRB),
  .o_m_axi_wlast                       (AXI_11_WLAST),
  .o_m_axi_wvalid                      (AXI_11_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_11_BID),
  .i_m_axi_bresp                       (AXI_11_BRESP),
  .i_m_axi_bvalid                      (AXI_11_BVALID),
  .o_m_axi_bready                      (AXI_11_BREADY),
  .i_m_axi_arready                     (AXI_11_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_11_ARID),
  .o_m_axi_araddr                      (AXI_11_ARADDR),
  .o_m_axi_arlen                       (AXI_11_ARLEN),
  .o_m_axi_arsize                      (AXI_11_ARSIZE),
  .o_m_axi_arburst                     (AXI_11_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_11_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_11_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_11_RID),
  .i_m_axi_rresp                       (AXI_11_RRESP),
  .i_m_axi_rvalid                      (AXI_11_RVALID),
  .i_m_axi_rdata                       (AXI_11_RDATA),
  .i_m_axi_rlast                       (AXI_11_RLAST),
  .o_m_axi_rready                      (AXI_11_RREADY)
);

assign  vio_tg_rst_11 =  1'd0;
assign  i_force_vio_tg_status_done_11 = 16'h0000;
assign  i_vio_enable_atg_axi_x_11 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_11 =  16'hffff;
assign  vio_tg_restart_11 =  'd0;
assign  vio_tg_err_chk_en_11 =  'd0;
assign  vio_tg_err_clear_11 =  'd0;
assign  vio_tg_err_clear_all_11 =  'd0;
assign  vio_tg_err_continue_11 =  'd0;
assign  vio_tg_instr_program_en_11 =  'd0;
assign  vio_tg_direct_instr_en_11 =  'd0;
assign  vio_tg_instr_num_11 =  'd0;
assign  vio_tg_instr_addr_mode_11 =  'd0;
assign  vio_tg_instr_data_mode_11 =  'd0;
assign  vio_tg_instr_rw_mode_11 =  'd0;
assign  vio_tg_instr_rw_submode_11 =  'd0;
assign  vio_tg_instr_victim_mode_11 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_11 =  'd0;
assign  vio_tg_instr_victim_select_11 =  'd0;
assign  vio_tg_instr_num_of_iter_11 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_11 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_11 =  'd0;
assign  vio_tg_instr_nxt_instr_11 =  'd0;
assign  vio_tg_seed_program_en_11 =  'd0;
assign  vio_tg_seed_num_11 =  'd0;
assign  vio_tg_seed_11 =  'd0;
assign  vio_tg_glb_start_addr_11 = 33'h0_B000_0000;

always@(posedge AXI_ACLK5_st0_buf or negedge axi_rst5_st0_n) begin
  if (~axi_rst5_st0_n) begin
    rd_cnt_11 <= 5'b0;
  end else if (AXI_11_RVALID && AXI_11_RREADY) begin
    rd_cnt_11 <= rd_cnt_11 + 1'b1;
  end
end

always@(posedge AXI_ACLK5_st0_buf or negedge axi_rst5_st0_n) begin
  if (~axi_rst5_st0_n) begin
    wr_cnt_11 <= 5'b0;
  end else if (AXI_11_BVALID && AXI_11_BREADY) begin
    wr_cnt_11 <= wr_cnt_11 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 11
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (11)
) u_axi_pmon_11 (
  .axi_arst_n              (axi_rst5_st0_n    ),
  .axi_aclk                (AXI_ACLK5_st0_buf ),
  .axi_awid                (AXI_11_AWID),
  .axi_awaddr              (AXI_11_AWADDR),
  .axi_awlen               (AXI_11_AWLEN),
  .axi_awsize              (AXI_11_AWSIZE),
  .axi_awburst             (AXI_11_AWBURST),
  .axi_awcache             (AXI_11_AWCACHE),
  .axi_awprot              (AXI_11_AWPROT),
  .axi_awvalid             (AXI_11_AWVALID),
  .axi_awready             (AXI_11_AWREADY),
  .axi_wdata               (AXI_11_WDATA),
  .axi_wstrb               (AXI_11_WSTRB),
  .axi_wlast               (AXI_11_WLAST),
  .axi_wvalid              (AXI_11_WVALID),
  .axi_wready              (AXI_11_WREADY),
  .axi_bready              (AXI_11_BREADY),
  .axi_bid                 (AXI_11_BID),
  .axi_bresp               (AXI_11_BRESP),
  .axi_bvalid              (AXI_11_BVALID),
  .axi_arid                (AXI_11_ARID),
  .axi_araddr              (AXI_11_ARADDR),
  .axi_arlen               (AXI_11_ARLEN),
  .axi_arsize              (AXI_11_ARSIZE),
  .axi_arburst             (AXI_11_ARBURST),
  .axi_arcache             (AXI_11_ARCACHE),
  .axi_arvalid             (AXI_11_ARVALID),
  .axi_arready             (AXI_11_ARREADY),
  .axi_rready              (AXI_11_RREADY),
  .axi_rid                 (AXI_11_RID),
  .axi_rdata               (AXI_11_RDATA),
  .axi_rresp               (AXI_11_RRESP),
  .axi_rlast               (AXI_11_RLAST),
  .axi_rvalid              (AXI_11_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 12
////////////////////////////////////////////////////////////////////////////////
// assign AXI_12_ARADDR = {vio_tg_glb_start_addr_12[32:28],o_m_axi_araddr_12[27:0]};
// assign AXI_12_AWADDR = {vio_tg_glb_start_addr_12[32:28],o_m_axi_awaddr_12[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_12 (
  .sr_done                             (sr_done[12]),
  .sr_newd                             (sr_newd[12]),
  .sr_din                              (sr_din[12]),
  .sr_dout                             (sr_dout[12]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK5_st0_buf),
  .i_rst                               (~axi_rst5_st0_n),
  .i_init_calib_complete               (apb_seq_complete_5_st0_r2),
  .compare_error                       (axi_12_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_12),
  .vio_tg_start                        (vio_tg_start_12),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_12),
  .vio_tg_err_clear                    (vio_tg_err_clear_12),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_12),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_12),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_12),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_12),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_12),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_12),
  .vio_tg_restart                      (vio_tg_restart_12),
  .vio_tg_pause                        (vio_tg_pause_12),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_12),
  .vio_tg_err_continue                 (vio_tg_err_continue_12),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_12),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_12),
  .vio_tg_instr_num                    (vio_tg_instr_num_12),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_12),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_12),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_12),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_12),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_12),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_12),
  .vio_tg_seed_num                     (vio_tg_seed_num_12),
  .vio_tg_seed                         (vio_tg_seed_12),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_12),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_12),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_12),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_12),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_12),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_12),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_12),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_12),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_12),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_12),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_12),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_12),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_12),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_12),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_12),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_12),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_12),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_12),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_12),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_12),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_12),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_12),
  .vio_tg_status_err_type              (vio_tg_status_err_type_12),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_12),
  .vio_tg_status_done                  (boot_mode_done_12),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_12),
  .tg_ila_debug                        (tg_ila_debug_12),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_12_AWREADY),
  .o_m_axi_awid                        (AXI_12_AWID),
  .o_m_axi_awaddr                      (AXI_12_AWADDR),
  .o_m_axi_awlen                       (AXI_12_AWLEN),
  .o_m_axi_awsize                      (AXI_12_AWSIZE),
  .o_m_axi_awburst                     (AXI_12_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_12_AWCACHE),
  .o_m_axi_awprot                      (AXI_12_AWPROT),
  .o_m_axi_awvalid                     (AXI_12_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_12_WREADY),
  .o_m_axi_wdata                       (AXI_12_WDATA),
  .o_m_axi_wstrb                       (AXI_12_WSTRB),
  .o_m_axi_wlast                       (AXI_12_WLAST),
  .o_m_axi_wvalid                      (AXI_12_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_12_BID),
  .i_m_axi_bresp                       (AXI_12_BRESP),
  .i_m_axi_bvalid                      (AXI_12_BVALID),
  .o_m_axi_bready                      (AXI_12_BREADY),
  .i_m_axi_arready                     (AXI_12_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_12_ARID),
  .o_m_axi_araddr                      (AXI_12_ARADDR),
  .o_m_axi_arlen                       (AXI_12_ARLEN),
  .o_m_axi_arsize                      (AXI_12_ARSIZE),
  .o_m_axi_arburst                     (AXI_12_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_12_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_12_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_12_RID),
  .i_m_axi_rresp                       (AXI_12_RRESP),
  .i_m_axi_rvalid                      (AXI_12_RVALID),
  .i_m_axi_rdata                       (AXI_12_RDATA),
  .i_m_axi_rlast                       (AXI_12_RLAST),
  .o_m_axi_rready                      (AXI_12_RREADY)
);

assign  vio_tg_rst_12 =  1'd0;
assign  i_force_vio_tg_status_done_12 = 16'h0000;
assign  i_vio_enable_atg_axi_x_12 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_12 =  16'hffff;
assign  vio_tg_restart_12 =  'd0;
assign  vio_tg_err_chk_en_12 =  'd0;
assign  vio_tg_err_clear_12 =  'd0;
assign  vio_tg_err_clear_all_12 =  'd0;
assign  vio_tg_err_continue_12 =  'd0;
assign  vio_tg_instr_program_en_12 =  'd0;
assign  vio_tg_direct_instr_en_12 =  'd0;
assign  vio_tg_instr_num_12 =  'd0;
assign  vio_tg_instr_addr_mode_12 =  'd0;
assign  vio_tg_instr_data_mode_12 =  'd0;
assign  vio_tg_instr_rw_mode_12 =  'd0;
assign  vio_tg_instr_rw_submode_12 =  'd0;
assign  vio_tg_instr_victim_mode_12 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_12 =  'd0;
assign  vio_tg_instr_victim_select_12 =  'd0;
assign  vio_tg_instr_num_of_iter_12 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_12 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_12 =  'd0;
assign  vio_tg_instr_nxt_instr_12 =  'd0;
assign  vio_tg_seed_program_en_12 =  'd0;
assign  vio_tg_seed_num_12 =  'd0;
assign  vio_tg_seed_12 =  'd0;
assign  vio_tg_glb_start_addr_12 = 33'h0_C000_0000;

always@(posedge AXI_ACLK5_st0_buf or negedge axi_rst5_st0_n) begin
  if (~axi_rst5_st0_n) begin
    rd_cnt_12 <= 5'b0;
  end else if (AXI_12_RVALID && AXI_12_RREADY) begin
    rd_cnt_12 <= rd_cnt_12 + 1'b1;
  end
end

always@(posedge AXI_ACLK5_st0_buf or negedge axi_rst5_st0_n) begin
  if (~axi_rst5_st0_n) begin
    wr_cnt_12 <= 5'b0;
  end else if (AXI_12_BVALID && AXI_12_BREADY) begin
    wr_cnt_12 <= wr_cnt_12 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 12
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (12)
) u_axi_pmon_12 (
  .axi_arst_n              (axi_rst5_st0_n    ),
  .axi_aclk                (AXI_ACLK5_st0_buf),
  .axi_awid                (AXI_12_AWID),
  .axi_awaddr              (AXI_12_AWADDR),
  .axi_awlen               (AXI_12_AWLEN),
  .axi_awsize              (AXI_12_AWSIZE),
  .axi_awburst             (AXI_12_AWBURST),
  .axi_awcache             (AXI_12_AWCACHE),
  .axi_awprot              (AXI_12_AWPROT),
  .axi_awvalid             (AXI_12_AWVALID),
  .axi_awready             (AXI_12_AWREADY),
  .axi_wdata               (AXI_12_WDATA),
  .axi_wstrb               (AXI_12_WSTRB),
  .axi_wlast               (AXI_12_WLAST),
  .axi_wvalid              (AXI_12_WVALID),
  .axi_wready              (AXI_12_WREADY),
  .axi_bready              (AXI_12_BREADY),
  .axi_bid                 (AXI_12_BID),
  .axi_bresp               (AXI_12_BRESP),
  .axi_bvalid              (AXI_12_BVALID),
  .axi_arid                (AXI_12_ARID),
  .axi_araddr              (AXI_12_ARADDR),
  .axi_arlen               (AXI_12_ARLEN),
  .axi_arsize              (AXI_12_ARSIZE),
  .axi_arburst             (AXI_12_ARBURST),
  .axi_arcache             (AXI_12_ARCACHE),
  .axi_arvalid             (AXI_12_ARVALID),
  .axi_arready             (AXI_12_ARREADY),
  .axi_rready              (AXI_12_RREADY),
  .axi_rid                 (AXI_12_RID),
  .axi_rdata               (AXI_12_RDATA),
  .axi_rresp               (AXI_12_RRESP),
  .axi_rlast               (AXI_12_RLAST),
  .axi_rvalid              (AXI_12_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 13
////////////////////////////////////////////////////////////////////////////////
// assign AXI_13_ARADDR = {vio_tg_glb_start_addr_13[32:28],o_m_axi_araddr_13[27:0]};
// assign AXI_13_AWADDR = {vio_tg_glb_start_addr_13[32:28],o_m_axi_awaddr_13[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_13 (
  .sr_done                             (sr_done[13]),
  .sr_newd                             (sr_newd[13]),
  .sr_din                              (sr_din[13]),
  .sr_dout                             (sr_dout[13]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK6_st0_buf),
  .i_rst                               (~axi_rst6_st0_n),
  .i_init_calib_complete               (apb_seq_complete_6_st0_r2),
  .compare_error                       (axi_13_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_13),
  .vio_tg_start                        (vio_tg_start_13),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_13),
  .vio_tg_err_clear                    (vio_tg_err_clear_13),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_13),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_13),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_13),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_13),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_13),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_13),
  .vio_tg_restart                      (vio_tg_restart_13),
  .vio_tg_pause                        (vio_tg_pause_13),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_13),
  .vio_tg_err_continue                 (vio_tg_err_continue_13),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_13),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_13),
  .vio_tg_instr_num                    (vio_tg_instr_num_13),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_13),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_13),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_13),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_13),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_13),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_13),
  .vio_tg_seed_num                     (vio_tg_seed_num_13),
  .vio_tg_seed                         (vio_tg_seed_13),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_13),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_13),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_13),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_13),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_13),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_13),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_13),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_13),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_13),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_13),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_13),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_13),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_13),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_13),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_13),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_13),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_13),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_13),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_13),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_13),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_13),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_13),
  .vio_tg_status_err_type              (vio_tg_status_err_type_13),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_13),
  .vio_tg_status_done                  (boot_mode_done_13),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_13),
  .tg_ila_debug                        (tg_ila_debug_13),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_13_AWREADY),
  .o_m_axi_awid                        (AXI_13_AWID),
  .o_m_axi_awaddr                      (AXI_13_AWADDR),
  .o_m_axi_awlen                       (AXI_13_AWLEN),
  .o_m_axi_awsize                      (AXI_13_AWSIZE),
  .o_m_axi_awburst                     (AXI_13_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_13_AWCACHE),
  .o_m_axi_awprot                      (AXI_13_AWPROT),
  .o_m_axi_awvalid                     (AXI_13_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_13_WREADY),
  .o_m_axi_wdata                       (AXI_13_WDATA),
  .o_m_axi_wstrb                       (AXI_13_WSTRB),
  .o_m_axi_wlast                       (AXI_13_WLAST),
  .o_m_axi_wvalid                      (AXI_13_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_13_BID),
  .i_m_axi_bresp                       (AXI_13_BRESP),
  .i_m_axi_bvalid                      (AXI_13_BVALID),
  .o_m_axi_bready                      (AXI_13_BREADY),
  .i_m_axi_arready                     (AXI_13_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_13_ARID),
  .o_m_axi_araddr                      (AXI_13_ARADDR),
  .o_m_axi_arlen                       (AXI_13_ARLEN),
  .o_m_axi_arsize                      (AXI_13_ARSIZE),
  .o_m_axi_arburst                     (AXI_13_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_13_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_13_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_13_RID),
  .i_m_axi_rresp                       (AXI_13_RRESP),
  .i_m_axi_rvalid                      (AXI_13_RVALID),
  .i_m_axi_rdata                       (AXI_13_RDATA),
  .i_m_axi_rlast                       (AXI_13_RLAST),
  .o_m_axi_rready                      (AXI_13_RREADY)
);

assign  vio_tg_rst_13 =  1'd0;
assign  i_force_vio_tg_status_done_13 = 16'h0000;
assign  i_vio_enable_atg_axi_x_13 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_13 =  16'hffff;
assign  vio_tg_restart_13 =  'd0;
assign  vio_tg_err_chk_en_13 =  'd0;
assign  vio_tg_err_clear_13 =  'd0;
assign  vio_tg_err_clear_all_13 =  'd0;
assign  vio_tg_err_continue_13 =  'd0;
assign  vio_tg_instr_program_en_13 =  'd0;
assign  vio_tg_direct_instr_en_13 =  'd0;
assign  vio_tg_instr_num_13 =  'd0;
assign  vio_tg_instr_addr_mode_13 =  'd0;
assign  vio_tg_instr_data_mode_13 =  'd0;
assign  vio_tg_instr_rw_mode_13 =  'd0;
assign  vio_tg_instr_rw_submode_13 =  'd0;
assign  vio_tg_instr_victim_mode_13 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_13 =  'd0;
assign  vio_tg_instr_victim_select_13 =  'd0;
assign  vio_tg_instr_num_of_iter_13 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_13 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_13 =  'd0;
assign  vio_tg_instr_nxt_instr_13 =  'd0;
assign  vio_tg_seed_program_en_13 =  'd0;
assign  vio_tg_seed_num_13 =  'd0;
assign  vio_tg_seed_13 =  'd0;
assign  vio_tg_glb_start_addr_13 = 33'h0_D000_0000;

always@(posedge AXI_ACLK6_st0_buf or negedge axi_rst6_st0_n) begin
  if (~axi_rst6_st0_n) begin
    rd_cnt_13 <= 5'b0;
  end else if (AXI_13_RVALID && AXI_13_RREADY) begin
    rd_cnt_13 <= rd_cnt_13 + 1'b1;
  end
end

always@(posedge AXI_ACLK6_st0_buf or negedge axi_rst6_st0_n) begin
  if (~axi_rst6_st0_n) begin
    wr_cnt_13 <= 5'b0;
  end else if (AXI_13_BVALID && AXI_13_BREADY) begin
    wr_cnt_13 <= wr_cnt_13 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 13
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (13)
) u_axi_pmon_13 (
  .axi_arst_n              (axi_rst6_st0_n    ),
  .axi_aclk                (AXI_ACLK6_st0_buf ),
  .axi_awid                (AXI_13_AWID),
  .axi_awaddr              (AXI_13_AWADDR),
  .axi_awlen               (AXI_13_AWLEN),
  .axi_awsize              (AXI_13_AWSIZE),
  .axi_awburst             (AXI_13_AWBURST),
  .axi_awcache             (AXI_13_AWCACHE),
  .axi_awprot              (AXI_13_AWPROT),
  .axi_awvalid             (AXI_13_AWVALID),
  .axi_awready             (AXI_13_AWREADY),
  .axi_wdata               (AXI_13_WDATA),
  .axi_wstrb               (AXI_13_WSTRB),
  .axi_wlast               (AXI_13_WLAST),
  .axi_wvalid              (AXI_13_WVALID),
  .axi_wready              (AXI_13_WREADY),
  .axi_bready              (AXI_13_BREADY),
  .axi_bid                 (AXI_13_BID),
  .axi_bresp               (AXI_13_BRESP),
  .axi_bvalid              (AXI_13_BVALID),
  .axi_arid                (AXI_13_ARID),
  .axi_araddr              (AXI_13_ARADDR),
  .axi_arlen               (AXI_13_ARLEN),
  .axi_arsize              (AXI_13_ARSIZE),
  .axi_arburst             (AXI_13_ARBURST),
  .axi_arcache             (AXI_13_ARCACHE),
  .axi_arvalid             (AXI_13_ARVALID),
  .axi_arready             (AXI_13_ARREADY),
  .axi_rready              (AXI_13_RREADY),
  .axi_rid                 (AXI_13_RID),
  .axi_rdata               (AXI_13_RDATA),
  .axi_rresp               (AXI_13_RRESP),
  .axi_rlast               (AXI_13_RLAST),
  .axi_rvalid              (AXI_13_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 14
////////////////////////////////////////////////////////////////////////////////
// assign AXI_14_ARADDR = {vio_tg_glb_start_addr_14[32:28],o_m_axi_araddr_14[27:0]};
// assign AXI_14_AWADDR = {vio_tg_glb_start_addr_14[32:28],o_m_axi_awaddr_14[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_14 (
  .sr_done                             (sr_done[14]),
  .sr_newd                             (sr_newd[14]),
  .sr_din                              (sr_din[14]),
  .sr_dout                             (sr_dout[14]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK6_st0_buf),
  .i_rst                               (~axi_rst6_st0_n),
  .i_init_calib_complete               (apb_seq_complete_6_st0_r2),
  .compare_error                       (axi_14_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_14),
  .vio_tg_start                        (vio_tg_start_14),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_14),
  .vio_tg_err_clear                    (vio_tg_err_clear_14),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_14),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_14),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_14),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_14),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_14),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_14),
  .vio_tg_restart                      (vio_tg_restart_14),
  .vio_tg_pause                        (vio_tg_pause_14),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_14),
  .vio_tg_err_continue                 (vio_tg_err_continue_14),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_14),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_14),
  .vio_tg_instr_num                    (vio_tg_instr_num_14),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_14),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_14),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_14),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_14),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_14),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_14),
  .vio_tg_seed_num                     (vio_tg_seed_num_14),
  .vio_tg_seed                         (vio_tg_seed_14),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_14),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_14),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_14),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_14),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_14),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_14),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_14),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_14),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_14),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_14),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_14),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_14),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_14),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_14),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_14),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_14),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_14),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_14),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_14),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_14),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_14),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_14),
  .vio_tg_status_err_type              (vio_tg_status_err_type_14),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_14),
  .vio_tg_status_done                  (boot_mode_done_14),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_14),
  .tg_ila_debug                        (tg_ila_debug_14),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_14_AWREADY),
  .o_m_axi_awid                        (AXI_14_AWID),
  .o_m_axi_awaddr                      (AXI_14_AWADDR),
  .o_m_axi_awlen                       (AXI_14_AWLEN),
  .o_m_axi_awsize                      (AXI_14_AWSIZE),
  .o_m_axi_awburst                     (AXI_14_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_14_AWCACHE),
  .o_m_axi_awprot                      (AXI_14_AWPROT),
  .o_m_axi_awvalid                     (AXI_14_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_14_WREADY),
  .o_m_axi_wdata                       (AXI_14_WDATA),
  .o_m_axi_wstrb                       (AXI_14_WSTRB),
  .o_m_axi_wlast                       (AXI_14_WLAST),
  .o_m_axi_wvalid                      (AXI_14_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_14_BID),
  .i_m_axi_bresp                       (AXI_14_BRESP),
  .i_m_axi_bvalid                      (AXI_14_BVALID),
  .o_m_axi_bready                      (AXI_14_BREADY),
  .i_m_axi_arready                     (AXI_14_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_14_ARID),
  .o_m_axi_araddr                      (AXI_14_ARADDR),
  .o_m_axi_arlen                       (AXI_14_ARLEN),
  .o_m_axi_arsize                      (AXI_14_ARSIZE),
  .o_m_axi_arburst                     (AXI_14_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_14_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_14_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_14_RID),
  .i_m_axi_rresp                       (AXI_14_RRESP),
  .i_m_axi_rvalid                      (AXI_14_RVALID),
  .i_m_axi_rdata                       (AXI_14_RDATA),
  .i_m_axi_rlast                       (AXI_14_RLAST),
  .o_m_axi_rready                      (AXI_14_RREADY)
);

assign  vio_tg_rst_14 =  1'd0;
assign  i_force_vio_tg_status_done_14 = 16'h0000;
assign  i_vio_enable_atg_axi_x_14 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_14 =  16'hffff;
assign  vio_tg_restart_14 =  'd0;
assign  vio_tg_err_chk_en_14 =  'd0;
assign  vio_tg_err_clear_14 =  'd0;
assign  vio_tg_err_clear_all_14 =  'd0;
assign  vio_tg_err_continue_14 =  'd0;
assign  vio_tg_instr_program_en_14 =  'd0;
assign  vio_tg_direct_instr_en_14 =  'd0;
assign  vio_tg_instr_num_14 =  'd0;
assign  vio_tg_instr_addr_mode_14 =  'd0;
assign  vio_tg_instr_data_mode_14 =  'd0;
assign  vio_tg_instr_rw_mode_14 =  'd0;
assign  vio_tg_instr_rw_submode_14 =  'd0;
assign  vio_tg_instr_victim_mode_14 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_14 =  'd0;
assign  vio_tg_instr_victim_select_14 =  'd0;
assign  vio_tg_instr_num_of_iter_14 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_14 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_14 =  'd0;
assign  vio_tg_instr_nxt_instr_14 =  'd0;
assign  vio_tg_seed_program_en_14 =  'd0;
assign  vio_tg_seed_num_14 =  'd0;
assign  vio_tg_seed_14 =  'd0;
assign  vio_tg_glb_start_addr_14 = 33'h0_E000_0000;

always@(posedge AXI_ACLK6_st0_buf or negedge axi_rst6_st0_n) begin
  if (~axi_rst6_st0_n) begin
    rd_cnt_14 <= 5'b0;
  end else if (AXI_14_RVALID && AXI_14_RREADY) begin
    rd_cnt_14 <= rd_cnt_14 + 1'b1;
  end
end

always@(posedge AXI_ACLK6_st0_buf or negedge axi_rst6_st0_n) begin
  if (~axi_rst6_st0_n) begin
    wr_cnt_14 <= 5'b0;
  end else if (AXI_14_BVALID && AXI_14_BREADY) begin
    wr_cnt_14 <= wr_cnt_14 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 14
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (14)
) u_axi_pmon_14 (
  .axi_arst_n              (axi_rst6_st0_n    ),
  .axi_aclk                (AXI_ACLK6_st0_buf ),
  .axi_awid                (AXI_14_AWID),
  .axi_awaddr              (AXI_14_AWADDR),
  .axi_awlen               (AXI_14_AWLEN),
  .axi_awsize              (AXI_14_AWSIZE),
  .axi_awburst             (AXI_14_AWBURST),
  .axi_awcache             (AXI_14_AWCACHE),
  .axi_awprot              (AXI_14_AWPROT),
  .axi_awvalid             (AXI_14_AWVALID),
  .axi_awready             (AXI_14_AWREADY),
  .axi_wdata               (AXI_14_WDATA),
  .axi_wstrb               (AXI_14_WSTRB),
  .axi_wlast               (AXI_14_WLAST),
  .axi_wvalid              (AXI_14_WVALID),
  .axi_wready              (AXI_14_WREADY),
  .axi_bready              (AXI_14_BREADY),
  .axi_bid                 (AXI_14_BID),
  .axi_bresp               (AXI_14_BRESP),
  .axi_bvalid              (AXI_14_BVALID),
  .axi_arid                (AXI_14_ARID),
  .axi_araddr              (AXI_14_ARADDR),
  .axi_arlen               (AXI_14_ARLEN),
  .axi_arsize              (AXI_14_ARSIZE),
  .axi_arburst             (AXI_14_ARBURST),
  .axi_arcache             (AXI_14_ARCACHE),
  .axi_arvalid             (AXI_14_ARVALID),
  .axi_arready             (AXI_14_ARREADY),
  .axi_rready              (AXI_14_RREADY),
  .axi_rid                 (AXI_14_RID),
  .axi_rdata               (AXI_14_RDATA),
  .axi_rresp               (AXI_14_RRESP),
  .axi_rlast               (AXI_14_RLAST),
  .axi_rvalid              (AXI_14_RVALID)
);
// synthesis translate on

////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_TG - 15
////////////////////////////////////////////////////////////////////////////////
// assign AXI_15_ARADDR = {vio_tg_glb_start_addr_15[32:28],o_m_axi_araddr_15[27:0]};
// assign AXI_15_AWADDR = {vio_tg_glb_start_addr_15[32:28],o_m_axi_awaddr_15[27:0]};

atg_axi_sr#(
  .SIMULATION                          (SIMULATION),
  .MEM_TYPE                            ("DDR4"),
  .MEM_ARCH                            ("ULTRASCALE"),
  //.APP_DATA_WIDTH                      (APP_DATA_WIDTH),
  .APP_ADDR_WIDTH                      (APP_ADDR_WIDTH),
  .C_AXI_ID_WIDTH                      (6),
  .C_AXI_ADDR_WIDTH                    (APP_ADDR_WIDTH),
  //.C_AXI_DATA_WIDTH                    (APP_DATA_WIDTH),
  .TG_PATTERN_MODE_PRBS_ADDR_WIDTH     (28),
  .ECC                                 ("OFF"),
  //.NUM_DQ_PINS                         (32),
	`ifdef OPT_DATA_W
		.APP_DATA_WIDTH(64),
		.C_AXI_DATA_WIDTH(64),
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(16),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(8),
			`endif
		`else
			`ifdef NCKPCLK_2
				.NUM_DQ_PINS(64),
				.nCK_PER_CLK(2),
			`else
				.nCK_PER_CLK(4),
				.NUM_DQ_PINS(32),
			`endif
		.APP_DATA_WIDTH(APP_DATA_WIDTH),
		.C_AXI_DATA_WIDTH(APP_DATA_WIDTH),
	`endif
  .DEFAULT_MODE                        ("HBM")
) u_atg_axi_15 (
  .sr_done                             (sr_done[15]),
  .sr_newd                             (sr_newd[15]),
  .sr_din                              (sr_din[15]),
  .sr_dout                             (sr_dout[15]),
  .i_TG_PATTERN_MODE_PRBS_ADDR_SEED    (28'b0),
  .i_clk                               (AXI_ACLK6_st0_buf),
  .i_rst                               (~axi_rst6_st0_n),
  .i_init_calib_complete               (apb_seq_complete_6_st0_r2),
  .compare_error                       (axi_15_data_msmatch_err),
  .vio_tg_rst                          (vio_tg_rst_15),
  .vio_tg_start                        (vio_tg_start_15),
  .vio_tg_err_chk_en                   (vio_tg_err_chk_en_15),
  .vio_tg_err_clear                    (vio_tg_err_clear_15),
  .vio_tg_instr_addr_mode              (vio_tg_instr_addr_mode_15),
  .vio_tg_instr_data_mode              (vio_tg_instr_data_mode_15),
  .vio_tg_instr_rw_mode                (vio_tg_instr_rw_mode_15),
  .vio_tg_instr_rw_submode             (vio_tg_instr_rw_submode_15),
  .vio_tg_instr_num_of_iter            (vio_tg_instr_num_of_iter_15),
  .vio_tg_instr_nxt_instr              (vio_tg_instr_nxt_instr_15),
  .vio_tg_restart                      (vio_tg_restart_15),
  .vio_tg_pause                        (vio_tg_pause_15),
  .vio_tg_err_clear_all                (vio_tg_err_clear_all_15),
  .vio_tg_err_continue                 (vio_tg_err_continue_15),
  .vio_tg_instr_program_en             (vio_tg_instr_program_en_15),
  .vio_tg_direct_instr_en              (vio_tg_direct_instr_en_15),
  .vio_tg_instr_num                    (vio_tg_instr_num_15),
  .vio_tg_instr_victim_mode            (vio_tg_instr_victim_mode_15),
  .vio_tg_instr_victim_aggr_delay      (vio_tg_instr_victim_aggr_delay_15),
  .vio_tg_instr_victim_select          (vio_tg_instr_victim_select_15),
  .vio_tg_instr_m_nops_btw_n_burst_m   (vio_tg_instr_m_nops_btw_n_burst_m_15),
  .vio_tg_instr_m_nops_btw_n_burst_n   (vio_tg_instr_m_nops_btw_n_burst_n_15),
  .vio_tg_seed_program_en              (vio_tg_seed_program_en_15),
  .vio_tg_seed_num                     (vio_tg_seed_num_15),
  .vio_tg_seed                         (vio_tg_seed_15),
  .vio_tg_glb_victim_bit               (vio_tg_glb_victim_bit_15),
  .vio_tg_glb_start_addr               (vio_tg_glb_start_addr_15),
  .vio_tg_glb_qdriv_rw_submode         (2'b00),
  .o_wrt_rqt_over_flow                 (),
  .vio_tg_status_state                 (vio_tg_status_state_15),
  .vio_tg_status_err_bit_valid         (vio_tg_status_err_bit_valid_15),
  .vio_tg_status_err_bit               (vio_tg_status_err_bit_15),
  .vio_tg_status_err_cnt               (vio_tg_status_err_cnt_15),
  .vio_tg_status_err_addr              (vio_tg_status_err_addr_15),
  .vio_tg_status_exp_bit_valid         (vio_tg_status_exp_bit_valid_15),
  .vio_tg_status_exp_bit               (vio_tg_status_exp_bit_15),
  .vio_tg_status_read_bit_valid        (vio_tg_status_read_bit_valid_15),
  .vio_tg_status_read_bit              (vio_tg_status_read_bit_15),
  .vio_tg_status_first_err_bit_valid   (vio_tg_status_first_err_bit_valid_15),
  .vio_tg_status_first_err_bit         (vio_tg_status_first_err_bit_15),
  .vio_tg_status_first_err_addr        (vio_tg_status_first_err_addr_15),
  .vio_tg_status_first_exp_bit_valid   (vio_tg_status_first_exp_bit_valid_15),
  .vio_tg_status_first_exp_bit         (vio_tg_status_first_exp_bit_15),
  .vio_tg_status_first_read_bit_valid  (vio_tg_status_first_read_bit_valid_15),
  .vio_tg_status_first_read_bit        (vio_tg_status_first_read_bit_15),
  .vio_tg_status_err_bit_sticky_valid  (vio_tg_status_err_bit_sticky_valid_15),
  .vio_tg_status_err_bit_sticky        (vio_tg_status_err_bit_sticky_15),
  .vio_tg_status_err_cnt_sticky        (vio_tg_status_err_cnt_sticky_15),
  .vio_tg_status_err_type_valid        (vio_tg_status_err_type_valid_15),
  .vio_tg_status_err_type              (vio_tg_status_err_type_15),
  .vio_tg_status_wr_done               (vio_tg_status_wr_done_15),
  .vio_tg_status_done                  (boot_mode_done_15),
  .vio_tg_status_watch_dog_hang        (vio_tg_status_watch_dog_hang_15),
  .tg_ila_debug                        (tg_ila_debug_15),
  .tg_qdriv_submode11_app_rd           (1'b0),
  // Slave Interface Write Address Ports
  .i_m_axi_awready                     (AXI_15_AWREADY),
  .o_m_axi_awid                        (AXI_15_AWID),
  .o_m_axi_awaddr                      (AXI_15_AWADDR),
  .o_m_axi_awlen                       (AXI_15_AWLEN),
  .o_m_axi_awsize                      (AXI_15_AWSIZE),
  .o_m_axi_awburst                     (AXI_15_AWBURST),
  .o_m_axi_awlock                      (),
  .o_m_axi_awcache                     (AXI_15_AWCACHE),
  .o_m_axi_awprot                      (AXI_15_AWPROT),
  .o_m_axi_awvalid                     (AXI_15_AWVALID),
  // Slave Interface Write Data Ports
  .i_m_axi_wready                      (AXI_15_WREADY),
  .o_m_axi_wdata                       (AXI_15_WDATA),
  .o_m_axi_wstrb                       (AXI_15_WSTRB),
  .o_m_axi_wlast                       (AXI_15_WLAST),
  .o_m_axi_wvalid                      (AXI_15_WVALID),
  // Slave Interface Write Response Ports
  .i_m_axi_bid                         (AXI_15_BID),
  .i_m_axi_bresp                       (AXI_15_BRESP),
  .i_m_axi_bvalid                      (AXI_15_BVALID),
  .o_m_axi_bready                      (AXI_15_BREADY),
  .i_m_axi_arready                     (AXI_15_ARREADY),
  // Slave Interface Read Address Ports
  .o_m_axi_arid                        (AXI_15_ARID),
  .o_m_axi_araddr                      (AXI_15_ARADDR),
  .o_m_axi_arlen                       (AXI_15_ARLEN),
  .o_m_axi_arsize                      (AXI_15_ARSIZE),
  .o_m_axi_arburst                     (AXI_15_ARBURST),
  .o_m_axi_arlock                      (),
  .o_m_axi_arcache                     (AXI_15_ARCACHE),
  .o_m_axi_arprot                      (),
  .o_m_axi_arvalid                     (AXI_15_ARVALID),
  // Slave Interface Read Data Ports
  .i_m_axi_rid                         (AXI_15_RID),
  .i_m_axi_rresp                       (AXI_15_RRESP),
  .i_m_axi_rvalid                      (AXI_15_RVALID),
  .i_m_axi_rdata                       (AXI_15_RDATA),
  .i_m_axi_rlast                       (AXI_15_RLAST),
  .o_m_axi_rready                      (AXI_15_RREADY)
);

assign  vio_tg_rst_15 =  1'd0;
assign  i_force_vio_tg_status_done_15 = 16'h0000;
assign  i_vio_enable_atg_axi_x_15 =  16'hffff;
assign  i_vio_status_out_sel_atg_axi_x_15 =  16'hffff;
assign  vio_tg_restart_15 =  'd0;
assign  vio_tg_err_chk_en_15 =  'd0;
assign  vio_tg_err_clear_15 =  'd0;
assign  vio_tg_err_clear_all_15 =  'd0;
assign  vio_tg_err_continue_15 =  'd0;
assign  vio_tg_instr_program_en_15 =  'd0;
assign  vio_tg_direct_instr_en_15 =  'd0;
assign  vio_tg_instr_num_15 =  'd0;
assign  vio_tg_instr_addr_mode_15 =  'd0;
assign  vio_tg_instr_data_mode_15 =  'd0;
assign  vio_tg_instr_rw_mode_15 =  'd0;
assign  vio_tg_instr_rw_submode_15 =  'd0;
assign  vio_tg_instr_victim_mode_15 =  'd0;
assign  vio_tg_instr_victim_aggr_delay_15 =  'd0;
assign  vio_tg_instr_victim_select_15 =  'd0;
assign  vio_tg_instr_num_of_iter_15 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_m_15 =  'd0;
assign  vio_tg_instr_m_nops_btw_n_burst_n_15 =  'd0;
assign  vio_tg_instr_nxt_instr_15 =  'd0;
assign  vio_tg_seed_program_en_15 =  'd0;
assign  vio_tg_seed_num_15 =  'd0;
assign  vio_tg_seed_15 =  'd0;
assign  vio_tg_glb_start_addr_15 = 33'h0_F000_0000;

always@(posedge AXI_ACLK6_st0_buf or negedge axi_rst6_st0_n) begin
  if (~axi_rst6_st0_n) begin
    rd_cnt_15 <= 5'b0;
  end else if (AXI_15_RVALID && AXI_15_RREADY) begin
    rd_cnt_15 <= rd_cnt_15 + 1'b1;
  end
end

always@(posedge AXI_ACLK6_st0_buf or negedge axi_rst6_st0_n) begin
  if (~axi_rst6_st0_n) begin
    wr_cnt_15 <= 5'b0;
  end else if (AXI_15_BVALID && AXI_15_BREADY) begin
    wr_cnt_15 <= wr_cnt_15 + 1'b1;
  end
end

// synthesis translate off
////////////////////////////////////////////////////////////////////////////////
// Instantiating AXI_PMON - 15
////////////////////////////////////////////////////////////////////////////////
axi_pmon_v1_0 #(
    .C_AXI_ID_WIDTH        (6),
    .C_AXI_ADDR_WIDTH      (33),
    .C_AXI_DATA_WIDTH      (256),
    .SIMULATION            ("TRUE"),
    .tCK                   (2222),
    .PARAM_AXI_TG_ID       (15)
) u_axi_pmon_15 (
  .axi_arst_n              (axi_rst6_st0_n    ),
  .axi_aclk                (AXI_ACLK6_st0_buf ),
  .axi_awid                (AXI_15_AWID),
  .axi_awaddr              (AXI_15_AWADDR),
  .axi_awlen               (AXI_15_AWLEN),
  .axi_awsize              (AXI_15_AWSIZE),
  .axi_awburst             (AXI_15_AWBURST),
  .axi_awcache             (AXI_15_AWCACHE),
  .axi_awprot              (AXI_15_AWPROT),
  .axi_awvalid             (AXI_15_AWVALID),
  .axi_awready             (AXI_15_AWREADY),
  .axi_wdata               (AXI_15_WDATA),
  .axi_wstrb               (AXI_15_WSTRB),
  .axi_wlast               (AXI_15_WLAST),
  .axi_wvalid              (AXI_15_WVALID),
  .axi_wready              (AXI_15_WREADY),
  .axi_bready              (AXI_15_BREADY),
  .axi_bid                 (AXI_15_BID),
  .axi_bresp               (AXI_15_BRESP),
  .axi_bvalid              (AXI_15_BVALID),
  .axi_arid                (AXI_15_ARID),
  .axi_araddr              (AXI_15_ARADDR),
  .axi_arlen               (AXI_15_ARLEN),
  .axi_arsize              (AXI_15_ARSIZE),
  .axi_arburst             (AXI_15_ARBURST),
  .axi_arcache             (AXI_15_ARCACHE),
  .axi_arvalid             (AXI_15_ARVALID),
  .axi_arready             (AXI_15_ARREADY),
  .axi_rready              (AXI_15_RREADY),
  .axi_rid                 (AXI_15_RID),
  .axi_rdata               (AXI_15_RDATA),
  .axi_rresp               (AXI_15_RRESP),
  .axi_rlast               (AXI_15_RLAST),
  .axi_rvalid              (AXI_15_RVALID)
);
// synthesis translate on

`ifdef SIMULATION_MODE
assign vio_tg_start_0 = 1'b1;
assign vio_tg_start_1 = 1'b1;
assign vio_tg_start_2 = 1'b1;
assign vio_tg_start_3 = 1'b1;
assign vio_tg_start_4 = 1'b1;
assign vio_tg_start_5 = 1'b1;
assign vio_tg_start_6 = 1'b1;
assign vio_tg_start_7 = 1'b1;
assign vio_tg_start_8 = 1'b1;
assign vio_tg_start_9 = 1'b1;
assign vio_tg_start_10 = 1'b1;
assign vio_tg_start_11 = 1'b1;
assign vio_tg_start_12 = 1'b1;
assign vio_tg_start_13 = 1'b1;
assign vio_tg_start_14 = 1'b1;
assign vio_tg_start_15 = 1'b1;
`else
assign vio_tg_start_0 = 1'b1;
assign vio_tg_pause_0 = 1'b0;
assign vio_tg_start_1 = 1'b1;
assign vio_tg_pause_1 = 1'b0;
assign vio_tg_start_2 = 1'b1;
assign vio_tg_pause_2 = 1'b0;
assign vio_tg_start_3 = 1'b1;
assign vio_tg_pause_3 = 1'b0;
assign vio_tg_start_4 = 1'b1;
assign vio_tg_pause_4 = 1'b0;
assign vio_tg_start_5 = 1'b1;
assign vio_tg_pause_5 = 1'b0;
assign vio_tg_start_6 = 1'b1;
assign vio_tg_pause_6 = 1'b0;
assign vio_tg_start_7 = 1'b1;
assign vio_tg_pause_7 = 1'b0;
assign vio_tg_start_8 = 1'b1;
assign vio_tg_pause_8 = 1'b0;
assign vio_tg_start_9 = 1'b1;
assign vio_tg_pause_9 = 1'b0;
assign vio_tg_start_10 = 1'b1;
assign vio_tg_pause_10 = 1'b0;
assign vio_tg_start_11 = 1'b1;
assign vio_tg_pause_11 = 1'b0;
assign vio_tg_start_12 = 1'b1;
assign vio_tg_pause_12 = 1'b0;
assign vio_tg_start_13 = 1'b1;
assign vio_tg_pause_13 = 1'b0;
assign vio_tg_start_14 = 1'b1;
assign vio_tg_pause_14 = 1'b0;
assign vio_tg_start_15 = 1'b1;
assign vio_tg_pause_15 = 1'b0;
`endif




assign ext_apb_seq_complete_0_s = 1'b0;



////////////////////////////////////////////////////////////////////////////////
// Generating AXI transaciton error status signal
////////////////////////////////////////////////////////////////////////////////
assign axi_trans_err = axi_00_data_msmatch_err || axi_01_data_msmatch_err ||
                       axi_02_data_msmatch_err || axi_03_data_msmatch_err ||
                       axi_04_data_msmatch_err || axi_05_data_msmatch_err ||
                       axi_06_data_msmatch_err || axi_07_data_msmatch_err ||
                       axi_08_data_msmatch_err || axi_09_data_msmatch_err ||
                       axi_10_data_msmatch_err || axi_11_data_msmatch_err ||
                       axi_12_data_msmatch_err || axi_13_data_msmatch_err ||
                       axi_14_data_msmatch_err || axi_15_data_msmatch_err ||
                       axi_16_data_msmatch_err || axi_17_data_msmatch_err ||
                       axi_18_data_msmatch_err || axi_19_data_msmatch_err ||
                       axi_20_data_msmatch_err || axi_21_data_msmatch_err ||
                       axi_22_data_msmatch_err || axi_23_data_msmatch_err ||
                       axi_24_data_msmatch_err || axi_25_data_msmatch_err ||
                       axi_26_data_msmatch_err || axi_27_data_msmatch_err ||
                       axi_28_data_msmatch_err || axi_29_data_msmatch_err ||
                       axi_30_data_msmatch_err || axi_31_data_msmatch_err ;


endmodule
