`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/21 09:27:37
// Design Name: 
// Module Name: mux_3
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

This is a 3-1 multiplexer module of our architecture.

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

module mux_3(
    sel,
    in0,
    in1,
    in2,
    o
);
    parameter DATA_WIDTH = 16;
    input [1:0] sel;
    input [DATA_WIDTH-1:0] in0;
    input [DATA_WIDTH-1:0] in1;
    input [DATA_WIDTH-1:0] in2;    
    output reg [DATA_WIDTH-1:0] o;
    always@(*)
    begin
        case(sel)
            2'b00:o <= in0;
            2'b01:o <= in1;
            2'b10:o <= in2;
            default:o <= {DATA_WIDTH{1'b0}};
        endcase
    end

    

    
endmodule

