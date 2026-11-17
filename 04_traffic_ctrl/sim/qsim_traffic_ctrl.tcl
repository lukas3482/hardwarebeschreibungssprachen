# (1) Create the simulation environment
vlib work

# (2) Compile source files
vlog ../src/traffic_ctrl_pkg.sv
vlog ../src/traffic_ctrl.sv

# (3) Compile tb files
vlog tb_traffic_ctrl.sv

# (4) Init simulation
vsim -voptargs=+acc work.tb_traffic_ctrl
#vsim work.tb_majvote  <<-- for MODELSIM

# (5) Log all signals and run simulation
log -r *
do wave_traffic_ctrl.do
run -all

# (6) Bring up the wave window
view wave
wave zoomfull

