onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_rom256x16bit/clk
add wave -noupdate -radix unsigned -format Analog-Step -height 80 -max 255.0 /tb_rom256x16bit/addr
add wave -noupdate -radix unsigned -format Analog-Step -height 200 -max 65535.0 /tb_rom256x16bit/q
add wave -noupdate /tb_rom256x16bit/run_sim
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -timelineunits us
update
