[之前的文章](https://github.com/zhxiaoq9/WeChat/blob/master/ClassicalCircuitDesign_FIFO/FIFOIntroduction.md)中我们讲了异步FIFO的设计原理与设计要点，本篇文章将给出FIFO设计的第1个实例与代码。      

### 1.FIFO设计结构  
![FIFO1结构](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/fifo1.PNG "FIFO1结构")      
异步FIFO的整体结构如上图所示，其中包含了一个双端口RAM模块，两个指针控制和空满信号产生模块，两个指针同步模块。下面具体介绍每一个模块的连接关系与功能。     
**双端口RAM模块：**         
写时钟域信号有写地址raddr，写数据wdata，写使能wclken，并且当FIFO的写使能信号winc有效且FIFO未写满(wfull=1'b0)时wclken才有效。读时钟域信号有读地址raddr和读数据rdata，并且RAM模块没有读时钟，意味着只要raddr的值改变rdata就会立即变为对应地址处的数据。              
**指针控制模块：**             
指针的产生采用了[上篇文章](https://github.com/zhxiaoq9/WeChat/blob/master/ClassicalCircuitDesign_FIFO/FIFOIntroduction.md)中格雷码的第2种方案。所以读写指针都有二进制码和格雷码两种。其中二进制码指针用于双端口RAM的读写，而格雷码指针主要用作同步。           
**空满信号产生模块：**    
空满信号的产生通常有两种方式，第一种是将同步后格雷码转换成二进制码与本时钟域的读写指针比较。这种情况下，如果两个指针的最高位不相等而其余所有位都相等那么判断FIFO为满，如果两个指针完全相等那么为空。但是这需要先将同步后的格雷码转换成二进制码。那么可不可以直接用同步后的格雷码做判断呢？答案是可以，但是不能再按照二进制码时的方法判断（注意地址指针的位宽比所需要的位宽多出1位）。       

![格雷码产生空满信号错误](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/full_empty_fault.PNG "格雷码产生空满信号错误")      如上图所示，一个深度为8的FIFO格雷码为4比特。假设先向FIFO中写入了7个数据（0-6地址单元）然后又将这7个数据读出，那么此时两个指针都指向第7个地址单元，对应的格雷码都是0_100。现在接着向FIFO中写入一个数据，写指针wptr变为1_100，而读指针仍为0_100，此时发现两个指针最高位不想等而其它所有位都相等，此时将会判断为满。但实际上此时FIFO中只有1个数据。认真观察上图中格雷码的变化我们可以发现，此时判断FIFO为满的条件应该为，两个指针的最高两位分别不相等，而剩下的部分全相等。具体就此例而言应该为：
```Verilog
assign wfull = (rptr[3] != wptr[3]) && (rptr[2] != wptr[2]) && (rptr[1:0] == wptr[1:0])；
```
或者也可以写为：   
```Verilog
assign wfull = (wptr == {~rptr[3:2], rptr[1:0]})；
```
**指针同步模块：**    
指针同步模块直接使用两级寄存器同步方法。

### 2.设计及仿真测试代码      
设计代码包含9个模块，分别为：   
**rrst_sync.v：** 读操作异步复位信号的同步处理。       
**wrst_sync.v：** 写操作异步复位信号的同步处理。      
**fifo_mem.v:** 双端口RAM控制模块。      
**sync_r2w.v:** 读指针同步到写时钟域。      
**sync_w2r.v:** 写指针同步到读时钟域。     
**rptr_empty.v:** 读指针控制及读空信号产生模块。      
**wptr_full.v:** 写指针控制及写满信号产生模块。     
**fifo1.v:** 顶层模块，用于连接各个子模块。  
**fifo_tb.v:** 简单的仿真测试代码。     











### 3.仿真结果       

