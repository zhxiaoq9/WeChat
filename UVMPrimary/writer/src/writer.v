module WRITER #(parameter DWIDTH = 10, parameter VWIDTH = 4)
(
 input                    clk,
 input                    rst_n,
 input                    clear,
 input                    start,
 input      [DWIDTH-1:0]  in,
 output reg [VWIDTH-1:0]  cnt,
 output reg [DWIDTH:0]    out
);

wire                   done;

always @(posedge clk or negedge rst_n)
	if(rst_n == 1'b0)
		cnt <= 0;
	else if(clear == 1'b1)
		cnt <= 0;
    else if(start == 1'b1)
		cnt <= cnt + 1'b1;
	else
		cnt <= cnt;

assign in_xor = ^in;
always @(posedge clk or negedge rst_n)
	if(rst_n == 1'b0)
		out <= 0;
	else if(clear == 1'b1)
		out <= 0;
	else if(start == 1'b1)
		out <= {in_xor, in};
	else
		out <= out;

endmodule






