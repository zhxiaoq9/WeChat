
add wave -noupdate -expand -group {input signal} /WRITER_TB/WRITER/clk
add wave -noupdate -expand -group {input signal} /WRITER_TB/WRITER/rst_n
add wave -noupdate -expand -group {input signal} /WRITER_TB/WRITER/clear
add wave -noupdate -expand -group {input signal} /WRITER_TB/WRITER/start
add wave -noupdate -expand -group {input signal} /WRITER_TB/WRITER/in


add wave -noupdate -expand -group {output signal} /WRITER_TB/WRITER/cnt
add wave -noupdate -expand -group {output signal} /WRITER_TB/WRITER/out


add wave -noupdate -expand -group {internal signal} /WRITER_TB/WRITER/in_xor



configure wave -namecolwidth 335
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns



