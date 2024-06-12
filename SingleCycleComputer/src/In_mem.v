//this is a intstruction memory ROM module.

integer num = 255; //this is the number of instructions to read in

module In_mem(
    input clk,
    input e,
    input [31:0] address,
    output reg [31:0] instr_out
);     
    reg [31:0] in_memory[0:num];

    // Load in_memory block with values of mem file
    initial begin
        $readmemh("instructions.mem", in_memory);
    end


    // Fetch instruction at in address and put it into instr_out
    always @(posedge clk) begin
        if(e)
            instr_out <= in_memory[address];
    end

endmodule