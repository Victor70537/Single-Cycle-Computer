//Testbench for Instruction memory
/*
This module calls In_mem.v
In_mem should load the file "instructions.mem" into memory
this module will then emulate a PC to dump the instruction contents into a waveform
*/

`timescale 10ms/1ms

module Im_mem_testbench();

//declare outside reg/wires
reg clk;
reg e;
reg [31:0] address;
wire [31:0] instr_out;

integer i = 0;
integer num = 10; //number of instructions to test

In_mem  UnderTest (
    clk,
    e, //enable places data on the output
    address, //desired address to output
    instr_out //the content instruction stored in the given adress
);

//Clock
always begin
	clk <= 0;
	#10;
	clk <= 1;
	#10;
end

initial begin
$dumpvars(0,Im_mem_testbench);

	//wait one cycle to show startup state
	@(posedge clk);

    // First Tick/TOCK show enable working
    @(negedge clk);//TICK
    e <= 1'b0; //enable low, output disabled
    address <= 32'h00;
    @(posedge clk); //TOCK
    
    for (i = 0; i < num; i=i+1) begin
        @(negedge clk); //TICK
        e <= 1'b1;
        address <= i;
        @(posedge clk); //TOCK
        //instruction is output on instr_out
    end

#10 $finish;
end
endmodule