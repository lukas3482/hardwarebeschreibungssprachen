module tb_sevenseg();

// (1) Declare signals to connect to the DUT
logic [3:0] tb_bin;
logic [6:0] tb_hex;
logic [6:0] tb_hexn;

// (2) Instantiate the DUT
sevenseg dut (
    .bin_i      (tb_bin),
    .hex_o      (tb_hex),
    .hexn_o     (tb_hexn)
);

// (3) Drive the DUT
initial begin
    tb_bin = 4'h0;
    #100ns;

    for(int i = 0; i <= 15; i++) begin
        tb_bin = i;
        #100ns;
        $display("bin_i = %h | hex_o = %b | hexn_o = %b", tb_bin, tb_hex, tb_hexn);
    end
end

endmodule
