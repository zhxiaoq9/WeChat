module ASYN_RESET(
input         clk,
input         rst_n,
input         in,
output reg    out
);

always @(posedge clk or negedge rst_n)
	if(rst_n == 1'b0)
		out <= 1'b0;
    else
		out <= in;

endmodule
