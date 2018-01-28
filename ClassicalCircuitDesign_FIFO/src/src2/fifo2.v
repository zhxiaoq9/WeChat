module FIFO2 #(parameter DSIZE = 8,
              parameter ASIZE = 4)
(
//input signals for write
input               wclk,           //write clock
input               wrst_n,         //async write reset
input               winc,           //write enable
input  [DSIZE-1:0]  wdata,          //write data  
//input signals for read
input               rclk,           //read clock
input               rrst_n,         //async read reset
input               rinc,           //read enable
//output signals for write
output              wfull,          //write full
output              afull,          //write almost full
//output signals for read
output              rempty,         //read empty
output              aempty,         //read almost empty
output [DSIZE-1:0]  rdata           //read data
);

wire      sync_rrst_n;              //sync of asyn read reset signal
wire      sync_wrst_n;              //sync of asyn write reset signal

wire [ASIZE-1:0]    wptr;           //write address
wire [ASIZE-1:0]    rptr;           //read address


RRST_SYNC  RRST_SYNC_0(
 .rclk(rclk),
 .rrst_n(rrst_n),
 .sync_rrst_n(sync_rrst_n)
);

WRST_SYNC  WRST_SYNC_0(
 .wclk(wclk),
 .wrst_n(wrst_n),
 .sync_wrst_n(sync_wrst_n)
);

ASYNC_CMP #(ASIZE) ASYNC_CMP_0(
 .wrst_n(sync_wrst_n),
 .wptr(wptr),
 .rptr(rptr),
 .aempty_n(aempty),
 .afull_n(afull)
);

FIFO_MEM #(DSIZE, ASIZE) FIFO_MEM_0(
 .wclk(wclk),
 .wen(winc),
 .waddr(wptr),
 .wdata(wdata),
 .raddr(rptr),
 .rdata(rdata)
);

RPTR_EMPTY #(ASIZE) RPTR_EMPTY_0(
 .rclk(rclk),
 .rrst_n(sync_rrst_n),
 .rinc(rinc),
 .aempty_n(aempty),
 .rptr(rptr),
 .rempty(rempty)
);

WPTR_FULL #(ASIZE) WPTR_FULL_0(
 .wclk(wclk),
 .wrst_n(sync_wrst_n),
 .winc(winc),
 .afull_n(afull),
 .wptr(wptr),
 .wfull(wfull)
);

endmodule
