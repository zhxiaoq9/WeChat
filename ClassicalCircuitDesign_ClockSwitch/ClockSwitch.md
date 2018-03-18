时钟切换是在设计中常见功能之一。但由于选择信号和两个时钟通常不在一个时钟域会导致毛刺的出现。在eetop网站上用户“usb_geek”共享过一篇无毛刺时钟切换电路相关的说明文档。虽然这篇文档对无毛刺时钟切换电路做了介绍，但还是不够浅显。本篇文章在这篇共享的说明文档的基础上对此电路做更详细的说明。     

**1. 不考虑毛刺的钟切换电路**  
不考虑毛刺的时钟切换电路如下图所示，其中sel是选择信号，clk0和clk1为异步时钟，通常情况下sel和clk0/clk1也是异步的。其实这就是一个2选1的多路选择器。这种情况下clk_out很容易产生毛刺。        
![不考虑毛刺的时钟切换](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_ClockSwitch/images/basic_switch.PNG "不考虑毛刺的时钟切换")  

**2. 将选择信号分为两路**     
既然毛刺的出现主要是因为选择信号sel和时钟的异步导致。那么最直接的解决方法就是将sel分别同步到clk0和clk1两个时钟域。这时必须将sel分为两路信号，因为同一时刻clk0和clk1只能选择一个，所以我们使用反相器即可，如下图所示。  
![part0](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_ClockSwitch/images/part0.PNG "选择信号分为两路")       
由于产生的两路选择信号同一时刻必然有一个为0一个为1，因此可以使用2个and门和1个or门将时钟选择出来（当然也可以使用2个or门和1个and门），如下图所示。     
![part1](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_ClockSwitch/images/part1.PNG "part1")       
接下来只要将sel-/sel+分别和G0/G1连接到一起即可。     
![选择信号分为两路](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_ClockSwitch/images/advance_switch.PNG "选择信号分为两路")    
上面电路中，当sel=0时选择clk0输出，当sel=1时选择clk1输出，与原来的电路选择功能相同。         
**3. 保证时钟切换的顺序**      
时钟切换是需要时间的，在时钟切换的过程中可能会发生两个时钟同时有效的情况，这必然也会导致毛刺的出现。所以在进行时钟切换的过程中必须保证先关断一个时钟再开启另一个时钟。而在文章第2部分中讲的电路并不能保证这一点。例如当sel由0变为1时，理想的切换方式是clk0对应的与门先无效然后再选通clk1对应的与门。但现实情况却是G1马上变为1，而由于sel到G0间有一个反相器延时，因此在这一延时时间内G0仍然保持为1不变。在这个反相器延时时间内clk0和clk1都是有效的。     
为了保证时钟切换时的时钟关断与开启顺序，我们在对sel分为两路后引入反馈电路，由电路part0得到了下面part0_a电路。       
![part0_a](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_ClockSwitch/images/part0_a.PNG "part0_a")     
对part0_a电路而言，当sel=0时sel+=0而sel-=1；当当sel=1时sel+=1而sel-=0。假设sel+与G0连接，sel-与G1连接，此时sel=0时选择clk1，sel=1时选择clk0。下面重点分析在sel变化的过程中sel+和sel-是如何变化的。    

**sel由0->1**：sel=0时sel-=1，而当sel变化后，**在sel-没有变成0的情况下sel+会一直维持在状态0**。只有当sel-变为0时sel+才会变为1。所以此时必然是sel-先由1变为0，之后sel+才由0变为1。再进一步说就是当sel由0->1时，电路会先将clk1关断再打开clk0。       
**sel由1->0**：sel=1时sel+=1，而当sel变化后，**在sel+没有变成0的情况下sel-会一直维持在状态0**。只有当sel+变为0时sel-才会变为1。所以此时必然是sel+先由1变为0，之后sel-才由0变为1。再进一步说就是当sel由0->1时，电路会先将clk0关断再打开clk1。      

由上面分析可知，加入反馈电路后，在sel变化的时候保证了电路都会先关闭之前的时钟再打开要选择的时钟，保证了合理的切换顺序。        

当然，我们也可以使用两个与门组成的反馈电路，如图part0_b所示。对于此电路，当sel=0时sel+=0而sel-=1；当sel=1时sel+=1而sel-=0。若sel由0->1则sel+先由0变1后sel-才由1变0。而sel由1->0则sel-先由0变1后sel+才由1变0。与part0_a对比可以发现，part0_a是先有一个信号由1->0另一个才由0->1，即先关断再打开。而part0_b是先有一个信号由0->1另一个才由1->0，即先打开再关断。很明显先打开再关断是不符合时钟切换顺序的。而要解决这个问题也很简单，只需要在sel+和sel-上增加一个反相器即可。          
![part0_b](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_ClockSwitch/images/part0_b.PNG "part0_b")     

**4. 加入2级同步器**      
将part0_a和part1结合起来得到如下电路图。此电路已经将sel分为两路并解决了时钟切换顺序问题。但是并没有对选择信号进行同步处理。而对于单比特信号的同步通常使用2级同步器，因此这里使用2个2级同步器即可。但是同步器的插入点有2个，分别是S0/S1和G0/G1。根据“usb_geek”的说法，如果插入点为G0/G1的话还会出现切换顺序不一定的情况（但是并没有解释为什么）所以插入点为S0/S1比较合适。个人理解可能是考虑到线延时的问题，同步器位置距反馈电路的输出越近越好。
![part0_a_part1](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_ClockSwitch/images/part0_a_part1.PNG "part0_a_part1")

将同步器插入位置S0/S1后得到下面的电路图。要注意的是同步器的复位值为0，以保证复位后输出无效。而且同步器的第二个寄存器为下降沿触发。这是因为同步器后使用and门做门控。而使用and门做门控时为保证不产生毛刺，门控信号必须要在输入时钟的低电平期间变化。第一个寄存器也可以使用上升沿也可以使用下降沿触发。       
![noglitch_switch_a](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_ClockSwitch/images/noglitch_switch_a.PNG "noglitch_switch_a")         
若使用part0_b和part1进行时钟切换，需要在G0/G1上加上反相器，原因见第3部分介绍。
![noglitch_switch_b](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_ClockSwitch/images/noglitch_switch_b.PNG "noglitch_switch_b")         

**参考文章:**    
[https://www.eetimes.com/document.asp?doc_id=1202359](https://www.eetimes.com/document.asp?doc_id=1202359)      
[http://bbs.eetop.cn/thread-319141-1-1.html](http://bbs.eetop.cn/thread-319141-1-1.html)   