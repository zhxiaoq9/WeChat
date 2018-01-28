module ASYNC_CMP #(parameter ASIZE = 4)
(
input                  wrst_n,               //write reset
input [ASIZE-1:0]      wptr,                 //write address
input [ASIZE-1:0]      rptr,                 //read address
output                 aempty_n,             //almost empty
output                 afull_n               //almost full
);

reg     direction;

wire    dirset_n = ~( (wptr[ASIZE-1]^rptr[ASIZE-2]) & ~(wptr[ASIZE-2]^rptr[ASIZE-1]) );
wire    dirclr_n = ~( ( ~(wptr[ASIZE-1]^rptr[ASIZE-2]) & (wptr[ASIZE-2]^rptr[ASIZE-1]) ) | ~wrst_n );

always @(negedge dirset_n or negedge dirclr_n)
		if(dirclr_n == 1'b0)
			direction <= 1'b0;                //going empty
	    else
			direction <= 1'b1;                //going full

assign  aempty_n = ~( (wptr == rptr) & (direction == 1'b0) );
assign  afull_n = ~( (wptr == rptr) & (direction == 1'b1) );

endmodule
