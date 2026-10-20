# enviroment creation
vlib work

# MIF-File muss im Simulationsverzeichnis liegen (init_file im ROM)
file copy -force ../fpga/gamma_2_2_16bit_8addr.mif .

# compile SRC files
vlog ../src/prescaler_pkg.sv
vlog ../src/prescaler.sv
vlog ../src/counter_pwm.sv
vlog ../fpga/rom256x16bit.v
vlog ../fpga/toplevel_c5g_hex4_uart.sv

# compile tb files
vlog tb_toplevel.sv

# init simulation (altsyncram kommt aus der Altera-Library)
vsim -L altera_mf_ver tb_toplevel

# run simulation
do wave_toplevel.do
run -all

# view waveform
view wave
wave zoomful
