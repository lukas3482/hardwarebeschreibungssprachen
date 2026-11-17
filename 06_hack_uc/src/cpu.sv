module cpu #(
    parameter int DW = 16,      // Datenbreite
    parameter int AW = 15,      // Breite Datenadresse
    parameter int PW = 15       // Breite Program Counter
)(
    input  logic          rst_n,
    input  logic          clk50m,
    input  logic          en25m,
    input  logic [DW-1:0] instr,
    input  logic [DW-1:0] inM,
    output logic          writeM,
    output logic [DW-1:0] outM,
    output logic [AW-1:0] addressM,
    output logic [PW-1:0] pc
);

// Decoder
logic          instr_type;
logic [DW-1:0] instr_v;
logic          cmd_a;
logic          cmd_c1, cmd_c2, cmd_c3, cmd_c4, cmd_c5, cmd_c6;
logic          cmd_d1, cmd_d2, cmd_d3;
logic          cmd_j1, cmd_j2, cmd_j3;

// Datenpfad
logic          aload, dload, mload;
logic [DW-1:0] ad;
logic [DW-1:0] a, d, m;
logic [DW-1:0] alu_y;
logic [DW-1:0] alu_out;
logic          alu_zr, alu_ng;
logic          pc_load, pc_inc;

instr_demux #(.DW(DW)) u_instr_demux (
    .instr      (instr),
    .instr_type (instr_type),
    .instr_v    (instr_v),
    .cmd_a      (cmd_a),
    .cmd_c1     (cmd_c1),
    .cmd_c2     (cmd_c2),
    .cmd_c3     (cmd_c3),
    .cmd_c4     (cmd_c4),
    .cmd_c5     (cmd_c5),
    .cmd_c6     (cmd_c6),
    .cmd_d1     (cmd_d1),
    .cmd_d2     (cmd_d2),
    .cmd_d3     (cmd_d3),
    .cmd_j1     (cmd_j1),
    .cmd_j2     (cmd_j2),
    .cmd_j3     (cmd_j3)
);

assign dload = cmd_d2;
assign mload = cmd_d3;
assign m     = inM;

// A-Register: A-Befehl lädt immer instr_v, C-Befehl lädt alu_out bei d1
assign aload = instr_type ? cmd_d1  : 1'b1;
assign ad    = instr_type ? alu_out : instr_v;

// Vorlagen-Register haben keinen Enable-Eingang -> en25m wird mit load verknüpft
dreg #(.W(DW)) u_a (
    .rst_n  (rst_n),
    .clk50m (clk50m),
    .load   (aload & en25m),
    .d      (ad),
    .q      (a)
);

dreg #(.W(DW)) u_d (
    .rst_n  (rst_n),
    .clk50m (clk50m),
    .load   (dload & en25m),
    .d      (alu_out),
    .q      (d)
);

// a-Bit wählt zwischen A und M
assign alu_y = cmd_a ? m : a;

alu #(.W(DW)) u_alu (
    .x   (d),
    .y   (alu_y),
    .zx  (cmd_c1),
    .nx  (cmd_c2),
    .zy  (cmd_c3),
    .ny  (cmd_c4),
    .f   (cmd_c5),
    .no  (cmd_c6),
    .out (alu_out),
    .zr  (alu_zr),
    .ng  (alu_ng)
);

jmp_ctrl u_jmp_ctrl (
    .j1      (cmd_j1),
    .j2      (cmd_j2),
    .j3      (cmd_j3),
    .neg     (alu_ng),
    .zero    (alu_zr),
    .pc_load (pc_load),
    .pc_inc  (pc_inc)
);

pcount #(.W(PW)) u_pcount (
    .rst_n  (rst_n),
    .clk50m (clk50m),
    .load   (pc_load & en25m),
    .inc    (pc_inc  & en25m),
    .cnt_in (a[PW-1:0]),
    .cnt    (pc)
);

assign writeM   = mload;
assign outM     = alu_out;
assign addressM = a[AW-1:0];

endmodule
