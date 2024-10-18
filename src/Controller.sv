`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2024 07:02:47 PM
// Design Name: 
// Module Name: Controller
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


module Controller
#(
    parameter A_ROWS = 2,
    parameter A_COLS = 2,
    parameter B_COLS = 2
)(
    input clk,
    input reset,
    input start,
    
    output reg rd_from_matrix_A,
    output reg rd_from_matrix_B,
    output reg [0:A_ROWS - 1] load_matrix_A,
    output reg [0:B_COLS - 1] load_matrix_B,
    output reg [$clog2(A_ROWS * A_COLS) - 1:0] addr_matrix_A,
    output reg [$clog2(A_COLS * B_COLS) - 1:0] addr_matrix_B
);
    typedef enum {IDLE, START} state_type;
    state_type state_nxt, state_crnt;
    
    reg [$clog2(A_ROWS * A_COLS) - 1:0] addr_A_nxt, addr_A_crnt;
    reg [$clog2(A_COLS * B_COLS) - 1:0] addr_B_nxt, addr_B_crnt;     
    
    // Counter for matrix A rows
    reg [7:0] c_rows_nxt, c_rows_crnt;
    // Counter for matrix B columns
    reg [7:0] c_cols_nxt, c_cols_crnt;
    
    always @(negedge clk or posedge reset)
    begin
        if(reset) begin
            state_crnt  <= IDLE;
            c_rows_crnt <= 'b0;
            c_cols_crnt <= 'b0;
            
            addr_A_crnt <= 'b0;
            addr_B_crnt <= 'b0;
        end
        else begin
            state_crnt  <= state_nxt;
            c_rows_crnt <= c_rows_nxt;
            c_cols_crnt <= c_cols_nxt;
            
            addr_A_crnt <= addr_A_nxt;
            addr_B_crnt <= addr_B_nxt;
        end
    end
    
    
    always @(*)
    begin
        state_nxt      = state_crnt;
        c_rows_nxt     = c_rows_crnt;
        c_cols_nxt     = c_cols_crnt;
        
        rd_from_matrix_A = 1'b0;
        load_matrix_A    = 'b0;
        rd_from_matrix_B = 1'b0;
        load_matrix_B    = 'b0; 
        
        addr_A_nxt = addr_A_crnt;
        addr_B_nxt = addr_B_crnt;
    
        case(state_crnt)
            IDLE:
            begin
                if(start) begin
                    state_nxt = START;
                end
            end
                             
            START:
            begin
                if(c_rows_crnt < A_ROWS) begin
                    rd_from_matrix_A = 1'b1;
                    load_matrix_A[c_rows_crnt] = 1'b1;
                    addr_A_nxt = addr_A_crnt + A_COLS;
                    c_rows_nxt = c_rows_crnt + 1;
                end
                
                if(c_cols_crnt < B_COLS) begin
                    rd_from_matrix_B = 1'b1;          
                    load_matrix_B[c_cols_crnt] = 1'b1;
                    addr_B_nxt = addr_B_crnt + A_COLS;
                    c_cols_nxt = c_cols_crnt + 1;  
                end
                
                if((c_rows_crnt > A_ROWS - 1) & (c_cols_crnt > B_COLS -1)) begin
                    state_nxt = IDLE;
                end
            end
            
            default:;
        endcase
    end
    
    assign addr_matrix_A = addr_A_crnt;
    assign addr_matrix_B = addr_B_crnt;
endmodule
