`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/12 19:39:10
// Design Name: 
// Module Name: stage_10
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

This is the pipeline state 0 of the pipeline 2 of our architecture.

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


module stage_10(
rst_n,
clk,
start_bn_tra_in,
addr_out,
start_bn_tra_out
    );
    parameter DATA_WIDTH = 16;
    parameter MINI_BATCH = 64;
    parameter ADDR_WIDTH = 6;
    
    input clk;
    input rst_n;
    
    input start_bn_tra_in;
    output [ADDR_WIDTH-1:0] addr_out;
    output start_bn_tra_out;
    
    reg [ADDR_WIDTH-1:0] counter;  
    reg start_bn_tra;
    reg counter_flag;
    assign addr_out = (rst_n&&counter_flag)?counter:{ADDR_WIDTH{1'b0}};
    assign start_bn_tra_out = start_bn_tra;

    always@(posedge clk)
    begin
        if(!rst_n)
        begin
            counter <= {ADDR_WIDTH{1'b0}};
            start_bn_tra <= 0;
            counter_flag <= 1'b0;
        end
        else if(start_bn_tra_in)
        begin
            start_bn_tra <= 1;
            counter_flag <= 1'b1;
        end
        else if(counter == MINI_BATCH-1)
        begin
            start_bn_tra <= 0;
            counter_flag <= 1'b0;
        end
    end   
    always@(posedge clk)
    begin
        if(!rst_n)
            counter <= {ADDR_WIDTH{1'b0}};              
        else if(counter_flag)
        begin
            counter <= counter + 1; 
        end
    end
endmodule
