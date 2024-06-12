module DataPath 
(
    input [31:0] PC,     //Program Counter value is used in cases of branching which gets sent to ALU
    input [31:0] REG_1,  //Contains data from register bank
    input [31:0] REG_2,
    input [15:0] IMM,    //16 bit immediate value that gets extended to 32 bits prior to ALU
    input AN_BOT,        //Identifies a MOV instruction in which the immediate value gets padded with 0's on the LHS
    input AN_TOP,        //Identifies a MOVT instruction in which the immediate value gets padded with 0's on the RHS
    input [1:0] IMM_BOT, //Identifies if an immediate has been passed and if it requires a sign extension(11) or not(01)
    input MUX_PC,        //Determines whether the program counter should be passed to ALU or not
    output reg [31:0] AN,//Sends the first operand value to ALU
    output reg [31:0] AM //Sends the second operand value to ALU
);

always @(*) begin
    if (!AN_BOT || !AN_TOP || !IMM_BOT || !MUX_PC ) begin //Default applies the data values from register bank to be sent to ALU
        AN = REG_1;
        AM = REG_2;
    end 
     if (IMM_BOT == 2'b01) begin //Extends 16 bit immediate value to 32 bits and pads MSB with 0's
        AM = {16'h0000 , IMM};
    end 
    if (IMM_BOT == 2'b11) begin //Sign extends 16 bit immediate value to 32 bits
        AM = {{16{IMM[15]}} , IMM};
    end 
     if (MUX_PC) begin //If high then assign operand 1 value of ALU as the program counter
        AN = PC;
    end 
     if (MUX_PC && (IMM_BOT == 2'b11)) begin //If a conditional branch or relative branch then assign both operand values of ALU to program counter and immediate value
        AN = PC;
        AM = {{16{IMM[15]}} , IMM};
    end 
    if (AN_TOP && (IMM_BOT == 2'b01)) begin // MOVT
        if(REG_1 === 'hx) begin
          AN = {IMM, 16'h0000};
        end
        else begin
        AN = (REG_1 & 32'h0000FFFF) | {IMM, 16'h0000};
        end
    end
    if (AN_BOT && (IMM_BOT == 2'b01)) begin // MOV
        if(REG_1 === 'hx) begin
        AN = {16'h0000, IMM};
        end
        else begin
        AN = (REG_1 & 32'hFFFF0000) | {16'h0000, IMM};  
        end
    end
end
endmodule