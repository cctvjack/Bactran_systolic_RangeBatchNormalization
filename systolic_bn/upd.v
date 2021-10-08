`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/12 21:12:53
// Design Name: 
// Module Name: upd
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

This is a module which calculates the global average and standart deviation of a mini batch of our architecture.

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

module upd(
valid_in,
var_in,
avg_in,
g_var_in,
g_avg_in,
g_var_out,
g_avg_out,
valid_out
    );
    parameter DATA_WIDTH = 16;
    parameter MINI_BATCH = 64;
    parameter MINI_BATCH_1 = MINI_BATCH-1;
    parameter ADDR_WIDTH = $clog2(MINI_BATCH);
    
    input valid_in;
    input signed [DATA_WIDTH-1:0] var_in;
    input signed [DATA_WIDTH-1:0] avg_in;
    input signed [DATA_WIDTH-1:0] g_var_in;
    input signed [DATA_WIDTH-1:0] g_avg_in;
   
    output valid_out;
    output signed [DATA_WIDTH-1:0] g_var_out;
    output signed [DATA_WIDTH-1:0] g_avg_out;
    
    assign g_var_out = valid_in?((var_in>>ADDR_WIDTH)+((g_var_in*MINI_BATCH_1)>>ADDR_WIDTH)):{DATA_WIDTH{1'b0}};
    assign g_avg_out = valid_in?((avg_in>>ADDR_WIDTH)+((g_avg_in*MINI_BATCH_1)>>ADDR_WIDTH)):{DATA_WIDTH{1'b0}};
    assign valid_out = valid_in?valid_in:1'b0;
    
endmodule
