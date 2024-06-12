module InstructionFetch(
          Clk,
          Reset,
          IF_NEXT_PC,
          BR_PC,
          BR_PC_COND,
          PSTATE_COND,
          PC_BR,
          PC,
          br_flags,
          PC_NEXT,
          PC_NEXT_ADDR);
    
    // br_flags: NCZV
    
    input Clk,Reset,IF_NEXT_PC, BR_PC, BR_PC_COND;
    input [3:0] PSTATE_COND, br_flags;
    input [31:0] PC_BR, PC;
    
    output reg [31:0] PC_NEXT, PC_NEXT_ADDR;
    
    always @(posedge Clk) begin 
        if(Reset) begin //On reset go back to beginning of program
          PC_NEXT = 32'h00000000;
          PC_NEXT_ADDR = 32'h00000000;
        end
        else if (BR_PC == 1'b1) begin //Absolute or immediate branching
            PC_NEXT <= PC_BR;
            PC_NEXT_ADDR <= PC_BR;
        end
        else if (BR_PC_COND == 1'b1) begin //Conditional branching
            
            case({PSTATE_COND})
                {4'b0000} : //Equal
                    begin
                    if(br_flags[1] == 1'b1)begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin
                      PC_NEXT <= PC + 4;
                      PC_NEXT_ADDR <= PC+4;
                      end
                    end
                {4'b0001} : //Not equal
                    begin
                    if(br_flags[1] == 1'b0)begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin
                      PC_NEXT <= PC + 4;
                      PC_NEXT_ADDR <= PC+4;
                      end
                    end
                {4'b0010} : //Unsigned higheer or same
                    begin
                    if(br_flags[2] == 1'b1)begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin
                      PC_NEXT <= PC + 4;
                      PC_NEXT_ADDR <= PC+4;
                      end
                    end
                {4'b0011} : //Unsigned lower
                    begin
                    if(br_flags[2] == 1'b0)begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin
                      PC_NEXT <= PC + 4;
                      PC_NEXT_ADDR <= PC+4;
                      end
                    end
                {4'b0100} : //Negative
                    begin
                    
                    if(br_flags[3] == 1'b1)begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin
                      PC_NEXT <= PC +4;
                      PC_NEXT_ADDR <= PC +4;
                      end
                    end
                {4'b0101} : //Positive or zero
                    begin
                    if(br_flags[3] == 1'b0)begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin
                      PC_NEXT <= PC + 4;
                      PC_NEXT_ADDR <= PC+4;
                      end
                    end
                {4'b0110} : //Overflow set
                    begin
                    if(br_flags[0] == 1'b1)begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin
                      PC_NEXT <= PC + 4;
                      PC_NEXT_ADDR <= PC+4;
                      end
                    end
                {4'b0111} : //Overflow clear
                    begin
                    if(br_flags[0] == 1'b0)begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin
                      PC_NEXT <= PC + 4;
                      PC_NEXT_ADDR <= PC+4;
                      end
                    end
                {4'b1000} : //Unsigned higher
                    begin
                    if((br_flags[2] == 1'b1) && (br_flags[1] == 1'b0))begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin
                      PC_NEXT <= PC + 4;
                      PC_NEXT_ADDR <= PC+4;
                      end
                    end
                {4'b1001} : //Unsigned Lower or same
                    begin
                    if((br_flags[2] == 1'b0) || (br_flags[1]!=1'b1))begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin
                      PC_NEXT <= PC + 4;
                      PC_NEXT_ADDR <= PC+4;
                      end
                    end
                {4'b1010} : //Signed greater than or equal
                    begin
                    if(br_flags[3] == br_flags[0])begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin 
                      PC_NEXT <= PC + 4;
                      PC_NEXT_ADDR <= PC+4;
                      end
                    end
                {4'b1011} : //Signed less than
                    begin
                    if(br_flags[3] != br_flags[0])begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin
                      PC_NEXT <= PC + 4;
                      PC_NEXT_ADDR <= PC+4;
                      end
                    end

                {4'b1100} : //Signed greater 
                    begin
                    if(((br_flags[1] == 0) && (br_flags[3]==br_flags[0])))begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin
                      PC_NEXT <= PC + 4;
                      PC_NEXT_ADDR <= PC+4;
                      end
                    end

                {4'b1101} : //Signed less than or equal
                    begin
                    if(!(br_flags[1] == 0 && br_flags[3]==br_flags[0]))begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                        end
                    else begin
                      PC_NEXT <= PC + 4;
                      PC_NEXT_ADDR <= PC+4;
                      end
                    end                      
                {4'b1110} : //always branch
                    begin
                        PC_NEXT <= PC_BR;
                        PC_NEXT_ADDR <= PC_BR;
                    end
                {4'b1111} : //never branch
                    begin
                        PC_NEXT <= PC+4;
                        PC_NEXT_ADDR <= PC+4;
                    end
                default :
                    begin
                        PC_NEXT <= PC+4;
                        PC_NEXT_ADDR <= PC+4;
                    end
            endcase
            
        end
                else if (IF_NEXT_PC) begin
            PC_NEXT = PC + 4;
            PC_NEXT_ADDR = PC + 4;
        end
    end
    

endmodule