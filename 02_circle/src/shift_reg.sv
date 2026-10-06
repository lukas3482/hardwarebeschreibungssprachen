// ---------------------------------------
// Project:     EIT HDL WS2026
// Purpose:     Circular shift register (rotating one-hot pattern)
// Author:      Lukas Wolf
// Version:     06.10.2026

module shift_reg
(
    input logic rst_ni,
    input logic clk_i,
    input logic shift_en_i,
    output logic [11:0] shift_out_o
);

always_ff @( negedge rst_ni or posedge clk_i ) begin
    // (1) async reset behavior
    if (!rst_ni) begin
        shift_out_o <= 12'b0000_0000_0001;  // start pattern: only bit 0 set
    end

    // (2) sync processing
    else if (shift_en_i) begin
        // rotate left: MSB wraps around to LSB
        shift_out_o <= {shift_out_o[10:0], shift_out_o[11]};
    end
end
endmodule
