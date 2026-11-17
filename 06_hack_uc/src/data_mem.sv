module data_mem
#(
    parameter int AW = 15,
    parameter int DW = 16
)
(
    input logic             rst_n,
    input logic             clk50m,
    // internal bus to the cpu
    input logic             we,
    input logic [DW-1:0]    data_in,
    input logic [AW-1:0]    addr,
    output logic [DW-1:0]   data_out,
    // IO to the FPGA pins
    input logic [DW-1:0] reg0x7400,
    input logic [DW-1:0] reg0x7401,
    input logic [DW-1:0] reg0x7402,
    output logic [DW-1:0] reg0x7000,
    output logic [DW-1:0] reg0x7001,
    output logic [DW-1:0] reg0x7002
);

localparam RAM_START    = 15'h0000;
localparam RAM_END      = 15'h3FFF;
localparam LEDG         = 15'h7000;
localparam LEDR         = 15'h7001;
localparam SEVENSEG     = 15'h7002;
localparam SW0          = 15'h7400;
localparam SW1          = 15'h7401;
localparam KEY          = 15'h7402;

logic we_ram16k;
logic [DW-1:0] data_out_ram16k;
logic [DW-1:0] data_out_ledg;
logic [DW-1:0] data_out_ledr;
logic [DW-1:0] data_out_sevenseg;

assign we_ram16k = we && (addr <= RAM_END ) && (addr >= RAM_START);

ram16k ram16k_u0(
	.aclr           (~rst_n),       // async clear
	.address        (addr[13:0]),   // address
	.clock          (clk50m),       // clk
	.data           (data_in),      // data auf data_in
	.wren           (we_ram16k),    // write enable fuer den ram wird nur gesetzt wenn addr <= RAM_END AND addr >= RAM_START
	.q              (data_out_ram16k)
);

// LED gruen
mem_slice
#(
    .ADDRESS        (LEDG)
)
mem_slice_ledg
(
    .rst_n          (rst_n),  
    .clk50m         (clk50m), 
    .addr           (addr),   
    .data_in        (data_in),
    .we             (we),     
    .data_out       (data_out_ledg)
);

// LED Rot
mem_slice
#(
    .ADDRESS        (LEDR)
)
mem_slice_ledr
(
    .rst_n          (rst_n),  
    .clk50m         (clk50m), 
    .addr           (addr),   
    .data_in        (data_in),
    .we             (we),     
    .data_out       (data_out_ledr)
);

// Sieben segment anzeige
mem_slice
#(
    .ADDRESS        (SEVENSEG)
)
mem_slice_sevenseg
(
    .rst_n          (rst_n),  
    .clk50m         (clk50m), 
    .addr           (addr),   
    .data_in        (data_in),
    .we             (we),     
    .data_out       (data_out_sevenseg)
);

// output muxer for data_out
always_comb begin
    if ((addr >= RAM_START) && (addr <= RAM_END)) data_out = data_out_ram16k;
    else if(addr == LEDG)       data_out = data_out_ledg;
    else if(addr == LEDR)       data_out = data_out_ledr;
    else if(addr == SEVENSEG)   data_out = data_out_sevenseg;
    else if(addr == SW0)        data_out = reg0x7400;
    else if(addr == SW1)        data_out = reg0x7401;
    else if(addr == KEY)        data_out = reg0x7402;
    else                        data_out = '0;
end

assign reg0x7000 = data_out_ledg;
assign reg0x7001 = data_out_ledr;
assign reg0x7002 = data_out_sevenseg;

endmodule