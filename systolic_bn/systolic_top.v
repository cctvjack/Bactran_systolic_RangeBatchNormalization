// top module

/*
Authour: Wang Lei, National University of Defense Technology, P.R.China.

This is the top module of systolic array in our architecture.

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


module systolic_top #(
    parameter PE_COL_NUM = 4,
    parameter PE_ROW_NUM = 4,
    parameter DATA_WIDTH = 16,
    parameter REG_WIDTH  = 16,
    parameter KERNEL_SIZE = 9 // the actural data length of input and depth of weight
)
 (
    input clk,
    input rst_n,
    input start,
    output cal_done,
    input [PE_ROW_NUM*DATA_WIDTH-1:0] tdata_ram_i,
    input [PE_COL_NUM*DATA_WIDTH-1:0] tdata_ram_w,
    output [PE_ROW_NUM-1:0]tvalid_res,
    output [PE_ROW_NUM*REG_WIDTH-1:0] tdata_res

);

    wire res_shift;
   

    // pe matrix
    pe_mxn #(
        .PE_COL_NUM(PE_COL_NUM),
        .PE_ROW_NUM(PE_ROW_NUM),
        .DATA_WIDTH(DATA_WIDTH),
	.REG_WIDTH(REG_WIDTH)
    )
    pe_mxn_inst (
        .clk        (clk),
        .rst_n      (rst_n),
        .shift_in   (res_shift),
        .i_in       (tdata_ram_i[PE_ROW_NUM*DATA_WIDTH-1:0]),
        .w_in       (tdata_ram_w[PE_COL_NUM*DATA_WIDTH-1:0]),
        .res_out    (tdata_res[PE_ROW_NUM*DATA_WIDTH-1:0])
    );

     // controller
    systolic_ctrl #(
        .PE_ROW_NUM(PE_ROW_NUM),
        .PE_COL_NUM(PE_COL_NUM),
        .DATA_WIDTH(DATA_WIDTH),
	.KERNEL_SIZE(KERNEL_SIZE)
    )
    systolic_ctrl_inst(
        .clk        (clk),
        .rst_n      (rst_n),
        .start      (start),
        .cal_done   (cal_done),
        // to pe_matrix
        .res_shift  (res_shift),
	.res_valid	(tvalid_res)
    );


endmodule
