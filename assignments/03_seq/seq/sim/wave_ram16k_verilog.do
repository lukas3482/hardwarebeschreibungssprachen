onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate /tb_ram16k_verilog/tb_clock
add wave -noupdate /tb_ram16k_verilog/tb_wren
add wave -noupdate -radix hexadecimal /tb_ram16k_verilog/tb_address
add wave -noupdate -radix hexadecimal /tb_ram16k_verilog/tb_data
add wave -noupdate -radix hexadecimal /tb_ram16k_verilog/tb_exp
add wave -noupdate -radix hexadecimal /tb_ram16k_verilog/tb_q
add wave -noupdate -radix decimal /tb_ram16k_verilog/errors
add wave -noupdate -divider DUT
add wave -noupdate /tb_ram16k_verilog/dut/clock
add wave -noupdate /tb_ram16k_verilog/dut/wren
add wave -noupdate -radix hexadecimal /tb_ram16k_verilog/dut/address
add wave -noupdate -radix hexadecimal /tb_ram16k_verilog/dut/data
add wave -noupdate -radix hexadecimal /tb_ram16k_verilog/dut/q
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -timelineunits ns
update
