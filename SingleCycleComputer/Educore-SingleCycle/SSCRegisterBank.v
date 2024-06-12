module SSCRegisterBank(

    //clock stuff
    input   clk,
	input   clk_en,

    //control stuff
    input  wEnable,
    
    //reg select
    input [2:0]DestReg,
    input [2:0]OpReg1,
    input [2:0]OpReg2,
    
    //Data In
    //input  [31:0]writeBackData,     //from ALU
    input  [31:0]WBDataIN,  
    input [31:0]PC_IN,          //From Instruction decoder

    //Flags
    input [3:0]BRFlags,
    input SetFlags,
    
    //Outputs to ALU
    output  [31:0]readRegA,
    output  [31:0]readRegB,
    output [31:0]PC_OUT
    

);

    reg [31:0] readRegA;
    reg [31:0] readRegB;
    reg [31:0] PC_OUT;
    
    wire [2:0] DestReg;
    wire [2:0] OpReg1;
    wire [2:0] OpReg2;

    //data
    reg [31:0] PC_Reg;
    reg [31:0] Reg1;
    reg [31:0] Reg2;
    reg [31:0] Reg3;
    reg [31:0] Reg4;
    reg [31:0] Reg5;
    reg [31:0] Reg6;
    reg [31:0] Reg7;

    reg flag0;
    reg flag1;
    reg flag2;
    reg flag3;

 
    always @(*) begin 
        PC_OUT <= PC_Reg;
        PC_Reg <= PC_IN;

        
        if (SetFlags) begin
            flag0 <= BRFlags[0];
            flag1 <= BRFlags[1];
            flag2 <= BRFlags[2];
            flag3 <= BRFlags[3];
        end
        if (wEnable == 1)begin
            case (DestReg)
                //000: PC_Reg <= WBDataIN;
                'b001: begin
                    Reg1 = WBDataIN;
                end    
                'b010: begin
                    Reg2 = WBDataIN;
                end
                'b011: begin
                    Reg3 = WBDataIN;
                end
                'b100: begin
                    Reg4 = WBDataIN;
                end
                'b101: begin
                    Reg5 = WBDataIN;
                end
                'b110: begin
                    Reg6 = WBDataIN;
                end
                'b111: begin
                    Reg7 = WBDataIN;
                end           
                default: 
                    PC_Reg = 'b0000000000000000;
            endcase
        end 
        case (OpReg1)
                //000: readRegA <= PC_Reg;
                'b001: begin 
                    readRegA <= Reg1;
                end    
                'b010: begin 
                    readRegA <= Reg2;
                end
                'b011: begin 
                    readRegA <= Reg3;
                end
                'b100: begin 
                    readRegA <= Reg4;
                end
                'b101: begin 
                    readRegA <= Reg5;
                end
                'b110: begin 
                    readRegA <= Reg6;
                end
                'b111: begin 
                    readRegA <= Reg7;
                end           
        endcase
        
        case (OpReg2)
           // 000: readRegB <= PC_Reg;
            'b001: begin 
                readRegB <= Reg1;
            end    
            'b010: begin 
                readRegB <= Reg2;
            end
            'b011: begin 
                readRegB <= Reg3;
            end
            'b100: begin 
                readRegB <= Reg4;
            end
            'b101: begin 
                readRegB <= Reg5;
            end
            'b110: begin 
                readRegB <= Reg6;
            end
            'b111: begin 
                readRegB <= Reg7;
            end           
        endcase 
        
    end
	 
	 
        

endmodule
    

