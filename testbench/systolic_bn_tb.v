`timescale 1ns / 1ps

/*
Authour: Yang Zhijie, National University of Defense Technology, P.R.China.

This is the testbench of our architecture.

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

module systolic_bn_tb;

    parameter PE_COL_NUM = 4;
    parameter PE_ROW_NUM = 4;
    parameter DATA_WIDTH = 16;
    parameter REG_WIDTH = 16;
    parameter KERNEL_SIZE = 9;
    parameter MINI_BATCH = 8;
    parameter TOTAL_BATCH = 16;
    parameter ADDR_WIDTH = $clog2(MINI_BATCH);

    //public
    reg clk;
    reg rst_n;
    //input
    //systoic
    reg start;
    reg [PE_ROW_NUM*DATA_WIDTH-1:0] tdata_ram_i;
    reg [PE_COL_NUM*DATA_WIDTH-1:0] tdata_ram_w;
    //bn
    reg [DATA_WIDTH-1:0] beta_in;
    reg [DATA_WIDTH-1:0] gamma_in;
    reg [1:0] mode_in;
    reg valid_gamma_beta;

    wire [PE_ROW_NUM-1:0] valid_x_out;
    wire [PE_ROW_NUM*DATA_WIDTH-1:0] x_out;

    systolic_bn #(
        .PE_COL_NUM  (PE_COL_NUM),
        .PE_ROW_NUM  (PE_ROW_NUM),
        .REG_WIDTH   (REG_WIDTH),
        .KERNEL_SIZE (KERNEL_SIZE),
        .DATA_WIDTH  (DATA_WIDTH),
        .MINI_BATCH  (MINI_BATCH),
        .ADDR_WIDTH  (ADDR_WIDTH),
        .TOTAL_BATCH (TOTAL_BATCH)
    )dut(
        .clk                (clk),
        .rst_n              (rst_n),
        .start              (start),
        .tdata_ram_i        (tdata_ram_i),
        .tdata_ram_w        (tdata_ram_w),
        .beta_in            (beta_in),
        .gamma_in           (gamma_in),
        .mode_in            (mode_in),
        .valid_gamma_beta   (valid_gamma_beta),
        .valid_x_out        (valid_x_out),
        .x_out              (x_out)
    );

always #5 clk = ~clk;
initial begin
    clk         = 0;
    rst_n       = 0;
#5
    gamma_in    = 16'h0;
    beta_in     = 16'h0;
    valid_gamma_beta = 0;
#10
    rst_n       = 1;
    start       = 1;
    tdata_ram_i = {16'h1,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h1,16'h0,16'h0,16'h0};

    mode_in     = 2'b0;
    gamma_in    = 16'h0004;
    beta_in     = 16'h0005;
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h2,16'h10,16'h0,16'h0};

    valid_gamma_beta = 1;
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h0};
    tdata_ram_w = {16'h3,16'h20,16'h100,16'h0};
    mode_in     = 2'b10;
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h4,16'h30,16'h200,16'h1000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h5,16'h40,16'h300,16'h2000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h6,16'h50,16'h400,16'h3000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h7,16'h60,16'h500,16'h4000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h8,16'h70,16'h600,16'h5000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h9,16'h80,16'h700,16'h4000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h0,16'h90,16'h800,16'h3000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h1,16'h1};
    tdata_ram_w = {16'h0,16'h0,16'h900,16'h2000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h0,16'h0,16'h0,16'h1000};
#10
    start       = 0;
#130                    //140?
    start       = 1;
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h1,16'h0,16'h0,16'h0};
#10
    tdata_ram_i = {16'h1,16'h1,16'h0,16'h0};
    tdata_ram_w = {16'h2,16'h10,16'h0,16'h0};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h3,16'h20,16'h100,16'h0};
    mode_in     = 2'b10;
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h4,16'h30,16'h200,16'h1000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h5,16'h40,16'h300,16'h2000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h6,16'h50,16'h400,16'h3000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h7,16'h60,16'h500,16'h4000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h8,16'h70,16'h600,16'h5000};
#10
     tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h9,16'h80,16'h700,16'h4000};
#10
    tdata_ram_i = {16'h0,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h0,16'h90,16'h800,16'h3000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h0,16'h0,16'h900,16'h2000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h1};
    tdata_ram_w = {16'h0,16'h0,16'h0,16'h1000};
#10
    start       = 0;
#130
    start       = 1;
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h2,16'h0,16'h0,16'h0};
#10
    tdata_ram_i = {16'h1,16'h1,16'h0,16'h0};
    tdata_ram_w = {16'h3,16'h20,16'h0,16'h0};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h4,16'h30,16'h200,16'h0};
    mode_in     = 2'b10;
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h5,16'h40,16'h300,16'h2000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h6,16'h50,16'h400,16'h3000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h7,16'h60,16'h500,16'h4000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h8,16'h70,16'h600,16'h5000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h9,16'h80,16'h700,16'h6000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'ha,16'h90,16'h800,16'h5000};
#10
    tdata_ram_i = {16'h0,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h0,16'ha0,16'h900,16'h4000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h0,16'h0,16'ha00,16'h3000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h1};
    tdata_ram_w = {16'h0,16'h0,16'h0,16'h2000};
#10
    start       = 0;
#130
    start       = 1;
    tdata_ram_i = {16'h1,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h2,16'h0,16'h0,16'h0};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h3,16'h20,16'h0,16'h0};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h0};
    tdata_ram_w = {16'h4,16'h30,16'h200,16'h0};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h5,16'h40,16'h300,16'h2000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h6,16'h50,16'h400,16'h3000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h7,16'h60,16'h500,16'h4000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h8,16'h70,16'h600,16'h5000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h9,16'h80,16'h700,16'h6000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'ha,16'h90,16'h800,16'h5000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h0,16'ha0,16'h900,16'h4000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h1,16'h1};
    tdata_ram_w = {16'h0,16'h0,16'ha00,16'h3000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h0,16'h0,16'h0,16'h2000};
#10
    start       = 0;  
#1200
    mode_in     = 2'b00;
#10
    mode_in     = 2'b01;
#10
    start       = 1;
    tdata_ram_i = {16'h1,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h1,16'h0,16'h0,16'h0};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h3,16'h10,16'h0,16'h0};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h0};
    tdata_ram_w = {16'h5,16'h30,16'h100,16'h0};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h7,16'h50,16'h300,16'h1000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h9,16'h70,16'h500,16'h3000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h2,16'h90,16'h700,16'h5000};
#10    
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h4,16'h20,16'h900,16'h3000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h6,16'h40,16'h200,16'h1000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h8,16'h60,16'h400,16'h3000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h0,16'h80,16'h600,16'h5000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h1,16'h1};
    tdata_ram_w = {16'h0,16'h0,16'h800,16'h3000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h0,16'h0,16'h0,16'h1000};
#10
    start       = 0;
#100
    mode_in     = 2'b00;
    start       = 1;
    tdata_ram_i = {16'h1,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h2,16'h0,16'h0,16'h0};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h4,16'h20,16'h0,16'h0};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h0};
    tdata_ram_w = {16'h6,16'h40,16'h200,16'h0};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h4,16'h60,16'h400,16'h2000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h2,16'h40,16'h600,16'h4000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h4,16'h20,16'h400,16'h6000};
#10    
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h6,16'h40,16'h200,16'h4000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h4,16'h60,16'h400,16'h2000};
#10
    tdata_ram_i = {16'h1,16'h1,16'h1,16'h1};
    tdata_ram_w = {16'h2,16'h40,16'h200,16'h4000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h0,16'h20,16'h400,16'h6000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h1,16'h1};
    tdata_ram_w = {16'h0,16'h0,16'h600,16'h4000};
#10
    tdata_ram_i = {16'h0,16'h0,16'h0,16'h0};
    tdata_ram_w = {16'h0,16'h0,16'h0,16'h2000};
#10
    start       = 0;          

     
end
endmodule
