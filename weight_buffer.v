// weight buffer, ref: shared_buffer
// input buffer, ref: shared_buffer\
//10kb
module weight_buffer(
    output reg  [511:0] Q,
    input  wire         CLK,
    input  wire         CEN,
    input  wire         WEN,
    input  wire         OPSTAGE,//weight���ѡ���źţ�1��ʾ���������0��ʾ�������1/////
    input  wire [12:0]  A,

    input  wire [511:0] D,
    input  wire         RETN
    );

integer i;
reg [511:0] mem [15:0];
always @(posedge CLK)
begin
    if(~WEN & RETN) begin
        Q <= 512'd0;
        mem[A] <= D;
    end else if(~CEN & RETN) begin
        Q <= OPSTAGE ? mem[A] : {16{1'b0, 8'b01111111, 23'b0}};///////
    end else begin
        Q <= 512'd0;
    end
end

endmodule