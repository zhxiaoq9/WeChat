[之前的文章](https://github.com/zhxiaoq9/WeChat/blob/master/ClassicalCircuitDesign_FIFO/FIFOIntroduction.md)中我们讲了异步FIFO的设计原理与设计要点，本篇文章将给出FIFO设计的第1个实例与代码。      

### 1.FIFO设计结构  
![FIFO1结构](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/fifo1.PNG "FIFO1结构")      
异步FIFO的整体结构如上图所示，其中包含了一个双端口RAM模块，两个指针控制和空满信号产生模块，两个指针同步模块。下面具体介绍每一个模块的连接关系与功能。     
**双端口RAM模块：**         
写时钟域信号有写地址raddr，写数据wdata，写使能wclken，并且当FIFO的写使能信号winc有效且FIFO未写满(wfull=1'b0)时wclken才有效。读时钟域信号有读地址raddr和读数据rdata，并且RAM模块没有读时钟，意味着只要raddr的值改变rdata就会立即变为对应地址处的数据。              
**指针控制模块：**             
指针的产生采用了[上篇文章](https://github.com/zhxiaoq9/WeChat/blob/master/ClassicalCircuitDesign_FIFO/FIFOIntroduction.md)中格雷码的第2种方案。所以读写指针有二进制码和格雷码两种。其中二进制码指针用于双端口RAM的读写，而格雷码指针主要用作同步。           
**空满信号产生模块：**    
空满信号的产生通常有两种方式，第一种是将同步后格雷码转换成二进制码与本时钟域的读写指针比较。这种情况下，如果两个指针的最高位不相等而其余所有位都相等那么判断FIFO为满，如果两个指针完全相等那么为空。但是这需要先将同步后的格雷码转换成二进制码。那么可不可以直接用同步后的格雷码做判断呢？答案是可以，但是不能再按照二进制码时的方法判断（注意地址指针的位宽比所需要的位宽多出1位）。       

![格雷码产生空满信号错误](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/full_empty_fault.PNG "格雷码产生空满信号错误")      如上图所示，一个深度为8的FIFO格雷码为4比特。假设先向FIFO中写入了7个数据（0-6地址单元）然后又将这7个数据读出，那么此时两个指针都指向第7个地址单元，对应的格雷码都是0_100。现在接着向FIFO中写入一个数据，写指针wptr变为1_100，而读指针仍为0_100，此时发现两个指针最高位不相等而其它所有位都相等，此时将会判断为满。但实际上此时FIFO中只有1个数据，所以发生了错误。认真观察上图中格雷码的变化我们可以发现，此时判断FIFO为满的条件应该为，两个指针的最高两位分别不相等，而剩下的部分全相等。具体就此例而言应该为：
```Verilog
assign wfull = (rptr[3] != wptr[3]) && (rptr[2] != wptr[2]) && (rptr[1:0] == wptr[1:0])；
```
或者也可以写为：   
```Verilog
assign wfull = (wptr == {~rptr[3:2], rptr[1:0]})；
```
**指针同步模块：**    
指针同步模块直接使用两级寄存器同步方法。

### 2.设计代码      
设计代码包含8个模块，分别为：   
**rrst_sync.v：** 读操作异步复位信号的同步处理。       
**wrst_sync.v：** 写操作异步复位信号的同步处理。      
**fifo_mem.v:** 双端口RAM控制模块。      
**sync_r2w.v:** 读指针同步到写时钟域。      
**sync_w2r.v:** 写指针同步到读时钟域。     
**rptr_empty.v:** 读指针控制及读空信号产生模块。      
**wptr_full.v:** 写指针控制及写满信号产生模块。     
**fifo1.v:** 顶层模块，用于连接各个子模块。  
     

下面给出各个模块的详细代码。

```Verilog
//rrst_sync.v
module RRST_SYNC(
input             rclk,         //read clock
input             rrst_n,       //async reset input
output   reg      sync_rrst_n   //sync reset output
);

reg        rst_d1;

always @(posedge rclk or negedge rrst_n)
	if(rrst_n == 1'b0)
		begin
  			rst_d1 <= 1'b0;
			sync_rrst_n <= 1'b0;
		end
	else
		begin
			rst_d1 <= 1'b1;
			sync_rrst_n <= rst_d1;
		end

endmodule
```


```Verilog
//wrst_sync.v
module WRST_SYNC(
input             wclk,         //write clock
input             wrst_n,       //async reset input
output   reg      sync_wrst_n   //sync reset output
);

reg        rst_d1;

always @(posedge wclk or negedge wrst_n)
	if(wrst_n == 1'b0)
		begin
  			rst_d1 <= 1'b0;
			sync_wrst_n <= 1'b0;
		end
	else
		begin
			rst_d1 <= 1'b1;
			sync_wrst_n <= rst_d1;
		end

endmodule
```


```Verilog
//fifo_mem.v
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
```


```Verilog
//sync_r2w.v
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
```


```Verilog
//sync_w2r.v
module SYNC_W2R #(parameter ASIZE = 4)
(
input                 rclk,               //read clock
input                 rrst_n,             //async read reset
input      [ASIZE:0]  wptr,               //write address from write clock region(gray code)
output reg [ASIZE:0]  wptr_sync           //the wptr synchronized to read clock
);

reg        [ASIZE:0]  wptr_d1;

always @(posedge rclk or negedge rrst_n)
	if(rrst_n == 1'b0)
		{wptr_sync, wptr_d1} <= 0;
    else
		{wptr_sync, wptr_d1} <= {wptr_d1, wptr};

endmodule
```


```Verilog
//rptr_empty.v
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

//almost empty generation, this design does not include this function

endmodule
```

```Verilog
//wptr_full.v
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

//almost full generation, this design does not include this function
endmodule
```

```Verilog
//fifo1.v
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

wire [ASIZE:0]      wptr;           //write address(gray code)
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

```
注意FIFO中有aempty和afull两个信号，分别表示FIFO将要空或将要满。实际设计中需要看具体情况设置产生条件。例如，可以认为当读写指针相差4个数时就将近满或空，也可以认为当FIFO中数据的个数超过FIFO容量的3/4时将近满，小于容量的1/4时接近空。本文的代码中只保留了这两个接口，但是没有给出具体的逻辑实现。    


### 3.仿真测试       
因为仿真测试不是本文的重点，而且要真正做好FIFO的仿真几乎是不可能的，所以只是简单地验证了一下FIFO的功能。本设计中的FIFO的宽度为8比特，深度为16。仿真代码中先向FIFO写入16个数据将FIFO写满；然后连续读16次将FIFO读空；最后再向FIFO中写入3个数据。仿真代码如下。
```Verilog
//fifo_tb.v
`timescale 1ns/1ns

module FIFO_TB;

reg            wclk;
reg            wrst_n;
reg            winc;
reg  [7:0]     wdata;   

reg            rclk;
reg            rrst_n;
reg            rinc;

wire           wfull;
wire           afull;
wire           rempty;
wire           aempty;
wire [7:0]     rdata; 



initial begin
init();
unreset();
//write 16 data
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();

//read 16 data
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();

//write 3 data
single_write();
single_write();
single_write();

#100;
end

/*
initial begin
init();
unreset();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
$stop;
end
*/

//100M write clock
always #5 wclk = ~wclk;
//250M read clock
always #2 rclk = ~rclk;

task init();
begin
	wclk = 1'b0;
	wrst_n = 1'b0;
	winc = 1'b0;
	wdata = 8'd0;

	rclk = 1'b0;
	rrst_n = 1'b0;
	rinc = 1'b0;
	#20;
end
endtask

task unreset();
begin
	wrst_n <= 1'b1;
	rrst_n <= 1'b1;
	#20;
end
endtask


task single_write();
begin
	winc <= 1'b1;
	wdata <= $random();
	@(posedge wclk);
	winc <= 1'b0;
end
endtask

task single_read();
begin
	rinc <= 1'b1;
	@(posedge rclk);
	rinc <= 1'b0;
end
endtask

task random_op();
begin
	winc <= $random();
	wdata <= $random();
	rinc <= $random();
	@(posedge rclk);
end
endtask

FIFO1  FIFO1(
 .wclk(wclk),
 .wrst_n(wrst_n),
 .winc(winc),
 .wdata(wdata),

 .rclk(rclk),
 .rrst_n(rrst_n),
 .rinc(rinc),

 .wfull(wfull),
 .afull(afull),

 .rempty(rempty),
 .aempty(aempty),
 .rdata(rdata)
);

endmodule
```
下图是连续写入16个数据后的波形图。在195ns时写入第16个数据后写指针重新指向第0个存储单元（参考waddr的值），此时下一个要写入的地址对应的格雷码wgnext=11000，同步后读指针格雷码为rptr_sync=00000，满条件成立wfull置位。        
![FIFO写满](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/write_full.PNG "FIFO写满")       

下图为写满后又连续读16个数据将FIFO读空的波形图。可以看到258ns在FIFO读空时读指针重新指向第0个地址（参考raddr的值），要读取地址对应的格雷码为rgnext=11000，同步后的写指针格雷码为wptr_sync=11000，空条件成立rempty置位。
![FIFO读空](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/read_empty.PNG "FIFO读空")        

下图为FIFO读空后又向FIFO中写入3个数据后的波形图（参考MEM前3个存储单元的变化），可以看到当写入一个数据后wptr_sync在270ns发生了变化，结果在下一个读时钟有效沿（274ns）处空条件不成立，rempty置低。
![FIFO再写入数据](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/read_again.PNG "FIFO再写入数据")     


上面给出的测试代码中随机测试的部分被注释掉了，有兴趣的话可以去掉注释跑一下随机测试。

源代码下载地址：https://github.com/zhxiaoq9/WeChat/tree/master/ClassicalCircuitDesign_FIFO/src/src1              


**参考文章:**   
1. Clifford E. Cummings, Sunburst Design, Inc. "Simulation and Synthesis Techniques for Asynchronous FIFO Design"    
2. Clifford E. Cummings, Sunburst Design, Inc., Peter Alfke Xilinx, Inc. "Simulation and Synthesis Techniques for Asynchronous FIFO Design with Asynchronous Pointer Comparisons"
