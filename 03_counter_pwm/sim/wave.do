onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_counter_pwm/rst_n
add wave -noupdate /tb_counter_pwm/clk
add wave -noupdate /tb_counter_pwm/en
add wave -noupdate /tb_counter_pwm/load
add wave -noupdate -radix unsigned /tb_counter_pwm/thr
add wave -noupdate -radix unsigned -format Analog-Step -height 80 -max 255.0 /tb_counter_pwm/cnt
add wave -noupdate /tb_counter_pwm/pwm
add wave -noupdate /tb_counter_pwm/run_sim
add wave -noupdate -divider DUT
add wave -noupdate /tb_counter_pwm/dut/cnt_up
add wave -noupdate /tb_counter_pwm/dut/cnt_up_new
add wave -noupdate /tb_counter_pwm/dut/pwm_comb
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -timelineunits ns
update
