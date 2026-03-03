`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 09:20:13 PM
// Design Name: 
// Module Name: risc_tb
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


module risc_tb(

);
    
    logic clk,rst,valid_inst;
    logic [13:0] instruction_i;
    logic [7:0] rs1data_o, rs2data_o;
    logic [2:0] imm_o;
    logic [3:0] ALUOp_o;
    logic ALUSrc_o;
    
    logic pass_o, error_o;
    `define FINISH_WITH_FAIL error_o = 1; pass_o = 0; #10; $finish();
    `define FINISH_WITH_PASS pass_o = 1; error_o = 0; #10; $finish();
    
    BarebonesRISCV UUT (
    .clk(clk),
    .rst(rst),
    .valid_inst(valid_inst),
    .instruction_i(instruction_i),
    .rs1data_o(rs1data_o),
    .rs2data_o(rs2data_o),
    .imm_o(imm_o),
    .ALUOp_o(ALUOp_o),
    .ALUSrc_o(ALUSrc_o)
    );
    //GUIDELINES FOR CREATING INSTRUCTIONS
    //R: (_ _ _) (_ _ _) (_ _ _) (_ _ _ _) (1)
    //    rs2      rs1     rd    opcode   i type
    //I: (_ _ _) (_ _ _) (_ _ _) (_ _ _ _) (0)
    //    imm      rs1     rd    opcode   i type
    

    always #10 clk = ~clk; //50 Mhz
    
    
    initial begin
        pass_o = 0;
        error_o = 0;
        clk = 0;
        rst = 1;
        valid_inst = 0;
        instruction_i = 0;
     
        @(negedge clk);
        rst = 0;
        @(negedge clk);
        rst = 1;
        valid_inst = 1;
        instruction_i = 14'b110_000_101_0000_1; //add x5, x0, x6   //strike up the pipeline
        @(posedge clk); //inst passes thru first pipeline stge
        @(negedge clk);
        instruction_i = 14'b000_011_001_0010_0;// ori x1,x3,0
        @(posedge clk); //first batch of data has arrived.
        @(negedge clk);
        if((rs2data_o !== 8'h6) || (rs1data_o !== 8'h0) || (imm_o !== 4'b0) || (ALUOp_o !== 4'b0000) || (ALUSrc_o !== 1'b1)) begin
             $display("Data at output #1 is incorrect\n");
             `FINISH_WITH_FAIL;
        end
        instruction_i = 14'b111_110_101_1000_0;// stgi x5,x6,7
        @(posedge clk); //second batch of data has arrived.
        @(negedge clk);
        if((rs2data_o !== 8'b0) || (rs1data_o !== 8'b0011) || (imm_o !== 4'b0000) || (ALUOp_o !== 4'b0010) || (ALUSrc_o !== 1'b0)) begin
             $display("Data at output #2 is incorrect\n");
             `FINISH_WITH_FAIL;
        end

        instruction_i = 14'b110_000_010_0011_1;// sll x2,x0,x6
        @(posedge clk); //third batch of data has arrived.
        @(negedge clk);
        if((rs2data_o !== 8'b0111) || (rs1data_o !== 8'b0110) || (imm_o !== 4'b0111) || (ALUOp_o !== 4'b1000) || (ALUSrc_o !== 1'b0)) begin
             $display("Data at output #3 is incorrect\n");
             `FINISH_WITH_FAIL;
        end
        instruction_i = 14'b001_001_101_0111_0;// xori x5,x1,1
        @(posedge clk); //fourth batch of data has arrived.
        @(negedge clk);
        if((rs2data_o !== 8'h6) || (rs1data_o !== 8'h0) || (imm_o !== 4'h0) || (ALUOp_o !== 4'b0011) || (ALUSrc_o !== 1'b1)) begin
             $display("Data at output #4 is incorrect\n");
             `FINISH_WITH_FAIL;
        end
        instruction_i = 14'b110_110_110_0000_1;// and x6,x6,x6
        @(posedge clk); //fifth batch of data has arrived.
        @(negedge clk);
        if((rs2data_o !== 8'h1) || (rs1data_o !== 8'h1) || (imm_o !== 4'h1) || (ALUOp_o !== 4'b0111) || (ALUSrc_o !== 1'b0)) begin
             $display("Data at output #5 is incorrect\n");
             `FINISH_WITH_FAIL;
        end
        instruction_i = 14'b100_010_101_0110_0;// subi x5,x2,4
        @(posedge clk); //sixth batch of data has arrived.
        @(negedge clk);
        if((rs2data_o !== 8'h6) || (rs1data_o !== 8'h6) || (imm_o !== 4'h0) || (ALUOp_o !== 4'b0000) || (ALUSrc_o !== 1'b1)) begin
             $display("Data at output #6 is incorrect\n");
             `FINISH_WITH_FAIL;
        end
        instruction_i = 14'b011_010_001_0101_1;// srl x1,x2,x3
        @(posedge clk); //seventh batch of data has arrived.
        @(negedge clk);
        if((rs2data_o !== 8'h4) || (rs1data_o !== 8'h2) || (imm_o !== 4'h4) || (ALUOp_o !== 4'b0110) || (ALUSrc_o !== 1'b0)) begin
             $display("Data at output #7 is incorrect\n");
             `FINISH_WITH_FAIL;
        end
        instruction_i = 14'b100_111_111_0100_0;// slti x7,x7,4
        @(posedge clk); //eighth batch of data has arrived.
        @(negedge clk);
        if((rs2data_o !== 8'h3) || (rs1data_o !== 8'h2) || (imm_o !== 4'h0) || (ALUOp_o !== 4'b0101) || (ALUSrc_o !== 1'b1)) begin
             $display("Data at output #8 is incorrect\n");
             `FINISH_WITH_FAIL;
        end
        @(posedge clk); //ninth batch of data has arrived.
        @(negedge clk);
        if((rs2data_o !== 8'h4) || (rs1data_o !== 8'h7) || (imm_o !== 4'h4) || (ALUOp_o !== 4'b0100) || (ALUSrc_o !== 1'b0)) begin
             $display("Data at output #9 is incorrect\n");
             `FINISH_WITH_FAIL;
        end
        
        
        $display("Basic Functionality Test Pass\n");
        $display("Start Vaild Instruction Test\n");
        
        valid_inst = 1'b0;
        instruction_i = 14'b111_111_111_1111_1;// opcode invalid should not be pass thru
        @(posedge clk); //supposedly invalid data has arrived
        @(posedge clk);
        @(negedge clk);
        if((rs2data_o !== 8'h4) || (rs1data_o !== 8'h7) || (imm_o !== 4'h4) || (ALUOp_o !== 4'b0100) || (ALUSrc_o !== 1'b0)) begin //if the data changed from last time
             $display("valid instruction signal was low but instruction somehow passed thru\n");
             `FINISH_WITH_FAIL;
        end
        
        
        
        
        `FINISH_WITH_PASS;
        
     end
        
        
        // Add more stimulus as needed
        final begin
      $display("Simulation time is %t", $time);
      if(error_o === 1) begin
	 $display("FAIL");
	 $display();
	 $display("Simulation Failed");
     end else if (pass_o === 1) begin
	 $display("PASS");
	 $display();
	 $display("Simulation Succeeded!");
     end else begin
        $display("IDK");
     end
   end
        
        

    
    
    
endmodule