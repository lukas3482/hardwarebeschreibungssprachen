module ram64x8bit
(
    input   logic[5:0] addr,
    input   logic[7:0] data_in,
    input   logic we,               // -> write enable
    output  logic[7:0] data_out
);

logic [7:0] mem [0:63];         // Speicher 
//      |           |
//    word with     |
//                mem depth


always_comb begin
    if (we) begin
        mem[addr] = data_in;
    end 
end

assign data_out = mem[addr];



endmodule