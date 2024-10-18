`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2024 02:02:22 AM
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
    parameter A_ROWS = 3,
              A_COLS = 3,
              B_ROWS = 3,
              B_COLS = 3
)(
    input clk,             // Clock signal
    input reset            // Reset signal    
    );
    // Instantiate the Data_Mem module where Matrix A
    Data_Mem #(
        .ADDR_WIDTH($log2(A_ROWS * A_COLS - 1)),
        .DATA_WIDTH(),
        .MEM_DEPTH(A_ROWS * A_COLS)
    ) MatrixA (
        .clk(clk),
        .reset(reset),
        .wr_en(),
        .rd_en(),
        .addr(),
        .data_in(),
        .data_out()
    );
    
    // Instantiate the Data_Mem module where Matrix B
    Data_Mem #(
        .ADDR_WIDTH($log2(B_ROWS * B_COLS - 1)),
        .DATA_WIDTH(),
        .MEM_DEPTH(B_ROWS * B_COLS)
    ) MatrixB (
        .clk(clk),
        .reset(reset),
        .wr_en(),
        .rd_en(),
        .addr(),
        .data_in(),
        .data_out()
    );
    
    
endmodule
