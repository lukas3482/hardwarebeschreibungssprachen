# enviroment creation
vlib work

# compile SRC files
vlog ../src/instr_demux.sv

# compile tb files
vlog tb_instr_demux.sv

# init simulation
vsim tb_instr_demux

# run simulation
do wave_instr_demux.do
run -all

# view waveform
view wave
wave zoomful
