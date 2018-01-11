module WPTR_FULL #(parameter ASIZE = 4)
(
input                         wclk,                         //write clock
input                         wrst_n,                       //asyn write reset
input                         winc,                         //write enable
input      [ASIZE:0]          rptr_sync,                    //read address synchronized to write clock region(gray code)

output reg [ASIZE:0]          wptr,                         //write address(gray code)
output     [ASIZE-1:0]        waddr,                        //write address(binary code)
output reg                    afull,                        //almost full
output reg                    wfull                         //fifo full
);

reg        [ASIZE:0]          wbin;                         //write address binary
wire       [ASIZE:0]          wbnext;                       //write address next
wire       [ASIZE:0]          wgnext;                       //write address next

wire                          isafull;
wire                          isfull;

//next address
assign wbnext = wbin + (winc & ~wfull);                     //increase binary address if write enable and fifo not full
assign wgnext = (wbnext>>1) ^ wbnext;
always @(posedge wclk or negedge wrst_n)
	if(wrst_n == 1'b0)
		{wbin, wptr} <= 0;
    else
		{wbin, wptr} <= {wbnext, wgnext};

assign waddr = wbin[ASIZE-1:0];

//full generation
assign isfull = (wgnext == {~rptr_sync[ASIZE:ASIZE-1], rptr_sync[ASIZE-2:0]});
always @(posedge wclk or negedge wrst_n)
	if(wrst_n == 1'b0)
		wfull <= 1'b0;
    else
		wfull <= isfull;

endmodule
