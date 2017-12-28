
## FIFO简介
FIFO(first in first out)的中文名称叫先进先出队列，它就像一个管道一样，我们可以在其一端写入数据，而在另一端将数据读出。FIFO可以分为同步FIFO和异步FIFO两种。其区别是：
> 同步FIFO：数据写入时钟与读取时钟是同一个时钟  
> 异步FIFO：数据写入时钟与读取时钟不是同一个时钟

异步FIFO在电路设计中经常用作不同时钟域的数据传输，也是电路设计中的难点之一。本系列文章基于Clifford的两篇经典论文介绍异步FIFO的设计方法。

## 异步FIFO基本工作原理










![图片引用](C:/Users/zhxiaoq9/Desktop/fifo工作原理.PNG)
       










> **参考文献:**
> 1. Clifford E. Cummings, Sunburst Design, Inc. "Simulation and Synthesis Techniques for Asynchronous FIFO Design"
> 2. Clifford E. Cummings, Sunburst Design, Inc., Peter Alfke Xilinx, Inc. "Simulation and Synthesis Techniques for Asynchronous FIFO Design with Asynchronous Pointer Comparisons"