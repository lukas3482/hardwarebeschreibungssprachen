// ---------------------------------------
// Project:     EIT HDL WS2026
// Purpose:     Prescaler to devide the clock
// Author:      Lukas Wolf
// Version:     06.10.2026

module prescaler
import prescaler_pkg::*;    // ::* -> import all elements
(
    input   logic       rst_ni,
    input   logic       clk_i,
    input   logic[2:0]  sel_i,
    output  logic       en_o
);

// internal singals
logic [NBITS-1:0]       cnt;
logic [NBITS-1:0]       preload_val;

always_comb begin
    case (sel_i)
        3'b000 : preload_val    = PRELOAD_0;
        3'b001 : preload_val    = PRELOAD_1;
        3'b010 : preload_val    = PRELOAD_2;
        3'b011 : preload_val    = PRELOAD_3;
        3'b100 : preload_val    = PRELOAD_4;
        3'b101 : preload_val    = PRELOAD_5;
        3'b110 : preload_val    = PRELOAD_6;
        default : preload_val   = PRELOAD_DEFAULT;
    endcase
end

// let's build the counter
always_ff @( negedge rst_ni or posedge clk_i ) begin
    // (1) async reset behavior
    if (!rst_ni) begin 
        cnt <= '0;      // reset all bits to zeros
        en_o <= 1'b0;
    end
    
    // (2) sync processing
    else if(cnt > '0) begin // Wenn counter > 0 dann cnt -1
        cnt <= cnt - 1'b1;
        en_o <= 1'b0;
    end
    else begin
        cnt <= preload_val; // Wenn counter == 0 dann cnt = preloadVal
        en_o <= 1'b1;
    end
end
endmodule