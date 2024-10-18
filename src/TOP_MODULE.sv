`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 05:48:14 PM
// Design Name: 
// Module Name: TOP_MODULE
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


module TOP_MODULE
#(
    parameter DATA_WIDTH = 8,
    parameter A_ROWS = 2,
    parameter A_COLS = 2,
    parameter B_COLS = 2
)(
    input clk,
    input reset,
    input enable,
    
    output [2 * DATA_WIDTH - 1:0] result [0:A_ROWS - 1][0:B_COLS - 1]
);
    wire rd_from_matrix_A;
    wire rd_from_matrix_B;
    
    wire [0:A_ROWS - 1] load_matrix_A;
    wire [0:B_COLS - 1] load_matrix_B;
    
    wire [DATA_WIDTH - 1:0] matrix_A [0:A_ROWS - 1];
    wire [DATA_WIDTH - 1:0] matrix_B [0:B_COLS - 1];
    
    wire [A_COLS * DATA_WIDTH - 1:0] data_from_matrix_A;
    wire [A_COLS * DATA_WIDTH - 1:0] data_from_matrix_B;
    
    wire [$clog2(A_ROWS * A_COLS) - 1:0] addr_matrix_A;
    wire [$clog2(A_COLS * B_COLS) - 1:0] addr_matrix_B;
        
    genvar m, n; 
    
    Controller #(
        .A_ROWS(A_ROWS),
        .A_COLS(A_COLS),
        .B_COLS(B_COLS)
    ) controller (
        .clk(clk),
        .reset(reset),
        .start(enable),
        .rd_from_matrix_A(rd_from_matrix_A),
        .rd_from_matrix_B(rd_from_matrix_B),
        .load_matrix_A(load_matrix_A),
        .load_matrix_B(load_matrix_B),
        .addr_matrix_A(addr_matrix_A),
        .addr_matrix_B(addr_matrix_B)
    );
    
    // Instantiate the Data_Mem module for Matrix A
    ROM #(
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_DEPTH(A_ROWS * A_COLS),
        .BLOCK_SIZE(A_COLS),
        .MATRIX_FILE("matrixA.mem")
    ) Matrix_A_mem (
        .clk(clk),
        .reset(reset),
        .rd_en(rd_from_matrix_A),
        .addr(addr_matrix_A),
        .data_out(data_from_matrix_A)
    );
    
    generate
        for (m = 0; m < A_ROWS; m = m + 1) begin : row
            // Instantiate the Shift Register module 
            Shift_Reg #(
                .DATA_WIDTH(DATA_WIDTH),
                .BLOCK_SIZE(A_COLS)
            ) shift_register (
                .clk(clk),
                .reset(reset),
                .load(load_matrix_A[m]),
                .data_in(data_from_matrix_A),
                .data_out(matrix_A[m])
            );
        end
    endgenerate
        
    // Instantiate the Data_Mem module for Matrix B
    ROM #(
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_DEPTH(A_COLS * B_COLS),
        .BLOCK_SIZE(A_COLS),
        .MATRIX_FILE("matrixB.mem")
    ) Matrix_B_mem (
        .clk(clk),
        .reset(reset),
        .rd_en(rd_from_matrix_B),
        .addr(addr_matrix_B),
        .data_out(data_from_matrix_B)
    );
   
    generate
        for (n = 0; n < B_COLS; n = n + 1) begin : col
            // Instantiate the Shift Register module
            Shift_Reg #(
                .DATA_WIDTH(DATA_WIDTH),
                .BLOCK_SIZE(A_COLS)
            ) shift_register (
                .clk(clk),
                .reset(reset),
                .load(load_matrix_B[n]),
                .data_in(data_from_matrix_B),
                .data_out(matrix_B[n])
            );
        end
    endgenerate
    
    // Instantiate the Systolic Array module
    Systolic_Array #(
        .DATA_WIDTH(DATA_WIDTH),
        .A_ROWS(A_ROWS),
        .B_COLS(B_COLS)
    ) systolic_array (
        .clk(clk),
        .reset(reset),
        .a(matrix_A),
        .b(matrix_B),
        .c(result)
    );
    
    reg [DATA_WIDTH - 1:0] Matrix_C_mem [0:A_ROWS * B_COLS - 1];
        
    integer k;
    always @(posedge reset)
    begin
        for (k = 0; k < (A_ROWS * B_COLS); k = k + 1) begin
            Matrix_C_mem[k] = 'b0;
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
