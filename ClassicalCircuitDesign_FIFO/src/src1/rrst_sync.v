module RRST_SYNC(
input             rclk,         //read clock
input             rrst_n,       //async reset input
output   reg      sync_rrst_n   //sync reset output
);

reg        rst_d1;

always @(posedge rclk or negedge rrst_n)
	if(rrst_n == 1'b0)
		begin
  			rst_d1 <= 1'b0;
			sync_rrst_n <= 1'b0;
		end
	else
		begin
			rst_d1 <= 1'b1;
			sync_rrst_n <= rst_d1;
		end

endmodule
