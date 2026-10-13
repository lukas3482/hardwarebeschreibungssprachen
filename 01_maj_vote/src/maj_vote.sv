module maj_vote(
    // port list
    input logic x0,
    input logic x1,
    input logic x2,
    output logic y_gates,
    output logic y_behav
);

// let's implement the manual solution
assign y_gates = (x2&x1) | (x1&x0) | (x2&x0);

// internal signal declaration logic
logic [2:0] xbus;
assign xbus = {x2,x1,x0}; // concatenation

// let's describe the behavoir and let the toolchain do the harder part
always_comb begin
    case (xbus)
        3'b011 : y_behav = 1'b1;
        3'b101 : y_behav = 1'b1;
        3'b110 : y_behav = 1'b1;
        3'b111 : y_behav = 1'b1;
        default: y_behav = 1'b0;
    endcase

end

endmodule

// logic 0, 1, Z, x
// Case sensitive
// White spaces and tabs are uncritical
// Datentypen integers -> 123, 8'ha5 -> 8 Bits breit, hex -> a5
// 8'b0000_1010 -> 8bits binär -> 0000_1010