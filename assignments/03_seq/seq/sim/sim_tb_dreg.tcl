# enviroment creation
vlib work

# compile SRC files
vlog ../src/dreg.sv

# compile tb files
vlog tb_dreg.sv

# init simulation
vsim tb_dreg

# run simulation
do wave_dreg.do
run -all

# view waveform
view wave
wave zoomful

