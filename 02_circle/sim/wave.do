onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_prescaler/rst_n
add wave -noupdate /tb_prescaler/clk
add wave -noupdate /tb_prescaler/sel
add wave -noupdate /tb_prescaler/en
add wave -noupdate /tb_prescaler/run_sim
add wave -noupdate -divider DUT
add wave -noupdate /tb_prescaler/dut/rst_ni
add wave -noupdate /tb_prescaler/dut/clk_i
add wave -noupdate /tb_prescaler/dut/sel_i
add wave -noupdate /tb_prescaler/dut/en_o
add wave -noupdate /tb_prescaler/dut/cnt
add wave -noupdate /tb_prescaler/dut/preload_val
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
