# enviroment creation
vlib work

# MIF-File muss im Simulationsverzeichnis liegen (init_file im ROM)
file copy -force ../fpga/gamma_2_2_16bit_8addr.mif .

# compile SRC files
vlog ../fpga/rom256x16bit.v

# compile tb files
vlog tb_rom256x16bit.sv

# init simulation (altsyncram kommt aus der Altera-Library)
vsim -L altera_mf_ver tb_rom256x16bit

# run simulation
do wave_rom256x16bit.do
run -all

# view waveform
view wave
wave zoomful
