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

// This module is used for defining the behavior of the Arithmetic Logic Unit
// of your Educore. Just like in a schematic, the module has a standardized 
// input and output, but the implementation details of how it accomplishes 
// its function are up to you. Each of these modules is instantiated and used 
// by the Educore module (excluding the Educore module itself).

module ArithmeticLogicUnit
(
	input [63:0] operand_a,
	input [63:0] operand_b,
	input        carry_in,
	input        invert_b,
	input        FnH,
	input  [2:0] cmd,

	output reg [63:0] result,
	output      [3:0] flags_nzcv,
	output reg writeback
);

// Place Your Code Here

always @(*) begin
	
	case (cmd)
		3'b000:	result = operand_a + operand_b; // add
		3'b001: result = operand_a - operand_b; // subtract
		3'b010: result = operand_a & operand_b; // and
		3'b011: result = operand_a | operand_b; // or
		3'b100:	
		3'b101:
		3'b110:
		3'b111:
	endcase

	


end


endmodule
