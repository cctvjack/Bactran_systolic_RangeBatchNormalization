`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/12 11:33:53
// Design Name: 
// Module Name: x_buffer
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

This is memory which stores the sums calculates from the systolic array and wait to be normalized by the bn engine of our architecture.

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


module x_buffer(
clk,
rst_n,
x_in,
x_out,
addr_in,
write_in
    );
    parameter DATA_WIDTH = 16;
    parameter MINI_BATCH = 64;
    parameter ADDR_WIDTH = 6;
    
    reg [DATA_WIDTH-1:0] x [MINI_BATCH-1:0];
    
    input clk;
    input rst_n;
    input [DATA_WIDTH-1:0] x_in;
    input [ADDR_WIDTH-1:0] addr_in;
    input write_in;
    
    output [DATA_WIDTH-1:0] x_out;
    
    assign x_out = x[addr_in];
    
    always@(posedge clk)
    begin
        if(!rst_n)
        begin
            x[0] = {DATA_WIDTH{1'b0}};
            x[1] = {DATA_WIDTH{1'b0}};
            x[2] = {DATA_WIDTH{1'b0}};
            x[3] = {DATA_WIDTH{1'b0}};
            x[4] = {DATA_WIDTH{1'b0}};
            x[5] = {DATA_WIDTH{1'b0}};
            x[6] = {DATA_WIDTH{1'b0}};
            x[7] = {DATA_WIDTH{1'b0}};
            x[8] = {DATA_WIDTH{1'b0}};
            x[9] = {DATA_WIDTH{1'b0}};
            x[10] = {DATA_WIDTH{1'b0}};
            x[11] = {DATA_WIDTH{1'b0}};
            x[12] = {DATA_WIDTH{1'b0}};
            x[13] = {DATA_WIDTH{1'b0}};
            x[14] = {DATA_WIDTH{1'b0}};
            x[15] = {DATA_WIDTH{1'b0}};
            x[16] = {DATA_WIDTH{1'b0}};
            x[17] = {DATA_WIDTH{1'b0}};
            x[18] = {DATA_WIDTH{1'b0}};
            x[19] = {DATA_WIDTH{1'b0}};
            x[20] = {DATA_WIDTH{1'b0}};
            x[21] = {DATA_WIDTH{1'b0}};
            x[22] = {DATA_WIDTH{1'b0}};
            x[23] = {DATA_WIDTH{1'b0}};
            x[24] = {DATA_WIDTH{1'b0}};
            x[25] = {DATA_WIDTH{1'b0}};
            x[26] = {DATA_WIDTH{1'b0}};
            x[27] = {DATA_WIDTH{1'b0}};
            x[28] = {DATA_WIDTH{1'b0}};
            x[29] = {DATA_WIDTH{1'b0}};
            x[30] = {DATA_WIDTH{1'b0}};
            x[31] = {DATA_WIDTH{1'b0}};
            x[32] = {DATA_WIDTH{1'b0}};
            x[33] = {DATA_WIDTH{1'b0}};
            x[34] = {DATA_WIDTH{1'b0}};
            x[35] = {DATA_WIDTH{1'b0}};
            x[36] = {DATA_WIDTH{1'b0}};
            x[37] = {DATA_WIDTH{1'b0}};
            x[38] = {DATA_WIDTH{1'b0}};
            x[39] = {DATA_WIDTH{1'b0}};
            x[40] = {DATA_WIDTH{1'b0}};
            x[41] = {DATA_WIDTH{1'b0}};
            x[42] = {DATA_WIDTH{1'b0}};
            x[43] = {DATA_WIDTH{1'b0}};
            x[44] = {DATA_WIDTH{1'b0}};
            x[45] = {DATA_WIDTH{1'b0}};
            x[46] = {DATA_WIDTH{1'b0}};
            x[47] = {DATA_WIDTH{1'b0}};
            x[48] = {DATA_WIDTH{1'b0}};
            x[49] = {DATA_WIDTH{1'b0}};
            x[50] = {DATA_WIDTH{1'b0}};
            x[51] = {DATA_WIDTH{1'b0}};
            x[52] = {DATA_WIDTH{1'b0}};
            x[53] = {DATA_WIDTH{1'b0}};
            x[54] = {DATA_WIDTH{1'b0}};
            x[55] = {DATA_WIDTH{1'b0}};
            x[56] = {DATA_WIDTH{1'b0}};
            x[57] = {DATA_WIDTH{1'b0}};
            x[58] = {DATA_WIDTH{1'b0}};
            x[59] = {DATA_WIDTH{1'b0}};
            x[60] = {DATA_WIDTH{1'b0}};
            x[61] = {DATA_WIDTH{1'b0}};
            x[62] = {DATA_WIDTH{1'b0}};
            x[63] = {DATA_WIDTH{1'b0}};
        end
        else if(write_in)
        begin
            x[addr_in] <= x_in;
        end
    end
endmodule
