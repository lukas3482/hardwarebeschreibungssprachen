module tb_cpu();

localparam int  DW       = 16;
localparam int  AW       = 15;
localparam int  PW       = 15;
localparam time T_CLK    = 20ns;    // 50 MHz

logic          tb_rst_n;
logic          tb_clk50m;
logic          tb_en25m;
logic [DW-1:0] tb_instr;
logic [DW-1:0] tb_inM;
logic          tb_writeM;
logic [DW-1:0] tb_outM;
logic [AW-1:0] tb_addressM;
logic [PW-1:0] tb_pc;

// Erwartungswerte (für das Wave-Fenster)
logic [DW-1:0] tb_exp_outM;
logic          tb_exp_writeM;
logic [AW-1:0] tb_exp_addressM;
logic [PW-1:0] tb_exp_pc;
logic [DW-1:0] tb_exp_a;
logic [DW-1:0] tb_exp_d;
int            errors = 0;

cpu #(.DW(DW), .AW(AW), .PW(PW)) dut (
    .rst_n    (tb_rst_n),
    .clk50m   (tb_clk50m),
    .en25m    (tb_en25m),
    .instr    (tb_instr),
    .inM      (tb_inM),
    .writeM   (tb_writeM),
    .outM     (tb_outM),
    .addressM (tb_addressM),
    .pc       (tb_pc)
);

// Takt 50 MHz und Enable 25 MHz (jede zweite Flanke)
initial tb_clk50m = 1'b0;
always #(T_CLK/2) tb_clk50m = ~tb_clk50m;

always_ff @(posedge tb_clk50m or negedge tb_rst_n) begin
    if (!tb_rst_n)
        tb_en25m <= 1'b0;
    else
        tb_en25m <= ~tb_en25m;
end

task automatic check(input string name, input string sig, input logic [DW-1:0] act, input logic [DW-1:0] exp);
    if (act !== exp) begin
        errors++;
        $error("FAIL %-12s %-8s = 0x%h | erwartet 0x%h", name, sig, act, exp);
    end
endtask

