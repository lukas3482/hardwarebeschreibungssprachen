module tb_counter_pwm();
    // (1) Declare signals to connect to the DUT
    logic       clk;
    logic       rst_n;
    logic       en;
    logic       load;
    logic [7:0] thr;
    logic [7:0] cnt;
    logic       pwm;

    // (2) Instantiate the DUT
    counter_pwm #(
        .BITS       (8),
        .PRELOAD    (8'h7f)
    ) dut (
        .clk_i      (clk),
        .res_ni     (rst_n),
        .en_i       (en),
        .load_i     (load),
        .thr_i      (thr),
        .cnt_o      (cnt),
        .pwm_o      (pwm)
    );

    // (3) Drive the DUT
    logic run_sim = 1'b1;
    initial begin
        clk = 1'b0;
        while(run_sim) begin
            #10ns;
            clk = ~clk; // Clock wird alle 10ns invertiert
        end
    end

    initial begin
        // init all signals at t=0
        rst_n = 1'b0;
        en    = 1'b0;
        load  = 1'b0;
        thr   = 8'd64;  // 25% Duty Cycle
        $display("Init done");
        #90ns;
        rst_n = 1'b1;
        $display("POR done");
        #100ns;
        en = 1'b1;
        $display("counting with thr = %d", thr);
        #12us;          // etwas mehr als eine volle Periode (hoch + runter)
        thr = 8'd192;   // 75% Duty Cycle
        $display("thr changed to %d", thr);
        #12us;
        run_sim = 1'b0;
        $display("sim stopped");
    end
endmodule
