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

// This module is used for defining the behavior of the Instruction Decoder
// of your Educore. Just like in a schematic, the module has a standardized 
// input and output, but the implementation details of how it accomplishes 
// its function are up to you. Each of these modules is instantiated and used 
// by the Educore module (excluding the Educore module itself).

module InstructionDecoder (
	input  [31:0] I, // Instruction to be decoded

	output reg  [4:0] read_reg_an,
	output reg  [4:0] read_reg_am,
	output reg  [4:0] read_reg_aa,
	output reg        read_n_sp,
	output reg  [1:0] exec_n_mux,
	output reg        exec_m_mux,
	output reg [63:0] immediate,

	// To Execute stage
	output reg  [5:0] shamt,
	output reg  [5:0] imm_sz,
	output reg        imm_n,
	output reg        FnH,
	output reg  [1:0] barrel_op,
	output reg        barrel_in_mux,
	output reg        barrel_u_in_mux,
	output reg        bitext_sign_ext,
	output reg  [1:0] alu_op_a_mux,
	output reg        alu_op_b_mux,
	output reg        wt_mask,
	output reg        alu_invert_b,
	output reg  [2:0] alu_cmd,
	output reg  [1:0] out_mux,
	output reg  [3:0] condition,
	output reg        pstate_en,
	output reg  [1:0] pstate_mux,
	output reg        br_condition_mux,
	output reg        nextPC_mux,
	output reg        PC_add_op_mux,

	// to memory stage
	output reg  [1:0] mem_size,
	output reg        mem_sign_ext,
	output reg        mem_read,
	output reg        mem_write,
	output reg        mem_addr_mux,
	output reg        load_FnH,

	// to writeback stage
	output reg  [4:0] wload_addr,
	output reg  [4:0] write_addr,
	output reg        wload_en,
	output reg        write_en,

	// Error detection
	output reg [3:0] decode_err
);

// Place Your Code Here

endmodule
