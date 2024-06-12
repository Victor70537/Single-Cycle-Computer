module EXE
(
    input [31:0] a, b, // input
    input [3:0] ALUOp, // control
    input [1:0] ior,   // immediate or register
    input SET_FLAGS,   // update flags
    output reg [31:0] result, // output
    output reg [3:0] BR_FLAGS // 4 different flags
);

reg [31:0] b_mask = 32'h0000_0000;
reg carry; //value used for identifying when a carry or borrow was done
always @(*) 
begin
    if(BR_FLAGS === 4'bxxxx)begin
    BR_FLAGS = 4'b0000; // default 
    end
    case (ior)
        2'b01: // incoming is imm offset (16 bits)
            // default the top is padded with zeros
            case (ALUOp[2:0]) 
                3'b100: // a & b
                    b_mask = {16'hFFFF, b[15:0]}; // mask top half with 1's
                3'b101: // a ^ b
                    b_mask = {~a[31:15], b[15:0]}; // mask top half with the invert of reg a info
                default:
                    b_mask = b; // no change
            endcase
        default:
          b_mask = b;
    endcase

    case (ALUOp[3])
        1'b1:
            begin
                case(ALUOp[2:0]) // ALU
                    3'b010: 
                        {carry, result} = a + b; // add
                    3'b011: 
                        {carry, result} = {1'b1,a} - b; // sub
                    3'b100: 
                        result = a & b_mask; // and
                    3'b101:
                        result = a | b; // or
                    3'b110: 
                        result = a ^ b_mask; // xor
                    3'b111: 
                        result = ~a; // not
                    default:
                        result = result; 
                endcase
            end
        1'b0: 
            begin
                case(ALUOp[2:0]) // Special
                    3'b001: //mov
                      result = a;
                    3'b011: // set
                        result = 32'hFFFF_FFFF; // passes in whatever result that is being inputted
                    3'b010: // signed adding
                        if(b == 'h0) begin
                        result = a;
                        end
                        else begin
                        {carry, result} = a + b; // signed adding
                        end
                    3'b100: 
                        result = a << b; // left shift by imm
                    3'b101:
                        result = a >> b; // right shift by imm
                    3'b000:
                        result = 32'h0000_0000; // clear result 
                    default:
                        result = result; 
                endcase
            end
    endcase
    if (result[31] == 1'b1 && SET_FLAGS) begin // neg
        BR_FLAGS[3] = 1'b1; // n = 1 if first bit is one (2's complement)
        if((a[31] == 1'b0) && (b[31] == 1'b0) && ((ALUOp == 4'b1010)|| (ALUOp == 4'b0010)) ) begin
         BR_FLAGS[3] = 1'b0;
      end
    end 
    else if (result[31] == 1'b0 && SET_FLAGS) begin
      BR_FLAGS[3] = 1'b0; // n = 1 if first bit is one (2's complement)
      if((a[31] == 1'b1) && (b[31] == 1'b1) && ((ALUOp == 4'b1011) || (ALUOp == 4'b1010)|| (ALUOp == 4'b0010)) ) begin
         BR_FLAGS[3] = 1'b1;
      end
    end 
    if (result == 'h0 && SET_FLAGS) begin // zero
        BR_FLAGS[1] = 1'b1; // z = 1 if result is all zero
    end 
    else if (result != 'h0 && SET_FLAGS) begin // zero
        BR_FLAGS[1] = 1'b0; 
    end 
    if (carry == 1'b1 && SET_FLAGS) begin // carry
        BR_FLAGS[2] = 1'b1; // c = 1 if result has carry out
    end
    else if (carry != 1'b1 && SET_FLAGS) begin // carry
        BR_FLAGS[2] = 1'b0; 
    end
    if ( SET_FLAGS) begin // overflow
      if((( result >= 32'h7fffffff) || (result <32'h80000001)) && carry == 1'b1)begin
       BR_FLAGS[0] = 1'b1; // v = 1 if the msb in the result is changed but there is no carry out
      end
      else begin
        BR_FLAGS[0] = 1'b0; 
      end
    end 
    
end
endmodule