module tb_pcount();

localparam int  W        = 15;
localparam time T_CLK    = 20ns;    // 50 MHz

logic         tb_rst_n;
logic         tb_clk50m;
logic         tb_en;
logic         tb_load;
logic         tb_inc;
logic [W-1:0] tb_cnt_in;
logic [W-1:0] tb_cnt;

logic [W-1:0] tb_exp;
int           errors = 0;

pcount #(.W(W)) dut (
    .rst_n  (tb_rst_n),
    .clk50m (tb_clk50m),
    .en     (tb_en),
    .load   (tb_load),
    .inc    (tb_inc),
    .cnt_in (tb_cnt_in),
    .cnt    (tb_cnt)
);

// Takt
initial tb_clk50m = 1'b0;
always #(T_CLK/2) tb_clk50m = ~tb_clk50m;

// cnt mit Erwartungswert vergleichen
task automatic check(input string name, input logic [W-1:0] exp);
    tb_exp = exp;
    if (tb_cnt !== exp) begin
        errors++;
        $error("FAIL %-22s rst_n=%b en=%b load=%b inc=%b cnt_in=0x%h | cnt=0x%h | erwartet cnt=0x%h",
               name, tb_rst_n, tb_en, tb_load, tb_inc, tb_cnt_in, tb_cnt, exp);
    end else begin
        $display("OK   %-22s rst_n=%b en=%b load=%b inc=%b cnt_in=0x%h | cnt=0x%h",
                 name, tb_rst_n, tb_en, tb_load, tb_inc, tb_cnt_in, tb_cnt);
    end
endtask

// Eingänge bei fallender Flanke anlegen, nach der steigenden Flanke prüfen
task automatic clk_step(input string name, input logic en, input logic load, input logic inc,
                        input logic [W-1:0] cnt_in, input logic [W-1:0] exp);
    @(negedge tb_clk50m);
    tb_en     = en;
    tb_load   = load;
    tb_inc    = inc;
    tb_cnt_in = cnt_in;
    @(posedge tb_clk50m);
    #1ns;
    check(name, exp);
endtask

initial begin
    tb_rst_n  = 1'b0;
    tb_en     = 1'b0;
    tb_load   = 1'b0;
    tb_inc    = 1'b0;
    tb_cnt_in = '0;
    tb_exp    = '0;

    // Reset aktiv: Zähler bleibt 0, obwohl load / inc gesetzt sind
    #1ns;
    check("reset", 15'h0000);
    clk_step("reset, inc=1",          1'b1, 1'b0, 1'b1, 15'h0000, 15'h0000);
    clk_step("reset, load=1",         1'b1, 1'b1, 1'b0, 15'h1234, 15'h0000);

    tb_rst_n = 1'b1;        // Reset loslassen (zwischen zwei Flanken)

    // Inkrementieren ab 0
    clk_step("inc",                   1'b1, 1'b0, 1'b1, 15'h1234, 15'h0001);
    clk_step("inc",                   1'b1, 1'b0, 1'b1, 15'h1234, 15'h0002);
    clk_step("inc",                   1'b1, 1'b0, 1'b1, 15'h1234, 15'h0003);

    // Laden
    clk_step("load 0x1234",           1'b1, 1'b1, 1'b0, 15'h1234, 15'h1234);
    clk_step("inc",                   1'b1, 1'b0, 1'b1, 15'h0000, 15'h1235);
    clk_step("load hat Vorrang",      1'b1, 1'b1, 1'b1, 15'h0100, 15'h0100);
    clk_step("inc",                   1'b1, 1'b0, 1'b1, 15'h0000, 15'h0101);

    // Halten
    clk_step("hold (inc=0, load=0)",  1'b1, 1'b0, 1'b0, 15'h2222, 15'h0101);
    clk_step("hold (en=0, inc=1)",    1'b0, 1'b0, 1'b1, 15'h2222, 15'h0101);
    clk_step("hold (en=0, load=1)",   1'b0, 1'b1, 1'b0, 15'h2222, 15'h0101);

    // Überlauf 0x7fff -> 0x0000
    clk_step("load 0x7ffe",           1'b1, 1'b1, 1'b0, 15'h7ffe, 15'h7ffe);
    clk_step("inc",                   1'b1, 1'b0, 1'b1, 15'h0000, 15'h7fff);
    clk_step("inc (Ueberlauf)",       1'b1, 1'b0, 1'b1, 15'h0000, 15'h0000);

    // 16 Takte zählen
    for (logic [W-1:0] i = 1; i <= 16; i++)
        clk_step("inc",               1'b1, 1'b0, 1'b1, 15'h0000, i);

    // asynchroner Reset: mitten in der Taktperiode, ohne Taktflanke
    @(posedge tb_clk50m);
    #(T_CLK/4);
    tb_rst_n = 1'b0;
    #1ns;
    check("async reset", 15'h0000);
    #(T_CLK);
    tb_rst_n = 1'b1;
    clk_step("inc",                   1'b1, 1'b0, 1'b1, 15'h0000, 15'h0001);

    if (errors == 0)
        $display("PASS: alle Tests bestanden");
    else
        $display("FAIL: %0d Fehler", errors);
    $stop;
end

endmodule
