# enviroment creation
vlib work

# compile SRC files
vlog ../src/pcount.sv

# compile tb files
vlog tb_pcount.sv

# init simulation
vsim tb_pcount

# run simulation
do wave_pcount.do
run -all

# view waveform
view wave
wave zoomful

