# enviroment creation
vlib work

# compile SRC files
vlog ../src/prescaler_pkg.sv
vlog ../src/prescaler.sv

# compile tb files
vlog tb_prescaler.sv

# init simulation
vsim tb_prescaler

# run simulation
do wave.do
run -all

# view waveform
view wave
wave zoomful
