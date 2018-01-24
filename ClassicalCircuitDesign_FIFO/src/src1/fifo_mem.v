module FIFO_MEM #(parameter DSIZE = 8, parameter ASIZE = 4)
(
//input signals for write
input                  wclk,            //write clock
input                  wen,             //write enable
input  [ASIZE-1:0]     waddr,           //write address
input  [DSIZE-1:0]     wdata,           //write data
input                  wfull,           //write full

//input signals for read
input  [ASIZE-1:0]     raddr,           //read address
//output signals for read
output [DSIZE-1:0]     rdata            //read data
);

localparam DEPTH = 1<<ASIZE;            //fifo depth
reg [DSIZE-1:0] MEM [0:DEPTH-1];

assign rdata = MEM[raddr];

always @(posedge wclk)                  //write to fifo if write enable and fifo not full
	if((wen == 1'b1) && (wfull == 1'b0)) 
		MEM[waddr] <= wdata;
    else
		;
endmodule

