`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 06:52:34 PM
// Design Name: 
// Module Name: DFF
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


module DFF #(parameter width_p = 32)(
    input clk,
    input rst,
    input [width_p -1:0] data_i,
    input valid_i,
    output reg [width_p -1:0] data_o
    );
    
    
    always@(posedge clk) begin
        if(rst) begin
            data_o <= {width_p{1'b0}};
        end else begin
            if(valid_i) begin
                data_o <= data_i;
            end else begin
                data_o <= data_o;
            end
        end
    end
    
    
    
    
endmodule
