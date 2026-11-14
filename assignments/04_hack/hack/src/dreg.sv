module dreg #(
    parameter int W = 16
)(
    input  logic         rst_n,
    input  logic         clk50m,
    input  logic         en,
    input  logic         load,
    input  logic [W-1:0] d,
    output logic [W-1:0] q
);

// asynchroner Reset (low aktiv), sonst Übernahme bei steigender Flanke
always_ff @(posedge clk50m or negedge rst_n) begin
    if (!rst_n)
        q <= '0;
    else if (load && en)
        q <= d;
    // sonst: q behält den Wert
end

endmodule
