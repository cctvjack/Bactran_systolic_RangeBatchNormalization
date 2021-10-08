`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/12 11:33:00
// Design Name: 
// Module Name: stage_01
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

This is the pipeline state 1 of the pipeline 1 of our architecture.

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


module stage_01 #(
    parameter DATA_WIDTH = 16,
    parameter MINI_BATCH = 64,
    parameter ADDR_WIDTH = 6
)(
    input clk,
    input rst_n,
   
    input [DATA_WIDTH-1:0] max_in,
    input [DATA_WIDTH-1:0] min_in,
    input [DATA_WIDTH-1:0] partsum_in,
    input valid_in,
    input [ADDR_WIDTH-1:0] addr_in,
    
    output  [DATA_WIDTH-1:0] max_out,
    output  [DATA_WIDTH-1:0] min_out,
    output  [DATA_WIDTH-1:0] max_res_out,
    output  [DATA_WIDTH-1:0] min_res_out,
    output  [DATA_WIDTH-1:0] partsum_out,
    output valid_out,
    output [DATA_WIDTH-1:0] sum_out
);

    
    reg [DATA_WIDTH-1:0] max,min,partsum,sum,max_res,min_res;
    //reg [DATA_WIDTH-1:0] tmpmax,tmpmin; 
    reg valid;  
    reg [ADDR_WIDTH:0] counter ;
    
    assign max_out = max;
    assign min_out = min;
    assign max_res_out = max_res; 
    assign min_res_out = min_res;
    assign partsum_out = partsum;
    assign valid_out = valid;
    assign sum_out = sum;
    always@(posedge clk)
    begin
        if(!rst_n)
        begin
            min <= {{1'b0},{(DATA_WIDTH-1){1'b1}}};
            max <= {DATA_WIDTH{1'b0}};
            min_res <= {DATA_WIDTH{1'b0}};
            max_res <= {DATA_WIDTH{1'b0}};
//            tmpmax <= {DATA_WIDTH{1'b0}};
//            tmpmin <= {{1'b0},{(DATA_WIDTH-1){1'b1}}};
        end
        else
        begin
            max <= max_in;
            min <= min_in;
//            tmpmax <= max_in;
//            tmpmin <= min_in;
            
            if(addr_in == MINI_BATCH-1)
            begin
                max_res <= max_in;
                min_res <= min_in;
                min <= {{1'b0},{(DATA_WIDTH-1){1'b1}}};
                max <= {DATA_WIDTH{1'b0}};
            end
        end

    end   
    
    always@(posedge clk)
    begin   
        if(!rst_n)
        begin
            valid <= 1'b0;
            partsum <= {DATA_WIDTH{1'b0}}; 
            sum <= {DATA_WIDTH{1'b0}}; 
            counter <= {(ADDR_WIDTH+1){1'b0}}; 
        end
        else
        begin
            if(valid_in)
                counter <= counter + 1;
            partsum <= partsum_in; 
            if(addr_in == MINI_BATCH-1)
            begin

                sum <= partsum_in;
                partsum <= {DATA_WIDTH{1'b0}}; 
                counter <= {(ADDR_WIDTH+1){1'b0}}; 
            end
        end 
    end
    
    always@(posedge clk)
    begin   
        if(!rst_n)
            valid <= 1'b0;
        else
        begin
            if(addr_in == MINI_BATCH-1 && valid_in)
                valid <= 1'b1;
            else
                valid <= 1'b0;  
            end
    end
endmodule
