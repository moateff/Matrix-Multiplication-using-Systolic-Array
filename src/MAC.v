`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2024 01:05:33 AM
// Design Name: 
// Module Name: MAC
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


module MAC
#(
    parameter DATA_WIDTH  = 8   // Width of the data bus
)(
    input                         clk,             // Clock signal
    input                         reset,           // Reset signal
    
    input  [DATA_WIDTH - 1:0]     operand1_in,     // First input operand (matrix A)
    input  [DATA_WIDTH - 1:0]     operand2_in,     // Second input operand (matrix B)
    
    output [DATA_WIDTH - 1:0]     operand1_out,    // Registered output operand1
    output [DATA_WIDTH - 1:0]     operand2_out,    // Registered output operand2
    output [2 * DATA_WIDTH - 1:0] mac_result       // Accumulated result (MAC output)
    );
    
    // Internal registers for operand1, operand2 and accumlator
    reg [DATA_WIDTH - 1:0]     operand1_reg, operand2_reg;
    reg [2 * DATA_WIDTH - 1:0] accumlator;
    
    always @(negedge clk or posedge reset) 
    begin
        if (reset)
        begin
            operand1_reg <= 'b0;
            operand2_reg <= 'b0;
            accumlator   <= 'b0;
        end
        else
        begin
            // Multiply and accumulate the result
            accumlator <= accumlator + operand1_reg * operand2_reg;
            // Register inputs for one clock cycle
            operand1_reg <= operand1_in;
            operand2_reg <= operand2_in;
        end
    end
  
    assign mac_result = accumlator;
    
    // Output the registered inputs to the next stage (for systolic array)
    assign operand1_out = operand1_reg;
    assign operand2_out = operand2_reg;
    
endmodule
