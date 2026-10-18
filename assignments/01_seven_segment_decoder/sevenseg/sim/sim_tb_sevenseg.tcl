# enviroment creation
vlib work

# compile SRC files
vlog ../src/sevenseg.sv

# compile tb files
vlog tb_sevenseg.sv

# init simulation
vsim tb_sevenseg

# run simulation
do wave.do
run -all

# view waveform
view wave
wave zoomful
