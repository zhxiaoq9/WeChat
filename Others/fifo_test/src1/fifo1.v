module FIFO1 #(parameter DSIZE = 8,
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

wire [ASIZE:0]      wptr;          //write address(gray code)
wire [ASIZE:0]      rptr;           //read address(gray code)
wire [ASIZE:0]      wptr_sync;      //write address(gray code)
wire [ASIZE:0]      rptr_sync;      //read address(gray code)
wire [ASIZE-1:0]    waddr;          //write address(binary code)
wire [ASIZE-1:0]    raddr;          //read address(binary code)


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


FIFO_MEM #(DSIZE, ASIZE) FIFO_MEM_0(
 .wclk(wclk),
 .wen(winc),
 .waddr(waddr),
 .wdata(wdata),
 .wfull(wfull),
 .raddr(raddr),
 .rdata(rdata)
);

SYNC_R2W #(ASIZE) SYNC_R2W_0(
 .wclk(wclk),
 .wrst_n(sync_wrst_n),
 .rptr(rptr),
 .rptr_sync(rptr_sync)
);

SYNC_W2R #(ASIZE) SYNC_W2R_0(
 .rclk(rclk),
 .rrst_n(sync_rrst_n),
 .wptr(wptr),
 .wptr_sync(wptr_sync)
);

WPTR_FULL #(ASIZE) WPTR_FULL_0(
 .wclk(wclk),
 .wrst_n(sync_wrst_n),
 .winc(winc),
 .rptr_sync(rptr_sync),
 .wptr(wptr),
 .waddr(waddr),
 .afull(afull),
 .wfull(wfull)
);

RPTR_EMPTY #(ASIZE) RPTR_EMPTY(
 .rclk(rclk),
 .rrst_n(sync_rrst_n),
 .rinc(rinc),
 .wptr_sync(wptr_sync),
 .rptr(rptr),
 .raddr(raddr),
 .aempty(aempty),
 .rempty(rempty)
);

endmodule
