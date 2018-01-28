module FIFO_MEM #(parameter DSIZE = 8,
                  parameter ASIZE = 4)
(
//input signals for write
input                  wclk,            //write clock
input                  wen,             //write enable
input  [ASIZE-1:0]     waddr,           //write address
input  [DSIZE-1:0]     wdata,           //write data
//input signals for read
input  [ASIZE-1:0]     raddr,           //read address
//output signals for read
output [DSIZE-1:0]     rdata            //read data
);

parameter DEPTH = 1<<ASIZE;             //fifo depth

`ifdef VENDORRAM
//instantiation of vendor's dual-port RAM

`else
reg [DSIZE-1:0] MEM [0:DEPTH-1];

assign rdata = MEM[raddr];

always @(posedge wclk)
	if(wen)
		MEM[waddr] <= wdata;
    else
		;
`endif

endmodule

