`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 01:43:42 PM
// Design Name: 
// Module Name: Row_Major_Mapping
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


module Row_Major_Mapping
#(
    parameter DATA_WIDTH = 8,
    parameter A_ROWS = 2,
    parameter B_COLS = 2
)(
    input reset,
    
    input [2 * DATA_WIDTH - 1:0] result [0:A_ROWS - 1][0:B_COLS - 1]
);
    
    reg [DATA_WIDTH - 1:0] Matrix_C_mem [0:A_ROWS * B_COLS - 1];
    
    integer m;
    always @(posedge reset)
    begin
        for (m = 0; m < (A_ROWS * B_COLS); m = m + 1) begin
            Matrix_C_mem[m] = 'b0;
        end
    end
    
    integer i, j;
    // Map 2D matrix to 1D memory in row-major order
    always @(*)
    begin
        for (i = 0; i < A_ROWS; i = i + 1) begin
            for (j = 0; j < B_COLS; j = j + 1) begin
                // Flatten the matrix to memory
                Matrix_C_mem[i * B_COLS + j] = result[i][j];
            end
        end
    end
    
endmodule
