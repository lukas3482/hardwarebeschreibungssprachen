onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_sevenseg/tb_bin
add wave -noupdate -radix binary /tb_sevenseg/tb_hex
add wave -noupdate -radix binary /tb_sevenseg/tb_hexn
add wave -noupdate -divider DUT
add wave -noupdate -radix hexadecimal /tb_sevenseg/dut/bin_i
add wave -noupdate -radix binary -childformat {{{/tb_sevenseg/dut/hex_o[6]} -radix binary} {{/tb_sevenseg/dut/hex_o[5]} -radix binary} {{/tb_sevenseg/dut/hex_o[4]} -radix binary} {{/tb_sevenseg/dut/hex_o[3]} -radix binary} {{/tb_sevenseg/dut/hex_o[2]} -radix binary} {{/tb_sevenseg/dut/hex_o[1]} -radix binary} {{/tb_sevenseg/dut/hex_o[0]} -radix binary}} -expand /tb_sevenseg/dut/hex_o
add wave -noupdate -radix binary /tb_sevenseg/dut/hexn_o
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -timelineunits ns
update
