# enviroment creation
vlib work

# compile SRC files
vlog ../src/counter_pwm.sv

# compile tb files
vlog tb_counter_pwm.sv

# init simulation
vsim tb_counter_pwm

# run simulation
do wave.do
run -all

# view waveform
view wave
wave zoomful
