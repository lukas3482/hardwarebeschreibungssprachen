onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate -radix decimal /tb_alu/tb_x
add wave -noupdate -radix decimal /tb_alu/tb_y
add wave -noupdate -radix binary /tb_alu/tb_cmd
add wave -noupdate -radix decimal /tb_alu/tb_exp
add wave -noupdate -radix decimal /tb_alu/tb_out
add wave -noupdate /tb_alu/tb_zr
add wave -noupdate /tb_alu/tb_ng
add wave -noupdate -radix decimal /tb_alu/errors
add wave -noupdate -divider DUT
add wave -noupdate -radix hexadecimal /tb_alu/dut/x
add wave -noupdate -radix hexadecimal /tb_alu/dut/y
add wave -noupdate /tb_alu/dut/zx
add wave -noupdate /tb_alu/dut/nx
add wave -noupdate /tb_alu/dut/zy
add wave -noupdate /tb_alu/dut/ny
add wave -noupdate /tb_alu/dut/f
add wave -noupdate /tb_alu/dut/no
add wave -noupdate -radix hexadecimal /tb_alu/dut/x_zx
add wave -noupdate -radix hexadecimal /tb_alu/dut/x_nx
add wave -noupdate -radix hexadecimal /tb_alu/dut/y_zy
add wave -noupdate -radix hexadecimal /tb_alu/dut/y_ny
add wave -noupdate -radix hexadecimal /tb_alu/dut/f_out
add wave -noupdate -radix hexadecimal /tb_alu/dut/no_out
add wave -noupdate -radix hexadecimal /tb_alu/dut/out
add wave -noupdate /tb_alu/dut/zr
add wave -noupdate /tb_alu/dut/ng
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -timelineunits ns
update
