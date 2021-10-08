`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/12 16:12:57
// Design Name: 
// Module Name: gprs
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

This is the parameter registers module of our architecture.

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



module gprs #(    
    parameter DATA_WIDTH = 16,
    parameter MINI_BATCH = 64,
    parameter ADDR_WIDTH = $clog2(MINI_BATCH)
)(
    input clk,
    input rst_n,
    input [DATA_WIDTH-1:0]stan_dev_in,
    input [DATA_WIDTH-1:0]avg_in,
    input [DATA_WIDTH-1:0]gamma_in,
    input [DATA_WIDTH-1:0]beta_in,
    input [DATA_WIDTH-1:0]a_in,
    input [DATA_WIDTH-1:0]b_in,
    input valid_stan_dev,
    input valid_avg,
    input valid_gamma,
    input valid_beta,
    input valid_a,
    input valid_b,
    output [DATA_WIDTH-1:0]stan_dev_out,
    output [DATA_WIDTH-1:0]avg_out,
    output [DATA_WIDTH-1:0]gamma_out,
    output [DATA_WIDTH-1:0]beta_out,
    output [DATA_WIDTH-1:0]a_out,
    output [DATA_WIDTH-1:0]b_out
    );
    reg [DATA_WIDTH-1:0] stan_dev;
    reg [DATA_WIDTH-1:0] avg;
    reg [DATA_WIDTH-1:0] gamma;
    reg [DATA_WIDTH-1:0] beta;
    reg [DATA_WIDTH-1:0] a;
    reg [DATA_WIDTH-1:0] b;
    
    assign stan_dev_out = stan_dev; 
    assign avg_out = avg; 
    assign gamma_out = gamma; 
    assign beta_out = beta; 
    assign a_out = a; 
    assign b_out = b; 
    
    always@(posedge clk)
    begin
        if(!rst_n)
        begin
            stan_dev <= {DATA_WIDTH{1'b0}};
        end
        else if(valid_stan_dev)
        begin
            stan_dev <= stan_dev_in;
        end
    end
    
    always@(posedge clk)
    begin
        if(!rst_n)
        begin
            avg <= {DATA_WIDTH{1'b0}};
        end
        else if(valid_avg)
        begin
            avg <= avg_in;
        end
    end
    
    always@(posedge clk)
    begin
        if(!rst_n)
        begin
            gamma <= {DATA_WIDTH{1'b0}};
        end
        else if(valid_gamma)
        begin
            gamma <= gamma_in;
        end
    end
    always@(posedge clk)
    begin
        if(!rst_n)
        begin
            beta <= {DATA_WIDTH{1'b0}};
        end
        else if(valid_beta)
        begin
            beta <= beta_in;
        end
    end
    always@(posedge clk)
    begin
        if(!rst_n)
        begin
            a <= {DATA_WIDTH{1'b0}};
        end
        else if(valid_a)
        begin
            a <= a_in;
        end
    end
    always@(posedge clk)
    begin
        if(!rst_n)
        begin
            b <= {DATA_WIDTH{1'b0}};
        end
        else if(valid_b)
        begin
            b <= b_in;
        end
    end
endmodule
