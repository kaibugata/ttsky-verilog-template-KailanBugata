`default_nettype none

module tt_RISCVTop (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);  


  tt_um_BarebonesRISCVKailanBugata RISCProject(
    .clk(clk),
    .rst(rst_n),//tiny tapeout uses neg reset!!!
    .valid_inst(ui_in[0]),
    .instruction_i({uio_in[6:0],ui_in[7:1]}),
    .rs1data_o(),
    .rs2data_o(), 
    .imm_o(uo_out[2:0]),
    .ALUOp_o(uo_out[6:3]),
    .ALUSrc_o(uio_out[7])
  );

  // All output pins must be assigned. If not used, assign to 0.
  //assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uo_out[7] = 0;
  assign uio_out[6:0] = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena};

endmodule
