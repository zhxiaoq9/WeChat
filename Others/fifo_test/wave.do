add wave -noupdate -expand -group {write signal} /FIFO_TB/FIFO1/wclk
add wave -noupdate -expand -group {write signal} /FIFO_TB/FIFO1/wrst_n
add wave -noupdate -expand -group {write signal} /FIFO_TB/FIFO1/winc
add wave -noupdate -expand -group {write signal} /FIFO_TB/FIFO1/wdata
add wave -noupdate -expand -group {write signal} /FIFO_TB/FIFO1/wfull
add wave -noupdate -expand -group {write signal} /FIFO_TB/FIFO1/afull


add wave -noupdate -expand -group read_signal /FIFO_TB/FIFO1/rclk
add wave -noupdate -expand -group read_signal /FIFO_TB/FIFO1/rrst_n
add wave -noupdate -expand -group read_signal /FIFO_TB/FIFO1/rinc
add wave -noupdate -expand -group read_signal /FIFO_TB/FIFO1/rempty
add wave -noupdate -expand -group read_signal /FIFO_TB/FIFO1/aempty
add wave -noupdate -expand -group read_signal /FIFO_TB/FIFO1/rdata


add wave -noupdate /FIFO_TB/FIFO1/sync_rrst_n
add wave -noupdate /FIFO_TB/FIFO1/sync_wrst_n


add wave -noupdate -expand -group pointer /FIFO_TB/FIFO1/wptr
add wave -noupdate -expand -group pointer /FIFO_TB/FIFO1/rptr
add wave -noupdate -expand -group pointer /FIFO_TB/FIFO1/wptr_sync
add wave -noupdate -expand -group pointer /FIFO_TB/FIFO1/rptr_sync
add wave -noupdate -expand -group pointer -radix unsigned /FIFO_TB/FIFO1/waddr
add wave -noupdate -expand -group pointer -radix unsigned /FIFO_TB/FIFO1/raddr



view structure
view signals