<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project is based on a RISCV 5 Stage Processor that I designed last summer. The github link for that is: https://github.com/kaibugata/RISCV_PIPELINE_CPU_KB-
However instead of making a full RISC Processor again, this TT project is a barebones version of my RISCV Processor with a few modifications of my choice. These changes are listed below.

### Instructions

Due to the pin constraints of this project, my instruction is limited to 14 bit instructions. For my barebones ISA, I use two types of RISCV instruction types: R and I.
Below is a table showing where bits of the instruction are assigned.

|rs2/imm| rs1 | rd | opcode | Inst Type |
|-------|-----|----|--------|-----------|
|inst(13:11)|inst(10:8)|inst(7:5)|inst(4:1)|inst(0)|

For I-type instructions where an immediate is needed, the rs2 bits are also immediate bits.
Instruction Type is dictated by the LSB which is 0 for I-Type inst and 1 for R-Type inst.


### Opcodes

For this ISA there is 18 diffrerent instructions that can be done. 9 R-type and 9 I-type. For each instruction, the immidiate equaivalent instruction has the same opcode.
For example the opcode for add is 0000. Meanwhile the opcode for addi is also 0000. This applies to all instructions. A table of opcodes is shown below.

|0000| 0001 | 0010 | 0011 | 0100 |0101| 0110 | 0111 | 1000 |
|-------|-----|----|--------|-----|------|-------|-----|----|
|add(i)|and(i)|or(i)|sll(i)|slt(i)|srl(i)|sub(i)|xor(i)|sgt(i)|
|addition|bitwise and|bitwise or|shift left logical|set less than|shift right logical|subtraction|xor operation|set greater than|

### IO

This design takes in a 14 bit input Instruction, and a 1 bit valid signal. The valid signal needs to be high for the Instruction to pass thru the first pipeline stage. It then takes one more pipeline stage to get valid output signals. The output signals for the top module are a 4 bit immediate value(which will be 0 if R-type), Then two signals related to an ALU: 4 bit ALUOp and 1 bit ALU src. Due to the size resitrictions, I didn't include the ALU, but the outputs would possible lead to an ALU. ALUOp is a control unit which changes what operation the ALU does. The ALUOp is the same as the Opcode and will set the ALU to do that operation. Meanwhile ALUSrc is a 1 bit signal meant to act as control signal for a Mux. The mux would decide if the ALU would take the immediate value or the rs2_data value. In our case, the ALUsrc signal comes from the I_Type. Unfortunately due to pin limitations, Rs1data and Rs2data are not outputs.

## How to test

There are two testbenches for this circuit. One is a cocotb test on the top module located in the test directory as test.py. This testbench tests for different compbinations of instructions and detects if the outputs are as expected. For our project, this is as thorough of a testbench as we need. We also test to make sure that instructions don't pass thru the first stage when the valid signal is low. The other testbench is located in src and is called risc_tb.sv. This is the same as the other testbench, but directly tests on the risc processor module instead of the top.

## AI USAGE

https://chatgpt.com/share/69a7b6c1-4170-8000-aeb1-c66af182b5a7

I used ChatGPT to figure out how I can initialize values into the register file(since readmemh or initial begin isnt ASIC synthesisable) and how I can convert my system verilog tb into cocotb.
