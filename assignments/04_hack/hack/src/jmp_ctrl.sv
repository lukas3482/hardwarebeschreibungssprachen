module jmp_ctrl (
    input  logic cmd_j1,    // springen wenn out < 0
    input  logic cmd_j2,    // springen wenn out = 0
    input  logic cmd_j3,    // springen wenn out > 0
    input  logic alu_zr,
    input  logic alu_ng,
    output logic pc_load,
    output logic pc_inc
);

logic alu_pos;

assign alu_pos = ~alu_zr & ~alu_ng;

assign pc_load = (cmd_j1 & alu_ng) | (cmd_j2 & alu_zr) | (cmd_j3 & alu_pos);
assign pc_inc  = ~pc_load;

endmodule
