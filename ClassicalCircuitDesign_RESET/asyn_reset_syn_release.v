module ASYN_RESET_SYN_RELEASE(
input              clk,
input              rst_n,
output  reg        rst_n_syn
);

reg   rst_n_d1;
always @(posedge clk or negedge rst_n)
	if(rst_n == 1'b0)
		{rst_n_syn, rst_n_d1} <= 2'b00;
    else
		{rst_n_syn, rst_n_d1} <= {rst_n_d1, 1'b1};

endmodule
