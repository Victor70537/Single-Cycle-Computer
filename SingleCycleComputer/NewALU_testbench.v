// testbench

`timescale 1ns/1ns

module NewALU_testbench ();

reg [31:0] a_s, b_s;
reg [3:0] ALUOp_s;
reg ior_s;
wire [31:0] result_s;
wire [3:0] nzcv_s;
wire carry_s;

reg clk;
NewALU Test(a_s, b_s, ALUOp_s, ior_s, carry_s, result_s, nzcv_s);

always begin
    clk = 0;
    #10;
    clk = 1;
    #10;
end

always @(posedge clk) begin
$dumpvars(0,NewALU_testbench);
    @(posedge clk);
    @(posedge clk);
    #5 a_s = 32'h0000_FFFF; // normal adding
    b_s = 32'b0;
    @(posedge clk);
    #5 ALUOp_s = 4'b1001; // a + b
    @(posedge clk);
    #5 ALUOp_s = 4'b1010; // a - b
    @(posedge clk);
    #5 ALUOp_s = 4'b1011; // a & b
    @(posedge clk);
    #5 ALUOp_s = 4'b1100; // a | b
    @(posedge clk);
    #5 ALUOp_s = 4'b1101; // a ^ b
    @(posedge clk);
    #5 ALUOp_s = 4'b1110; // ~result
    @(posedge clk);
    #5 a_s = 32'hFFFF_FFFF; // signed number (-1)
    b_s = 32'b1; // signed number (1)
    @(posedge clk);
    #5 ALUOp_s = 4'b0111; // signed a + b
    @(posedge clk);
    #5 b_s = 32'hFFFF_FFFF; // signed number (-1)
    @(posedge clk);
    #5 ALUOp_s = 4'b0111; // signed a + b
    @(posedge clk);
    #5 a_s = 32'hF0F0_F0F0; 
    b_s = 32'h0000_FFFF;
    ior_s = 1'b1;
    @(posedge clk);
    #5 ALUOp_s = 4'b1011;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    
#10 $finish;
end

endmodule