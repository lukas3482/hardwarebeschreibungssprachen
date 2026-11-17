onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_uart_tx/FCLK_TB
add wave -noupdate /tb_uart_tx/BAUD_TB
add wave -noupdate /tb_uart_tx/rst_ni
add wave -noupdate /tb_uart_tx/clk_i
add wave -noupdate /tb_uart_tx/tx_en_i
add wave -noupdate /tb_uart_tx/tx_start_i
add wave -noupdate /tb_uart_tx/tx_data_i
add wave -noupdate -color Purple -itemcolor Purple /tb_uart_tx/tx_o
add wave -noupdate -color Purple -itemcolor Purple /tb_uart_tx/tx_idle_o
add wave -noupdate -color Purple -itemcolor Purple /tb_uart_tx/tx_done_o
add wave -noupdate /tb_uart_tx/run_sim
add wave -noupdate -divider DUT
add wave -noupdate -format Analog-Step -height 74 -max 49.0 -radix unsigned /tb_uart_tx/dut/wc_cnt
add wave -noupdate /tb_uart_tx/dut/wc_load
add wave -noupdate /tb_uart_tx/dut/wc_zero
add wave -noupdate -format Analog-Step -height 74 -max 7.0 -radix unsigned /tb_uart_tx/dut/bc_cnt
add wave -noupdate /tb_uart_tx/dut/bc_inc
add wave -noupdate /tb_uart_tx/dut/bc_clr
add wave -noupdate /tb_uart_tx/dut/sr
add wave -noupdate /tb_uart_tx/dut/sr_shift
add wave -noupdate /tb_uart_tx/dut/sr_load
add wave -noupdate /tb_uart_tx/dut/tx_start_old
add wave -noupdate /tb_uart_tx/dut/tx_start_posedge
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {85869 ns}
