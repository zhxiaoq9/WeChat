module RPTR_EMPTY #(parameter ASIZE = 4)
(
input                        rclk,                   //read clock
input                        rrst_n,                 //async read reset
input                        rinc,                   //read enable
input       [ASIZE:0]        wptr_sync,              //write address synchronized to read clock region(gray code)

output reg  [ASIZE:0]        rptr,                   //read address(gray code)
output      [ASIZE-1:0]      raddr,                  //read address(binary code)
output reg                   aempty,                 //almost empty
output reg                   rempty                  //fifo empty
);

reg         [ASIZE:0]        rbin;                   //read binary address
wire        [ASIZE:0]        rbnext;                 //next read address binary
wire        [ASIZE:0]        rgnext;                 //next read address gray code

wire                         isaempty;
wire                         isempty; 

//next address
assign rbnext = rbin + (rinc & ~rempty);             //increase binary address if read enable and fifo not empty
assign rgnext = (rbnext>>1) ^ rbnext;
always @(posedge rclk or negedge rrst_n)
	if(rrst_n == 1'b0)
		{rbin, rptr} <= 0;
    else
		{rbin, rptr} <= {rbnext, rgnext};

assign raddr = rbin[ASIZE-1:0];


//empty generation
assign isempty = (wptr_sync == rgnext);
always @(posedge rclk or negedge rrst_n)
	if(rrst_n == 1'b0)
		rempty <= 1'b1;                              //fifo is empty when reset
    else
		rempty <= isempty;

//almost empty generation



endmodule
