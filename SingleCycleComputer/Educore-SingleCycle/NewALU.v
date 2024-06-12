module NewALU
(
    input [31:0] a, b, // input
    input [3:0] ALUOp, // control
    input ior, // immediate or register
    output reg carry, // carry
    output reg [31:0] result, // output
    output reg [3:0] nzcv // 4 different flags
);

reg [31:0] b_mask = 32'h0000_0000;

always @(*) 
begin
    
    nzcv = 4'b0000; // default 

    case (ior)
        1'b1: // incoming is imm offset (16 bits)
            // default the top is padded with zeros
            case (ALUOp[2:0]) 
                3'b011: // a & b
                    b_mask = {16'hFFFF, b[15:0]}; // mask top half with 1's
                3'b101: // a ^ b
                    b_mask = {~a[31:15], b[15:0]}; // mask top half with the invert of reg a info
                default:
                    b_mask = b; // no change
            endcase
    endcase

    case (ALUOp[3])
        1'b1:
            begin
                case(ALUOp[2:0]) // ALU
                    3'b001: 
                        {carry, result} = a + b; // add
                    3'b010: 
                        result = a - b; // sub
                    3'b011: 
                        result = a & b_mask; // and
                    3'b100: 
                        result = a | b; // or
                    3'b101: 
                        result = a ^ b_mask; // xor
                    3'b110: 
                        result = ~result; // not
                    default:
                        result = result; 
                endcase
            end
        1'b0:
            begin
                case(ALUOp[2:0]) // Special
                    3'b000: // pass
                        result = b; // passes in whatever result that is being inputted
                    3'b111: // signed adding
                        {carry, result} = a + b; // signed adding
                    3'b100: 
                        result = result << b; // left shift by imm
                    3'b101:
                        result = result >> b; // right shift by imm
                    3'b010:
                        result = 32'h0000_0000; // clear result 
                    default:
                        result = result; 
                endcase
            end
    endcase

    if (result[31] == 1'b1) begin // neg
        nzcv[3] = 1'b1; // n = 1 if first bit is one (2's complement)
    end 

    if (result == 32'b0) begin // zero
        nzcv[2] = 1'b1; // z = 1 if result is all zero
    end 

    if ({carry, result[31]} == 2'b01) begin // overflow
        nzcv[0] = 1'b1; // v = 1 if the msb in the result is changed but there is no carry out
    end 

end
endmodule