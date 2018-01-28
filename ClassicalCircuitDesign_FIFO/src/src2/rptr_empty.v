module RPTR_EMPTY #(parameter ASIZE = 4)
(
//input signals
input                   rclk,                //read clock
input                   rrst_n,              //read reset
input                   rinc,                //read enable

input                   aempty_n,            //almost empty
//output signals
output reg  [ASIZE-1:0] rptr,                //updated read address
output reg              rempty               //fifo empty
);

reg                     aempty_d1;            //delay one clock cycle for aempty_n

reg    [ASIZE-1:0]      rbin;                //binary address counter
wire   [ASIZE-1:0]      rbnext;              //binary next address
wire   [ASIZE-1:0]      rgnext;              //gray code next address

always @(posedge rclk or negedge rrst_n)
	if(rrst_n == 1'b0)
		begin
			rbin <= 0;
			rptr <= 0;
		end
	else
		begin
			rbin <= rbnext;
			rptr <= rgnext;
		end

assign rbnext = (rempty == 1'b0) ? (rbin + rinc) : rbin;   //update rbnext if not empty and read enable(rinc)
assign rgnext = (rbnext >> 1) ^ rbnext;                    //binary to gray code

always @(posedge rclk or negedge aempty_n)
	if(aempty_n == 1'b0)
		{rempty, aempty_d1} <= 2'b11;
    else
		{rempty, aempty_d1} <= {aempty_d1, ~aempty_n};

endmodule
