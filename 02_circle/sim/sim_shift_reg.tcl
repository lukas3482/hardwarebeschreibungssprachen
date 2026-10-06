# enviroment creation
vlib work

# compile SRC files
vlog ../src/shift_reg.sv

# compile tb files
vlog tb_shift_reg.sv

# init simulation
vsim tb_shift_reg

# run simulation
do wave_shift_reg.do
run -all

# view waveform
view wave
wave zoomful
