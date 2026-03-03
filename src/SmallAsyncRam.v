`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 08:43:07 PM
// Design Name: 
// Module Name: SmallAsyncRam
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


module SmallAsyncRam #(

    parameter  DataWidth = 8,
    parameter  NumEntries = 16
) (
    input   clk,
    input   rst,

    
    input wr_valid_i,
    input  [DataWidth-1:0]          wr_data_i,
    input  [$clog2(NumEntries)-1:0] wr_addr_i,

    input  [$clog2(NumEntries)-1:0] rs1_addr_i,
    output reg [DataWidth-1:0]          rs1_data_o,

    input  [$clog2(NumEntries)-1:0] rs2_addr_i,
    output reg [DataWidth-1:0]          rs2_data_o
);

    reg [DataWidth-1:0] mem [0:NumEntries-1];//the mem comp

    
    always @(*) begin 
        
        rs1_data_o <= mem[rs1_addr_i];
        rs2_data_o <= mem[rs2_addr_i]; 
    end
    

    always @(posedge clk) begin
        if (rst) begin
            mem[0]  <= 8'h0;
            mem[1]  <= 8'h1;
            mem[2]  <= 8'h2;
            mem[3]  <= 8'h3;
            mem[4]  <= 8'h4;
            mem[5]  <= 8'h5;
            mem[6]  <= 8'h6;
            mem[7]  <= 8'h7;
            mem[8]  <= 8'h8;
            mem[9]  <= 8'h9;
            mem[10] <= 8'hA;
            mem[11] <= 8'hB;
            mem[12] <= 8'hC;
            mem[13] <= 8'hD;
            mem[14] <= 8'hE;
            mem[15] <= 8'hF;
        end else begin
        if(wr_valid_i) begin
          
            mem[wr_addr_i] <= wr_data_i;
            
            end
            
            end
    end
    
    endmodule
