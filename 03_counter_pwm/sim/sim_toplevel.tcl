# enviroment creation
vlib work

# compile SRC files
vlog ../src/prescaler_pkg.sv
vlog ../src/prescaler.sv
vlog ../src/counter_pwm.sv
vlog ../fpga/toplevel_c5g_hex4_uart.sv

# compile tb files
vlog tb_toplevel.sv

# init simulation
vsim tb_toplevel

# run simulation
do wave_toplevel.do
run -all

# view waveform
view wave
wave zoomful
