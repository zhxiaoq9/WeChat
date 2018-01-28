异步读写指针的比较一直是异步FIFO中需要重点关注的内容。在“[FIFO设计实例1](https://github.com/zhxiaoq9/WeChat/blob/master/ClassicalCircuitDesign_FIFO/FIFOExample1.md)”中采取的方案是将另一个时钟域的读写指针同步过来后进行比较。这是一种同步的比较方案，即读写指针的比较是在时钟有效沿。     
这篇文章中我们将介绍异步FIFO的第2个实例。此实例中指针的比较过程是异步的，即读写指针的比较与时钟无关，当有了比较结果后再将比较结果同步到对应时钟域。这种方案同步时只需要同步1比特的空满号到另一个时钟域即可，而不需要将整个读写指针同步到另一个时钟域，因此节省了很多寄存器的使用。     


### 1.FIFO设计方案    
![FIFO2结构](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/fifo2.PNG "FIFO2结构")         
我们先看一下本实例的FIFO的整体设计方案，再详细讲解指针比较及空满信号的产生。如上图所示，与实例1中的设计相比，主要有以下几个变化：   
**双端口RAM模块没有wfull输入信号：**      
没有wfull信号导致的结果是在写操作时我们需要添加相应的检测电路，一旦检测到wfull有效就要马上将FIFO写使能信号**winc**置为无效，否则就会发生错误。当然，在本实例中也可以将wfull信号作为双端口RAM的输入信号做与实例1一样的控制，只是这个实例中没有这样做而已。    
**空满信号产生模块产生的地址指针只有格雷码指针，没有二进制码指针：**     
本实例中格雷码的产生采用与实例1中相同的方式。唯一的区别在于实例1中的格雷码指针位宽比实际需要的位宽多1个比特。而本实例中的格雷码位宽就是实际上所需要的位宽。因此本实例中的格雷码可以直接用来对双端口RAM进行寻址（原因参考FIFO系列第一篇文章）。   
**实例1中的指针同步模块被异步比较模块代替：**     
可以看到异步比较模块是没有时钟的，并且此模块产生了**afull_n**和**aempty_n**两个信号。这两个信号用于辅助空满信号的产生。       

### 2.空满信号的产生      
本例中因为格雷码指针的位宽没有做1比特扩展，而FIFO空满的判断条件都是wptr==rptr。所以我们需要额外的信息区分两者相等时FIFO到底是空还是满。因此在异步比较模块生成了一个将空信号和一个将满信号，在两个指针相等时如果将空信号有效那么判断FIFO为空，如果将满信号有效那么判断FIFO为满。          
我们可以将格雷码指针按照最高两比特的变化分为4个部分。当写指针所在区域落后读指针1个部分时说明FIFO将满（因为写指针永远在读指针前面）。例如写指针在第1部分而读指针在第2部分，说明写指针已经写完一次FIFO又重新开始写了。同样地当读指针落后写指针1个部分时说明FIFO将空。读写指针的变化可参考下面两图。      
![将满](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/going_full.PNG "将满")       
写指针落后读指针一个部分（将满）             
![将空](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/going_empty.PNG "将空")       
读指针落后写指针一个部分（将空）        

根据读写指针的变化及将空/满的满足条件可以得到逻辑表达式为：
```Verilog
assign dirset_n = ~( (wptr[ASIZE-1]^rptr[ASIZE-2]) & ~(wptr[ASIZE-2]^rptr[ASIZE-1]) );
assign dirclr_n = ~( ( ~(wptr[ASIZE-1]^rptr[ASIZE-2]) & (wptr[ASIZE-2]^rptr[ASIZE-1]) ) | ~wrst_n );
```
将满时dirset_n=1'b0，将空时dirclr_n=1'b0。因为当复位时FIFO为空，所以dirclr_n逻辑表达式中含有wrst_n。将dirset_n和dirclr_n分别连接到寄存器的置位端和复位端，即可得到下面的电路。        
![将空将满产生电路](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/aempty_afull_generation.PNG "将空将满产生电路")    
当direction=1'b1时表示将满，direction=1'b0时表示将空。         

### 3.设计代码   
设计代码包含7个模块，分别为：                 
**rrst_sync.v：** 读操作异步复位信号的同步处理。       
**wrst_sync.v：** 写操作异步复位信号的同步处理。      
**fifo_mem.v:** 双端口RAM控制模块。      
**async_cmp.v:** 异步指针比较模块。     
**rptr_empty.v:** 读指针控制及读空信号产生模块。      
**wptr_full.v:** 写指针控制及写满信号产生模块。     
**fifo2.v:** 顶层模块，用于连接各个子模块。   

其中rrst_sync.v与wrst_sync.v模块和实例1中的相同，fifo_mem模块与实例1也并无太大区别，fifo2.v只是用于连接各个部分。因此这里重点讲解async_cmp.v，rptr_empty.v和wptr_full.v3个模块。       
![空满信号产生电路](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/asyn_cmp.PNG "空满信号产生电路")    上图为异步比较模块的详细框图及其产生空满信号的逻辑图。可以看到空满信号是由dirction信号和读写指针的比较结果一起确定的。下面我们通过分析FIFO工作中的一些关键操作状态分析空满信号的变化过程。          
**复位：** FIFO刚开始工作时进入复位状态，此时wptr==rptr且direction=1'b0，结果aempty_n=1'b0而afull_n=1'b1，这两个信号分别经过两级同步使得rempty=1'b1而wfull=1'b0。所以复位后空信号有效，满信号无效，符合FIFO工作逻辑。       
**FIFO开始写入少量数据：** FIFO开始写入数据后wptr和rptr不相等。在写时钟有效沿aempty_n=1'b1，由于rempty是在读时钟域产生的所以aempty_n的变化需要经过两级同步同步到读时钟域。同步后rempty=1'b0，表示FIFO不为空。同理wfull也为1'b0。符合FIFO工作逻辑。            
**FIFO继续写入数据直到写指针落后读指针一个部分（整个指针分为4部分）：** 此时读写指针不相等且direction=1'b1。         
**FIFO继续写入数据直到两指针又相等：**                此时由于direction=1'b1，所以在写时钟有效沿aempty_n=1'b1而afull_n=1'b0。由于wfull本就在写时钟域产生，因此不需要同步。此时的同步器只是起到延时作用，经过两个时钟周期后wfull=1'b1，表示FIFO已满。符合FIFO工作逻辑。              
**FIFO读出少量数据：**               FIFO满后再读出少量数据，此时在读时钟有效沿rptr发生变化导致读写指针不相等，因此aempty_n和afull_n都为1'b1。由于wfull是在写时钟域产生的，所以afull_n需要经过两级同步器同步到写时钟域，同步后wfull=1'b0，表示FIFO不为满。符合FIFO工作逻辑。     
**FIFO继续读出数据直到读指针落后写指针一个部分：**       
此时读写指针不相等且direction=1'b0。                          
**FIFO继续读出数据直到两指针又相等：**         
此时由于direction=1'b0，因此在读时钟有效沿aempty_n=1'b0而afull_n=1'b1。因为rempty本身就在读时钟域产生，因此不需要同步。此时同步器只起到延时作用，经过两个时钟周期后rempty=1'b1，表示FIFO已空。符合FIFO工作逻辑。          

忽略async_cmp.v模块的细节，将rptr_emtpy.v和wptr_full.v的细节添加进来，可以得到下图所示电路图，可以将其与上图互相比较以更好理解异步比较的过程。          
![空满信号产生电路1](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/asyn_cmp1.PNG "空满信号产生电路1") 

本实例源代码下载地址：https://github.com/zhxiaoq9/WeChat/tree/master/ClassicalCircuitDesign_FIFO/src/src2             

### 4.仿真测试       
本实例仿真测试代码与实例1一样，即复位后先写入16个数据，再读出16个数据，最后再写入3个数据。仿真结果如下图所示。        
![仿真结果](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_FIFO/images/fifo2_sim.PNG "仿真结果")      
由上图可看到复位后rempty有效，当开始写入数据后rempty无效，FIFO写满后(195ns)wfull有效。接着读FIFO则wfull又变为无效，当读空后(258ns)rempty有效。然后再次写入3个数据rempty无效。另外，由于MEM用格雷码做地址索引，所以对其进行读写时的顺序不是按照1,2,3这样的自然数顺序。但这并不会影响FIFO的正常功能。         

异步FIFO是数字电路中十分常见的部件。工程实践中一般都不需要我们设计完整的FIFO，而只要调用别人已经设计好的FIFO或IP核即可。但如果我们了解异步FIFO的设计原理与设计挑战，那么对FIFO的使用就会更加胸有成竹。           


**参考文章:**   
1. Clifford E. Cummings, Sunburst Design, Inc. "Simulation and Synthesis Techniques for Asynchronous FIFO Design"    
2. Clifford E. Cummings, Sunburst Design, Inc., Peter Alfke Xilinx, Inc. "Simulation and Synthesis Techniques for Asynchronous FIFO Design with Asynchronous Pointer Comparisons"
