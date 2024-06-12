/*
Header file for the Single Cycle Computer (SCC)
A single place to keep constants
This can make your code wayy more legible
*/

`ifndef SCC_HEADER
`define SCC_HEADER

//                      EZKEY-MSB [32'b] 31_27_23_19_15_11_7_3
//First Decode Branch, Load/Store, Data Immediate, Data Register
`define I_TYPE_1DCODE_BR     32'b11xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_1DCODE_LIDS     32'b10xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_1DCODE_IMM    32'b01xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_1DCODE_REG    32'b00xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx

//Branch Instruction Decode
`define I_TYPE_BR_Imm     32'bxx00_000x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_BR_Cond    32'bxx00_001x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_BR_REG     32'bxx00_010x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx

`define I_TYPE_SYS_NOP    32'bxx00_100x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_SYS_HALT   32'bxx01_000x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx

//Load Store Decode [25]
`define I_TYPE_LOAD       32'bxxxx_xx0x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx 
`define I_TYPE_STORE      32'bxxxx_xx1x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx 

`define mov	    7'b0000000
`define movt	7'b0000001
`define nop	    7'b1100100
`define r_load	7'b1000000
`define o_load	7'b1000000
`define r_stor	7'b1000001
`define o_stor	7'b1000001
`define i_add	7'b0010001
`define r_add	7'b0010001
`define i_adds	7'b0011001
`define r_adds	7'b0011001
`define i_sub	7'b0010010
`define r_sub	7'b0010010
`define i_subs	7'b0011010
`define r_subs	7'b0011010
`define i_and	7'b0010011
`define r_and	7'b0010011
`define i_ands	7'b0011011
`define r_ands	7'b0011011
`define i_or	7'b0010100
`define r_or	7'b0010100
`define i_ors	7'b0011100
`define r_ors	7'b0011100
`define i_xor	7'b0010101
`define r_xor	7'b0010101
`define r_xors	7'b0111101
`define i_xors	7'b0011101
`define not_	7'b0110110
`define b	    7'b1100000
`define b_cond	7'b1100001
`define r_br	7'b1100010
`define o_br	7'b1100010
`define halt	7'b1101000
`define lsl	    7'b0000100
`define lsr	    7'b0000101
`define clr	    7'b0000010
`define set	    7'b0000011
`define PAUSE	7'b1111111

//ALU or Special [29]
//`define I_TYPE_ALU        32'bxx1x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
//`define I_TYPE_SPECIAL    32'bxx0x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx

//OPCODE


/* thought they looked cute might delete
`define I_TYPE_SP        32'bxx0x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_2DCODE    32'bxxx0_000x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_ALU       32'bxxx0_000x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx

`define I_TYPE_BRANCH    32'bxxx0_000x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx

`define I_TYPE_RD        32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_RP        32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_IMM       32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx

`define I_TYPE_OP1       32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_OP2       32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx

`define I_TYPE_ALU_ADD       32'bxxxx_001x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_ALU_SUB       32'bxxxx_010x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_ALU_AND       32'bxxxx_011x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_ALU_OOR       32'bxxxx_100x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_ALU_XOR       32'bxxxx_101x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
`define I_TYPE_ALU_NOT       32'bxxxx_110x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx
*/


`endif