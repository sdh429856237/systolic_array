module PE(
    input wire CLK,                         
    input wire RESET,                       
    input wire EN,//PEʹ���ź�                          
    input wire SELECTOR,//weightѡ���źţ�1Ϊд��weight��0Ϊʹ��weight���ڼ��� 
    input wire OPSEL,//����ģʽѡ���źţ�1ΪPEִ�������˷����㣬0ΪPEִ��L1��������                   
    input wire W_EN,//дweightʹ���ź�                        
    
    input wire [31:0]active_left,
    output reg [31:0]active_right,

    input wire [63:0]in_sum,
    output reg [63:0]out_sum,

    input wire [31:0]in_weight_above,
    output wire [31:0]out_weight_below
	);
	
    reg [31:0] weight_1; 
    reg [31:0] weight_2;
    
    //
    wire exception1, exception2, overflow, underflow;
    wire [31:0] weight_tmp, L1_operand, L1_result_tmp, L1_result;
    wire [63:0] mul_tmp, mul_result;
    //
    
    always @(negedge RESET or posedge CLK ) begin
        if(~RESET) begin
            out_sum <= 0;
            active_right <= 0; 
            weight_1 <= 0;
            weight_2 <= 0;
        end
        else begin
            if(EN) begin
                active_right <= active_left;              
                if(SELECTOR) begin                                       
                    //out_sum <= weight_2 * active_left + in_sum;//�ҰѸ���ӷ��͸���˷���ģ��ɾ���ˣ���*��+��︡��˺͸���ӵ���˼���������
                    out_sum <= (OPSEL) ? mul_result : {32'b0, L1_result};////
                    if(W_EN) begin
                        weight_1 <= in_weight_above;
                    end
                end  
                else begin
                    //out_sum <= weight_1 * active_left + in_sum;
                    out_sum <= (OPSEL) ? mul_result : {32'b0, L1_result};/////
                    if(W_EN) begin
                        weight_2 <= in_weight_above;    
                    end
                end             
            end
        end
    end
    /////
    assign weight_tmp = (SELECTOR) ? weight_2 : weight_1;
    Multiplication mul0(
   	    .a_operand(weight_tmp),
   	    .b_operand(active_left),
   	    .Exception(exception1),
   	    .Overflow(overflow),
   	    .Underflow(underflow),
   	    .result(mul_tmp)
    );
    Addition_Subtraction add0(///////������64bit�ļӷ�
   	    .a_operand(mul_tmp),
   	    .b_operand(in_sum),
   	    .AddBar_Sub(1'b0),
   	    .Exception(exception2),
   	    .result(mul_result)
    );
    
    Addition_Subtraction sub0(
   	    .a_operand(weight_tmp),
   	    .b_operand(active_left),
   	    .AddBar_Sub(1'b1),
   	    .Exception(exception2),
   	    .result(L1_operand)
    );
    assign L1_result_tmp = {1'b0, L1_operand[30:0]};
    Addition_Subtraction add1(
   	    .a_operand(L1_result_tmp),
   	    .b_operand(in_sum[31:0]),
   	    .AddBar_Sub(1'b0),
   	    .Exception(exception2),
   	    .result(L1_result)
    );
    /////
    assign out_weight_below = (SELECTOR) ? weight_1 : weight_2;
endmodule