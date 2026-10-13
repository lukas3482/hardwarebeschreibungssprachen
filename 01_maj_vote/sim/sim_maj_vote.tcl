# enviroment creation
vlib work

# compile SRC files
vlog ../src/maj_vote.sv

# compile tb files
vlog tb_maj_vote.sv

# init simulation
vsim tb_maj_vote

# run simulation
do wave.do
run -all

# view waveform
view wave
