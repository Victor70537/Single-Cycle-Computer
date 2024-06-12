`include "InstructionDecoder.v"
`include "InstructionFetch.v"
`include "DataPath.v"
`include "RegisterBank.v"
`include "EXE.v"
`include "MemoryAccess.v"
`include "WriteBack.v"
module Core
(
	input Clk,
  input Reset,
	input [31:0] instruction_memory_v,      // Instruction memory read value
	input [31:0] data_memory_in_v,          // Data memory read value
  output reg [31:0] instruction_memory_a, // Instruction memory address
  output reg [31:0] data_memory_a,        // Data memory address
  output reg [31:0] data_memory_out_v,    // Data memory write value
  output reg    data_memory_read,         // Data memory read control
	output reg    data_memory_write,        // Data memory write control
  output reg [1:0] decode_error
);
//local inputs and output variables
wire [31:0] PC;              //Program counter holds current instruction address
wire [3:0] BR_FLAGS;         //Branch flags set by ALU for conditional branching in IF
wire [31:0] PC_BR;           //Branched program counter holds the instruction address for the program to branch to
wire IF_NEXT_PC;             //Determines if IF should increment PC
wire BR_PC;                  //Signifies an immediate or absolute branching instruction when high
wire BR_PC_COND;             //Signifies a conditional branch
wire [3:0] PSTATE_COND;      //Used to identify the type of conditional branching statement
wire [31:0] PC_NEXT;         //Identifies the next program counter
wire [31:0] PC_NEXT_ADDR;    //Final program counter sent to IO to grab next instruction from memory
wire SET_FLAGS;              //Signifies whether flags need to be set and updated
wire REG_WRITE;              //Determines if register bank should write to a register
wire [2:0] REG_ADDR_AA;      //Write register address
wire [31:0] REG_AA_DATA;     //Write register data
wire [2:0] REG_ADDR_AM;      //Read register 2
wire [2:0] REG_ADDR_AN;      //Read register 1
wire [31:0] REG_AN_DATA;     //Register 1 data
wire [31:0] REG_AM_DATA;     //Register 2 data
wire READ_SP;                //If destination register acts as source register
wire [31:0] SOURCE_REGISTER; //Data value in cases of STOR, MOV, and MOVT
wire [15:0] IMM;             //Immediate data value in cases of immediate instructions or offset values
wire MUX_PC;                 //Determines whether the program counter should be passed to ALU or not
wire [1:0] IMM_BOT;          //Identifies if an immediate value is being sent
wire AN_TOP;                 //Signifies a MOVT instruction
wire AN_BOT;                 //Signifies a MOV instruction
wire WB_READ;                //If value has been read from memory
wire WB_WRITE;               //Determines if a value is being written into memory
wire [31:0] AN;              //Operand 1 value for ALU
wire [31:0] AM;              //Operand 2 value for ALU
wire [1:0] DECODE_ERR;       //Used to identify if the SCC is running as intended with no errors(00), if it has halted(01), or an error occured(10)
wire [3:0] OP;               //Identifies the type of arithmetic instruction for the ALU
wire [31:0] ALU_RESULT;      //Output value from ALU

// Instruction Fetch module
InstructionFetch instruction_fetch(
  .Clk(Clk),
  .Reset(Reset),
  .IF_NEXT_PC(IF_NEXT_PC),
  .BR_PC(BR_PC),
  .BR_PC_COND(BR_PC_COND),
  .PSTATE_COND(PSTATE_COND),
  .PC_BR(PC_BR),
  .PC(PC),
  .br_flags(BR_FLAGS),
  .PC_NEXT(PC_NEXT),
  .PC_NEXT_ADDR(PC_NEXT_ADDR)
);

//Instruction Decode module
InstructionDecoder instruction_decoder(
  .I(instruction_memory_v), //the instruction to decode
	//TO IF
	.BR_PC(BR_PC), //if high, we're branching
	.BR_PC_COND(BR_PC_COND), //if high branching is conditional
	.IF_NEXT_PC(IF_NEXT_PC), // mux for HALT or increment PC
	.PSTATE_COND(PSTATE_COND), //decode the Pstate to compair

	//TO EXE
	.op(OP), //instructions sent to ALU or Special (1bit flag, 3bit operand)

	//TO REG
	.REG_WRITE(REG_WRITE), //store the incoming data
	.reg_addr_AA(REG_ADDR_AA), //location to store data
	.reg_addr_AN(REG_ADDR_AN), //first reg addr
	.reg_addr_AM(REG_ADDR_AM), //2nd reg addr
  .read_sp(READ_SP),
	.SET_FLAGS(SET_FLAGS), //indicates if the op should store flags

	//TO COMBOCLOUD (DATAFLOW)
	.MUX_PC(MUX_PC), //replace reg1 with PC
	.IMM_BOT(IMM_BOT), //
	.AN_TOP(AN_TOP), //mask the top 
	.AN_BOT(AN_BOT), //mask the bot
  .IMM(IMM),
	//To Writeback
	.WB_READ(WB_READ),
	.WB_WRITE(WB_WRITE),
	// Error detection
	.decode_err(DECODE_ERR)
);

//Register Bank module
RegisterBank register_bank(

    //clock stuff
    .clk(Clk),
	  .clk_en(Reset),

    //control stuff
    .wEnable(REG_WRITE),
    
    //reg select
    .DestReg(REG_ADDR_AA),
    .OpReg1(REG_ADDR_AN),
    .OpReg2(REG_ADDR_AM),
    //Data In
    .WBDataIN(REG_AA_DATA),  
    .PC_IN(PC_NEXT),
    
    //Outputs to ALU
    .readRegA(REG_AN_DATA),
    .readRegB(REG_AM_DATA),
    .sourceRegister(SOURCE_REGISTER),
    .PC_OUT(PC)

);

//Dataflow module
DataPath data_path 
(
    .PC(PC),
    .REG_1(REG_AN_DATA),
    .REG_2(REG_AM_DATA),
    .IMM(IMM),
    .AN_BOT(AN_BOT),
    .AN_TOP(AN_TOP),
    .IMM_BOT(IMM_BOT),
    .MUX_PC(MUX_PC),
    .AN(AN),
    .AM(AM)
);

//EXE
EXE exe
(
    .a(AN),
    .b(AM),
    .ALUOp(OP), // control
    .ior(IMM_BOT),
    .SET_FLAGS(SET_FLAGS),
    .result(ALU_RESULT), 
    .BR_FLAGS(BR_FLAGS) 
);

//MEM
wire [31:0] mem_data_out;    //Value to send back to IO to store value into memory
wire [31:0] mem_address_out; //Address sent to IO to identify where to read or store values in memory
wire  mem_write;             //Value sent to IO for determining if a value will be stored in memory
wire  mem_read;              //Determines if memory is being read to store or extract a value from memory
MemoryAccess memory_access(
  .ALU_RESULT(ALU_RESULT),
  .REG_AM_DATA(SOURCE_REGISTER),
  .WB_READ(WB_READ),
  .WB_WRITE(WB_WRITE),
  .data_memory_read(mem_read),
  .data_memory_write(mem_write),
  .data_memory_a(mem_address_out),
  .data_memory_out_v(mem_data_out)
);
always @(*) begin //Sends values out to IO
  data_memory_a <= mem_address_out;
  instruction_memory_a <= PC_NEXT_ADDR;
  data_memory_read <= mem_read;
  data_memory_write <= mem_write;
  data_memory_out_v <= mem_data_out;
end
always @(posedge Clk) begin //Only fetch next instruction on positive edge of clock signal
  instruction_memory_a <= PC_NEXT_ADDR;
  decode_error <= DECODE_ERR;
end
//WB
WriteBack write_back (
  .data_memory_in_v(data_memory_in_v), //from data mem
  .ALU_RESULT(ALU_RESULT), // from exe stage
  .WB_READ(WB_READ),
  .REG_AA_DATA(REG_AA_DATA) // sent back to register
);
assign PC_BR = REG_AA_DATA; //always assign result from ALU as a branch address 

endmodule

