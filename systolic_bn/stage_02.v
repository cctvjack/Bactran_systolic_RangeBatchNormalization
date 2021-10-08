`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/12 11:33:15
// Design Name: 
// Module Name: stage_02
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

This is the pipeline state 2 of the pipeline 1 of our architecture.

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


module stage_02(
rst_n,
clk,
stan_dev_in,
avg_in,
valid_in,
stan_dev_out,
avg_out,
valid_out
    );
    parameter DATA_WIDTH = 16;
    
    input clk;
    input rst_n;
    
    input valid_in;
    input [DATA_WIDTH-1:0] stan_dev_in;
    input [DATA_WIDTH-1:0] avg_in;

    output  [DATA_WIDTH-1:0] stan_dev_out;
    output  [DATA_WIDTH-1:0] avg_out;
    output valid_out;

    reg [DATA_WIDTH-1:0] avg,stan_dev;  
    reg valid;
    assign stan_dev_out = stan_dev;
    assign avg_out = avg;
    assign valid_out = valid;
    
    always@(posedge clk)
    begin
        if(!rst_n)
        begin
            avg <= {DATA_WIDTH{1'b0}};
            stan_dev <= {DATA_WIDTH{1'b0}};
            valid <= 1'b0;
        end
        else if(valid_in)
        begin
            avg <= avg_in;
            stan_dev <= stan_dev_in;
            valid <= 1'b1;
        end
        else
        begin
            avg <= {DATA_WIDTH{1'b0}};
            stan_dev <= {DATA_WIDTH{1'b0}};
            valid <= 1'b0;
        end  
    end
endmodule
