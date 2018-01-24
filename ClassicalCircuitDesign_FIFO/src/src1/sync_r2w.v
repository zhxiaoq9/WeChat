module SYNC_R2W #(parameter ASIZE = 4)
(
input                 wclk,               //write clock
input                 wrst_n,             //async write reset
input      [ASIZE:0]  rptr,               //read address from read clock region(gray code)
output reg [ASIZE:0]  rptr_sync           //the rptr synchronized to write clock
);

reg        [ASIZE:0]  rptr_d1;

always @(posedge wclk or negedge wrst_n)
	if(wrst_n == 1'b0)
		{rptr_sync, rptr_d1} <= 0;
    else
		{rptr_sync, rptr_d1} <= {rptr_d1, rptr};

endmodule
