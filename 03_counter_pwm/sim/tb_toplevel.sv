module tb_toplevel();
    // (1) Declare signals to connect to the DUT
    logic       clk;
    logic       rst_n;
    logic [3:0] key;
    logic [9:0] sw;
    logic [9:0] ledr;
    logic [7:0] ledg;
    logic [6:0] hex0, hex1, hex2, hex3;
    logic       uart_tx;

    // (2) Instantiate the DUT
    toplevel_c5g_hex4_uart dut (
        .CLOCK_125_p    (1'b0),
        .CLOCK_50_B5B   (clk),
        .CLOCK_50_B6A   (1'b0),
        .CLOCK_50_B7A   (1'b0),
        .CLOCK_50_B8A   (1'b0),
        .LEDG           (ledg),
        .LEDR           (ledr),
        .CPU_RESET_n    (rst_n),
        .KEY            (key),
        .SW             (sw),
        .HEX0           (hex0),
        .HEX1           (hex1),
        .HEX2           (hex2),
        .HEX3           (hex3),
        .UART_RX        (1'b1),
        .UART_TX        (uart_tx)
    );

    // (3) Drive the DUT
    logic run_sim = 1'b1;
    initial begin
        clk = 1'b0;
        while(run_sim) begin
            #10ns;
            clk = ~clk; // 50 MHz
        end
    end

    // Der echte Prescaler gibt hoechstens alle 10 ms ein Enable aus -> viel zu
    // langsam fuer die Simulation. Darum wird cnt_en hier ueberschrieben:
    // ein Enable-Puls alle 256 Takte (ca. eine PWM-Periode pro Zaehlschritt).
    int en_cnt = 0;
    always @(posedge clk) begin
        en_cnt <= (en_cnt == 255) ? 0 : en_cnt + 1;
        force dut.cnt_en = (en_cnt == 255);
    end

    initial begin
        // init all signals at t=0
        rst_n = 1'b0;
        key   = 4'b1111;    // KEYs are active low -> not pressed
        sw    = '0;
        $display("Init done");
        #90ns;
        rst_n = 1'b1;
        $display("POR done");
        #1us;
        key[0] = 1'b0;      // press load -> every channel gets its PRELOAD
        #100ns;
        key[0] = 1'b1;
        $display("load done");
        #6ms;               // etwas mehr als ein voller Zyklus (hoch + runter)
        run_sim = 1'b0;
        $display("sim stopped");
    end
endmodule
