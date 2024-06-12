

module Data_mem(
    input clk,
    input [31:0] data_address,
    input [31:0] data_in,
    input we, //write_enable
    input re, //read_enable
    output reg [31:0] data_out
);


// Data memory block (1024*4) bytes of space or just 1024 DWORDS lmao 
reg [31:0] data_memory [0:1023];

// Load data_memory with contents of file (assuming file is in hex)
initial begin
    $readmemh("data.mem", data_memory);
end

// read/write synchronous block
always @(posedge clk) begin
    if(we==1'b1) begin
        data_memory[data_address] <= data_in; end
    if (re==1'b1) begin
        data_out <= data_memory[data_address]; end
end


endmodule
