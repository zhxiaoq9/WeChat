
//remove 5 clock cycle glitch
module GLITCH_FREE(
input            clk,
input            in_glitch,
output           out_noglitch
);


reg         in_d0;
reg         in_d1;
reg         in_d2;
reg         in_d3;
reg         in_d4;
reg         in_d5;

always @(posedge clk)
begin
	in_d0 <= in_glitch;
	in_d1 <= in_d0;
	in_d2 <= in_d1;
	in_d3 <= in_d2;
	in_d4 <= in_d3;
	in_d5 <= in_d4;
end

assign out_noglitch = in_glitch | in_d0 | in_d1 | in_d2 | in_d3 | in_d4 | in_d5;
                     
endmodule
