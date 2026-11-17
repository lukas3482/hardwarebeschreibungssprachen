//-------------------------------
// Project      Hack uC
// Purpose      Unify the CPU, RAM and ROM
// Author       ANM
// Version      v00
//-------------------------------

module uc 
#(
    parameter int AW = 15,
    parameter int DW = 16,
    parameter int PW = 15
)
(
    input  logic                rst_n,
    input  logic                clk50m,
    input  logic [DW-1:0]       reg0x7400,
    input  logic [DW-1:0]       reg0x7401,
    input  logic [DW-1:0]       reg0x7402,
    output logic [DW-1:0]       reg0x7000,
    output logic [DW-1:0]       reg0x7001,
    output logic [DW-1:0]       reg0x7002
);

logic [DW-1:0]      instr;          // instruction word from PROM to CPU
logic [PW-1:0]      pc;             // program counter as address of the PROM
logic               writeM;         // we for RAM
logic [DW-1:0]      outM;           // data from CPU to RAM
logic [AW-1:0]      addressM;       // address for the RAM
logic [DW-1:0]      inM;            // data from RAM to CPU

logic en25m;

always_ff @( negedge rst_n or posedge clk50m ) begin
   if (~rst_n) begin
        en25m <= 1'b0;
   end
   else begin
        en25m <= ~en25m;
   end
end

cpu
#(
    .DW     (DW),
    .AW     (AW),
    .PW     (PW)
)
cpu_u0
(
    .rst_n              (rst_n),   
    .clk50m             (clk50m),  
    .en25m              (en25m),   
    .inM                (inM),     
    .instr              (instr),    
    .writeM             (writeM),  
    .outM               (outM),    
    .addressM           (addressM),
    .pc                 (pc)       
);


data_mem #(
    .AW (AW),
    .DW (DW)
) 
data_mem_u0
(
    .rst_n                          (rst_n),
    .clk50m                         (clk50m),
    .we                             (writeM),
    .data_in                        (outM),
    .addr                           (addressM),
    .data_out                       (inM),

    .data_out_led0                  (reg0x7000),
    .data_out_led1                  (reg0x7001),
    .data_out_sevseg                (reg0x7002),

    .data_in_sw0                    (reg0x7400),
    .data_in_sw1                    (reg0x7401),
    .data_in_key                    (reg0x7402)
);

rom32k rom32k_u0(
	.address            (pc),
	.clock              (clk50m),
	.q                  (instr)
);

endmodule