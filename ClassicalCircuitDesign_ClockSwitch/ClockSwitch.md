时钟切换是在设计中最常见电路之一。但由于控制信号和两个时钟通常不在一个时钟域，因此会导致毛刺的出现。在eetop网站上用户“usb_geek”共享过一篇相关的设计文档。虽然这篇文档对无毛刺时钟切换电路做了介绍，但还是不够浅显。本篇文章在这篇共享的设计文档的基础上对其进行进一步补充说明。     

**1.不考虑毛刺的钟切换电路**  
不考虑毛刺的时钟切换电路如下图所示，其中sel是选择信号，clk0和clk1为异步时钟，通常情况下sel和clk0/clk1也是异步的。其实这就是一个2选1的多路选择器。这种情况下clk_out很容易产生毛刺。        
![不考虑毛刺的时钟切换](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_ClockSwitch/images/basic_switch.PNG "不考虑毛刺的时钟切换")  

**2.将选择信号分为两路**     
既然毛刺的出现主要是因为选择信号sel和时钟的异步导致。那么最直接的解决方法就是将sel分别同步到clk0和clk1两个时钟域。这时必须将sel分为两路信号，又因为同一时刻clk0和clk1只能选择一个，所以我们可以使用反相器先将sel分为两路，再使用2个and门和1个or门将时钟选择出来（当然也可以使用2个or门和1个and门）。具体结构见下图。     
![选择信号分为两路](https://raw.githubusercontent.com/zhxiaoq9/WeChat/master/ClassicalCircuitDesign_ClockSwitch/images/advance_switch.PNG "选择信号分为两路")    

      


**参考文章:**    
[https://www.eetimes.com/document.asp?doc_id=1202359](https://www.eetimes.com/document.asp?doc_id=1202359)      
[http://bbs.eetop.cn/thread-319141-1-1.html](http://bbs.eetop.cn/thread-319141-1-1.html)   