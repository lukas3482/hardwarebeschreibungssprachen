onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_toplevel/rst_n
add wave -noupdate /tb_toplevel/clk
add wave -noupdate /tb_toplevel/key
add wave -noupdate /tb_toplevel/dut/cnt_en
add wave -noupdate /tb_toplevel/dut/load
add wave -noupdate -divider THRESHOLDS
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 /tb_toplevel/dut/pwm_thr_0
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 /tb_toplevel/dut/pwm_thr_1
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 /tb_toplevel/dut/pwm_thr_2
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 /tb_toplevel/dut/pwm_thr_3
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 /tb_toplevel/dut/pwm_thr_4
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 /tb_toplevel/dut/pwm_thr_5
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 /tb_toplevel/dut/pwm_thr_6
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 /tb_toplevel/dut/pwm_thr_7
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 /tb_toplevel/dut/pwm_thr_8
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 /tb_toplevel/dut/pwm_thr_9
add wave -noupdate -divider LEDR
add wave -noupdate -expand /tb_toplevel/ledr
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -timelineunits us
update
