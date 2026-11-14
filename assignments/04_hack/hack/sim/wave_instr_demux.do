onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate -radix binary /tb_instr_demux/tb_instr
add wave -noupdate /tb_instr_demux/tb_exp_type
add wave -noupdate /tb_instr_demux/tb_instr_type
add wave -noupdate -radix hexadecimal /tb_instr_demux/tb_exp_v
add wave -noupdate -radix hexadecimal /tb_instr_demux/tb_instr_v
add wave -noupdate -radix binary /tb_instr_demux/tb_exp_cmd
add wave -noupdate -radix binary /tb_instr_demux/tb_cmd
add wave -noupdate -radix decimal /tb_instr_demux/errors
add wave -noupdate -divider DUT
add wave -noupdate /tb_instr_demux/dut/cmd_a
add wave -noupdate /tb_instr_demux/dut/cmd_c1
add wave -noupdate /tb_instr_demux/dut/cmd_c2
add wave -noupdate /tb_instr_demux/dut/cmd_c3
add wave -noupdate /tb_instr_demux/dut/cmd_c4
add wave -noupdate /tb_instr_demux/dut/cmd_c5
add wave -noupdate /tb_instr_demux/dut/cmd_c6
add wave -noupdate /tb_instr_demux/dut/cmd_d1
add wave -noupdate /tb_instr_demux/dut/cmd_d2
add wave -noupdate /tb_instr_demux/dut/cmd_d3
add wave -noupdate /tb_instr_demux/dut/cmd_j1
add wave -noupdate /tb_instr_demux/dut/cmd_j2
add wave -noupdate /tb_instr_demux/dut/cmd_j3
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -timelineunits ns
update
