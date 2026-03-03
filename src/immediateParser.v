`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 07:22:53 PM
// Design Name: 
// Module Name: immediateParser
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


module immediateParser (
    input  [13:0] Instruction,
    input  I_Type,
    output reg [2:0] constant

);

always@(*) begin
case (I_Type)
  1'b0: constant = Instruction[13:11]; //I type inst
  default: constant = 3'd0;
endcase
end


endmodule
