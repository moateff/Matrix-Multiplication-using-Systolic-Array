`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2024 03:30:25 AM
// Design Name: 
// Module Name: Systolic_Array
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


module Systolic_Array
#(
    parameter DATA_WIDTH = 8,
    parameter A_ROWS = 2,
    parameter A_COLS = 2,
    parameter B_COLS = 2
)(
    input clk,
    input reset,
    
    input  [DATA_WIDTH - 1:0] a [0:A_ROWS - 1],     // Matrix A
    input  [DATA_WIDTH - 1:0] b [0:B_COLS - 1],      // Matrix B
    
    output [2 * DATA_WIDTH - 1:0] c [0:A_ROWS - 1][0:B_COLS - 1] // Matrix C
);
   
    wire [DATA_WIDTH - 1:0] a_w  [0:A_ROWS - 1][0:B_COLS - 1];
    wire [DATA_WIDTH - 1:0] b_w  [0:A_ROWS - 1][0:B_COLS - 1];
        
    integer k, l;
    genvar i, j;  

    generate
        for (i = 0; i < A_ROWS; i = i + 1) begin 
            for (j = 0; j < B_COLS; j = j + 1) begin
                MAC #(.DATA_WIDTH(DATA_WIDTH)) 
                PE (
                    .clk(clk),
                    .reset(reset),
                    .operand1_in(j == 0 ? a[i] : a_w[i][j-1]), 
                    .operand2_in(i == 0 ? b[j] : b_w[i-1][j]), 
                    .operand1_out(a_w[i][j]),
                    .operand2_out(b_w[i][j]),
                    .mac_result(c[i][j]) 
                );
            end
        end
    endgenerate
    
endmodule

/*
   MAC #(.DATA_WIDTH(DATA_WIDTH))
   first_PE (
       .clk(clk),
       .reset(reset),
       .operand1_in(a[0]),    
       .operand2_in(b[0]),
       .operand1_out(a_w[0][0]),
       .operand2_out(b_w[0][0]),
       .mac_result(c[0][0])  
   );
   assign mem[0][0] = c[0][0];
    
   generate
       for (m = 1; m < A_ROWS; m = m + 1) begin : first_col
           MAC #(.DATA_WIDTH(DATA_WIDTH)) 
           PE (
               .clk(clk),
               .reset(reset),
               .operand1_in(a[m]),     
               .operand2_in(b_w[m-1][0]),
               .operand1_out(a_w[m][0]),
               .operand2_out(b_w[m][0]),
               .mac_result(c[m][0])  
           );
           assign mem[m][0] = c[m][0];
       end
   endgenerate
   
   generate
       for (n = 1; n < B_COLS; n = n + 1) begin : first_row
           MAC #(.DATA_WIDTH(DATA_WIDTH)) 
           PE (
               .clk(clk),
               .reset(reset),
               .operand1_in(a_w[0][n-1]),     
               .operand2_in(b[n]),
               .operand1_out(a_w[0][n]),
               .operand2_out(b_w[0][n]),
               .mac_result(c[0][n])  
           );
           assign mem[0][n] = c[0][n];
       end
   endgenerate
                            
   // Instantiate PEs in a systolic array configuration
   generate
       for (i = 1; i < A_ROWS; i = i + 1) begin : row
           for (j = 1; j < B_COLS; j = j + 1) begin : col
               MAC #(.DATA_WIDTH(DATA_WIDTH)) 
               PE (
                   .clk(clk),
                   .reset(reset),
                   .operand1_in(a_w[i][j-1]), 
                   .operand2_in(b_w[i-1][j]), 
                   .operand1_out(a_w[i][j]),
                   .operand2_out(b_w[i][j]),
                   .mac_result(c[i][j]) 
               );
               assign mem[i][j] = c[i][j];
           end
       end
   endgenerate
*/