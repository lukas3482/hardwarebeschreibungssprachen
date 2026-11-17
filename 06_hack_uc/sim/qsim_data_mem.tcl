# (1) Create the simulation environment
vlib work

# (2) Compile source files
vlog ../fpga/ram16k.v
vlog ../src/mem_slice.sv
vlog ../src/data_mem.sv

# (3) Compile tb files
vlog tb_data_mem.sv

# (4) Init simulation (altsyncram kommt aus der Altera-Library)
vsim -voptargs=+acc -L altera_mf_ver work.tb_data_mem

# (5) Log all signals and run simulation
log -r *
add wave -r /tb_data_mem/*
run -all

# (6) Bring up the wave window
view wave
wave zoomfull
