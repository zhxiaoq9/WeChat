`timescale 1ns/1ps

module ASYN_RESET_SYN_RELEASE_T;

reg              clk;
reg              rst_n;
wire             rst_n_syn;

always #5 clk = ~clk;

initial
	begin
		clk = 1'b0;
		rst_n = 1'b1;
		#2
		rst_n = 1'b0;
		#15
		rst_n = 1'b1;
		#25
		rst_n = 1'b0;
		#25
		$stop;
	end


ASYN_RESET_SYN_RELEASE   ASYN_RESET_SYN_RELEASE_T(
.clk(clk),
.rst_n(rst_n),
.rst_n_syn(rst_n_syn)
);

endmodule
