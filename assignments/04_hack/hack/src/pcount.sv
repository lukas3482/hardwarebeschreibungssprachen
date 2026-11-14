module pcount #(
    parameter int W = 15
)(
    input  logic         rst_n,
    input  logic         clk50m,
    input  logic         en,
    input  logic         load,
    input  logic         inc,
    input  logic [W-1:0] cnt_in,
    output logic [W-1:0] cnt
);

// Priorität: Reset > Load > Inc > Halten
always_ff @(posedge clk50m or negedge rst_n) begin
    if (!rst_n)
        cnt <= '0;
    else if (load && en)
        cnt <= cnt_in;
    else if (inc && en)
        cnt <= cnt + 1'b1;     // läuft bei 2^W-1 auf 0 über
end

endmodule
