module sevenseg(
    input  logic [3:0] bin_i,
    output logic [6:0] hex_o,   
    output logic [6:0] hexn_o   
);

always_comb begin
    case (bin_i)
        4'h0   : hex_o = 7'b0111111;
        4'h1   : hex_o = 7'b0000110;
        4'h2   : hex_o = 7'b1011011;
        4'h3   : hex_o = 7'b1001111;
        4'h4   : hex_o = 7'b1100110;
        4'h5   : hex_o = 7'b1101101;
        4'h6   : hex_o = 7'b1111101;
        4'h7   : hex_o = 7'b0000111;
        4'h8   : hex_o = 7'b1111111;
        4'h9   : hex_o = 7'b1101111;
        4'hA   : hex_o = 7'b1110111;
        4'hB   : hex_o = 7'b1111100;
        4'hC   : hex_o = 7'b0111001;
        4'hD   : hex_o = 7'b1011110;
        4'hE   : hex_o = 7'b1111001;
        4'hF   : hex_o = 7'b1110001;
        default: hex_o = 7'b0000000;
    endcase
end

assign hexn_o = ~hex_o;
endmodule
