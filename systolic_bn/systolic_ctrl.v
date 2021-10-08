// systolic control unit

/*
Authour: Wang Lei, National University of Defense Technology, P.R.China.

This is a copntroller for the systolic array of our architecture.

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

module systolic_ctrl #(
    parameter PE_ROW_NUM = 4,
    parameter PE_COL_NUM = 4,
    parameter DATA_WIDTH = 32,
    parameter KERNEL_SIZE = 9
 )
(
    input clk,
    input rst_n,
    input start,
    output reg cal_done,
    // to pe matrix
    output res_shift,

    output[PE_ROW_NUM-1:0] res_valid
);
    wire valid;
    reg [31:0] counter;
    reg [PE_ROW_NUM-1:0] valid_reg;
    reg enable;
    // ****************************
    // data input/output control
    // ****************************

    
    // ****************************
    // systolic calculation control
    // ****************************
    always@(posedge clk or negedge rst_n)
    if(~rst_n)
	enable <= 1'b0;
    else if(start)
	enable <= 1'b1;
    else if(cal_done)
	enable <= 1'b0;

    always@(posedge clk or negedge rst_n)
    if(~rst_n)
        counter <= 32'b0;
    else if(enable)
        counter <= counter + 1'b1;
    else 
        counter <= 32'b0;
    
    assign res_shift = counter > (KERNEL_SIZE+PE_COL_NUM+2) &&
                       counter < (KERNEL_SIZE+PE_COL_NUM+PE_ROW_NUM+2);
    assign valid = counter > (KERNEL_SIZE+PE_COL_NUM+1) &&
			 counter < (KERNEL_SIZE+PE_COL_NUM+PE_ROW_NUM+2);
    wire cal_done_wire = counter == (KERNEL_SIZE+PE_COL_NUM+PE_ROW_NUM+1);
    always@(posedge clk)
    if(~rst_n)
        cal_done <= 1'b0;
    else
        cal_done <= cal_done_wire;
genvar i;
    always@(*)
	valid_reg[0] = valid; 
generate for (i=1;i<PE_ROW_NUM;i=i+1)begin : result_valid
    always@(posedge clk)
    	valid_reg[i] <= valid_reg[i-1];
end
endgenerate
    assign res_valid = valid_reg; 

endmodule
