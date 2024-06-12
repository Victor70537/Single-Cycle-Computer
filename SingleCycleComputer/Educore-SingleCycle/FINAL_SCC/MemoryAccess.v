module MemoryAccess
(
  input [31:0] ALU_RESULT,        //Contains address value to read or write from in memory
  input [31:0] REG_AM_DATA,       //Contains data value to store into memory
  input WB_READ,                  //Identifies a LOAD instruction
  input WB_WRITE,                 //Identifies a STOR instrucion
  output data_memory_read,        
  output data_memory_write,       
  output [31:0] data_memory_a,    
  output [31:0] data_memory_out_v 
);

assign data_memory_read = WB_READ; 
assign data_memory_write = WB_WRITE;
assign data_memory_a = (WB_READ || WB_WRITE) ? ALU_RESULT : 'hx; //In case of a LOAD or STOR instruction assign the address with the value from ALU
assign data_memory_out_v = (WB_WRITE) ? REG_AM_DATA : 'hx;   //In case of a STOR instruction assign the output with data that needs will be stored into memory
endmodule

