// output buffer, ref: shared_buffer
// input buffer, ref: shared_buffer\
//10kb
module output_buffer(
    output reg  [1023:0]  Q,
    input  wire          CLK,
    input  wire          CEN,
    input  wire          WEN,
    input  wire [12:0]   A,

    input  wire [1023:0] D,
    input  wire          RETN
    );
integer i;
integer j;
//reg [12:0] count;
reg [1023:0] mem [31:0];
always @(posedge CLK)
begin
    if(~WEN & RETN) begin
        Q <= 1024'd0;
        //mem[A] <= D;
        for (i=0;i < 16;i = i + 1)begin
            for(j = 64 * i;j < 64 * i + 64;j = j + 1)begin
                mem[A - i][j] <= D[j];
            end
        end
    end else if(~CEN & RETN) begin
        Q <= mem[A];
    end else begin
        Q <= 1024'd0;
    end
end

endmodule