`include "Core.v"
`include "Instruction_and_data.v"
module IO
(
  input mem_Clk,                     //Clock signal used for memory
	input Clk,                         //Clock signal used for core module
  input Reset,                       //Reset allows for resetting program counter to initial address of 'h0 and for clearing results in registers
  input instruction_memory_en,       //Determines whether an instructions should be fetched from memory or pause the program at current instruction
                                     
  output [31:0] instruction_memory_v,//Contains the instruction data
  output [31:0] data_memory_in_v,    //Contains the data that was read from a memory location. Sends data only on a LOAD 
  output [31:0] instruction_memory_a,//Contains the address for which instruction to fetch from memory
  output [31:0] data_memory_a,       //Contains the address for which data value needs to be fetched from memory
  output [31:0] data_memory_out_v,   //Contains the data that will be stored into memory
  output data_memory_read,           //If high then it outputs the data to Core, and if low then it does nothing
  output data_memory_write,          //If high then it writes a value into memory, and if low then it does nothing
  output [1:0]decode_error           //Used to identify if the SCC is running as intended with no errors(00), if it has halted(01), or an error occured(10)
);

Core core(
	.Clk(Clk),
  .Reset(Reset),
	.instruction_memory_v(instruction_memory_v), 
	.data_memory_in_v(data_memory_in_v),     
  .instruction_memory_a(instruction_memory_a), 
  .data_memory_a(data_memory_a),        
  .data_memory_out_v(data_memory_out_v),    
  .data_memory_read(data_memory_read),     
	.data_memory_write(data_memory_write),
  .decode_error(decode_error)     
);

Instruction_and_data instruction_and_data(
   .mem_Clk(mem_Clk),
  .instruction_memory_en(instruction_memory_en),
  .instruction_memory_a(instruction_memory_a),
  .data_memory_a(data_memory_a),
  .data_memory_read(data_memory_read), 
  .data_memory_write(data_memory_write),
  .data_memory_out_v(data_memory_out_v),
  .instruction_memory_v(instruction_memory_v), 
  .data_memory_in_v(data_memory_in_v)
);
endmodule

