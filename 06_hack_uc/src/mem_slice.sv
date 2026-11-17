module mem_slice
#(
    parameter int DW = 16,
    parameter int AW = 15,
    parameter int ADDRESS = 15'h7000
)
(
    input logic             rst_n,
    input logic             clk50m,
    input logic [AW-1:0]    addr,
    input logic [DW-1:0]    data_in,
    input logic             we,
    output logic [DW-1:0]   data_out
);

// FF that stores data_in when addr == ADDRESS
always_ff @( posedge clk50m or negedge rst_n ) begin
    if (~rst_n) begin
        data_out <= '0;
    end
    else if ((addr == ADDRESS) && we) begin
        data_out <= data_in;
    end 
end
endmodule