onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_maj_vote/tb_x0
add wave -noupdate /tb_maj_vote/tb_x1
add wave -noupdate /tb_maj_vote/tb_x2
add wave -noupdate /tb_maj_vote/tb_y_gates
add wave -noupdate /tb_maj_vote/tb_y_behav
add wave -noupdate -divider DUT
add wave -noupdate /tb_maj_vote/dut/x0
add wave -noupdate /tb_maj_vote/dut/x1
add wave -noupdate /tb_maj_vote/dut/x2
add wave -noupdate /tb_maj_vote/dut/y_gates
add wave -noupdate /tb_maj_vote/dut/y_behav
add wave -noupdate /tb_maj_vote/dut/xbus
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 199
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
WaveRestoreZoom {0 ps} {932 ps}
