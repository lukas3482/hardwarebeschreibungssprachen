# (1) Create the simulation environment
vlib work

# (2) Compile source files
vlog ../src/uart_tx.sv

# (3) Compile tb files
vlog tb_uart_tx.sv

# (4) Init simulation
vsim -voptargs=+acc work.tb_uart_tx
#vsim work.tb_majvote  <<-- for MODELSIM

# (5) Log all signals and run simulation
log -r *
do wave_uart_tx.do
run -all

# (6) Bring up the wave window
view wave
wave zoomfull

