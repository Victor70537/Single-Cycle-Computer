`timescale 1ns / 1ps
//`include "SSCRegisterBank.v"

module SSCRegisterBank_tb ();

//Need three reg selects
reg [2:0] DestReg_t;
reg [2:0] OpReg1_t;
reg [2:0] OpReg2_t;

//need WBDATA in
reg [31:0] WBDataIN_t;
reg [31:0] PC_IN_t;
reg wEnable_t;

//flag stuff
reg [3:0]BRFlags_t;
reg SetFlags_t;

//need clk stuff
reg Clk_t;
reg Clk_Enable_t;

wire [31:0]OutA;
wire [31:0]OutB;
wire [31:0]PCOut;

SSCRegisterBank SSCRegisterBank_1(Clk_t, Clk_Enable_t, wEnable_t, DestReg_t, OpReg1_t, OpReg2_t, WBDataIN_t, PC_IN_t, BRFlags_t, SetFlags_t, OutA, OutB, PCOut);

always begin
    Clk_t <= 1;
    #10;
    Clk_t <= 0;
    #10;
end 

initial begin
$dumpvars(0,SSCRegisterBank_tb);
//reset all inputs to known state
    #10Clk_Enable_t <= 1;
    #10wEnable_t <= 0;
	#10DestReg_t <= 'b001;
	#10OpReg1_t <= 'b001;
	#10OpReg2_t <= 'b001;
	#10WBDataIN_t <= 'h0000;
	#10PC_IN_t <= 'hEEEE;
	
	#10@(posedge Clk_t);
	#10@(posedge Clk_t);
	#10@(posedge Clk_t);
	#10@(posedge Clk_t);
	#10@(posedge Clk_t);
//Store FFFF to Reg 3

	#10Clk_Enable_t <= 1;
	#10wEnable_t <= 1; 
	#10DestReg_t <= 'b001;
	#10OpReg1_t <= 'b001;
	#10OpReg2_t <= 'b001;
	#10WBDataIN_t <= 'hFFFF;
	
	#10@(posedge Clk_t);
	#10@(posedge Clk_t);
	#10@(posedge Clk_t);
	#10wEnable_t <= 0;
	#10@(posedge Clk_t);
	#10@(posedge Clk_t);
	#10wEnable_t <= 1;
	
	//Filling the registers
	#10DestReg_t <= 'b010;
	#10WBDataIN_t <= 'hFFFF;
	#10@(posedge Clk_t);
	#10DestReg_t <= 'b011;
	#10WBDataIN_t <= 'hEEEE;
	#10@(posedge Clk_t);
	#10DestReg_t <= 'b100;
	#10WBDataIN_t <= 'hDDDD;
	#10@(posedge Clk_t);
	#10DestReg_t <= 'b101;
	#10WBDataIN_t <= 'hCCCC;
	#10@(posedge Clk_t);
	#10DestReg_t <= 'b110;
	#10WBDataIN_t <= 'hBBBB;
	#10@(posedge Clk_t);
	#10DestReg_t <= 'b111;
	#10WBDataIN_t <= 'hAAAA;
	#10@(posedge Clk_t);

	#50@(posedge Clk_t);
	#10OpReg1_t <= 'b101;
	#10OpReg2_t <= 'b011;


	#100 $finish;	
end 


endmodule