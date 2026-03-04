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
    inst1 = encode_r(rs2=6, rs1=0, rd=5, opcode=0)  # add x5, x0, x6
    drive_instruction(dut, inst1)

    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    # --- Instruction 2 ---
    inst2 = encode_i(imm=0, rs1=3, rd=1, opcode=2)  # ori x1,x3,0
    drive_instruction(dut, inst2)

    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    # Now check internal signals hierarchically
    assert dut.user_project.RISCProject.rs2data_o.value == 0x6
    assert dut.user_project.RISCProject.rs1data_o.value == 0x0

    # Check outputs exposed at top
    uo = int(dut.uo_out.value)
    uio = int(dut.uio_out.value)
    imm    =  uo & 0x7
    aluop  = (uo >> 3) & 0xF
    alusrc = (uio >> 7) & 0x1
    
    assert imm == 0
    assert aluop == 0
    assert alusrc == 1

    # --- Instruction 3 ---
    inst3 = encode_i(imm=7, rs1=6, rd=5, opcode=8)  # stgi x5,x6,7
    drive_instruction(dut, inst3)

    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    # Now check internal signals hierarchically
    assert dut.user_project.RISCProject.rs2data_o.value == 0x0
    assert dut.user_project.RISCProject.rs1data_o.value == 0x3

    # Check outputs exposed at top
    uo = int(dut.uo_out.value)
    uio = int(dut.uio_out.value)
    imm    =  uo & 0x7
    aluop  = (uo >> 3) & 0xF
    alusrc = (uio >> 7) & 0x1
    
    assert imm == 0
    assert aluop == 2
    assert alusrc == 0


    # --- Instruction 4 ---
    inst4 = encode_r(rs2=6, rs1=0, rd=2, opcode=3)  # sll x2,x0,x6
    drive_instruction(dut, inst4)

    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    # Now check internal signals hierarchically
    assert dut.user_project.RISCProject.rs2data_o.value == 0x7
    assert dut.user_project.RISCProject.rs1data_o.value == 0x6

    # Check outputs exposed at top
    uo = int(dut.uo_out.value)
    uio = int(dut.uio_out.value)
    imm    =  uo & 0x7
    aluop  = (uo >> 3) & 0xF
    alusrc = (uio >> 7) & 0x1
    
    assert imm == 7
    assert aluop == 8
    assert alusrc == 0


    # --- Instruction 5 ---
    inst5 = encode_i(imm=1, rs1=1, rd=5, opcode=7)  # xori x5,x1,1
    drive_instruction(dut, inst5)

    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    # Now check internal signals hierarchically
    assert dut.user_project.RISCProject.rs2data_o.value == 0x6
    assert dut.user_project.RISCProject.rs1data_o.value == 0x0

    # Check outputs exposed at top
    uo = int(dut.uo_out.value)
    uio = int(dut.uio_out.value)
    imm    =  uo & 0x7
    aluop  = (uo >> 3) & 0xF
    alusrc = (uio >> 7) & 0x1
    
    assert imm == 0
    assert aluop == 3
    assert alusrc == 1


    # --- Instruction 6 ---
    inst6 = encode_r(rs2=6, rs1=6, rd=6, opcode=1)  # and x6,x6,x6
    drive_instruction(dut, inst6)

    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    # Now check internal signals hierarchically
    assert dut.user_project.RISCProject.rs2data_o.value == 0x1
    assert dut.user_project.RISCProject.rs1data_o.value == 0x1

    # Check outputs exposed at top
    uo = int(dut.uo_out.value)
    uio = int(dut.uio_out.value)
    imm    =  uo & 0x7
    aluop  = (uo >> 3) & 0xF
    alusrc = (uio >> 7) & 0x1
    
    assert imm == 1
    assert aluop == 7
    assert alusrc == 0


    # --- Instruction 7 ---
    inst7 = encode_i(imm=4, rs1=2, rd=5, opcode=6)  # subi x5,x2,4
    drive_instruction(dut, inst7)

    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    # Now check internal signals hierarchically
    assert dut.user_project.RISCProject.rs2data_o.value == 0x6
    assert dut.user_project.RISCProject.rs1data_o.value == 0x6

    # Check outputs exposed at top
    uo = int(dut.uo_out.value)
    uio = int(dut.uio_out.value)
    imm    =  uo & 0x7
    aluop  = (uo >> 3) & 0xF
    alusrc = (uio >> 7) & 0x1
    
    assert imm == 0
    assert aluop == 0
    assert alusrc == 1


    # --- Instruction 8 ---
    inst8 = encode_r(rs2=3, rs1=2, rd=1, opcode=5)  # srl x1,x2,x3
    drive_instruction(dut, inst8)

    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    # Now check internal signals hierarchically
    assert dut.user_project.RISCProject.rs2data_o.value == 0x4
    assert dut.user_project.RISCProject.rs1data_o.value == 0x2

    # Check outputs exposed at top
    uo = int(dut.uo_out.value)
    uio = int(dut.uio_out.value)
    imm    =  uo & 0x7
    aluop  = (uo >> 3) & 0xF
    alusrc = (uio >> 7) & 0x1
    
    assert imm == 4
    assert aluop == 6
    assert alusrc == 0


    # --- Instruction 9 ---
    inst9 = encode_i(imm=4, rs1=7, rd=7, opcode=4)  # slti x7,x7,4
    drive_instruction(dut, inst9)

    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    # Now check internal signals hierarchically
    assert dut.user_project.RISCProject.rs2data_o.value == 0x3
    assert dut.user_project.RISCProject.rs1data_o.value == 0x2

    # Check outputs exposed at top
    uo = int(dut.uo_out.value)
    uio = int(dut.uio_out.value)
    imm    =  uo & 0x7
    aluop  = (uo >> 3) & 0xF
    alusrc = (uio >> 7) & 0x1
    
    assert imm == 0
    assert aluop == 5
    assert alusrc == 1

    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    # Now check internal signals hierarchically
    assert dut.user_project.RISCProject.rs2data_o.value == 0x4
    assert dut.user_project.RISCProject.rs1data_o.value == 0x7

    # Check outputs exposed at top
    uo = int(dut.uo_out.value)
    uio = int(dut.uio_out.value)
    imm    =  uo & 0x7
    aluop  = (uo >> 3) & 0xF
    alusrc = (uio >> 7) & 0x1
    
    assert imm == 4
    assert aluop == 4
    assert alusrc == 0


    dut._log.info("Basic Functionality Test Pass")
    dut._log.info("Start valid instruction pass")


    inst10 = encode_r(imm=4, rs1=7, rd=7, opcode=15)  #bad instruction opcode bade
    drive_instruction(dut, inst9, 0) #not valid inst so shouldnt pass

    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    assert dut.user_project.RISCProject.rs2data_o.value == 0x4
    assert dut.user_project.RISCProject.rs1data_o.value == 0x7

    # Check outputs exposed at top
    uo = int(dut.uo_out.value)
    uio = int(dut.uio_out.value)
    imm    =  uo & 0x7
    aluop  = (uo >> 3) & 0xF
    alusrc = (uio >> 7) & 0x1
    
    assert imm == 4
    assert aluop == 4
    assert alusrc == 0

    dut._log.info("Test passed!")

