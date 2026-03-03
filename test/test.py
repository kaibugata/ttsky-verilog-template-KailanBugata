# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())



    #Recall
  #   tt_um_BarebonesRISCVKailanBugata RISCProject(
  #   .clk(clk),
  #   .rst(rst_n),//tiny tapeout uses neg reset!!!
  #   .valid_inst(ui_in[0]),
  #   .instruction_i({uio_in[6:0],ui_in[7:1]}),
  #   .rs1data_o(),
  #   .rs2data_o(), 
  #   .imm_o(uo_out[2:0]),
  #   .ALUOp_o(uo_out[6:3]),
  #   .ALUSrc_o(uio_out[7])
  # );


    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    dut.ui_in.value = 67  # {Instruction[6:0], valid_inst} = {01_0000_1, 1} = 
    dut.uio_in.value = 97 # {Instruction[13:7]} = uion in {0_110_000_1} = 
    # valid_inst = 1;
    # instruction_i = 14'b110_000_101_0000_1; //add x5, x0, x6   //strike up the pipeline

    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 2)

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    #if((rs2data_o !== 8'h6) || (rs1data_o !== 8'h0) || (imm_o !== 3'b0) || (ALUOp_o !== 4'b0000) || (ALUSrc_o !== 1'b1)) begin
    assert dut.uo_out.value == 0  #{0, ALUOp_o, imm_o} = {0, 0000, 000}
    assert dut.uio_out.value == 128  #{ALU SRC 0000000} = 1000000

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
