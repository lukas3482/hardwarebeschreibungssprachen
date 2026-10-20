# enviroment creation
vlib work

# compile SRC files
vlog ../src/ram64x8bit.sv

# compile tb files
vlog tb_ram64x8bit.sv

# init simulation
vsim tb_ram64x8bit

# run simulation
#do wave.do
run -all

# view memory
view memory
add mem /tb_ram64x8bit/dut/mem -a hexadecimal -d hexadecimal
