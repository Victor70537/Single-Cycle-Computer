module IF(IF_NEXT_PC,
          BR_PC,
          BR_PC_COND,
          PSTATE_COND,
          PC_BR,
          PC,
          br_flags,
          PC_NEXT,
          PC_NEXT_ADDR);
    
    // br_flags: NCZV
    
    input IF_NEXT_PC, BR_PC, BR_PC_COND;
    input [3:0] PSTATE_COND, br_flags;
    input [31:0] PC_BR, PC;
    
    output reg [31:0] PC_NEXT, PC_NEXT_ADDR;
    
    always @(*) begin
        if (BR_PC == 1'b1) begin
            PC_NEXT = PC_BR + 4;
            PC_NEXT_ADDR = PC_BR;
        end
        else if (BR_PC_COND == 1'b1) begin
            
            case({PSTATE_COND, br_flags})
                {4'b0000, 4'b0010} : 
                    begin
                        PC_NEXT = PC_BR + 4;
                        PC_NEXT_ADDR = PC_BR;
                    end
                {4'b0001, 4'b0000} :
                    begin
                        PC_NEXT = PC_BR + 4;
                        PC_NEXT_ADDR = PC_BR;
                    end
                {4'b0010, 4'b0100} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b0011, 4'b0000} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b0100, 4'b1000} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b0101, 4'b0000} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b0110, 4'b0001} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b0111, 4'b0000} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1000, 4'b0100} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1001, 4'b0010} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1001, 4'b0110} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1010, 4'b1001} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1010, 4'b0000} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1011, 4'b0001} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1011, 4'b1000} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1100, 4'b1001} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1100, 4'b0000} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1101, 4'b0010} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1101, 4'b0011} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1101, 4'b1010} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1101, 4'b1011} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1101, 4'b0010} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1101, 4'b0001} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1101, 4'b1000} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1110} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1111} :
                    begin
                        PC_NEXT <= PC_BR + 4;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                default :
                    begin
                        PC_NEXT <= PC + 4;
                        PC_NEXT_ADDR <= PC;
                    end
            endcase
            
        end
        else if (IF_NEXT_PC == 1'b1) begin
            PC_NEXT <= PC + 4;
            PC_NEXT_ADDR <= PC + 4;
        end
        
    end
    

endmodule