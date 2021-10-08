`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/12 21:34:05
// Design Name: 
// Module Name: stage_22
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

This is the pipeline state 2 of the pipeline 3 of our architecture.

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


module stage_22(
rst_n,
clk,
valid_in,
g_var_in,
g_avg_in,
partvar_out,
partavg_out,
g_var_out,
g_avg_out,
valid_out,
res_valid_in
    );
    parameter DATA_WIDTH = 16;
    parameter MINI_BATCH = 64;
    parameter TOTAL_BATCH = 128;
    parameter BATCH_NUM = TOTAL_BATCH/MINI_BATCH;
    parameter ADDR_WIDTH = $clog2(MINI_BATCH);
     
    input clk;
    input rst_n;
    
    input valid_in;
    input [DATA_WIDTH-1:0] g_var_in;
    input [DATA_WIDTH-1:0] g_avg_in;
    input res_valid_in;
    output [DATA_WIDTH-1:0] partvar_out;
    output [DATA_WIDTH-1:0] partavg_out;

    output [DATA_WIDTH-1:0] g_var_out;
    output [DATA_WIDTH-1:0] g_avg_out;
    output valid_out;
    
    
    reg valid;
    reg [DATA_WIDTH-1:0] g_avg,g_var,partavg,partvar;
    reg [ADDR_WIDTH:0] counter;
    reg flag;
    assign valid_out = valid;
    assign partavg_out = partavg;
    assign partvar_out = partvar;
    assign g_avg_out = g_avg;
    assign g_var_out = g_var;

    always@(posedge clk)
    begin
        if(!rst_n)
        begin
            counter <= {(ADDR_WIDTH+1){1'b0}};
            valid <= 1'b0;
            flag <= 1'b0;
        end
        else
        begin
            if(valid_in)
                counter <= counter + 1; 
            if(counter == BATCH_NUM )
            begin
                counter <= {(ADDR_WIDTH+1){1'b0}};
                valid <= 1'b1;
                flag <= 1;
            end
            else if(!res_valid_in&&flag)
                valid <= 1'b1;
            else if(res_valid_in)
            begin
                flag = 1'b0;
                valid <= 1'b0;
            end
            else
                valid <= 1'b0;
                
        end
    end
    
    always@(posedge clk)
    begin
        if(!rst_n)
        begin
            g_avg <= {DATA_WIDTH{1'b0}};
            g_var <= {DATA_WIDTH{1'b0}};
            partavg <= {DATA_WIDTH{1'b0}};
            partvar <= {DATA_WIDTH{1'b0}};
        end
        else 
        begin
            if(valid_in)
            begin
                partvar <= g_var_in;
                partavg <= g_avg_in;
            end
            if(counter == BATCH_NUM)
            begin
                g_avg <= partavg;
                g_var <= partvar;
            end
         end
    end   
endmodule
