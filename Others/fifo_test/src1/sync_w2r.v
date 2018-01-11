module SYNC_W2R #(parameter ASIZE = 4)
(
input                 rclk,               //read clock
input                 rrst_n,             //async read reset
input      [ASIZE:0]  wptr,               //write address from write clock region(gray code)
output reg [ASIZE:0]  wptr_sync           //the wptr synchronized to read clock
);

reg        [ASIZE:0]  wptr_d1;

always @(posedge rclk or negedge rrst_n)
	if(rrst_n == 1'b0)
		{wptr_sync, wptr_d1} <= 0;
    else
		{wptr_sync, wptr_d1} <= {wptr_d1, wptr};

endmodule
