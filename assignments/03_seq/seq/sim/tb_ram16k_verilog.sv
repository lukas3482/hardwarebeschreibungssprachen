module tb_ram16k_verilog();

localparam int  AW       = 14;
localparam int  DW       = 16;
localparam int  DEPTH    = 1 << AW;
localparam time T_CLK    = 20ns;    // 50 MHz

logic          tb_aclr;
logic [AW-1:0] tb_address;
logic          tb_clock;
logic [DW-1:0] tb_data;
logic          tb_wren;
logic [DW-1:0] tb_q;

logic [DW-1:0] tb_exp;
int            errors = 0;

ram16k_verilog dut (
    .aclr    (tb_aclr),
    .address (tb_address),
    .clock   (tb_clock),
    .data    (tb_data),
    .wren    (tb_wren),
    .q       (tb_q)
);

// Takt
initial tb_clock = 1'b0;
always #(T_CLK/2) tb_clock = ~tb_clock;

// Erwartungswert je Testmuster
function automatic logic [DW-1:0] pattern(input int mode, input logic [AW-1:0] addr);
    case (mode)
        0:       return '0;              // alle Nullen
        1:       return '1;              // alle Einsen
        default: return {{(DW-AW){1'b0}}, addr};  // Wert = eigene Adresse
    endcase
endfunction

// ganzen Speicher mit dem Muster beschreiben (1 Wort pro Takt)
task automatic write_all(input int mode);
    for (int a = 0; a < DEPTH; a++) begin
        @(negedge tb_clock);
        tb_address = a;
        tb_data    = pattern(mode, tb_address);
        tb_wren    = 1'b1;
    end
    @(negedge tb_clock);
    tb_wren = 1'b0;
endtask

// ganzen Speicher auslesen und prüfen (Lesen ist asynchron)
task automatic check_all(input string name, input int mode);
    int err_before = errors;
    for (int a = 0; a < DEPTH; a++) begin
        @(negedge tb_clock);
        tb_address = a;
        tb_exp     = pattern(mode, tb_address);
        #1ns;
        if (tb_q !== tb_exp) begin
            errors++;
            if (errors - err_before <= 10)
                $error("FAIL %-14s addr=0x%h | q=0x%h | erwartet q=0x%h",
                       name, tb_address, tb_q, tb_exp);
        end
    end
    if (errors == err_before)
        $display("OK   %-14s %0d Adressen geprueft", name, DEPTH);
    else
        $display("FAIL %-14s %0d Fehler", name, errors - err_before);
endtask

initial begin
    tb_aclr    = 1'b0;
    tb_address = '0;
    tb_data    = '0;
    tb_wren    = 1'b0;
    tb_exp     = '0;
    #(2*T_CLK);

    write_all(0);
    check_all("alle Nullen", 0);

    write_all(1);
    check_all("alle Einsen", 1);

    write_all(2);
    check_all("Wert=Adresse", 2);

    // wren = 0 darf nichts verändern
    @(negedge tb_clock);
    tb_address = 14'h0abc;
    tb_data    = 16'hdead;
    tb_wren    = 1'b0;
    @(posedge tb_clock);
    #1ns;
    tb_exp = 16'h0abc;
    if (tb_q !== tb_exp) begin
        errors++;
        $error("FAIL %-14s addr=0x%h | q=0x%h | erwartet q=0x%h",
               "wren=0", tb_address, tb_q, tb_exp);
    end else begin
        $display("OK   %-14s addr=0x%h | q=0x%h", "wren=0", tb_address, tb_q);
    end

    if (errors == 0)
        $display("PASS: alle Tests bestanden");
    else
        $display("FAIL: %0d Fehler", errors);
    $stop;
end

endmodule
