
module test_read;

parameter SIZE = 18 -1;
reg [31:0] mem_data [0:SIZE]; //holds Hex input from file

//example read from file
//use python script to parse and format for input (mem.py)
initial begin 
    $readmemh("output.txt", mem_data);
end

//example dump to log
integer i;
initial begin 
     $display("mem_dump_data:");

     for (i=0; i <= SIZE; i=i+1)

     $display("%h:%h",i*4,mem_data[i]);
end

//example write to file
initial begin 
    $writememh("mem_dump.txt", mem_data);
end
endmodule
