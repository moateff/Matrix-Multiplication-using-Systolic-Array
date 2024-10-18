`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2024 02:55:23 PM
// Design Name: 
// Module Name: Shift_Reg
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


module Shift_Reg
#(
    parameter DATA_WIDTH = 8,
              BLOCK_SIZE = 3
)(
    input clk,
    input reset,
    
    input                                  load,
    input  [BLOCK_SIZE * DATA_WIDTH - 1:0] data_in,
    
    output [DATA_WIDTH - 1:0] data_out
    );
    
    reg [BLOCK_SIZE * DATA_WIDTH - 1:0] Q_nxt, Q_crnt;
    
    always @(negedge clk or posedge reset)
    begin
        if (reset) begin
            Q_crnt <= 'b0;
        end
        else begin
            Q_crnt <= Q_nxt;
        end
    end
    
    always @(*)
    begin
        if (load) begin
            // Load input data into the register
            Q_nxt = data_in;
        end
        else begin 
            // Shift the register by DATA_WIDTH bits
            Q_nxt = (Q_crnt >> DATA_WIDTH);
        end
    end
    
    // Output the lower DATA_WIDTH bits
    assign data_out = Q_nxt[DATA_WIDTH - 1:0];
        
endmodule
