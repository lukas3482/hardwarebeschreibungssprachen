# enviroment creation
vlib work

# compile SRC files
vlog ../src/alu.sv

# compile tb files
vlog tb_alu.sv

# init simulation
vsim tb_alu

# run simulation
do wave.do
run -all

# view waveform
view wave
wave zoomful
