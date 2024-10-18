`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2024 01:45:48 AM
// Design Name: 
// Module Name: MAC_tb
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


module MAC_tb(
);

    // Parameters
    parameter DATA_WIDTH = 8;
    
    // Inputs
    reg                  clk;
    reg                  reset;
    reg [DATA_WIDTH-1:0] operand1_in;
    reg [DATA_WIDTH-1:0] operand2_in;
    
    // Outputs
    wire [DATA_WIDTH-1:0] operand1_out;
    wire [DATA_WIDTH-1:0] operand2_out;
    wire [2 * DATA_WIDTH-1:0] mac_result;
    
    // Instantiate the MAC module
    MAC #(
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .operand1_in(operand1_in),
        .operand2_in(operand2_in),
        .operand1_out(operand1_out),
        .operand2_out(operand2_out),
        .mac_result(mac_result)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end
    
    // Task to send inputs to MAC
    task send_input;
        input [DATA_WIDTH-1:0] a;
        input [DATA_WIDTH-1:0] b;
        begin
            operand1_in = a;
            operand2_in = b;
            @(negedge clk); // Wait for the positive edge of the clock
        end
    endtask
    
    // Testbench procedure
    initial begin
        // Initialize inputs
        reset = 1;
        operand1_in = 0;
        operand2_in = 0;
        
        // Reset the system
        @(negedge clk);  // Wait for one clock cycle
        reset = 0;         // De-assert reset
        
        #10;
        // Test case 1: Apply inputs to MAC
        send_input(8'd3, 8'd4);    // 3 * 4 = 12
        send_input(8'd5, 8'd2);    // 5 * 2 = 10
        
        // Test case 2: Apply more inputs
        send_input(8'd7, 8'd6);    // 7 * 6 = 42
        send_input(8'd1, 8'd9);    // 1 * 9 = 9
        
        send_input(8'd0, 8'd0);    
        
        // Reset again for next round of tests
        @(negedge clk);
        reset = 1;
        #10;
        reset = 0;
        
        // Test case 3: Different inputs after reset
        send_input(8'd10, 8'd3);   // 10 * 3 = 30
        send_input(8'd8, 8'd8);    // 8 * 8 = 64
        
        send_input(8'd0, 8'd0);
        
        // Finish the simulation
        #100;
        $stop;
    end

endmodule
