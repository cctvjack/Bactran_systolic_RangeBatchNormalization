`timescale 1ns / 1ps

/*
Authour: Yang Zhijie, National University of Defense Technology, P.R.China.

This is the top module for systolic array and the batch normalization engine of our architecture.

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


module systolic_bn #(
//
    parameter PE_COL_NUM = 4,
	parameter PE_ROW_NUM = 4,
	parameter DATA_WIDTH = 16,
	parameter REG_WIDTH = 16,
	parameter KERNEL_SIZE = 9,
	parameter MINI_BATCH = 8,
	parameter ADDR_WIDTH = $clog2(MINI_BATCH),
	parameter TOTAL_BATCH = 16
)(
	input clk,
    input rst_n,
//systolic input
    input start,
    input [PE_ROW_NUM*DATA_WIDTH-1:0] tdata_ram_i,
    input [PE_COL_NUM*DATA_WIDTH-1:0] tdata_ram_w,
//bn input
    input [DATA_WIDTH-1:0] beta_in,
    input [DATA_WIDTH-1:0] gamma_in,
    input [1:0] mode_in,
    input valid_gamma_beta,
//bn output
    output [PE_ROW_NUM-1:0] valid_x_out,
    output [PE_ROW_NUM*DATA_WIDTH-1:0]x_out
);

    wire [PE_ROW_NUM-1:0]           tvalid_res;
    wire [PE_ROW_NUM*REG_WIDTH-1:0] tdata_res;

    systolic_top #(
        .PE_COL_NUM (PE_COL_NUM),
        .PE_ROW_NUM (PE_ROW_NUM),
        .DATA_WIDTH (DATA_WIDTH),
        .REG_WIDTH  (REG_WIDTH),
        .KERNEL_SIZE(KERNEL_SIZE)
    )u_systolic_top(
        .clk        (clk),
        .rst_n      (rst_n),
        .start      (start),
        .cal_done   (cal_done),
        .tdata_ram_i(tdata_ram_i),
        .tdata_ram_w(tdata_ram_w),
        .tvalid_res (tvalid_res),
        .tdata_res  (tdata_res)
 
    );

    pipeline_bn_top #(
        .DATA_WIDTH (DATA_WIDTH),
        .MINI_BATCH (MINI_BATCH),
        .ADDR_WIDTH (ADDR_WIDTH),
        .TOTAL_BATCH(TOTAL_BATCH)
    )u_pipeline_bn_top [PE_ROW_NUM-1:0] (
        .clk                ({PE_ROW_NUM{clk}}),
        .rst_n              ({PE_ROW_NUM{rst_n}}),
        .mode_in            ({PE_ROW_NUM{mode_in}}),
        .gamma_in           ({PE_ROW_NUM{gamma_in}}),
        .beta_in            ({PE_ROW_NUM{beta_in}}),
        .valid_gamma_beta   ({PE_ROW_NUM{valid_gamma_beta}}),
        .x_in               (tdata_res),
        .valid_x_in         (tvalid_res),
        .x_out              (x_out),
        .valid_x_out        (valid_x_out)
    );

endmodule
