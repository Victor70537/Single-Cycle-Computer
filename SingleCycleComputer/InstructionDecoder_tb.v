// Testbench Instruction Decode
/*

*/

`timescale 10ms/1ms

module ID_TB();

	reg CLK;
	reg [31:0] I; 

	wire BR_PC; 
	wire BR_PC_COND; 
	wire IF_NEXT_PC;
	wire [3:0] PSTATE_COND; 

	wire [3:0] op; 

	wire REG_WRITE; 
	wire [2:0]reg_addr_AA; 
	wire [2:0]reg_addr_AN; 
	wire [2:0]reg_addr_AM; 
	wire SET_FLAGS; 
	wire MUX_PC;
	wire IMM_BOT;
	wire AN_TOP; 
	wire AN_BOT; 


	wire WB_READ;
	wire WB_WRITE;

	wire [3:0] decode_err;


InstructionDecoder test (
	I, 
	BR_PC, 
	BR_PC_COND,
	IF_NEXT_PC,
	PSTATE_COND,
	op,
	REG_WRITE,
	reg_addr_AA,
	reg_addr_AN, 
	reg_addr_AM,
	SET_FLAGS, 
	MUX_PC, 
	IMM_BOT,
	AN_TOP,
	AN_BOT,
	WB_READ,
	WB_WRITE,
	decode_err
);

//Clock
always begin
	CLK <= 0;
	#10;
	CLK <= 1;
	#10;
end

// Test come inputs
initial begin
$dumpvars(0,ID_TB);
	//wait one cycle to show startup state
	@(posedge CLK);

	@(negedge CLK);
I <= {7'b0000000,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0000001,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b1100100,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b1000000,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b1000000,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b1000001,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b1000001,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0010001,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0010001,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0011001,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0011001,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0010010,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0010010,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0011010,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0011010,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0010011,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0010011,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0011011,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0011011,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0010100,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0010100,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0011100,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0011100,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0010101,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0010101,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0111101,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0011101,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0110110,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b1100000,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b1100001,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b1100010,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b1100010,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b1101000,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0000100,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0000101,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0000010,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b0000011,25'h0};
@(posedge CLK); //TOCK
@(negedge CLK);
I <= {7'b1111111,25'h0};
@(posedge CLK); //TOCK

#10 $finish;
end
endmodule