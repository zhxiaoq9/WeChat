#退出当前仿真
quit -sim  

#删除work库
if [file exists work] {  
  vdel -all  
}

#设置UVM库路径
set UVM_DPI_HOME D:/QuestaSim10_4e/uvm-1.2/win64

#新建work库
vlib work  

#加载编译dut文件，VHDL文件用vcom，verilog文件用vlog
vlog -f dut.f

#加载编译仿真文件
vlog -f tb.f

#设置仿真优化并开启覆盖率收集
#b:branch, c:condition, e:expression, s:statement, x:toggle, f:FSM
vopt FIFO_TB +acc +cover=bcesf -o top_optimized

#仿真设置
# top_optimized:优化后的设计文件 
# -l:指定要保存仿真输出的文件
# -L:指定DPI库 
# -coverage：收集覆盖率
# +UVM_TESTNAME: 指定UVM仿真TC
vsim top_optimized -coverage -l sim.log -L $UVM_DPI_HOME/uvm_dpi +UVM_TESTNAME=case0

#添加波形信号
do wave.do

#开始仿真
run -all

#保存覆盖率报告与覆盖率文件
coverage report -file rpt/coverage_rpt.txt
coverage report -file rpt/coverage_rpt.ucdb

#记录所有信号数据
#log /* -r
