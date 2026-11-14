# enviroment creation
vlib work

# compile SRC files
vlog ../src/alu.sv
vlog ../src/dreg.sv
vlog ../src/pcount.sv
vlog ../src/instr_demux.sv
vlog ../src/jmp_ctrl.sv
vlog ../src/cpu.sv

# compile tb files
vlog tb_cpu.sv

# init simulation
vsim tb_cpu

# run simulation
do wave_cpu.do
run -all

# view waveform
view wave
wave zoomful
