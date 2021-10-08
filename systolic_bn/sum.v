`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/12 11:33:34
// Design Name: 
// Module Name: sum
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

This is the sum function module of our architecture.

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

module sum #(
    parameter DATA_WIDTH = 16,
    parameter MINI_BATCH = 8,
    parameter ADDR_WIDTH = 3
)(
    input signed [DATA_WIDTH-1:0] x_in,
    input signed [DATA_WIDTH-1:0] partsum_in,
    input signed [DATA_WIDTH-1:0] max_in,
    input signed [DATA_WIDTH-1:0] min_in,
    input valid_in,
    input [ADDR_WIDTH-1:0] addr_in,

    output signed [DATA_WIDTH-1:0] max_out,
    output signed [DATA_WIDTH-1:0] min_out,
    output signed [DATA_WIDTH-1:0] partsum_out,
    output valid_out,
    output [ADDR_WIDTH-1:0]addr_out
);
    assign max_out = ((max_in<x_in)&&valid_in)?x_in:max_in;
    assign min_out = ((min_in>x_in)&&valid_in)?x_in:min_in;
    assign valid_out = valid_in?valid_in:1'b0;
    assign partsum_out = valid_in?(partsum_in + x_in):partsum_in;
    assign addr_out = addr_in;


endmodule

