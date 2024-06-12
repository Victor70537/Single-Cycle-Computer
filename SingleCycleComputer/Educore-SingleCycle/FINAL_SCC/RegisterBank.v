module RegisterBank(

    //clock stuff
    input   clk,
	  input   clk_en,

    //control stuff
    input  wEnable,
    
    //reg select
    input [2:0]DestReg,
    input [2:0]OpReg1,
    input [2:0]OpReg2,
    input read_sp,
    //Data In
    //input  [31:0]writeBackData,     //from ALU
    input  [31:0]WBDataIN,  
    input [31:0]PC_IN,          //From Instruction decoder
    
    //Outputs to ALU
    output  [31:0]readRegA,
    output  [31:0]readRegB,
    output  [31:0]sourceRegister,
    output [31:0]PC_OUT
    

);

    reg [31:0] readRegA;
    reg [31:0] readRegB;
    reg [31:0] sourceRegister;
    wire [2:0] DestReg;
    wire [2:0] OpReg1;
    wire [2:0] OpReg2;

    //data
    reg [31:0] PC_OUT;
    reg [31:0] PC_Reg;
    reg [31:0] Reg0;
    reg [31:0] Reg1;
    reg [31:0] Reg2;
    reg [31:0] Reg3;
    reg [31:0] Reg4;
    reg [31:0] Reg5;
    reg [31:0] Reg6;
    reg [31:0] Reg7;
    
    always @(clk) begin  //On reset clear registers
        if(clk_en)begin
          Reg0 = 32'hxxxxxxxx;
          Reg1= 32'hxxxxxxxx;
          Reg2= 32'hxxxxxxxx;
          Reg3= 32'hxxxxxxxx;
          Reg4= 32'hxxxxxxxx;
          Reg5= 32'hxxxxxxxx;
          Reg6= 32'hxxxxxxxx;
          Reg7= 32'hxxxxxxxx;
    end
    end
    always @(*) begin //Sends next Program counter to IF
        PC_OUT = PC_IN;
    end
        always @(*) begin
        case (OpReg1)
                //000: readRegA <= PC_Reg;
                'b000: begin 
                readRegA = Reg0;
                end
                'b001: begin 
                    readRegA = Reg1;
                end    
                'b010: begin 
                    readRegA = Reg2;
                end
                'b011: begin 
                    readRegA = Reg3;
                end
                'b100: begin 
                    readRegA = Reg4;
                end
                'b101: begin 
                    readRegA = Reg5;
                end
                'b110: begin 
                    readRegA = Reg6;
                end
                'b111: begin 
                    readRegA = Reg7;
                end           
        endcase
        
        case (OpReg2)
           // 000: readRegB <= PC_Reg;
           'b000: begin 
                readRegB = Reg0;
                sourceRegister = Reg0;
           end
            'b001: begin 
                readRegB = Reg1;
                sourceRegister = Reg1;
            end    
            'b010: begin 
                readRegB = Reg2;
                sourceRegister = Reg2;
            end
            'b011: begin 
                readRegB = Reg3;
                sourceRegister = Reg3;
            end
            'b100: begin 
                readRegB = Reg4;
                sourceRegister = Reg4;
            end
            'b101: begin 
                readRegB = Reg5;
                sourceRegister = Reg5;
            end
            'b110: begin 
                readRegB = Reg6;
                sourceRegister = Reg6;
            end
            'b111: begin 
                readRegB = Reg7;
                sourceRegister = Reg7;
            end           
        endcase 
        
    end
    always @(posedge clk) begin
        if (wEnable == 1)begin
            case (DestReg)
                //000: PC_Reg <= WBDataIN;
                'b000: begin
                    Reg0 = WBDataIN;
                end  
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
    end

	 
	 
        

endmodule