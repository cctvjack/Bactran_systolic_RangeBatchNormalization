// systolic array in one dimension

/*
Authour: Wang Lei, National University of Defense Technology, P.R.China.

This is a one dimension systolic array of our architecture.

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



module pe_1xn #(
    parameter PE_NUM = 4,
    parameter DATA_WIDTH = 16,
    parameter REG_WIDTH = 16
)
(
    input clk,
    input rst_n,
    input [DATA_WIDTH-1:0] i_in,
    input shift_in,
    input [PE_NUM*DATA_WIDTH-1:0] w_in,
    output [PE_NUM*DATA_WIDTH-1:0] w_out,
    output [REG_WIDTH-1:0] res_out
);
    genvar i;
    wire [PE_NUM*DATA_WIDTH-1:0] i_in_wire, i_out_wire;
    wire [PE_NUM*REG_WIDTH-1:0] res_in_wire, res_out_wire;

    pe #(.DATA_WIDTH(DATA_WIDTH),.REG_WIDTH(REG_WIDTH)) pe_inst [PE_NUM-1:0] (
        .clk        ({PE_NUM{clk}}),
        .rst_n      ({PE_NUM{rst_n}}),
        .i_in       (i_in_wire[PE_NUM*DATA_WIDTH-1:0]),
        .shift_in   ({PE_NUM{shift_in}}),
        .w_in       (w_in),
        .res_in     (res_in_wire[PE_NUM*REG_WIDTH-1:0]),
        .i_out      (i_out_wire[PE_NUM*DATA_WIDTH-1:0]),
        .w_out      (w_out),
        .res_out    (res_out_wire[PE_NUM*REG_WIDTH-1:0])
    );

    assign i_in_wire[DATA_WIDTH-1:0] = i_in;
    assign res_in_wire[REG_WIDTH-1:0] = {REG_WIDTH{1'b0}};
    generate for (i=1; i<PE_NUM; i=i+1) begin : pe_connection
       assign i_in_wire[DATA_WIDTH*i +: DATA_WIDTH] = i_out_wire[DATA_WIDTH*(i-1) +: DATA_WIDTH];
       assign res_in_wire[REG_WIDTH*i +: REG_WIDTH] = 
              res_out_wire[REG_WIDTH*(i-1) +: REG_WIDTH];
    end
    endgenerate

    assign res_out[REG_WIDTH-1:0] = res_out_wire[REG_WIDTH*(PE_NUM-1) +: REG_WIDTH];

endmodule
