`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2024 03:19:22 PM
// Design Name: 
// Module Name: Shift_Reg_tb
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


module Shift_Reg_tb(
);
    
    parameter CLK_DELAY = 5;
    
    // Parameters for the shift register
    parameter DATA_WIDTH = 8;
    parameter BLOCK_SIZE = 3;

    // Inputs to the shift register
    reg clk;
    reg reset;
    reg load;
    reg [BLOCK_SIZE * DATA_WIDTH - 1:0] data_in;
    
    // Output from the shift register
    wire [DATA_WIDTH-1:0] data_out;

    // Instantiate the Shift Register module
    Shift_Reg #(
        .DATA_WIDTH(DATA_WIDTH),
        .BLOCK_SIZE(BLOCK_SIZE)
    ) uut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation: Toggle every 5 time units
    always #CLK_DELAY clk = ~clk;
    
    // Task to reset the MAC module
    task reset_module();
    begin
        reset = 1;            // Assert reset
        #CLK_DELAY;           // Hold reset for 5 time units
        reset = 0;            // Deassert reset
    end
    endtask
        
    // Task to send data to the shift register
    task send_data(input [BLOCK_SIZE * DATA_WIDTH - 1:0] in_data);
        begin
            // Set load to 1 to load the data
            load = 1;
            data_in = in_data;
            @(negedge clk);  // Wait for a clock cycle
            // Set load to 0 to begin shifting
            load = 0;
            data_in = 'b0;
            #10;
        end
    endtask

    // Initial block to apply stimulus
    initial begin
        // Initialize signals
        clk = 0;

        reset_module();
        
        #CLK_DELAY; 
        
        // Send some data and observe shifts
        send_data(24'hA1B2C3);  // Example 24-bit data (3 blocks of 8 bits)

        // Wait for a few clock cycles to shift the data
        #30;

        // End simulation
        $stop;
    end

    // Monitor the signals
    initial begin
        $monitor("Time: %0t | Load: %b | Data_in: %h | Data_out: %h",
                  $time, load, data_in, data_out);
    end
endmodule

