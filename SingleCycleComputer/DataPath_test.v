`timescale 1ns/1ns

module DataPath_test ();

//inputs
reg [31:0] PC_s, REG_1_s, REG_2_s;
reg [15:0] IMM_s;
reg AN_BOT_s, AN_TOP_s, IMM_BOT_s, MUX_PC_s;

//outputs
wire [31:0] AN_s, AM_s;  

DataPath test_unit
(
    PC_s, REG_1_s, REG_2_s,
    IMM_s,
    AN_BOT_s, AN_TOP_s, IMM_BOT_s, MUX_PC_s,
    AN_s, AM_s
);

initial begin
$dumpvars(0, DataPath_test); 
REG_1_s <= 32'h0000FFFF;
IMM_s <= 16'hABCD;
#10 AN_BOT_s <= 1;
//#20 AN_BOT_s <= 0;
//REG_1_s <= 32'hFFFF0000;
#10 AN_BOT_s <= 0;
#10 AN_TOP_s <= 1;
#10 AN_TOP_s <= 0;
#10 IMM_BOT_s <= 1;

//#10 AN_TOP_s <= 0;


#50 $finish;
end 
endmodule