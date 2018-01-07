[上篇文章](https://github.com/zhxiaoq9/WeChat/blob/master/ClassicalCircuitDesign_RESET/asyn_reset_syn_reset.md)讲解了同步复位与异步复位的优缺点。而异步复位同步释放电路可以结合两者优点，避免两者缺点。实际电路中也往往采用的是这种方案。

**1. Verilog代码**  
异步复位同步释放的Verilog代码如下：  
```Verilog
//asyn_reset_syn_release.v
module ASYN_RESET_SYN_RELEASE(
input              clk,
input              rst_n,
output  reg        rst_n_syn
);

reg   rst_n_d1;
always @(posedge clk or negedge rst_n)
	if(rst_n == 1'b0)
		{rst_n_syn, rst_n_d1} <= 2'b00;
    else
		{rst_n_syn, rst_n_d1} <= {rst_n_d1, 1'b1};

endmodule
```
用Vivado综合出的电路图为：  
![异步复位同步释放](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_RESET/images/asyn_reset_syn_release.PNG "异步复位同步释放")  
从代码和综合出的电路我们可以看到，当复位信号**rst_n**变为1'b0时，输出端**rst_n_syn**也马上变为1'b0(因为**rst_n**连接到了寄存器的异步清零端)。但是当**rst_n**变为1'b1时，**rst_n_syn**必须等待两个时钟有效沿后才能变为1'b1。因为**rst_n_syn**必须等待时钟有效沿将寄存器**rst_n_d1_reg**输入端(D)的高电平送到寄存器**rst_n_syn_reg**的输出端(Q)。实际上，当**rst_n**变为1'b1后，两个寄存器组成了一个同步器，此同步器在**clk**的作用下将高电平赋值给**rst_n_syn**。   
使用**rst_n_syn**时，只需将**rst_n_syn**输入到其他寄存器的异步复位端口即可。

**2.代码仿真**  
用下面的仿真代码可对上面的设计进行仿真：  
```Verilog
//asyn_reset_syn_release_t.v
`timescale 1ns/1ps

module ASYN_RESET_SYN_RELEASE_T;

reg              clk;
reg              rst_n;
wire             rst_n_syn;

always #5 clk = ~clk;

initial
	begin
		clk = 1'b0;
		rst_n = 1'b1;
		#2
		rst_n = 1'b0;
		#15
		rst_n = 1'b1;
		#25
		rst_n = 1'b0;
		#25
		$stop;
	end


ASYN_RESET_SYN_RELEASE   ASYN_RESET_SYN_RELEASE_T(
.clk(clk),
.rst_n(rst_n),
.rst_n_syn(rst_n_syn)
);

endmodule
```
仿真波形图如下图所示：   
![异步复位同步释放仿真](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_RESET/images/asyn_reset_syn_release_t.PNG "异步复位同步释放仿真")     
可以看到，在仿真时间为2ns和42ns时，**rst_n**置为1'b0时**rst_n_syn**也马上置为1'b0。而在第17ns时**rst_n**由1'b0变为1'b1，但是**rst_n_syn**却是在**rst_n**变为1'b1后的第2个时钟有效沿(35ns)处变为1'b1。验证了异步复位，同步释放的合理性。

**3.优缺点**  
经过上一篇文章的分析，我们知道，对于**同步复位**来讲，其主要缺点是：
* 复位消耗额外的组合逻辑并且可能导致时序问题。  
* 对某些特殊的电路，如三态总线，不能实现及时复位。  

异步复位，同步释放电路，通过使用异步复位策略避免了这两个问题。

而对于**异步复位**来讲，其主要缺点是：
* 需要专门的去毛刺电路。
* 复位撤离问题：撤离复位发生在时钟有效沿附近时寄存器输出可能不稳定。
* 复位网络问题：由于异步复位具有很大的扇出与负载，导致撤离复位时，复位撤离信号不能在同一时钟周期内到达所有寄存器，导致不同寄存器在不同的时钟有效沿退出复位状态。

下一篇文章详细介绍异步复位同步释放电路如何避免这些问题。



