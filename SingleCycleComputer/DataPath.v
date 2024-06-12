module DataPath 
(
    input[31:0] PC, REG_1, REG_2,
    input[15:0] IMM,
    input AN_BOT, AN_TOP, IMM_BOT, MUX_PC,
    output reg [31:0] AN, AM   
);

always @(*) begin
    if (AN_BOT) begin //IF AN_BOT REG_1 is and with FFFF0000
        AN = REG_1 & 32'hFFFF0000;
    end 
    if (AN_TOP) begin // AN_TOP signal 
        AN = REG_1 & 32'h0000FFFF;
    end 
    if (IMM_BOT) begin 
        AM = {16'h0000, IMM};
    end 
    if (MUX_PC) begin 
        AN = PC;
    end 
    if (MUX_PC & IMM_BOT) begin
        AN = PC;
        AM = {16'h0000 , IMM};
    end 
    if (!AN_BOT | !AN_TOP | !IMM_BOT | !MUX_PC ) begin
        AN = REG_1;
        AM = REG_2;
    end
end
endmodule