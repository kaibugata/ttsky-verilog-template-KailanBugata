`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 06:48:25 PM
// Design Name: 
// Module Name: BarebonesRISCV
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


module tt_um_BarebonesRISCVKailanBugata(
    input clk,
    input rst,
    input valid_inst,
    input [16:0] instruction_i,
    
    output [7:0] rs1data_o, rs2data_o, 
    output [3:0] imm_o,
    output [3:0] ALUOp_o,
    output ALUSrc_o
    

    );
    
    wire [16:0] inst_w;
    
    
    DFF #(.width_p(17)) instPipeline
    (
    .clk(clk),
    .rst(rst),
    .data_i(instruction_i),
    .valid_i(valid_inst),
    .data_o(inst_w)
    );
    
    wire [3:0] rd,rs1,rs2;              
    wire [3:0] opcode;                      
    wire I_Type;   
    
    Instruction_Parser getInst 
    (
    .Instruction(inst_w),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .opcode(opcode),
    .I_Type(I_Type)
    );
    
    wire [3:0] const;
    immediateParser getimm
    (
    .Instruction(inst_w),
    .I_Type(I_Type),
    .constant(const)
    );
    
    wire [3:0] ALUOp;
    wire ALUSrc;
    Control getSig
    (
    .opcode(opcode),
    .I_Type(I_Type),
    .ALUSrc(ALUSrc),
    .ALUOp(ALUOp)
    );
    
    wire [7:0] rs1_data,rs2_data;
    SmallAsyncRam Regist
    (
    .clk(clk),
    .rst(rst),
    .wr_valid_i(1'b0),
    .wr_data_i(0),
    .wr_addr_i(rd),
    .rs1_addr_i(rs1),
    .rs1_data_o(rs1_data),
    .rs2_addr_i(rs2),
    .rs2_data_o(rs2_data)
    );
    
    
     DFF #(.width_p(8)) rs1Pipeline
    (
    .clk(clk),
    .rst(rst),
    .data_i(rs1_data),
    .valid_i(1'b1),
    .data_o(rs1data_o)
    );
    
    DFF #(.width_p(8)) rs2Pipeline
    (
    .clk(clk),
    .rst(rst),
    .data_i(rs2_data),
    .valid_i(1'b1),
    .data_o(rs2data_o)
    );
    
    DFF #(.width_p(4)) immPipeline
    (
    .clk(clk),
    .rst(rst),
    .data_i(const),
    .valid_i(1'b1),
    .data_o(imm_o)
    );
    
    DFF #(.width_p(4)) ALUoppipeline
    (
    .clk(clk),
    .rst(rst),
    .data_i(ALUOp),
    .valid_i(1'b1),
    .data_o(ALUOp_o)
    );
    
    
    DFF #(.width_p(1)) ALUsrcipeline
    (
    .clk(clk),
    .rst(rst),
    .data_i(ALUSrc),
    .valid_i(1'b1),
    .data_o(ALUSrc_o)
    );
    
    
    
    
    
    
endmodule
