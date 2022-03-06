module comp #(
    parameter BIN = 32'b0_01111101_00000000000000000000110)
    (
    input  wire [63:0] in_operand,
    output wire [31:0] out_operand 
);


    wire [31:0] tmp;
    wire        exception;

    Addition_Subtraction sub0(//////ºŸ…Ë «in_operandºıBIN
   	    .a_operand(in_operand),
   	    .b_operand(BIN),
   	    .AddBar_Sub(1'b1),
   	    .Exception(exception),
   	    .result(tmp)
    );
    assign out_operand = tmp[31] ? 32'b0_01111111_00000000000000000000000 : 32'b0;
    
endmodule