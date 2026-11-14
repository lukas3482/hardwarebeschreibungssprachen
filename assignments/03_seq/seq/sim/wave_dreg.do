onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate /tb_dreg/tb_clk50m
add wave -noupdate /tb_dreg/tb_rst_n
add wave -noupdate /tb_dreg/tb_en
add wave -noupdate /tb_dreg/tb_load
add wave -noupdate -radix hexadecimal /tb_dreg/tb_d
add wave -noupdate -radix hexadecimal /tb_dreg/tb_exp
add wave -noupdate -radix hexadecimal /tb_dreg/tb_q
add wave -noupdate -radix decimal /tb_dreg/errors
add wave -noupdate -divider DUT
add wave -noupdate /tb_dreg/dut/clk50m
add wave -noupdate /tb_dreg/dut/rst_n
add wave -noupdate /tb_dreg/dut/en
add wave -noupdate /tb_dreg/dut/load
add wave -noupdate -radix hexadecimal /tb_dreg/dut/d
add wave -noupdate -radix hexadecimal /tb_dreg/dut/q
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -timelineunits ns
update
