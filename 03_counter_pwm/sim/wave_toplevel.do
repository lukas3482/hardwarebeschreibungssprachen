onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_toplevel/rst_n
add wave -noupdate /tb_toplevel/clk
add wave -noupdate /tb_toplevel/key
add wave -noupdate /tb_toplevel/dut/cnt_en
add wave -noupdate /tb_toplevel/dut/load
add wave -noupdate -divider COUNTER
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 {/tb_toplevel/dut/cnt[0]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 {/tb_toplevel/dut/cnt[1]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 {/tb_toplevel/dut/cnt[2]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 {/tb_toplevel/dut/cnt[3]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 {/tb_toplevel/dut/cnt[4]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 {/tb_toplevel/dut/cnt[5]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 {/tb_toplevel/dut/cnt[6]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 {/tb_toplevel/dut/cnt[7]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 {/tb_toplevel/dut/cnt[8]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 255.0 {/tb_toplevel/dut/cnt[9]}
add wave -noupdate -divider THRESHOLDS
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 65535.0 {/tb_toplevel/dut/pwm_thr[0]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 65535.0 {/tb_toplevel/dut/pwm_thr[1]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 65535.0 {/tb_toplevel/dut/pwm_thr[2]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 65535.0 {/tb_toplevel/dut/pwm_thr[3]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 65535.0 {/tb_toplevel/dut/pwm_thr[4]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 65535.0 {/tb_toplevel/dut/pwm_thr[5]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 65535.0 {/tb_toplevel/dut/pwm_thr[6]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 65535.0 {/tb_toplevel/dut/pwm_thr[7]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 65535.0 {/tb_toplevel/dut/pwm_thr[8]}
add wave -noupdate -radix unsigned -format Analog-Step -height 40 -max 65535.0 {/tb_toplevel/dut/pwm_thr[9]}
add wave -noupdate -divider LEDR
add wave -noupdate -expand /tb_toplevel/ledr
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -timelineunits us
update
