module tb_alu();

localparam int W = 16;

logic [W-1:0] tb_x;
logic [W-1:0] tb_y;
logic [5:0]   tb_cmd; 
logic [W-1:0] tb_out;
logic         tb_zr;
logic         tb_ng;

logic [W-1:0] tb_exp;
int           errors = 0;

// control bits laut Figure 2
localparam logic [5:0] C_ZERO   = 6'b101010;
localparam logic [5:0] C_ONE    = 6'b111111; 
localparam logic [5:0] C_M_ONE  = 6'b111010; 
localparam logic [5:0] C_NOT_X  = 6'b001101;
localparam logic [5:0] C_NEG_X  = 6'b001111;
localparam logic [5:0] C_X_ADD_Y= 6'b000010; 
localparam logic [5:0] C_X_SUB_Y= 6'b010011;
localparam logic [5:0] C_X_AND_Y= 6'b000000;
localparam logic [5:0] C_X_OR_Y = 6'b010101;

alu #(.W(W)) dut (
    .x      (tb_x),
    .y      (tb_y),
    .zx     (tb_cmd[5]),
    .nx     (tb_cmd[4]),
    .zy     (tb_cmd[3]),
    .ny     (tb_cmd[2]),
    .f      (tb_cmd[1]),
    .no     (tb_cmd[0]),
    .out    (tb_out),
    .zr     (tb_zr),
    .ng     (tb_ng)
);

task automatic check(input string name, input logic [W-1:0] x, input logic [W-1:0] y,
                     input logic [5:0] cmd, input logic [W-1:0] exp);
    logic exp_zr, exp_ng;
    tb_x   = x;
    tb_y   = y;
    tb_cmd = cmd;
    tb_exp = exp;
    exp_zr = (exp == '0);
    exp_ng = exp[W-1];
    #100ns;
    if (tb_out !== exp || tb_zr !== exp_zr || tb_ng !== exp_ng) begin
        errors++;
        $error("FAIL %-14s cmd=%b | out=%6d (0x%h) zr=%b ng=%b | erwartet out=%6d (0x%h) zr=%b ng=%b",
               name, cmd, $signed(tb_out), tb_out, tb_zr, tb_ng, $signed(exp), exp, exp_zr, exp_ng);
    end else begin
        $display("OK   %-14s cmd=%b | out=%6d (0x%h) zr=%b ng=%b",
                 name, cmd, $signed(tb_out), tb_out, tb_zr, tb_ng);
    end
endtask

initial begin
    tb_x   = '0;
    tb_y   = '0;
    tb_cmd = '0;
    tb_exp = '0;
    #100ns;

    check("1 + 2",        16'd1,    16'd2,    C_X_ADD_Y, 16'd3);
    check("100 - 50",     16'd100,  16'd50,   C_X_SUB_Y, 16'd50);
    check("50 - 100",     16'd50,   16'd100,  C_X_SUB_Y, -16'sd50);
    check("0",            16'h1234, 16'h5678, C_ZERO,    16'd0);
    check("0xaa & 0x55",  16'h00aa, 16'h0055, C_X_AND_Y, 16'h0000);
    check("0xaa | 0x55",  16'h00aa, 16'h0055, C_X_OR_Y,  16'h00ff);
    check("-1",           16'h1234, 16'h5678, C_M_ONE,   -16'sd1);
    check("!255",         16'd255,  16'd0,    C_NOT_X,   16'hff00);
    check("-255",         16'd255,  16'd0,    C_NEG_X,   -16'sd255);

    if (errors == 0)
        $display("PASS: alle Tests bestanden");
    else
        $display("FAIL: %0d Fehler", errors);
    $stop;
end

endmodule
