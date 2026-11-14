module alu #(
    parameter int W = 16
)(
    input  logic [W-1:0] x,
    input  logic [W-1:0] y,
    input  logic         zx,
    input  logic         nx,
    input  logic         zy, 
    input  logic         ny, 
    input  logic         f,
    input  logic         no,
    output logic [W-1:0] out,
    output logic         zr, 
    output logic         ng  
);

logic [W-1:0] x_zx, x_nx; 
logic [W-1:0] y_zy, y_ny;
logic [W-1:0] f_out; 
logic [W-1:0] no_out;

always_comb begin
    x_zx = zx ? '0    : x;
    x_nx = nx ? ~x_zx : x_zx;

    y_zy = zy ? '0    : y;
    y_ny = ny ? ~y_zy : y_zy;

    f_out = f ? (x_nx + y_ny) : (x_nx & y_ny);

    no_out = no ? ~f_out : f_out;
end

assign out = no_out;

assign zr = (out == '0);
assign ng = out[W-1];       // MSB = Vorzeichenbit (Zweierkomplement)

endmodule
