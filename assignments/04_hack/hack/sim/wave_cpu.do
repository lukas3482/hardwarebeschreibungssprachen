onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate /tb_cpu/tb_clk50m
add wave -noupdate /tb_cpu/tb_en25m
add wave -noupdate /tb_cpu/tb_rst_n
add wave -noupdate -radix hexadecimal /tb_cpu/tb_instr
add wave -noupdate -radix hexadecimal /tb_cpu/tb_inM
add wave -noupdate -radix hexadecimal /tb_cpu/tb_exp_outM
add wave -noupdate -radix hexadecimal /tb_cpu/tb_outM
add wave -noupdate /tb_cpu/tb_exp_writeM
add wave -noupdate /tb_cpu/tb_writeM
add wave -noupdate -radix hexadecimal /tb_cpu/tb_exp_addressM
add wave -noupdate -radix hexadecimal /tb_cpu/tb_addressM
add wave -noupdate -radix hexadecimal /tb_cpu/tb_exp_pc
add wave -noupdate -radix hexadecimal /tb_cpu/tb_pc
add wave -noupdate -radix decimal /tb_cpu/errors
add wave -noupdate -divider DUT
add wave -noupdate /tb_cpu/dut/instr_type
add wave -noupdate /tb_cpu/dut/cmd_a
add wave -noupdate /tb_cpu/dut/aload
add wave -noupdate /tb_cpu/dut/dload
add wave -noupdate /tb_cpu/dut/mload
add wave -noupdate -radix hexadecimal /tb_cpu/tb_exp_a
add wave -noupdate -radix hexadecimal /tb_cpu/dut/a
add wave -noupdate -radix hexadecimal /tb_cpu/tb_exp_d
add wave -noupdate -radix hexadecimal /tb_cpu/dut/d
add wave -noupdate -radix hexadecimal /tb_cpu/dut/alu_y
add wave -noupdate -radix hexadecimal /tb_cpu/dut/alu_out
add wave -noupdate /tb_cpu/dut/alu_zr
add wave -noupdate /tb_cpu/dut/alu_ng
add wave -noupdate /tb_cpu/dut/pc_load
add wave -noupdate /tb_cpu/dut/pc_inc
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -timelineunits ns
update
