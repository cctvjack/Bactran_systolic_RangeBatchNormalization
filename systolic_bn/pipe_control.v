`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/14 15:54:08
// Design Name: 
// Module Name: pipe_control
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

This is the controller of our architecture.

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

module pipe_control(
    clk,
    rst_n,
    p_in0,
    p_in1,
    tra_done,    //p_in2
    mode_in,
    gamma_in,
    valid_gamma_beta_in,
    beta_in,
    gamma_out,
    p_out1,
    p_out2,
    pipe_addr_mux_out,
    mode_out,
    beta_out,
    valid_gamma_beta_out
    );
    parameter DATA_WIDTH = 16;
    input clk;
    input rst_n;
    input p_in0;
    input p_in1;
    input tra_done; //p_in2
    input [1:0] mode_in;  // 0:no bn 1:inf bn 2:tra bn
    input valid_gamma_beta_in;
    input [DATA_WIDTH-1:0] gamma_in;
    input [DATA_WIDTH-1:0] beta_in;
    
    output [DATA_WIDTH-1:0] gamma_out;
    output [DATA_WIDTH-1:0] beta_out;
    output valid_gamma_beta_out;
    
    output reg p_out1;
    output reg p_out2;
    output reg pipe_addr_mux_out;

    output reg [1:0] mode_out;
    reg [2:0] current_state;
    reg [2:0] next_state;
    parameter IDLE = 3'd0;
    parameter INF = 3'd1;
    parameter LINE0 = 3'd2;
    parameter EXCHANGE = 3'd3;
    parameter STABLE = 3'd4;
    parameter TRA = 3'd2;
        
    assign gamma_out =  next_state == IDLE ? gamma_in : {DATA_WIDTH{1'b0}};
    assign beta_out =  next_state == IDLE ? beta_in : {DATA_WIDTH{1'b0}};
    assign valid_gamma_beta_out = next_state == IDLE ? valid_gamma_beta_in : 1'b0;    
        
//    always@(posedge clk)
    always@(*)
    begin
        case(current_state)
            IDLE:
            begin
                if(mode_in==INF)
                    next_state <= INF;
                if(mode_in==TRA)
                    next_state<= LINE0;
            end
            INF:
            begin
                if(mode_in==IDLE)
                    next_state <= IDLE;
                if(mode_in==TRA)
                        next_state<= LINE0;
            end
            LINE0:
            begin
                if(mode_in==IDLE)
                    next_state <= IDLE;
                if(p_in0)
                    next_state <= EXCHANGE;
            end
            EXCHANGE:
            begin
                if(mode_in==IDLE)
                    next_state <= IDLE;
                else
                    next_state <= STABLE;
            end
            STABLE:
            begin
                if(mode_in==IDLE||tra_done)
                    next_state <= IDLE;
                if(p_in0)
                    next_state <= EXCHANGE;
            end
            default:
            begin
                next_state <= IDLE;
            end
        endcase        
    end
 
 
//    always@(current_state,next_state)
    always@(posedge clk)
    begin
           case(next_state)
            IDLE:
            begin
                p_out1 <= 1'b0;
                p_out2 <= 1'b0;
                pipe_addr_mux_out <= 1'b0;
                mode_out <= 2'b00;
            end
            INF:
            begin
                p_out1 <= 1'b0;
                p_out2 <= 1'b0;
                pipe_addr_mux_out <= 1'b0;
                mode_out <= 2'b01;
            end
            LINE0:
            begin               
                p_out1 <= 1'b0;
                p_out2 <= 1'b0;
                pipe_addr_mux_out <= 1'b0;
                mode_out <= 2'b10;            
            end
            EXCHANGE:
            begin
                p_out1 <= 1'b1;
                p_out2 <= 1'b1;
                pipe_addr_mux_out <= ~pipe_addr_mux_out;
                mode_out <= 2'b10;
            end
            STABLE:
            begin
                 p_out1 <= 1'b0;
                 p_out2 <= 1'b0;
                 mode_out <= 2'b10;
            end
            default:
            begin
                p_out1 <= 1'b0;
                p_out2 <= 1'b0;
                pipe_addr_mux_out <= 1'b0;
                mode_out <= 2'b00;
            end
            endcase
//        end
    end
      
    always@(posedge clk)
    begin
        if(!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
    
endmodule
