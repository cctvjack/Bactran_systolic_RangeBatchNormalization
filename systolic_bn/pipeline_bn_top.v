`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/21 10:17:24
// Design Name: 
// Module Name: pipeline_bn_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


/*
Authour: Yang Zhijie, National University of Defense Technology, P.R.China.

This is the pipeline top module for the batch normalization function of our architecture.

Use this please cite: 

[1] Yang. Zhijie, Wang. Lei, et al., "Bactran: A Hardware Batch Normalization Implementation for CNN Training Engine," in IEEE Embedded Systems Letters, vol. 13, no. 1, pp. 29-32, March 2021.

This code follows the MIT License

Copyright (c) 2021 Yang Zhijie and Wang Lei of National University of Defense Technology, P.R.China

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/


module pipeline_bn_top #(
    parameter PE_COL_NUM = 4,
    parameter PE_ROW_NUM = 4,
    parameter DATA_WIDTH = 16,
    parameter REG_WIDTH = 16,
    parameter KERNEL_SIZE = 9,
    parameter MINI_BATCH = 8,
    parameter ADDR_WIDTH = $clog2(MINI_BATCH),
    parameter TOTAL_BATCH = 16,
    parameter APPROX_STAN_DEV = 2
)(
 beta_in,
    clk,
    gamma_in,
    mode_in,
    rst_n,
    valid_gamma_beta,
    valid_x_in,
    valid_x_out,
    x_in,
    x_out);
  input [DATA_WIDTH-1:0]beta_in;
  input clk;
  input [DATA_WIDTH-1:0]gamma_in;
  input [1:0]mode_in;
  input rst_n;
  input valid_gamma_beta;
  input valid_x_in;
  output valid_x_out;
  input [DATA_WIDTH-1:0]x_in;
  output [DATA_WIDTH-1:0]x_out;

  wire adj_0_start_bn_tra_out;
  wire [DATA_WIDTH-1:0]adj_0_x_out;
  wire [DATA_WIDTH-1:0]beta_in_1;
  wire bn_0_valid_out;
  wire [DATA_WIDTH-1:0]bn_0_x_out;
  wire [DATA_WIDTH-1:0]cal_0_avg_out;
  wire [DATA_WIDTH-1:0]cal_0_stan_dev_out;
  wire cal_0_valid_out;
  wire [DATA_WIDTH-1:0]cal_ab_0_a_out;
  wire [DATA_WIDTH-1:0]cal_ab_0_b_out;
  wire cal_ab_0_valid_out;
  wire clk_1;
  wire [DATA_WIDTH-1:0]cordic_0_m_axis_dout_tdata;
  wire cordic_0_m_axis_dout_tvalid;
  wire dmux_1_2_1_o0;
  wire dmux_1_2_1_o1;
  wire dmux_1_3_0_o0;
  wire dmux_1_3_0_o1;
  wire dmux_1_3_0_o2;
  wire [DATA_WIDTH-1:0]dmux_1_3_1_o0;
  wire [DATA_WIDTH-1:0]dmux_1_3_1_o1;
  wire [DATA_WIDTH-1:0]dmux_1_3_1_o2;
  wire [DATA_WIDTH-1:0]gamma_in_1;
  wire [DATA_WIDTH-1:0]gprs_0_a_out;
  wire [DATA_WIDTH-1:0]gprs_0_avg_out;
  wire [DATA_WIDTH-1:0]gprs_0_b_out;
  wire [DATA_WIDTH-1:0]gprs_0_beta_out;
  wire [DATA_WIDTH-1:0]gprs_0_gamma_out;
  wire [DATA_WIDTH-1:0]gprs_0_stan_dev_out;
  wire [1:0]mode_in_1;
  wire [5:0]mux_2_0_o;
  wire [5:0]mux_2_1_o;
  wire [DATA_WIDTH-1:0]mux_2_2_o;
  wire [DATA_WIDTH-1:0]mux_3_0_out;
  wire mux_3_1_out;
  wire norm_0_start_bn_tra_out;
  wire [DATA_WIDTH-1:0]norm_0_x_out;
  wire [DATA_WIDTH-1:0]pipe_control_0_beta_out;
  wire [DATA_WIDTH-1:0]pipe_control_0_gamma_out;
  wire [1:0]pipe_control_0_mode_out;
  wire pipe_control_0_p_out1;
  wire pipe_control_0_p_out2;
  wire pipe_control_0_pipe_addr_mux_out;
  wire pipe_control_0_valid_gamma_beta;
  wire rst_n_1;
  wire [DATA_WIDTH-1:0]sqa_0_avg_out;
  wire sqa_0_valid_out;
  wire [DATA_WIDTH-1:0]sqa_0_var_out;
  wire [ADDR_WIDTH-1:0]stage_00_0_addr_out;
  wire stage_00_0_valid_out;
  wire [DATA_WIDTH-1:0]stage_00_0_x_out;
  wire [DATA_WIDTH-1:0]stage_01_0_max_out;
  wire [DATA_WIDTH-1:0]stage_01_0_max_res_out;
  wire [DATA_WIDTH-1:0]stage_01_0_min_out;
  wire [DATA_WIDTH-1:0]stage_01_0_min_res_out;
  wire [DATA_WIDTH-1:0]stage_01_0_partsum_out;
  wire [DATA_WIDTH-1:0]stage_01_0_sum_out;
  wire stage_01_0_valid_out;
  wire [DATA_WIDTH-1:0]stage_02_0_avg_out;
  wire [DATA_WIDTH-1:0]stage_02_0_stan_dev_out;
  wire stage_02_0_valid_out;
  wire [ADDR_WIDTH-1:0]stage_10_0_addr_out;
  wire stage_10_0_start_bn_tra_out;
  wire [DATA_WIDTH-1:0]stage_11_0_avg_out;
  wire [DATA_WIDTH-1:0]stage_11_0_stan_dev_out;
  wire stage_11_0_start_bn_tra_out;
  wire [DATA_WIDTH-1:0]stage_11_0_x_out;
  wire stage_12_0_start_bn_tra_out;
  wire [DATA_WIDTH-1:0]stage_12_0_x_out;
  wire stage_13_0_start_bn_tra_out;
  wire [DATA_WIDTH-1:0]stage_13_0_x_out;
  wire [DATA_WIDTH-1:0]stage_20_0_avg_out;
  wire [DATA_WIDTH-1:0]stage_20_0_stan_dev_out;
  wire stage_20_0_valid_out;
  wire [DATA_WIDTH-1:0]stage_21_0_avg_out;
  wire stage_21_0_valid_out;
  wire [DATA_WIDTH-1:0]stage_21_0_var_out;
  wire [DATA_WIDTH-1:0]stage_22_0_g_avg_out;
  wire [DATA_WIDTH-1:0]stage_22_0_g_var_out;
  wire [DATA_WIDTH-1:0]stage_22_0_partavg_out;
  wire [DATA_WIDTH-1:0]stage_22_0_partvar_out;
  wire stage_22_0_valid_out;
  wire [DATA_WIDTH-1:0]stage_23_0_g_avg_out;
  wire [DATA_WIDTH-1:0]stage_23_0_g_stan_dev_out;
  wire stage_23_0_valid_out;
  wire [DATA_WIDTH-1:0]stage_24_0_a_out;
  wire [DATA_WIDTH-1:0]stage_24_0_b_out;
  wire stage_24_0_valid_out;
  wire stage_30_0_valid_out;
  wire [DATA_WIDTH-1:0]stage_30_0_x_out;
  wire stage_31_0_valid_out;
  wire [DATA_WIDTH-1:0]stage_31_0_x_out;
  wire [ADDR_WIDTH-1:0]sum_0_addr_out;
  wire [DATA_WIDTH-1:0]sum_0_max_out;
  wire [DATA_WIDTH-1:0]sum_0_min_out;
  wire [DATA_WIDTH-1:0]sum_0_partsum_out;
  wire sum_0_valid_out;
  wire [DATA_WIDTH-1:0]upd_0_g_avg_out;
  wire [DATA_WIDTH-1:0]upd_0_g_var_out;
  wire upd_0_valid_out;
  wire valid_gamma_beta_1;
  wire valid_x_in_1;
  wire [DATA_WIDTH-1:0]x_buffer_0_x_out;
  wire [DATA_WIDTH-1:0]x_buffer_1_x_out;
  wire [DATA_WIDTH-1:0]x_in_1;

  assign beta_in_1 = beta_in[DATA_WIDTH-1:0];
  assign clk_1 = clk;
  assign gamma_in_1 = gamma_in[DATA_WIDTH-1:0];
  assign mode_in_1 = mode_in[1:0];
  assign rst_n_1 = rst_n;
  assign valid_gamma_beta_1 = valid_gamma_beta;
  assign valid_x_in_1 = valid_x_in;
  assign valid_x_out = mux_3_1_out;
  assign x_in_1 = x_in[DATA_WIDTH-1:0];
  assign x_out[DATA_WIDTH-1:0] = mux_3_0_out;
  
  adj #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  adj_0
       (.beta_in(gprs_0_beta_out),
        .gamma_in(gprs_0_gamma_out),
        .start_bn_tra_in(stage_12_0_start_bn_tra_out),
        .start_bn_tra_out(adj_0_start_bn_tra_out),
        .x_in(stage_12_0_x_out),
        .x_out(adj_0_x_out));
  bn #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  bn_0
       (.a_in(gprs_0_a_out),
        .b_in(gprs_0_b_out),
        .valid_in(stage_30_0_valid_out),
        .valid_out(bn_0_valid_out),
        .x_in(stage_30_0_x_out),
        .x_out(bn_0_x_out));
  cal #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH),.APPROX_STAN_DEV(APPROX_STAN_DEV))
  cal_0
       (.avg_out(cal_0_avg_out),
        .max_in(stage_01_0_max_res_out),
        .min_in(stage_01_0_min_res_out),
        .stan_dev_out(cal_0_stan_dev_out),
        .sum_in(stage_01_0_sum_out),
        .valid_in(stage_01_0_valid_out),
        .valid_out(cal_0_valid_out));
  cal_ab #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  cal_ab_0
       (.a_out(cal_ab_0_a_out),
        .b_out(cal_ab_0_b_out),
        .beta_in(gprs_0_beta_out),
        .g_avg_in(stage_23_0_g_avg_out),
        .g_stan_dev_in(stage_23_0_g_stan_dev_out),
        .gamma_in(gprs_0_gamma_out),
        .valid_in(stage_23_0_valid_out),
        .valid_out(cal_ab_0_valid_out));
  cordic_0 cordic_0
       (.aclk(clk_1),
        .m_axis_dout_tdata(cordic_0_m_axis_dout_tdata),
        .m_axis_dout_tvalid(cordic_0_m_axis_dout_tvalid),
        .s_axis_cartesian_tdata(stage_22_0_g_var_out),
        .s_axis_cartesian_tvalid(stage_22_0_valid_out));
  dmux_1_2 dmux_1_2_1
       (.in0(stage_00_0_valid_out),
        .o0(dmux_1_2_1_o0),
        .o1(dmux_1_2_1_o1),
        .sel(pipe_control_0_pipe_addr_mux_out));
  dmux_1_3 dmux_1_3_0
       (.in0(valid_x_in_1),
        .o0(dmux_1_3_0_o0),
        .o1(dmux_1_3_0_o1),
        .o2(dmux_1_3_0_o2),
        .sel(pipe_control_0_mode_out));
  dmux_1_3_16 #(.DATA_WIDTH(DATA_WIDTH)) 
  dmux_1_3_1
       (.in0(x_in_1),
        .o0(dmux_1_3_1_o0),
        .o1(dmux_1_3_1_o1),
        .o2(dmux_1_3_1_o2),
        .sel(pipe_control_0_mode_out));
  gprs #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  gprs_0
       (.a_in(stage_24_0_a_out),
        .a_out(gprs_0_a_out),
        .avg_in(stage_02_0_avg_out),
        .avg_out(gprs_0_avg_out),
        .b_in(stage_24_0_b_out),
        .b_out(gprs_0_b_out),
        .beta_in(pipe_control_0_beta_out),
        .beta_out(gprs_0_beta_out),
        .clk(clk_1),
        .gamma_in(pipe_control_0_gamma_out),
        .gamma_out(gprs_0_gamma_out),
        .rst_n(rst_n_1),
        .stan_dev_in(stage_02_0_stan_dev_out),
        .stan_dev_out(gprs_0_stan_dev_out),
        .valid_a(stage_24_0_valid_out),
        .valid_avg(stage_02_0_valid_out),
        .valid_b(stage_24_0_valid_out),
        .valid_beta(pipe_control_0_valid_gamma_beta),
        .valid_gamma(pipe_control_0_valid_gamma_beta),
        .valid_stan_dev(stage_02_0_valid_out));
  mux_2 #(.DATA_WIDTH(ADDR_WIDTH))
  mux_2_0
       (.sel(pipe_control_0_pipe_addr_mux_out),
        .a(stage_00_0_addr_out),
        .b(stage_10_0_addr_out),
        .o(mux_2_0_o));
  mux_2 #(.DATA_WIDTH(ADDR_WIDTH))
  mux_2_1
       (.sel(pipe_control_0_pipe_addr_mux_out),
        .a(stage_10_0_addr_out),
        .b(stage_00_0_addr_out),
        .o(mux_2_1_o));
  mux_2 #(.DATA_WIDTH(DATA_WIDTH)) 
  mux_2_2
       (.sel(pipe_control_0_pipe_addr_mux_out),
        .a(x_buffer_1_x_out),
        .b(x_buffer_0_x_out),
        .o(mux_2_2_o));
  mux_3 #(.DATA_WIDTH(DATA_WIDTH))
  mux_3_0
       (.in0(dmux_1_3_1_o0),
        .in1(stage_31_0_x_out),
        .in2(stage_13_0_x_out),
        .o(mux_3_0_out),
        .sel(pipe_control_0_mode_out));
  mux_3 #(.DATA_WIDTH(1))
  mux_3_1
       (.in0(dmux_1_3_0_o0),
        .in1(stage_31_0_valid_out),
        .in2(stage_13_0_start_bn_tra_out),
        .o(mux_3_1_out),
        .sel(pipe_control_0_mode_out));
  norm #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  norm_0
       (.avg_in(stage_11_0_avg_out),
        .stan_dev_in(stage_11_0_stan_dev_out),
        .start_bn_tra_in(stage_11_0_start_bn_tra_out),
        .start_bn_tra_out(norm_0_start_bn_tra_out),
        .x_in(stage_11_0_x_out),
        .x_out(norm_0_x_out));
  pipe_control #(.DATA_WIDTH(DATA_WIDTH))
  pipe_control_0
       (.beta_in(beta_in_1),
        .beta_out(pipe_control_0_beta_out),
        .clk(clk_1),
        .gamma_in(gamma_in_1),
        .gamma_out(pipe_control_0_gamma_out),
        .mode_in(mode_in_1),
        .mode_out(pipe_control_0_mode_out),
        .p_in0(stage_02_0_valid_out),
        .p_in1(stage_13_0_start_bn_tra_out),
        .p_out1(pipe_control_0_p_out1),
        .p_out2(pipe_control_0_p_out2),
        .pipe_addr_mux_out(pipe_control_0_pipe_addr_mux_out),
        .rst_n(rst_n_1),
        .tra_done(stage_24_0_valid_out),
        .valid_gamma_beta_in(valid_gamma_beta_1),
        .valid_gamma_beta_out(pipe_control_0_valid_gamma_beta));
  sqa #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  sqa_0
       (.avg_in(stage_20_0_avg_out),
        .avg_out(sqa_0_avg_out),
        .stan_dev_in(stage_20_0_stan_dev_out),
        .valid_in(stage_20_0_valid_out),
        .valid_out(sqa_0_valid_out),
        .var_out(sqa_0_var_out));
  stage_00 #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  stage_00_0
       (.clk(clk_1),
        .rst_n(rst_n_1),
        .x_in(dmux_1_3_1_o2),
        .valid_in(dmux_1_3_0_o2),
        .x_out(stage_00_0_x_out),
        .addr_out(stage_00_0_addr_out),
        .valid_out(stage_00_0_valid_out));
  stage_01 #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  stage_01_0
       (.addr_in(sum_0_addr_out),
        .clk(clk_1),
        .max_in(sum_0_max_out),
        .max_out(stage_01_0_max_out),
        .max_res_out(stage_01_0_max_res_out),
        .min_in(sum_0_min_out),
        .min_out(stage_01_0_min_out),
        .min_res_out(stage_01_0_min_res_out),
        .partsum_in(sum_0_partsum_out),
        .partsum_out(stage_01_0_partsum_out),
        .rst_n(rst_n_1),
        .sum_out(stage_01_0_sum_out),
        .valid_in(sum_0_valid_out),
        .valid_out(stage_01_0_valid_out));
  stage_02 #(.DATA_WIDTH(DATA_WIDTH))
  stage_02_0
       (.avg_in(cal_0_avg_out),
        .avg_out(stage_02_0_avg_out),
        .clk(clk_1),
        .rst_n(rst_n_1),
        .stan_dev_in(cal_0_stan_dev_out),
        .stan_dev_out(stage_02_0_stan_dev_out),
        .valid_in(cal_0_valid_out),
        .valid_out(stage_02_0_valid_out));
  stage_10 #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  stage_10_0
       (.addr_out(stage_10_0_addr_out),
        .clk(clk_1),
        .rst_n(rst_n_1),
        .start_bn_tra_in(pipe_control_0_p_out1),
        .start_bn_tra_out(stage_10_0_start_bn_tra_out));
  stage_11 #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  stage_11_0
       (.avg_in(gprs_0_avg_out),
        .avg_out(stage_11_0_avg_out),
        .clk(clk_1),
        .rst_n(rst_n_1),
        .stan_dev_in(gprs_0_stan_dev_out),
        .stan_dev_out(stage_11_0_stan_dev_out),
        .start_bn_tra_in(stage_10_0_start_bn_tra_out),
        .start_bn_tra_out(stage_11_0_start_bn_tra_out),
        .x_in(mux_2_2_o),
        .x_out(stage_11_0_x_out));
  stage_12 #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  stage_12_0
       (.clk(clk_1),
        .rst_n(rst_n_1),
        .start_bn_tra_in(norm_0_start_bn_tra_out),
        .start_bn_tra_out(stage_12_0_start_bn_tra_out),
        .x_in(norm_0_x_out),
        .x_out(stage_12_0_x_out));
  stage_13 #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  stage_13_0
       (.clk(clk_1),
        .rst_n(rst_n_1),
        .start_bn_tra_in(adj_0_start_bn_tra_out),
        .start_bn_tra_out(stage_13_0_start_bn_tra_out),
        .x_in(adj_0_x_out),
        .x_out(stage_13_0_x_out));
  stage_20 #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  stage_20_0
       (.avg_in(gprs_0_avg_out),
        .avg_out(stage_20_0_avg_out),
        .clk(clk_1),
        .rst_n(rst_n_1),
        .stan_dev_in(gprs_0_stan_dev_out),
        .stan_dev_out(stage_20_0_stan_dev_out),
        .valid_in(pipe_control_0_p_out2),
        .valid_out(stage_20_0_valid_out));
  stage_21 #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  stage_21_0
       (.avg_in(sqa_0_avg_out),
        .avg_out(stage_21_0_avg_out),
        .clk(clk_1),
        .rst_n(rst_n_1),
        .valid_in(sqa_0_valid_out),
        .valid_out(stage_21_0_valid_out),
        .var_in(sqa_0_var_out),
        .var_out(stage_21_0_var_out));
  stage_22 #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.TOTAL_BATCH(TOTAL_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  stage_22_0
       (.clk(clk_1),
        .g_avg_in(upd_0_g_avg_out),
        .g_avg_out(stage_22_0_g_avg_out),
        .g_var_in(upd_0_g_var_out),
        .g_var_out(stage_22_0_g_var_out),
        .partavg_out(stage_22_0_partavg_out),
        .partvar_out(stage_22_0_partvar_out),
        .res_valid_in(cordic_0_m_axis_dout_tvalid),
        .rst_n(rst_n_1),
        .valid_in(upd_0_valid_out),
        .valid_out(stage_22_0_valid_out));
  stage_23 #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  stage_23_0
       (.clk(clk_1),
        .g_avg_in(stage_22_0_g_avg_out),
        .g_avg_out(stage_23_0_g_avg_out),
        .g_stan_dev_in(cordic_0_m_axis_dout_tdata),
        .g_stan_dev_out(stage_23_0_g_stan_dev_out),
        .rst_n(rst_n_1),
        .valid_in(cordic_0_m_axis_dout_tvalid),
        .valid_out(stage_23_0_valid_out));
  stage_24 #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  stage_24_0
       (.a_in(cal_ab_0_a_out),
        .a_out(stage_24_0_a_out),
        .b_in(cal_ab_0_b_out),
        .b_out(stage_24_0_b_out),
        .clk(clk_1),
        .rst_n(rst_n_1),
        .valid_in(cal_ab_0_valid_out),
        .valid_out(stage_24_0_valid_out));
  stage_30 #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  stage_30_0
       (.clk(clk_1),
        .rst_n(rst_n_1),
        .valid_in(dmux_1_3_0_o1),
        .valid_out(stage_30_0_valid_out),
        .x_in(dmux_1_3_1_o1),
        .x_out(stage_30_0_x_out));
  stage_31 #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  stage_31_0
       (.clk(clk_1),
        .rst_n(rst_n_1),
        .valid_in(bn_0_valid_out),
        .valid_out(stage_31_0_valid_out),
        .x_in(bn_0_x_out),
        .x_out(stage_31_0_x_out));
  sum #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  sum_0
       (.addr_in(stage_00_0_addr_out),
        .addr_out(sum_0_addr_out),
        .max_in(stage_01_0_max_out),
        .max_out(sum_0_max_out),
        .min_in(stage_01_0_min_out),
        .min_out(sum_0_min_out),
        .partsum_in(stage_01_0_partsum_out),
        .partsum_out(sum_0_partsum_out),
        .valid_in(stage_00_0_valid_out),
        .valid_out(sum_0_valid_out),
        .x_in(stage_00_0_x_out));
  upd #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  upd_0
       (.avg_in(stage_21_0_avg_out),
        .g_avg_in(stage_22_0_partavg_out),
        .g_avg_out(upd_0_g_avg_out),
        .g_var_in(stage_22_0_partvar_out),
        .g_var_out(upd_0_g_var_out),
        .valid_in(stage_21_0_valid_out),
        .valid_out(upd_0_valid_out),
        .var_in(stage_21_0_var_out));
  x_buffer #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  x_buffer_0
       (.addr_in(mux_2_0_o),
        .clk(clk_1),
        .rst_n(rst_n_1),
        .write_in(dmux_1_2_1_o0),
        .x_in(stage_00_0_x_out),
        .x_out(x_buffer_0_x_out));
  x_buffer #(.DATA_WIDTH(DATA_WIDTH),.MINI_BATCH(MINI_BATCH),.ADDR_WIDTH(ADDR_WIDTH))
  x_buffer_1
       (.addr_in(mux_2_1_o),
        .clk(clk_1),
        .rst_n(rst_n_1),
        .write_in(dmux_1_2_1_o1),
        .x_in(stage_00_0_x_out),
        .x_out(x_buffer_1_x_out));
endmodule
