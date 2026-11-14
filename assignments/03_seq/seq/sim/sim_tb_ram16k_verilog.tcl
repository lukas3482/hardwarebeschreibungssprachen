# enviroment creation
vlib work

# compile SRC files
vlog ../src/ram16k_verilog.sv

# compile tb files
vlog tb_ram16k_verilog.sv

# init simulation
vsim tb_ram16k_verilog

# run simulation
do wave_ram16k_verilog.do
run -all

# view waveform
view wave
wave zoomful

# view memory
view memory
add mem /tb_ram16k_verilog/dut/mem -a hexadecimal -d hexadecimal
