module instr_demux #(
    parameter int DW = 16
)(
    input  logic [DW-1:0] instr,
    output logic          instr_type,   // 0 = A-Befehl, 1 = C-Befehl
    output logic [DW-1:0] instr_v,
    output logic          cmd_a,
    output logic          cmd_c1,
    output logic          cmd_c2,
    output logic          cmd_c3,
    output logic          cmd_c4,
    output logic          cmd_c5,
    output logic          cmd_c6,
    output logic          cmd_d1,
    output logic          cmd_d2,
    output logic          cmd_d3,
    output logic          cmd_j1,
    output logic          cmd_j2,
    output logic          cmd_j3
);

// C-Befehl: 1 1 1 a c1 c2 c3 c4 c5 c6 d1 d2 d3 j1 j2 j3
logic [12:0] cmd;

assign instr_type = instr[DW-1];
assign instr_v    = {1'b0, instr[DW-2:0]};

// bei A-Befehlen sind alle Steuerbits 0
assign cmd = instr_type ? instr[12:0] : '0;

assign {cmd_a,
        cmd_c1, cmd_c2, cmd_c3, cmd_c4, cmd_c5, cmd_c6,
        cmd_d1, cmd_d2, cmd_d3,
        cmd_j1, cmd_j2, cmd_j3} = cmd;

endmodule
