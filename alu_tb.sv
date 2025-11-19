`timescale 1ns/1ps

module alu_tb;

    
    alu_if aluif();

    // DUT
    alu dut (
        .a(aluif.a),
        .b(aluif.b),
        .op(aluif.op),
        .y(aluif.y),
        .carry(aluif.carry)
    );

    // Expected output
    logic [4:0] expected;

    
    covergroup alu_cov @(posedge clk);     //Coverage block to check whether all values of a,b and op are tested
        coverpoint aluif.op {
            bins ops[] = {0,1,2,3};
        }
        coverpoint aluif.a;
        coverpoint aluif.b;
        cross aluif.op, aluif.a, aluif.b;
    endgroup

    alu_cov C1 = new();

    // Clock
    logic clk;
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        repeat (50) begin
            aluif.a = $urandom_range(0, 15);
            aluif.b = $urandom_range(0, 15);
            aluif.op = $urandom_range(0, 3);

            #1; 

            
            case(aluif.op)
                0: expected = aluif.a + aluif.b;
                1: expected = aluif.a - aluif.b;
                2: expected = {1'b0, aluif.a & aluif.b};
                3: expected = {1'b0, aluif.a | aluif.b};
            endcase

            
            if ({aluif.carry, aluif.y} !== expected)
                $display("ERROR: a=%0d b=%0d op=%0d -> DUT=%0d exp=%0d",
                    aluif.a, aluif.b, aluif.op,
                    {aluif.carry,aluif.y}, expected
                );

            C1.sample();
            #10;
        end

        $display("Simulation Completed.");
        $finish;
    end

endmodule
