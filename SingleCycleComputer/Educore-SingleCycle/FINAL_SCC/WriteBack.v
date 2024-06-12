module WriteBack
(
	input [31:0] data_memory_in_v, //Data memory value
	input [31:0] ALU_RESULT,       // EXE value
  input WB_READ,                 //Determines whether to send data from memory or ALU back to register
	output [31:0] REG_AA_DATA      //Holds data that will be sent to the writeback register in the register bank
);

assign REG_AA_DATA = (WB_READ) ? data_memory_in_v : ALU_RESULT; //If high then send data from memory to register else send data from ALU to register
endmodule