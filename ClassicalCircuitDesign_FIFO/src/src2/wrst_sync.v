module WRST_SYNC(
input             wclk,         //write clock
input             wrst_n,       //async reset input
output   reg      sync_wrst_n   //sync reset output
);

reg        rst_d1;

always @(posedge wclk or negedge wrst_n)
	if(wrst_n == 1'b0)
		begin
  			rst_d1 <= 1'b0;
			sync_wrst_n <= 1'b0;
		end
	else
		begin
			rst_d1 <= 1'b1;
			sync_wrst_n <= rst_d1;
		end

endmodule
