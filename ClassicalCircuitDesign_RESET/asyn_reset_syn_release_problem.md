[上篇文章](https://github.com/zhxiaoq9/WeChat/blob/master/ClassicalCircuitDesign_RESET/asyn_reset_syn_release.md)中我们讲了异步复位同步释放电路结构，下面我们将对此电路做进一步的介绍。    

**1.去除毛刺**   
由于异步复位同步释放电路仍然采用了异步复位，所以需要专门的去毛刺电路。这里介绍一种延迟与做或操作的方案。例子代码如下：   
```verilog
//glitch_free.v
//remove 5 clock cycle glitch
module GLITCH_FREE(
input            clk,
input            in_glitch,   //in put glitch signal
output           out_noglitch //output signal  without glitch
);


reg         in_d0;
reg         in_d1;
reg         in_d2;
reg         in_d3;
reg         in_d4;
reg         in_d5;

always @(posedge clk)
begin
	in_d0 <= in_glitch;
	in_d1 <= in_d0;
	in_d2 <= in_d1;
	in_d3 <= in_d2;
	in_d4 <= in_d3;
	in_d5 <= in_d4;
end

assign out_noglitch = in_glitch | in_d0 | in_d1 | in_d2 | in_d3 | in_d4 | in_d5;

endmodule
```
上面代码中，输入信号**in_glitch**经过了6级寄存器打拍，然后原输入与各寄存器输出做或操作，得到输出信号**out_noglitch**。此电路可以滤除小于等于5个时钟周期的毛刺。Vivado综合后的电路图如下图所示：   
![滤除毛刺](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_RESET/images/glitch_sch.PNG "滤除毛刺")     
当然，这个电路只能滤除5个时钟周期的毛刺，如果你需要滤除N个时钟周期的毛刺，那么你需要使用N+1个寄存器。   

下面的代码对上面的设计做了仿真，仿真代码中的时钟周期为10ns。在做的3次测试中分别将**in_glitch**置低了45ns,50ns和55ns。    
```verilog
//glitch_free_t.v
`timescale 1ns/1ns
module GLITCH_FREE_T;

reg       clk;
reg       in_glitch;
wire      out_noglitch;

int       delay = 0;

initial
begin
	clk = 1'b0;
	//reset 45ns
	unreset();
	in_glitch = 1'b0;
	#45;

	//reset 50ns
	unreset();
	in_glitch = 1'b0;
	#50;
	
	//reset 55ns
	unreset();
	in_glitch = 1'b0;
	#55;

	unreset();
	#10;
	$stop;
end

always #5 clk = ~clk;

task unreset();
	in_glitch = 1'b1;
	#10;
endtask

GLITCH_FREE GLITCH_FREE_T(
 .clk(clk),
 .in_glitch(in_glitch),
 .out_noglitch(out_noglitch)
);

endmodule

```
仿真后的波形图如下图所示：    
![滤除毛刺波形图](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_RESET/images/glitch_wave.PNG "滤除毛刺波形图")     
可以看到，在前两次测试中**out_noglitch**一直保持高电平状态。而当**in_glitch保持低电平时间=55ns>50ns的测试中，out_noglitch出现了5ns(175ns-180ns)的低电平状态。**在仿真时间180ns时**in_glitch**置高后**out_noglitch**也马上置高。说明当clk周期为10ns时，此电路很好地过滤掉了**in_glitch**小于50ns的毛刺。    

**2.复位撤离**     
复位撤离时间距离时钟有效沿太近时寄存器无法确定复位到底有没有撤离，这时输出就不知道应该保持复位状态还是要采样D端的值。虽然异步复位同步撤离方案采用了两级同步方案，但是这也会引入亚稳态的问题。那么，亚稳态一旦出现会对电路产生什么影响呢？     
用Vivado综合出的异步复位同步释放电路图为：  
![异步复位同步释放](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_RESET/images/asyn_reset_syn_release.PNG "异步复位同步释放")      
由于只有两个寄存器，所以可能出现4中情况：
1. rst_n_d1_reg出现亚稳态，rst_n_syn_reg正常；
2. rst_n_d1_reg正常，rst_n_syn_reg出现亚稳态；
3. rst_n_d1_reg出现亚稳态，rst_n_syn_reg出现亚稳态；     
4. rst_n_d1_reg正常，rst_n_syn_reg正常；

      
**第1种情况：**   
其时序图如下所示，rst_n在17ns左右撤离，第1个寄存器的复位信号rst_n_d1_reg在时钟上升沿附近撤离，而rst_n_syn_reg在时钟沿到来前已经撤离。   
![第1级亚稳态](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_RESET/images/level1_fault.PNG "第1级亚稳态")      
**20ns处：** 第1个寄存器输出端rst_n_d1_reg_Q出现亚稳态并持续一段时间(小于1个时钟周期)，然后稳定到0或1；第2个寄存器采样rst_n_d1_reg_Q的旧值1'b0，所以rst_n_syn_reg_Q仍然为1'b0。   
**30ns处：** 第1个寄存器采样D端高电平，输出端rst_n_d1_reg_Q变为1'b1。第2个寄存器采样rst_n_d1_reg_Q从亚稳态恢复后的值，所以rst_n_syn_reg_Q的值不能确定是0还是1。  
**40ns处：** 第1个寄存器采样D端高电平，输出端rst_n_d1_reg_Q变为1'b1。第2个寄存器采样rst_n_d1_reg_Q的旧值1'b1，所以rst_n_syn_reg_Q变为1'b1。    

我们看到，如果只有第1级寄存器出现亚稳态，那rst_n_syn_reg_Q本该在30ns处变为1'b1，现在却延迟到了40ns处才变为1'b1。这通常不会对系统功能造成影响，而只是使系统撤离复位状态延迟了1个时钟周期。   

**第2种情况：**   
其时序图如下所示，rst_n在15ns左右撤离，第1个寄存器的复位信号rst_n_d1_reg在时钟上升沿到来前已经撤离，而rst_n_syn_reg在时钟沿附近撤离。   
![第2级亚稳态](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_RESET/images/level2_fault.PNG "第2级亚稳态")      
**20ns处：** 第1个寄存器正常工作，输出端rst_n_d1_reg_Q变为1'b1。第2个寄存器出现亚稳态，可能继续保持复位或者输出端被赋予输入端的旧值。在保持复位的情况下，第2个寄存器的输出端继续保持1'b0，如信号rst_n_syn_reg_Q(reset value)所示，而如果输出端不是保持复位而是采样输入端的旧址，那么因为其输入端rst_n_d1_reg_Q的旧值为1'b0，所以其输出为1'b0，如信号rst_n_syn_reg_Q(D value)所示。所以尽管发生了亚稳态，但是第2级寄存器的输出却是确定的1'b0。   
**30ns处：** 两个寄存器都正常工作，电路正常工作。    

我们看到，如果只有第2级寄存器出现亚稳态，那此亚稳态不会造成任何影响。

**第3种情况：**   
其时序图如下所示，rst_n在17ns左右撤离,而两个寄存器的异步复位端都在时钟沿附近撤离，都发生了亚稳态。   
![都发生亚稳态](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_RESET/images/level1_level2_fault.PNG "都发生亚稳态")   
**20ns处：** 第1级寄存器输出rst_n_d1_reg_Q出现亚稳态，维持一段时间(小于1个时钟周期)后恢复到一个确定值1'b0或1'b1；第2级输出rst_n_syn_reg_Q出现亚稳态但其值却是确定的1'b0(原因见第2种情况分析)。     
**30ns处：** 第1级寄存器输出rst_n_d1_reg_Q采样D端口高电平变为1'b1；第2个寄存器输出口rst_n_syn_reg_Q采样rst_n_d1_reg_Q的旧值，因此不能确定是高电平还是低电平。  
**40ns处：** 第1个寄存器采样D端高电平，输出端rst_n_d1_reg_Q变为1'b1。第2个寄存器采样rst_n_d1_reg_Q的旧值1'b1，所以rst_n_syn_reg_Q变为1'b1。 

我们看到，如果2个寄存器都出现亚稳态，这种情况与只有第1个寄存器出现亚稳态的情况是一样的。

**第4种情况：**   
两个寄存器都正常工作，不用分析了。       

总结来看，在两个寄存器中，只有第1级寄存器出现亚稳态时可能会对复位撤离产生影响。而且此影响也只是将系统撤离复位的时间延迟了一个时钟周期。为什么说是可能产生影响呢？这是因为如果第1个寄存器亚稳态恢复后，只有在恢复的值为1'b0的情况下才有可能产生此影响，否则一点影响也没有。       
另外，上面分析中我们默认亚稳态持续的时间小于1个时钟周期。而真实的情况是亚稳态持续的时间是不可控的，一旦持续时间超过了1个时钟周期，那么使用两级寄存器的方法就失去了作用。不过此时我们可以使用3级或更多级的寄存器进行处理。


**3.复位网络**    
异步复位的最后一个问题就是具有很大的扇出。这导致不同寄存器可能在不同的时钟周期中退出复位状态，造成系统初始工作状态的不确定。详情可参考复位系列文章中的[第一篇文章](https://github.com/zhxiaoq9/WeChat/blob/master/ClassicalCircuitDesign_RESET/asyn_reset_syn_reset.md)。解决这个问题的方法就是采用多个复位模块，减轻各个复位网络的删除。如下图所示：  
![复位网络](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_RESET/images/rst_net.PNG "复位网络")  

**在设计中使用复位时常常是先将异步复位做去除毛刺处理，然后采用上面的复位网络传递到各个设计模块中。虽然看起来比较简单，但其背后还是有很多需要我们掌握的东西。**  
复位系列文章暂时就写到这里了，以后如果有必要再补充。

**参考文章:**    
[http://www.cnblogs.com/IClearner/p/6683100.html](http://www.cnblogs.com/IClearner/p/6683100.html)   
[https://www.cnblogs.com/linjie-swust/archive/2012/01/07/YWT.html](https://www.cnblogs.com/linjie-swust/archive/2012/01/07/YWT.html)