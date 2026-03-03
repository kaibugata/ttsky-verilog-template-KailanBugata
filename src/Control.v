`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 08:29:05 PM
// Design Name: 
// Module Name: Control
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

module Control (
    input [3:0] opcode,
    input  I_Type,
    output ALUSrc,
    output [3:0] ALUOp

);



assign ALUSrc = (I_Type == 1'b1); //1 for taking from rs2, 0 taking from immidiate will be used in pre alu mux



//ALU depends on the opcode
//ALU op
//0000 = ADD
//0001 = AND
//0010 = OR
//0011 = SLL
//0100 = SLT
//0101 = SRL
//0110 = SUB
//0111 = XOR
//1000 = SGT

assign ALUOp = opcode;



endmodule
