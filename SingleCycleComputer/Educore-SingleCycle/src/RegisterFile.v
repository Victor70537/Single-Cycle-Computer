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

// This module is used for defining the behavior of the Register File of your 
// Educore. Just like in a schematic, the module has a standardized input and 
// output, but the implementation details of how it accomplishes its function 
// are up to you. Each of these modules is instantiated and used by the Educore 
// module (excluding the Educore module itself).

module RegisterFile
(
	input        clk,
	input        clk_en,
	input        read_n_sp,
	input  [4:0] read_reg_an,
	input  [4:0] read_reg_am,
	input  [4:0] read_reg_aa,

	input        write_en,
	input  [4:0] write_reg_a,
	input [63:0] write_reg_v,

	input        wload_en,
	input  [4:0] wload_reg_a,
	input [63:0] wload_reg_v,

	output [63:0] read_reg_vn,
	output [63:0] read_reg_vm,
	output [63:0] read_reg_va
);

// Ensure the tools synthesize the correct components "flip-flops" not memory.
reg [63:0] rX00, rX01, rX02, rX03, rX04, rX05, rX06, rX07;
reg [63:0] rX08, rX09, rX10, rX11, rX12, rX13, rX14, rX15;
reg [63:0] rX16, rX17, rX18, rX19, rX20, rX21, rX22, rX23;
reg [63:0] rX24, rX25, rX26, rX27, rX28, rX29, rX30, rX31; // <- SP

// Place Your Code Here

endmodule
