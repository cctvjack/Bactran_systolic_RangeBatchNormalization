// a single pe

/*
Authour: Wang Lei, National University of Defense Technology, P.R.China.

This is a processing element(PE) module in the systolic array of our architecture.

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


module pe #(
    parameter DATA_WIDTH = 16,
    parameter REG_WIDTH = 16
)
(
    input clk,
    input rst_n,
    input signed [DATA_WIDTH-1:0] i_in,
    input shift_in, // come in the next cycle when the last pe finished its computation
    input signed [DATA_WIDTH-1:0] w_in,
    input signed [REG_WIDTH-1:0] res_in,
    output reg [DATA_WIDTH-1:0] i_out,
    output reg [DATA_WIDTH-1:0] w_out,
    output signed [REG_WIDTH-1:0] res_out
);
    reg shift_in_reg;
    always@(posedge clk or negedge rst_n)
    if(!rst_n)
        shift_in_reg <= 1'b0;
    else
        shift_in_reg <= shift_in;
    wire shift_ending = ~shift_in & shift_in_reg;

    reg [REG_WIDTH-1:0] accumulated_res;
    always@(posedge clk or negedge rst_n)
    if(!rst_n)
        accumulated_res <= {REG_WIDTH{1'b0}};
    else if(shift_ending)
        accumulated_res <= {REG_WIDTH{1'b0}};
    else if(i_in&&w_in)
        accumulated_res <= accumulated_res + i_in* w_in;
                                  

    always@(posedge clk or negedge rst_n)
    if(!rst_n)
        i_out <= 1'b0;
    else
        i_out <= i_in;

    always@(posedge clk or negedge rst_n)
    if(!rst_n)
        w_out <= {DATA_WIDTH{1'b0}};
    else
        w_out <= w_in;
            
    reg [REG_WIDTH-1:0] res_in_reg;
    always@(posedge clk or negedge rst_n)
    if(!rst_n)
        res_in_reg <= {REG_WIDTH{1'b0}};
    else 
        res_in_reg <= res_in;

    assign res_out = shift_in ? res_in_reg : accumulated_res;

endmodule
