# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotb.triggers import Timer, RisingEdge, FallingEdge, with_timeout, First


def encode_r(rs2, rs1, rd, opcode):
    return ((rs2 & 7) << 11 |
            (rs1 & 7) << 8  |
            (rd  & 7) << 5  |
            (opcode & 0xF) << 1 |
            1)


def encode_i(imm, rs1, rd, opcode):
    return ((imm & 7) << 11 |
            (rs1 & 7) << 8  |
            (rd  & 7) << 5  |
            (opcode & 0xF) << 1 |
            0)


def drive_instruction(dut, inst, valid=1):
    lower = inst & 0x7F
    upper = (inst >> 7) & 0x7F
    dut.ui_in.value = (valid & 1) | (lower << 1)
    dut.uio_in.value = upper


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



    # --- Instruction 1 ---
    inst1 = encode_r(rs2=6, rs1=0, rd=5, opcode=0)  # add
    drive_instruction(dut, inst1)

    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    # --- Instruction 2 ---
    inst2 = encode_i(imm=0, rs1=3, rd=1, opcode=2)  # ori
    drive_instruction(dut, inst2)

    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    # Now check internal signals hierarchically
    assert dut.tt_um_BarebonesRISCVKailanBugata.rs2data_o.value == 0x6
    assert dut.tt_um_BarebonesRISCVKailanBugata.rs1data_o.value == 0x0

    # Check outputs exposed at top
    imm = dut.uo_out.value & 0x7
    aluop = (dut.uo_out.value >> 3) & 0xF
    alusrc = dut.uio_out[7].value

    assert imm == 0
    assert aluop == 0
    assert alusrc == 1

    dut._log.info("Test passed!")

