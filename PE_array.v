//num2: ÿ�е�PE�ĸ���,num1 :PE������
module PE_array#(parameter num1 = 16, parameter num2 = 16)
	(
	
    input  wire CLK,                         
    input  wire RESET,                       
    input  wire EN,                          
	input  wire SELECTOR,   
	input  wire OPSEL,                 
    input  wire W_EN,                        
	
	input  wire [num1 * 32 - 1:0] active_left,
	input  wire [num2 * 32 - 1:0] in_weight_above,
	output wire [num2 * 32 - 1:0] out_weight_final,
	
	output wire [num2 * 64 - 1:0] out_sum_final
	);

wire [num1 * 32 * num2 - 1:0] out_weight_below;
wire [num1 * 64 * num2 - 1:0] out_sum;

reg [num2 * 64 - 1:0] zero = 1024'd0;
//����PE��
genvar gi;
generate
    for(gi = 0; gi < num1; gi = gi + 1)   
    begin:label
		if(gi == 0)begin
			PE_row #(.num(num2))PE_row_unit(
    		.CLK(CLK),
    		.RESET(RESET),
    		.EN(EN),
			.SELECTOR(SELECTOR),
			.OPSEL(OPSEL),
			.W_EN(W_EN),
			.active_left(active_left[31:0]),
			.in_sum(zero),
			.out_sum(out_sum[num2 * 64 - 1:0]),
			.in_weight_above(in_weight_above),
			.out_weight_below(out_weight_below[num2 * 32 - 1:0])
    		);
		end
		else begin
			PE_row #(.num(num2))PE_row_unit(
    		.CLK(CLK),
    		.RESET(RESET),
    		.EN(EN),
			.SELECTOR(SELECTOR),
			.OPSEL(OPSEL),
			.W_EN(W_EN),
			.active_left(active_left[(gi + 1) * 32 - 1:gi * 32]),
			.in_sum(out_sum[num2 * 64 * gi - 1:num2 * 64 * (gi - 1)]),
			.out_sum(out_sum[num2 * 64 * (gi + 1) - 1:num2 * 64 * gi]),
			.in_weight_above(out_weight_below[num2 * 32 * gi-1:num2 * 32 * (gi - 1)]),
			.out_weight_below(out_weight_below[num2 * 32 * (gi + 1) - 1:num2 * 32 * gi])
    		);
		end
    	
	end
endgenerate


assign out_sum_final = out_sum[num1 * 64 * num2:(num1 - 1) * 64 * num2];
assign out_weight_final = out_weight_below[num1 * 32 * num2 - 1:(num1 - 1) * 32 * num2];
endmodule