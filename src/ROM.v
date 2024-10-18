`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2024 11:47:43 PM
// Design Name: 
// Module Name: Data_Mem
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

module ROM
#(
    parameter DATA_WIDTH  = 8,             // Width of the data bus
              MEM_DEPTH   = 9,             // Depth of the memory (number of words)
              BLOCK_SIZE  = 3,             // Number of words per block
              MATRIX_FILE = "matrixA.mem"  // File for matrix initialization
)(
    input                                  clk,             // Clock signal
    input                                  reset,           // Reset signal
    
    input                                  rd_en,           // Read enable signal
    input  [$clog2(MEM_DEPTH) - 1:0]       addr,            // Memory address
    
    output [BLOCK_SIZE * DATA_WIDTH - 1:0] data_out         // Output data (block of words) read from memory
    );
        
    // Declare the memory array, each word is DATA_WIDTH bits wide, and there are MEM_DEPTH words
    reg [DATA_WIDTH - 1:0] mem [0: MEM_DEPTH - 1];
    
    reg [BLOCK_SIZE * DATA_WIDTH - 1:0] data_out_r;
    integer i;
    
    always @(negedge clk or posedge reset) 
    begin
        if (reset) begin
            // On reset, clear the output register, enable signals, and initialize memory from file
            data_out_r <= 'b0;
            $readmemh(MATRIX_FILE, mem);   // Load memory from file
        end
    end 
    
    always @(*)
    begin
        if (rd_en) begin
           // Read operation: accumulate BLOCK_SIZE words starting at addr
           data_out_r = 'b0;  // Clear the temporary register before accumulation
            
           for(i = 0; i < BLOCK_SIZE; i = i + 1) begin
                data_out_r = data_out_r | (mem[addr + i] << (i * DATA_WIDTH)); // Accumulate data
           end
        end 
    end
    
    assign data_out = data_out_r;  // Output the accumulated block
    
endmodule