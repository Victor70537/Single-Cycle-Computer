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

// This module is used for defining the behavior of the Barrel Shifter of your
// Educore. Just like in a schematic, the module has a standardized input and 
// output, but the implementation details of how it accomplishes its function 
// are up to you. Each of these modules is instantiated and used by the Educore
// module (excluding the Educore module itself).

module BarrelShifter (
	input   [5:0] shamt,
	input         FnH,
	input   [1:0] barrel_op,
	input  [63:0] barrel_in,
	input  [63:0] upper_in,

	output  [5:0] right_shamt,
	output [63:0] barrel_out
);

// Place Your Code Here

endmodule
