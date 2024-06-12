//----------------------------------------------------------------------------
//The information contained in this file may only be used by a person
//authorised under and to the extent permitted by a subsisting licensing 
//agreement from Arm Limited or its affiliates 
//
//(C) COPYRIGHT 2020 Arm Limited or its affiliates
//ALL RIGHTS RESERVED.
//Licensed under the ARM EDUCATION INTRODUCTION TO COMPUTER ARCHITECTURE 
//EDUCATION KIT END USER LICENSE AGREEMENT.
//See https://www.arm.com/-/media/Files/pdf/education/computer-architecture-education-kit-eula
//
//This entire notice must be reproduced on all copies of this file
//and copies of this file may only be made by a person if such person is
//permitted to do so under the terms of a subsisting license agreement
//from Arm Limited or its affiliates.
//----------------------------------------------------------------------------
`include "Educore.vh"

// This module acts as the 'glue' of the Educore, making sure the input and 
// output goes where it needs to in order to complete each instruction. It 
// also implements essential architecture features such as the registers, 
// program counter, memory I/O, etc. Just like in a schematic, the module has 
// a standardized input and output, but the implementation details of how it 
// accomplishes its function are up to you.

module Educore
(
	input         clk,    // Core clock
	input         clk_en, // Clock enable
	input         nreset, // Active low reset
	input  [31:0] instruction_memory_v, // Instruction memory read value
	input  [63:0] data_memory_in_v,     // Data memory read value

	output  [3:0] error_indicator,
	output [63:0] instruction_memory_a, // Instruction memory address
	output        instruction_memory_en,// Instruction memory read enable
	output [63:0] data_memory_a,        // Data memory address
	output [63:0] data_memory_out_v,    // Data memory write value
	output  [1:0] data_memory_s,        // Data memory read/write size
	output        data_memory_read,     // Data memory read control
	output        data_memory_write     // Data memory write control
);

/******************************************************************************/
// Register declaration
/* The program counter (pointing to the next instruction to be fetched) */
reg [61:0] PC;
/* Processor state register (Holds NZCV flags`) */
reg [3:0] PSTATE;

/*****************************************************************************/

// Place Your Code Here

endmodule
