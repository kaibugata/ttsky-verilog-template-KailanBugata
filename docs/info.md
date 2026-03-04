<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project is based on a RISCV 5 Stage Processor that I designed last summer. The github link for that is: https://github.com/kaibugata/RISCV_PIPELINE_CPU_KB-
However instead of making a full RISC Processor again, this TT project is a barebones version of my RISCV Processor with a few modifications of my choice.

### Instructions

Due to the pin constraints of this project, my instruction is limited to 14 bit instructions. For my barebones ISA, I use two types of RISCV instruction types: R and I.
Below is a table showing where bits of the instruction are assigned.

|rs2/imm| rs1 | rd | opcode | Inst Type |
|-------|-----|----|--------|-----------|
|inst(13:11)|inst(10:8)|inst(7:5)|inst(4:1)|inst(0)|

For I-type instructions where an immediate is needed, the rs2 bits are also immediate bits.
Instruction Type is dictated by the LSB which is 0 for I-Type inst and 1 for R-Type inst.



## How to test

Explain how to use your project (test)

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
