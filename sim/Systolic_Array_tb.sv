`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2024 03:47:12 PM
// Design Name: 
// Module Name: Systolic_Array_tb
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


module Systolic_Array_tb(
);
    parameter CLK_DELAY = 5;
    
    // Parameters
    parameter DATA_WIDTH = 8;
    parameter A_ROWS = 2;
    parameter A_COLS = 2;
    parameter B_COLS = 2;

    // Inputs
    reg clk;
    reg reset;
    reg [DATA_WIDTH - 1:0] a [0:A_ROWS - 1];
    reg [DATA_WIDTH - 1:0] b [0:B_COLS - 1];
                
    // Outputs
    wire [2 * DATA_WIDTH - 1:0] c [0:A_ROWS - 1][0:B_COLS - 1];

    // Instantiate the DUT (Device Under Test)
    Systolic_Array #(
        .DATA_WIDTH(DATA_WIDTH),
        .A_ROWS(A_ROWS),
        .A_COLS(A_COLS),
        .B_COLS(B_COLS)
    ) uut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .c(c)
    );

    // Clock generation
    always #CLK_DELAY clk = ~clk;
    
        
    // Task to reset the MAC module
    task reset_mac();
    begin
        reset = 1;            // Assert reset
        #(CLK_DELAY);         // Hold reset for 5 time units
        reset = 0;            // Deassert reset
    end
    endtask

    // Test procedure
    initial begin
        // Initialize inputs
        clk = 1'b0;
        a[0] = 0; a[1] = 0;
        b[0] = 0; b[1] = 0;
        reset_mac();
        @(negedge clk)
        a[0] = 1; a[1] = 0;
        b[0] = 1; b[1] = 0;
        @(negedge clk)
        a[0] = 2; a[1] = 1;
        b[0] = 2; b[1] = 1;
        @(negedge clk)
        a[0] = 0; a[1] = 2;
        b[0] = 0; b[1] = 2;         
        @(negedge clk)
        a[0] = 0; a[1] = 0;
        b[0] = 0; b[1] = 0;    
            
        // Wait for a few cycles
        #50;
        
        // Display the result matrix C
        $display("Matrix C:");
        $display("C[0][0] = %0d", c[0][0]);
        $display("C[0][1] = %0d", c[0][1]);
        $display("C[1][0] = %0d", c[1][0]);
        $display("C[1][1] = %0d", c[1][1]);
        
        // Add further tests if necessary
        $finish;
    end
    
    // Monitor the values during the simulation
    initial begin
        $monitor("Time = %t | a[0] = %d, a[1] = %d | b[0] = %d, b[1] = %d | c[0][0] = %d, c[0][1] = %d | c[1][0] = %d, c[1][1] = %d",
                 $time, a[0], a[1], b[0], b[1], c[0][0], c[0][1], c[1][0], c[1][1]);
    end
    
endmodule
