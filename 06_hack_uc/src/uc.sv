module uc 
#(
    parameter int AW = 15,
    parameter int DW = 16,
    parameter int PW = 15
)
(
    input logic             rst_n,
    input logic             clk50m,
    input logic [DW-1:0] reg0x7400,
    input logic [DW-1:0] reg0x7401,
    input logic [DW-1:0] reg0x7402,

    output logic [DW-1:0] reg0x7000,
    output logic [DW-1:0] reg0x7001,
    output logic [DW-1:0] reg0x7002
);

// Internal Wire declaration
logic en25m;
// ROM
logic [PW-1:0]      pc;         // program counter
logic [DW-1:0]      instr;      // machine code from rom
// bus to data_mem
logic               writeM;     // write enable
logic [DW-1:0]      outM;       // CPU data_out, mem data_in
logic [AW-1:0]      addressM;   // CPU addressM, data_mem addr_in
logic [DW-1:0]      inM;        // data_mem data_out


// FF for the 25Mhz enable
always_ff @( posedge clk50m or negedge rst_n ) begin
    if(!rst_n) begin 
        en25m <= 1'b0;
    end
    else begin
        en25m <= ~en25m;
    end
end



cpu
#(
    .DW         (DW),
    .AW         (AW),
    .PW         (PW)
)
cpu_u0
(
    .rst_n          (rst_n),   
    .clk50m         (clk50m),  
    .en25m          (en25m),   
    .instr          (instr),   
    .inM            (inM),     
    .writeM         (writeM),  
    .outM           (outM),    
    .addressM       (addressM),
    .pc             (pc)      

);

rom32k rom32k_u0
(
	.address        (pc),
	.clock          (clk50m),
	.q              (instr)
);

data_mem
#(
    .DW         (DW),
    .AW         (AW),
)
data_mem_u0
(
    .rst_n          (rst_n),
    .clk50m         (clk50m),
    // internal bus to the cpu
    .we             (writeM),
    .data_in        (outM),
    .addr           (addressM),
    .data_out       (inM),
    // IO to the FPGA pins
    .reg0x7400      (reg0x7400),
    .reg0x7401      (reg0x7401),
    .reg0x7402      (reg0x7402),
    .reg0x7000      (reg0x7000),
    .reg0x7001      (reg0x7001),
    .reg0x7002      (reg0x7002)
);

endmodule