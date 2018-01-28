module WPTR_FULL #(parameter ASIZE = 4)
(
input                          wclk,             //write clock
input                          wrst_n,           //write reset
input                          winc,             //write enable
input                          afull_n,          //almost full

output  reg    [ASIZE-1:0]     wptr,             //updated write address
output  reg                    wfull             //fifo full
);

reg                            afull_d1;         //delay one clock cycle for almost full

reg            [ASIZE-1:0]     wbin;             //binary address
wire           [ASIZE-1:0]     wbnext;           //next binary address
wire           [ASIZE-1:0]     wgnext;           //next gray code address

always @(posedge wclk or negedge wrst_n)
	if(wrst_n == 1'b0)
		begin
			wbin <= 0;
			wptr <= 0;
		end
	else
		begin
			wbin <= wbnext;
			wptr <= wgnext;
		end

assign wbnext = (wfull == 1'b0) ? (wbin + winc) : wbin; //update write address if fifo not full and write enable
assign wgnext = (wbnext>>1) ^ wbnext;                   //binary to gray code

always @(posedge wclk or negedge wrst_n or negedge afull_n)
	if(wrst_n == 1'b0)
		{wfull, afull_d1} <= 2'b00;
    else if(afull_n == 1'b0)
		{wfull, afull_d1} <= 2'b11;
    else
		{wfull, afull_d1} <= {afull_d1, ~afull_n};

endmodule
