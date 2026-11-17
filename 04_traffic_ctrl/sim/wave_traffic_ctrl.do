onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_traffic_ctrl/TO_MAIN_GREEN
add wave -noupdate /tb_traffic_ctrl/TO_MAIN_YELLOW
add wave -noupdate /tb_traffic_ctrl/TO_MAIN_RED
add wave -noupdate /tb_traffic_ctrl/rst_ni
add wave -noupdate /tb_traffic_ctrl/clk_i
add wave -noupdate /tb_traffic_ctrl/sensor_i
add wave -noupdate /tb_traffic_ctrl/main_green_o
add wave -noupdate -color yellow -itemcolor yellow /tb_traffic_ctrl/main_yellow_o
add wave -noupdate -color Maroon -itemcolor Maroon /tb_traffic_ctrl/main_red_o
add wave -noupdate /tb_traffic_ctrl/side_green_o
add wave -noupdate -color yellow -itemcolor yellow /tb_traffic_ctrl/side_yellow_o
add wave -noupdate -color Maroon -itemcolor Maroon /tb_traffic_ctrl/side_red_o
add wave -noupdate /tb_traffic_ctrl/run_sim
add wave -noupdate /tb_traffic_ctrl/error_cnt
add wave -noupdate -divider DUT
add wave -noupdate /tb_traffic_ctrl/dut/state
add wave -noupdate -format Analog-Step -height 74 -max 254.99999999999997 -radix unsigned /tb_traffic_ctrl/dut/to_cnt
add wave -noupdate /tb_traffic_ctrl/dut/to_value
add wave -noupdate /tb_traffic_ctrl/dut/to_load
add wave -noupdate /tb_traffic_ctrl/dut/to_zero
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 235
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
update
WaveRestoreZoom {0 ns} {375380 ns}
