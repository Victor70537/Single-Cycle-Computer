//1kB
//offset 256


/*
Memory-Module for Class SingleCycleComputer (SCC)
*/
module Mem_Module (
    clk,

    i_mem_a,            //instruction mem addressing
    i_mem_v,            //instruction mem (read only)
    i_mem_en,           //instruction control

    d_mem_a,            //data mem addressing
    d_mem_out_v, d_mem_in_v, //data mem IO busses
    d_mem_write, d_mem_read //data mem control
);


/* BY THE BOOK: SCC ISA states...
"Instruction and Address Width
	Like ARMv8, instructions have a fixed width of 32-bits, and the addressing space in memory is 32-bits."
*/
parameter INSTRUCTION_ADDRESS_SIZE = 31;
parameter INSTRUCTION_SIZE = 31; //bit depth

parameter DATA_ADDRESS_SIZE = 31; //fixed by ISA
parameter DATA_SIZE = 31; //data bit-depth

	input clk;

    //to read Instructions
	input       [31:0] i_mem_a;         // Instruction memory address
    output reg  [31:0] i_mem_v;         // Instruction memory value
    input       i_mem_en;               // Instruction memory read enable

    //adressing data
    input   [31:0] d_mem_a;             // Data memory address
    
    //to read Data
    input   d_mem_read;                 //indicate data read
    output reg  [31:0] d_mem_out_v;     // Data memory write value
 
    //to write Data
	input   d_mem_write;                // indicate data write
    input   d_mem_in_v;                 // data memory write value

    
endmodule