// Befehl während eines Enable-Takts anlegen.
// Vor der Flanke: outM, writeM, addressM (kombinatorisch)
// Nach der Flanke: pc, A, D
task automatic exec(input string name, input logic [DW-1:0] instr, input logic [DW-1:0] inM,
                    input logic [DW-1:0] exp_outM, input logic exp_writeM, input logic [AW-1:0] exp_addressM,
                    input logic [PW-1:0] exp_pc, input logic [DW-1:0] exp_a, input logic [DW-1:0] exp_d);
    int            err_before = errors;
    logic [DW-1:0] outM;
    logic          writeM;
    // fallende Flanke abwarten, nach der die nächste steigende Flanke aktiv ist
    do @(negedge tb_clk50m); while (tb_en25m !== 1'b1);
    tb_instr        = instr;
    tb_inM          = inM;
    tb_exp_outM     = exp_outM;
    tb_exp_writeM   = exp_writeM;
    tb_exp_addressM = exp_addressM;
    #1ns;
    check(name, "outM",     tb_outM,     exp_outM);
    check(name, "writeM",   tb_writeM,   exp_writeM);
    check(name, "addressM", tb_addressM, exp_addressM);
    outM   = tb_outM;
    writeM = tb_writeM;
    @(posedge tb_clk50m);
    #1ns;
    tb_exp_pc = exp_pc;
    tb_exp_a  = exp_a;
    tb_exp_d  = exp_d;
    check(name, "pc",       tb_pc,       exp_pc);
    check(name, "A",        dut.a,       exp_a);
    check(name, "D",        dut.d,       exp_d);
    if (errors == err_before)
        $display("OK   %-12s instr=0x%h inM=0x%h | outM=0x%h writeM=%b addressM=0x%h | pc=0x%h A=0x%h D=0x%h",
                 name, instr, inM, outM, writeM, exp_addressM, tb_pc, dut.a, dut.d);
endtask

initial begin
    tb_rst_n        = 1'b0;
    tb_instr        = '0;
    tb_inM          = '0;
    tb_exp_outM     = '0;
    tb_exp_writeM   = 1'b0;
    tb_exp_addressM = '0;
    tb_exp_pc       = '0;
    tb_exp_a        = '0;
    tb_exp_d        = '0;
    #(2*T_CLK + 5ns);
    tb_rst_n = 1'b1;

    // A-Befehl: alle Steuerbits 0 -> ALU rechnet D & A (writeM = 0, outM unbenutzt)
    //    name            instr                    inM       outM      wrM   addrM     pc        A         D
    // Befehle aus Table 1
    exec("@32767",       16'b0111_1111_1111_1111, 16'h0000, 16'h0000, 1'b0, 15'h0000, 15'h0001, 16'h7fff, 16'h0000);
    exec("D=1",          16'b111_0_111111_010_000, 16'h0000, 16'h0001, 1'b0, 15'h7fff, 15'h0002, 16'h7fff, 16'h0001);
    exec("D=D+A",        16'b111_0_000010_010_000, 16'h0000, 16'h8000, 1'b0, 15'h7fff, 15'h0003, 16'h7fff, 16'h8000);
    exec("@0",           16'b0000_0000_0000_0000, 16'h0000, 16'h0000, 1'b0, 15'h7fff, 15'h0004, 16'h0000, 16'h8000);
    exec("M=A+1",        16'b111_0_110111_001_000, 16'h0000, 16'h0001, 1'b1, 15'h0000, 15'h0005, 16'h0000, 16'h8000);

    // a = 1: ALU rechnet mit inM
    exec("D=M",          16'b111_1_110000_010_000, 16'h1234, 16'h1234, 1'b0, 15'h0000, 15'h0006, 16'h0000, 16'h1234);

    // Sprünge (Ziel steht in A)
    exec("@20",          16'd20,                   16'h0000, 16'h0000, 1'b0, 15'h0000, 15'h0007, 16'd20,   16'h1234);
    exec("D;JLT (nein)", 16'b111_0_001100_000_100, 16'h0000, 16'h1234, 1'b0, 15'd20,   15'h0008, 16'd20,   16'h1234);
    exec("D;JGT (ja)",   16'b111_0_001100_000_001, 16'h0000, 16'h1234, 1'b0, 15'd20,   15'd20,   16'd20,   16'h1234);
    exec("@3",           16'd3,                    16'h0000, 16'h0014, 1'b0, 15'd20,   15'd21,   16'd3,    16'h1234);
    exec("0;JMP",        16'b111_0_101010_000_111, 16'h0000, 16'h0000, 1'b0, 15'd3,    15'd3,    16'd3,    16'h1234);
    exec("D=0",          16'b111_0_101010_010_000, 16'h0000, 16'h0000, 1'b0, 15'd3,    15'd4,    16'd3,    16'h0000);
    exec("@7",           16'd7,                    16'h0000, 16'h0000, 1'b0, 15'd3,    15'd5,    16'd7,    16'h0000);
    exec("D;JNE (nein)", 16'b111_0_001100_000_101, 16'h0000, 16'h0000, 1'b0, 15'd7,    15'd6,    16'd7,    16'h0000);
    exec("D;JEQ (ja)",   16'b111_0_001100_000_010, 16'h0000, 16'h0000, 1'b0, 15'd7,    15'd7,    16'd7,    16'h0000);

    // alle Ziele gleichzeitig, A wird negativ -> addressM nur untere 15 Bit
    exec("AMD=-1",       16'b111_0_111010_111_000, 16'h0000, 16'hffff, 1'b1, 15'd7,    15'd8,    16'hffff, 16'hffff);
    exec("D;JLT (ja)",   16'b111_0_001100_000_100, 16'h0000, 16'hffff, 1'b0, 15'h7fff, 15'h7fff, 16'hffff, 16'hffff);
    exec("D;JGE (nein)", 16'b111_0_001100_000_011, 16'h0000, 16'hffff, 1'b0, 15'h7fff, 15'h0000, 16'hffff, 16'hffff);

    // Reset setzt pc, A und D zurück
    @(negedge tb_clk50m);
    tb_rst_n = 1'b0;
    #1ns;
    check("reset", "pc", tb_pc, '0);
    check("reset", "A",  dut.a, '0);
    check("reset", "D",  dut.d, '0);
    $display("%-4s %-12s pc=0x%h A=0x%h D=0x%h", (tb_pc == 0 && dut.a == 0 && dut.d == 0) ? "OK" : "FAIL",
             "reset", tb_pc, dut.a, dut.d);

    if (errors == 0)
        $display("PASS: alle Tests bestanden");
    else
        $display("FAIL: %0d Fehler", errors);
    $stop;
end

endmodule
