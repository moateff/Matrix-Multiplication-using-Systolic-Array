`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2024 12:18:27 AM
// Design Name: 
// Module Name: Data_Mem_tb
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


module Data_Mem_tb(
    );
    
    // Parameters
    parameter DATA_WIDTH = 8;
    parameter MEM_DEPTH  = 9;
    parameter BLOCK_SIZE = 4;

    // Signals
    reg                          clk;
    reg                          reset;
    reg                          wr_en;
    reg                          rd_en;
    reg   [$clog2(MEM_DEPTH)-1:0] addr;
    reg   [DATA_WIDTH-1:0]       data_in;
    wire  [BLOCK_SIZE * DATA_WIDTH - 1:0] data_out;

    // Instantiate the Data_Mem module
    Data_Mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_DEPTH(MEM_DEPTH),
        .BLOCK_SIZE(BLOCK_SIZE)
    ) uut (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task for writing to memory
    task write_mem(input [$clog2(MEM_DEPTH)-1:0] write_addr, input [DATA_WIDTH-1:0] write_data);
    begin
        @(negedge clk);
        wr_en = 1;
        rd_en = 0;
        addr = write_addr;
        data_in = write_data;
        @(negedge clk);  // Wait for one clock cycle
        wr_en = 0;
    end
    endtask

    // Task for reading from memory
    task read_mem(input [$clog2(MEM_DEPTH)-1:0] read_addr);
    begin
        @(negedge clk);
        wr_en = 0;
        rd_en = 1;
        addr = read_addr;
        @(negedge clk);  // Wait for one clock cycle
        rd_en = 0;
    end
    endtask

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        wr_en = 0;
        rd_en = 0;
        addr = 0;
        data_in = 0;

        // Apply reset
        #10;
        reset = 0;

        // Write data to memory
        write_mem(3, 8'hA5);  // Write 0xA5 to address 3
        write_mem(5, 8'h3C);  // Write 0x3C to address 5

        // Read data from memory
        read_mem(0);          // Read from address 3
        #10;                  // Wait to observe data on data_out
        $display("Data at address 3: %h", data_out);

        read_mem(3);          // Read from address 5
        #10;                  // Wait to observe data on data_out
        $display("Data at address 5: %h", data_out);

        // Finish simulation
        #20;
        $finish;
    end

endmodule

