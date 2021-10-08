// systolic matrix

/*
Authour: Wang Lei, National University of Defense Technology, P.R.China.

This is a systolic array of our architecture.

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

module pe_mxn #(
    parameter PE_COL_NUM = 4,
    parameter PE_ROW_NUM = 4,
    parameter DATA_WIDTH = 16,
    parameter REG_WIDTH = 16
)
(
    input clk,
    input rst_n,
    input shift_in,
    input [PE_ROW_NUM*DATA_WIDTH-1:0] i_in,
    input [PE_COL_NUM*DATA_WIDTH-1:0] w_in,
    output [PE_ROW_NUM*REG_WIDTH-1:0] res_out
);
    wire [PE_ROW_NUM-1:0] shift_wire;
    reg [PE_ROW_NUM-1:1] shift_reg;
    genvar i;
    wire [PE_COL_NUM*PE_COL_NUM*DATA_WIDTH-1:0] w_in_wire, w_out_wire;

    // shift control
    assign shift_wire[0] = shift_in;
    generate for(i=1; i<PE_ROW_NUM; i=i+1) begin : shift_ctrl
        always@(posedge clk)
        if(~rst_n)
            shift_reg[i] <= 1'b0;
        else
            shift_reg[i] <= shift_wire[i-1];
        assign shift_wire[i] = shift_reg[i];
    end
    endgenerate

    // pe matrix
    pe_1xn #(.PE_NUM(PE_COL_NUM), .DATA_WIDTH(DATA_WIDTH),.REG_WIDTH(REG_WIDTH))
    pe_1xn_inst [PE_ROW_NUM-1:0] (
        .clk        ({PE_ROW_NUM{clk}}),
        .rst_n      ({PE_ROW_NUM{rst_n}}),
        .i_in       (i_in),
        .shift_in   (shift_wire),
        .w_in       (w_in_wire),
        .w_out      (w_out_wire),
        .res_out    (res_out)
    );

    assign w_in_wire[PE_COL_NUM*DATA_WIDTH-1:0] = w_in;
    generate for (i=1; i<PE_ROW_NUM; i=i+1) begin : pe_array_connection
        assign w_in_wire[PE_COL_NUM*DATA_WIDTH*i +: PE_COL_NUM*DATA_WIDTH]
             = w_out_wire[PE_COL_NUM*DATA_WIDTH*(i-1) +: PE_COL_NUM*DATA_WIDTH];
    end
    endgenerate

endmodule
