module alu (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic [1:0] op,      // 00=ADD, 01=SUB, 10=AND, 11=OR
    output logic [3:0] y,
    output logic       carry
);

    always_comb begin
        case(op)
            2'b00: {carry, y} = a + b;
            2'b01: {carry, y} = a - b;
            2'b10: {carry, y} = {1'b0, a & b};
            2'b11: {carry, y} = {1'b0, a | b};
        endcase
    end

endmodule
