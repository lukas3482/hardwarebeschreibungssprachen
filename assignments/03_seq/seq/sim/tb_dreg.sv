module tb_dreg();

localparam int  W        = 16;
localparam time T_CLK    = 20ns;    // 50 MHz

logic         tb_rst_n;
logic         tb_clk50m;
logic         tb_en;
logic         tb_load;
logic [W-1:0] tb_d;
logic [W-1:0] tb_q;

logic [W-1:0] tb_exp;
int           errors = 0;

dreg #(.W(W)) dut (
    .rst_n  (tb_rst_n),
    .clk50m (tb_clk50m),
    .en     (tb_en),
    .load   (tb_load),
    .d      (tb_d),
    .q      (tb_q)
);

// Takt
initial tb_clk50m = 1'b0;
always #(T_CLK/2) tb_clk50m = ~tb_clk50m;

// q mit Erwartungswert vergleichen
task automatic check(input string name, input logic [W-1:0] exp);
    tb_exp = exp;
    if (tb_q !== exp) begin
        errors++;
        $error("FAIL %-22s rst_n=%b en=%b load=%b d=0x%h | q=0x%h | erwartet q=0x%h",
               name, tb_rst_n, tb_en, tb_load, tb_d, tb_q, exp);
    end else begin
        $display("OK   %-22s rst_n=%b en=%b load=%b d=0x%h | q=0x%h",
                 name, tb_rst_n, tb_en, tb_load, tb_d, tb_q);
    end
endtask

// Eingänge bei fallender Flanke anlegen, nach der steigenden Flanke prüfen
task automatic clk_step(input string name, input logic en, input logic load,
                        input logic [W-1:0] d, input logic [W-1:0] exp);
    @(negedge tb_clk50m);
    tb_en   = en;
    tb_load = load;
    tb_d    = d;
    @(posedge tb_clk50m);
    #1ns;
    check(name, exp);
endtask

initial begin
    tb_rst_n = 1'b0;
    tb_en    = 1'b0;
    tb_load  = 1'b0;
    tb_d     = '0;
    tb_exp   = '0;

    // Reset aktiv: Register bleibt 0, obwohl load & en gesetzt sind
    #1ns;
    check("reset", 16'h0000);
    clk_step("reset, load=1 en=1",   1'b1, 1'b1, 16'hffff, 16'h0000);
    clk_step("reset, load=1 en=1",   1'b1, 1'b1, 16'haa55, 16'h0000);

    tb_rst_n = 1'b1;        // Reset loslassen (zwischen zwei Flanken)

    // Laden der geforderten Werte
    clk_step("load 0x0000",          1'b1, 1'b1, 16'h0000, 16'h0000);
    clk_step("load 0xffff",          1'b1, 1'b1, 16'hffff, 16'hffff);
    clk_step("load 0xaa55",          1'b1, 1'b1, 16'haa55, 16'haa55);
    clk_step("load 0x55aa",          1'b1, 1'b1, 16'h55aa, 16'h55aa);

    // Halten: load = 0 bzw. en = 0
    clk_step("hold (load=0)",        1'b1, 1'b0, 16'h1234, 16'h55aa);
    clk_step("hold (en=0)",          1'b0, 1'b1, 16'h1234, 16'h55aa);
    clk_step("hold (load=0, en=0)",  1'b0, 1'b0, 16'h1234, 16'h55aa);
    clk_step("load 0xffff",          1'b1, 1'b1, 16'hffff, 16'hffff);

    // asynchroner Reset: mitten in der Taktperiode, ohne Taktflanke
    @(posedge tb_clk50m);
    #(T_CLK/4);
    tb_rst_n = 1'b0;
    #1ns;
    check("async reset", 16'h0000);
    #(T_CLK);
    tb_rst_n = 1'b1;
    clk_step("load 0xaa55",          1'b1, 1'b1, 16'haa55, 16'haa55);

    if (errors == 0)
        $display("PASS: alle Tests bestanden");
    else
        $display("FAIL: %0d Fehler", errors);
    $stop;
end

endmodule
