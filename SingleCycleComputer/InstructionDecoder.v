//This is the Instruction Decoder Module for the Class-ISA Single Cycle Computer
//Decode_err = 
/*
the op code instances a 1st and 2nd level decode
the entire decode is within [31:25] 7 bits

1LD [31:30] (First level decode) 2bit
------
11 sys branch
10 load or store (memory instruction)
01 data | register
00 data | immediate

S [29] ALU special instruction 1bit (only if data instruction)
------
1 ALU
0 Special Functions (NOT ALU)

2LD [28:25] (Second level decode) 4bit
------
[28] "set flags", sets NCZV with ALU result
[27:25] ALU Operation

ALU OC [27:25] 3 bit subset of 2LD
------
001	Add
010	Sub
011	And
100	Or
101	Xor
110	Not

SPECIAL OC [27:25] 3 bit subset of 2LD
-------
000 MOV
001 MOVT
100 LSL
101 LSR
010 CLR
011 SET

BRANCH. Conditional [27:25] 3 bit subset of 2LD
-----
010 BR (r_br, and o_br)
001 b.cond
000 b
		CHECK		 0000011
==================================
mov 	 mov 	 	 0000000 00 0 0 011
movt 	 movt 	 	 0000001

r_load 	 load 	 	 1000000
o_load 	 load 	 	 1000000
r_stor 	 stor 	 	 1000001

i_add 	 add 	 	 0010001
r_add 	 add 	 	 0110001
i_adds 	 adds 	 	 0011001
r_adds 	 adds 	 	 0111001
i_sub 	 sub 	 	 0010010
r_sub 	 sub 	 	 0110010
i_subs 	 cmp 	 	 0011010
r_subs 	 cmp 	 	 0111010
i_and 	 and 	 	 0010011 (optional)?
r_and 	 and 	 	 0110011
i_ands 	 ands 	 	 0011011
r_ands 	 ands 	 	 0111011
i_or 	 or 	 	 0010100 (optional)?
r_or 	 or 	 	 0110100
i_ors 	 ors 	 	 0011100
r_ors 	 ors 	 	 0111100
i_xor 	 xor 	 	 0010101 (optional)?
r_xor 	 xor 	 	 0110101
r_xors 	 xors 	 	 0111101
i_xors 	 xors 	 	 0011101

not 	 not 	 	 0110110

b 	 b 	 	 		 1100000
b.cond 	 b.cond 	 1100001
r_br 	 br 	 	 1100010
halt 	 halt 	 	 1101000
nop 	 nop 	 	 1100100

lsl 	 lsl 	 	 0000100
lsr 	 lsr 	 	 0000101
clr 	 clr 	 	 0000010
set 	 set 	 	 0000011
*/

`include "SCC_HEADER.vh" //store global define statements

module InstructionDecoder (
    input [31:0] I, //the instruction to decode
	//TO IF
	output reg BR_PC, //if high, we're branching
	output reg BR_PC_COND, //if high branching is conditional
	output reg IF_NEXT_PC, // mux for HALT or increment PC
	output reg [3:0] PSTATE_COND, //decode the Pstate to compair

	//TO EXE
	output reg [3:0] op, //instructions sent to ALU or Special (1bit flag, 3bit operand)

	//TO REG
	output reg REG_WRITE, //store the incoming data
	output reg [2:0]reg_addr_AA, //location to store data
	output reg [2:0]reg_addr_AN, //first reg addr
	output reg [2:0]reg_addr_AM, //2nd reg addr
	output reg SET_FLAGS, //indicates if the op should store flags

	//TO COMBOCLOUD (DATAFLOW)
	output reg MUX_PC, //replace reg1 with PC
	output reg IMM_BOT, //
	output reg AN_TOP, //mask the top 
	output reg AN_BOT, //mask the bot

	//To Writeback
	output reg WB_READ,
	output reg WB_WRITE,

	// Error detection
	output reg [3:0] decode_err
);

//steering ################################################################################
wire [1:0] L1D = I[31:30]; //OPCODE [31:30], 00 imm, 01 reg, 10 load/store, 11 sys branch
wire ALU_Special = I[29]; //OPCODE [29] command the ALU or special function
wire [4:0] L2D = I[28:25]; //OPCODE [28:25], ALU Operand, [28]flags, [27:25] op

wire [4:0] BR = I[29:25]; //sys branch OPCODE [29:25]
wire [3:0] Br_cond = I[24:21]; //branch conditional flag

wire [2:0] Rd = I[24:22]; //destination reg [24:22], Branch Conditional
wire [2:0] Rp = I[21:19]; //pointer memory [21:19], OP1 Register

wire [15:0] Imm = I[15:0]; //Immediate [15:0], Branch Label
wire [2:0] OP2 = I[18:16]; // OP2 Register[18:16]

wire [6:0] OPCODE = I[31:25];
//END steering ############################################################################


//constant assigns Input=Output

//REG
always @ ( * ) begin
	reg_addr_AA <= Rd;
	reg_addr_AN <= Rp;
	reg_addr_AM <= OP2;
	SET_FLAGS <= I[28];
end

//IF
always @ ( * ) begin
	PSTATE_COND = Br_cond;
end

always @ ( * ) case(OPCODE)
`mov: 	begin
	AN_BOT <= 1'b1;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1011;
	end
