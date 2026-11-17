/*------------------------------
Projekt: Hack Computer
Purpose: Translate binary number to seven segment display
Author: ANM
Version: v01
--------------------------------*/



module sevenseg(
    input   logic   [3:0]               bin_i,
    output  logic   [6:0]               hex_o,
    output  logic   [6:0]               hex_no
);

always_comb begin
    case (bin_i)
    //                gfe_dcba
    4'd0 :   hex_o = 7'b011_1111;
    4'd1 :   hex_o = 7'b000_0110;
    4'd2 :   hex_o = 7'b101_1011;
    4'd3 :   hex_o = 7'b100_1111;
    4'd4 :   hex_o = 7'b110_0110;
    4'd5 :   hex_o = 7'b110_1101;
    4'd6 :   hex_o = 7'b111_1101;
    4'd7 :   hex_o = 7'b000_0111;
    4'd8 :   hex_o = 7'b111_1111;
    4'd9 :   hex_o = 7'b110_1111;
    4'd10:   hex_o = 7'b111_0111; //A
    4'd11:   hex_o = 7'b111_1100; //b
    4'd12:   hex_o = 7'b011_1001; //C
    4'd13:   hex_o = 7'b101_1110; //d
    4'd14:   hex_o = 7'b111_1001; //E
    4'd15:   hex_o = 7'b111_0001; //F
    default: hex_o = 7'b000_0000;    // default is required to ensure combin_iatorial synthesis
    endcase
end

assign hex_no = ~hex_o;     // bit wise inversion for active low displays

endmodule