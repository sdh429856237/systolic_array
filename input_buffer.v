// input buffer, ref: shifter_buffer
//10kb
module input_buffer(
    output reg  [511:0] Q,
    input  wire         CLK,
    input  wire         CEN,
    input  wire         WEN,
    input  wire [4:0]   A,
    input  wire         RESET,
    input  wire [511:0] D,
    input  wire         RETN
    );
integer i;
integer j;
parameter num = 32;
reg [511:0] mem [31:0];
always @(posedge CLK)
begin
    if(~RESET)begin
        for (i = 0; i < num; i = i + 1)
				mem[i] <= 512'b0;
	    Q <= 512'b0;
	end
    else if(~WEN & RETN) begin
        Q <= 512'd0;
        //mem[A] <= D;
        for (i = 0;i < 16;i = i + 1)begin
            for(j = 32 * i;j < 32 * i + 32;j = j + 1)begin
                mem[i + A][j] <= D[j];
            end
        end
    end else if(~CEN & RETN) begin
        Q <= mem[A];
    end else begin
        Q <= 512'd0;
    end
end

endmodule