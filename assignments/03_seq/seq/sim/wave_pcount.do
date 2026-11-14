onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate /tb_pcount/tb_clk50m
add wave -noupdate /tb_pcount/tb_rst_n
add wave -noupdate /tb_pcount/tb_en
add wave -noupdate /tb_pcount/tb_load
add wave -noupdate /tb_pcount/tb_inc
add wave -noupdate -radix hexadecimal /tb_pcount/tb_cnt_in
add wave -noupdate -radix hexadecimal /tb_pcount/tb_exp
add wave -noupdate -radix hexadecimal /tb_pcount/tb_cnt
add wave -noupdate -radix decimal /tb_pcount/errors
add wave -noupdate -divider DUT
add wave -noupdate /tb_pcount/dut/clk50m
add wave -noupdate /tb_pcount/dut/rst_n
add wave -noupdate /tb_pcount/dut/en
add wave -noupdate /tb_pcount/dut/load
add wave -noupdate /tb_pcount/dut/inc
add wave -noupdate -radix hexadecimal /tb_pcount/dut/cnt_in
add wave -noupdate -radix hexadecimal /tb_pcount/dut/cnt
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -timelineunits ns
update
