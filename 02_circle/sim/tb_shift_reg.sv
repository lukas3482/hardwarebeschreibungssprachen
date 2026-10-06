module tb_shift_reg();
    // (1) Declare signals to connect to the DUT
    logic           rst_n;
    logic           clk;
    logic           shift_en;
    logic [11:0]    shift_out;

    // (2) Instantiate the DUT
    shift_reg dut(
        .rst_ni         (rst_n),
        .clk_i          (clk),
        .shift_en_i     (shift_en),
        .shift_out_o    (shift_out)
    );

    // (3) Drive the DUT
    logic run_sim = 1'b1;
    initial begin
        clk = 1'b0;
        while(run_sim) begin
            #10ns;
            clk = ~clk; // Clock wird alle 10ns invertiert (Periode 20ns)
        end
    end

    // expected value for self-check
    logic [11:0] expected;

    initial begin
        // init all signals at t=0
        rst_n = 1'b0;
        shift_en = 1'b0;
        $display("Init done");
        #90ns;
        rst_n = 1'b1;
        $display("POR done");

        // check reset value
        @(negedge clk);
        expected = 12'b0000_0000_0001;
        if (shift_out !== expected)
            $error("Reset value wrong: %b (expected %b)", shift_out, expected);

        // shift_en = 0 -> value must hold
        repeat(3) @(negedge clk);
        if (shift_out !== expected)
            $error("Value changed without shift_en: %b", shift_out);

        // shift one full circle + 2 steps (14 shifts)
        shift_en = 1'b1;
        repeat(14) begin
            @(negedge clk);
            expected = {expected[10:0], expected[11]};
            $display("%t: shift_out = %b", $time, shift_out);
            if (shift_out !== expected)
                $error("Shift wrong: %b (expected %b)", shift_out, expected);
        end

        // pause shifting
        shift_en = 1'b0;
        repeat(3) @(negedge clk);
        if (shift_out !== expected)
            $error("Value changed during pause: %b", shift_out);

        // async reset in the middle of operation
        #3ns;
        rst_n = 1'b0;
        #1ns;
        if (shift_out !== 12'b0000_0000_0001)
            $error("Async reset failed: %b", shift_out);
        #20ns;
        rst_n = 1'b1;

        #100ns;
        run_sim = 1'b0;
        $display("sim stopped");
    end
endmodule