`movt: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b1;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1011;
	end
`nop: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b1;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b0111;
	end
`r_load: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b1;
	REG_WRITE <= 1'b0;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b0111;
	end
`o_load: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1001;
	end
`r_stor: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1001;
	end
`o_stor: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b1;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1001;
	end
`i_add: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b1;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1001;
	end
`r_add: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1010;
	end
`i_adds: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1010;
	end
`r_adds: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b1;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1010;
	end
`i_sub: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b1;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1010;
	end
`r_sub: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1011;
	end
`i_subs: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1011;
	end
`r_subs: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b1;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1011;
	end
`i_and: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b1;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1011;
	end
`r_and: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1100;
	end
`i_ands: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1100;
	end
`r_ands: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b1;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1100;
	end
`i_or: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b1;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1100;
	end
`r_or: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1101;
	end
`i_ors: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1101;
	end
`r_ors: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b1;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1101;
	end
`i_xor: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b1;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1101;
	end
`r_xor: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1110;
	end
`r_xors: 	begin
	AN_BOT <= 1'b1;
	AN_TOP <= 1'b1;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b1;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b0;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b0;
	BR_PC <= 1'b1;
	BR_PC_COND <= 1'b0;
	op <= 4'b0111;
	end
`i_xors: 	begin
	AN_BOT <= 1'b1;
	AN_TOP <= 1'b1;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b1;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b0;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b0;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b1;
	op <= 4'b0111;
	end
`not_: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b1;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b0;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b0;
	BR_PC <= 1'b1;
	BR_PC_COND <= 1'b0;
	op <= 4'b0111;
	end
`b: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b1;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b0;
	SET_FLAGS <= 1'b1;
	IF_NEXT_PC <= 1'b0;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b0000;
	end
`b_cond: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b1;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b0;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b0000;
	end
`r_br: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b1;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b0100;
	end
`o_br: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b0101;
	end
`halt: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b0010;
	end
`lsl: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b0011;
	end
`lsr: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b1;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b0;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b0;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b0000;
	end
`clr: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b0;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b0;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b0010;
	end
`set: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b1;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b1;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b0011;
	end
`PAUSE: 	begin
	AN_BOT <= 1'b0;
	AN_TOP <= 1'b0;
	IMM_BOT <= 1'b0;
	MUX_PC <= 1'b0;
	WB_READ <= 1'b0;
	WB_WRITE <= 1'b0;
	REG_WRITE <= 1'b0;
	SET_FLAGS <= 1'b0;
	IF_NEXT_PC <= 1'b0;
	BR_PC <= 1'b0;
	BR_PC_COND <= 1'b0;
	op <= 4'b1111;
	end
default: begin
	decode_err = 2'b10; //results in Houston having a hard time.
	IF_NEXT_PC <= 1'b0;
end
endcase

endmodule