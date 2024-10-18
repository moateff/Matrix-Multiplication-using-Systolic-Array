`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 07:44:50 PM
// Design Name: 
// Module Name: testbench
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


module testbench(
);

    // Parameters for the TOP_MODULE
    parameter DATA_WIDTH = 16;
    parameter A_ROWS = 4;
    parameter A_COLS = 4;
    parameter B_COLS = 4;

    // Inputs to the TOP_MODULE
    reg clk;
    reg reset;
    reg enable;

    // Outputs from the TOP_MODULE
    wire [2 * DATA_WIDTH - 1:0] result [0:A_ROWS - 1][0:B_COLS - 1];

    // Instantiate the TOP_MODULE
    TOP_MODULE #(
        .DATA_WIDTH(DATA_WIDTH),
        .A_ROWS(A_ROWS),
        .A_COLS(A_COLS),
        .B_COLS(B_COLS)
    ) uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .result(result)
    );

    // Clock generation: Toggle every 5 time units
    always #5 clk = ~clk;

    // Task to reset and enable the system
    task reset_and_enable;
        begin
            reset = 1;
            enable = 0;
            #10;
            reset = 0;
            #10;
            enable = 1;
            #10;
            enable = 0;
        end
    endtask

    // Initial block to apply stimulus
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        enable = 0;

        // Apply reset and enable the module
        reset_and_enable();

        // Wait for matrix multiplication to complete
        #120;

        // Finish simulation
        $stop;
    end

endmodule

