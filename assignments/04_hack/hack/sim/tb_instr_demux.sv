module tb_instr_demux();

localparam int DW = 16;

logic [DW-1:0] tb_instr;
logic          tb_instr_type;
logic [DW-1:0] tb_instr_v;
logic          tb_cmd_a;
logic          tb_cmd_c1, tb_cmd_c2, tb_cmd_c3, tb_cmd_c4, tb_cmd_c5, tb_cmd_c6;
logic          tb_cmd_d1, tb_cmd_d2, tb_cmd_d3;
logic          tb_cmd_j1, tb_cmd_j2, tb_cmd_j3;

// Steuerbits zusammengefasst: a c1..c6 d1..d3 j1..j3
logic [12:0]   tb_cmd;
logic [12:0]   tb_exp_cmd;
logic          tb_exp_type;
logic [DW-1:0] tb_exp_v;
int            errors = 0;

instr_demux #(.DW(DW)) dut (
    .instr      (tb_instr),
    .instr_type (tb_instr_type),
    .instr_v    (tb_instr_v),
    .cmd_a      (tb_cmd_a),
    .cmd_c1     (tb_cmd_c1),
    .cmd_c2     (tb_cmd_c2),
    .cmd_c3     (tb_cmd_c3),
    .cmd_c4     (tb_cmd_c4),
    .cmd_c5     (tb_cmd_c5),
    .cmd_c6     (tb_cmd_c6),
    .cmd_d1     (tb_cmd_d1),
    .cmd_d2     (tb_cmd_d2),
    .cmd_d3     (tb_cmd_d3),
    .cmd_j1     (tb_cmd_j1),
    .cmd_j2     (tb_cmd_j2),
    .cmd_j3     (tb_cmd_j3)
);

assign tb_cmd = {tb_cmd_a,
                 tb_cmd_c1, tb_cmd_c2, tb_cmd_c3, tb_cmd_c4, tb_cmd_c5, tb_cmd_c6,
                 tb_cmd_d1, tb_cmd_d2, tb_cmd_d3,
                 tb_cmd_j1, tb_cmd_j2, tb_cmd_j3};

task automatic check(input string name, input logic [DW-1:0] instr,
                     input logic exp_type, input logic [DW-1:0] exp_v, input logic [12:0] exp_cmd);
    tb_instr    = instr;
    tb_exp_type = exp_type;
    tb_exp_v    = exp_v;
    tb_exp_cmd  = exp_cmd;
    #100ns;
    if (tb_instr_type !== exp_type || tb_instr_v !== exp_v || tb_cmd !== exp_cmd) begin
        errors++;
        $error("FAIL %-10s instr=%b | type=%b v=0x%h a_c_d_j=%b_%b_%b_%b | erwartet type=%b v=0x%h a_c_d_j=%b_%b_%b_%b",
               name, instr, tb_instr_type, tb_instr_v,
               tb_cmd[12], tb_cmd[11:6], tb_cmd[5:3], tb_cmd[2:0],
               exp_type, exp_v, exp_cmd[12], exp_cmd[11:6], exp_cmd[5:3], exp_cmd[2:0]);
    end else begin
        $display("OK   %-10s instr=%b | type=%b v=0x%h a_c_d_j=%b_%b_%b_%b",
                 name, instr, tb_instr_type, tb_instr_v,
                 tb_cmd[12], tb_cmd[11:6], tb_cmd[5:3], tb_cmd[2:0]);
    end
endtask

initial begin
    tb_instr    = '0;
    tb_exp_type = 1'b0;
    tb_exp_v    = '0;
    tb_exp_cmd  = '0;
    #100ns;

    //                     instr                    type  instr_v   a_c_d_j
    // Befehle aus Table 1
    check("@32767",   16'b0111_1111_1111_1111,      1'b0, 16'h7fff, 13'b0_000000_000_000);
    check("@0",       16'b0000_0000_0000_0000,      1'b0, 16'h0000, 13'b0_000000_000_000);
    check("D=1",      16'b111_0_111111_010_000,     1'b1, 16'h6fd0, 13'b0_111111_010_000);
    check("D=D+A",    16'b111_0_000010_010_000,     1'b1, 16'h6090, 13'b0_000010_010_000);
    check("M=A+1",    16'b111_0_110111_001_000,     1'b1, 16'h6dc8, 13'b0_110111_001_000);
    // zusätzlich: a = 1, alle dest-Bits und Sprungbits
    check("AMD=M-1",  16'b111_1_110010_111_000,     1'b1, 16'h7cb8, 13'b1_110010_111_000);
    check("0;JMP",    16'b111_0_101010_000_111,     1'b1, 16'h6a87, 13'b0_101010_000_111);
    // A-Befehl mit gesetzten unteren Bits: Steuerbits müssen 0 bleiben
    check("@8191",    16'b0001_1111_1111_1111,      1'b0, 16'h1fff, 13'b0_000000_000_000);

    if (errors == 0)
        $display("PASS: alle Tests bestanden");
    else
        $display("FAIL: %0d Fehler", errors);
    $stop;
end

endmodule
