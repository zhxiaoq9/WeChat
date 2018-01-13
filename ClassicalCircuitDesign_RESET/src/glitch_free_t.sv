`timescale 1ns/1ns
module GLITCH_FREE_T;

reg       clk;
reg       in_glitch;
wire      out_noglitch;

int       delay = 0;

initial
begin
	clk = 1'b0;
	//reset 45ns
	unreset();
	in_glitch = 1'b0;
	#45;

	//reset 50ns
	unreset();
	in_glitch = 1'b0;
	#50;
	
	//reset 55ns
	unreset();
	in_glitch = 1'b0;
	#55;

	unreset();
	#10;
	$stop;
end

always #5 clk = ~clk;

task unreset();
	in_glitch = 1'b1;
	#10;
endtask




GLITCH_FREE GLITCH_FREE_T(
 .clk(clk),
 .in_glitch(in_glitch),
 .out_noglitch(out_noglitch)
);



endmodule

