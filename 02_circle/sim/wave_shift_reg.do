onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_shift_reg/rst_n
add wave -noupdate /tb_shift_reg/clk
add wave -noupdate /tb_shift_reg/shift_en
add wave -noupdate -radix binary /tb_shift_reg/shift_out
add wave -noupdate -radix binary /tb_shift_reg/expected
add wave -noupdate /tb_shift_reg/run_sim
add wave -noupdate -divider DUT
add wave -noupdate /tb_shift_reg/dut/rst_ni
add wave -noupdate /tb_shift_reg/dut/clk_i
add wave -noupdate /tb_shift_reg/dut/shift_en_i
add wave -noupdate -radix binary /tb_shift_reg/dut/shift_out_o
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {700 ns}
