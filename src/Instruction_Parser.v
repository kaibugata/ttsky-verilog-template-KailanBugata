`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 07:01:23 PM
// Design Name: 
// Module Name: Instruction_Parser
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


module Instruction_Parser (
    input [16:0] Instruction,
    output reg [3:0] rd,rs1,rs2,
    output reg [3:0] opcode,
    output reg I_Type
);


always@(*) begin
    //Key: I: 0x0, R:0x1
    I_Type = Instruction[0];
    rd = Instruction[8:5];
    rs1 = Instruction[12:9];
    rs2 = Instruction[16:13];
    opcode = Instruction[4:1];
 
 end


endmodule