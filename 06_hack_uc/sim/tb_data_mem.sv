module tb_data_mem ();

// (1) DUT signals
    logic           rst_n;
    logic           clk50m;
    logic           we;
    logic [15:0]    data_in;
    logic [14:0]    addr;
    logic [15:0]    data_out;
    logic [15:0]    reg0x7400;      // SW0
    logic [15:0]    reg0x7401;      // SW1
    logic [15:0]    reg0x7402;      // KEY
    logic [15:0]    reg0x7000;      // LEDG
    logic [15:0]    reg0x7001;      // LEDR
    logic [15:0]    reg0x7002;      // SEVENSEG

// Adressen der einzelnen Bereiche
    localparam logic [14:0] RAM_START = 15'h0000;
    localparam logic [14:0] RAM_END   = 15'h3FFF;
    localparam logic [14:0] LEDG      = 15'h7000;
    localparam logic [14:0] LEDR      = 15'h7001;
    localparam logic [14:0] SEVENSEG  = 15'h7002;
    localparam logic [14:0] SW0       = 15'h7400;
    localparam logic [14:0] SW1       = 15'h7401;
    localparam logic [14:0] KEY       = 15'h7402;
    localparam logic [14:0] UNUSED    = 15'h5000;

// (2) DUT instance
    data_mem dut (.*);

// (3) DUT stimuli
logic run_sim = 1'b1;
initial begin
    clk50m = 1'b0;
    while (run_sim) begin
        #10ns;
        clk50m = ~clk50m;
    end
end

initial begin
    rst_n     = 1'b0;
    we        = 1'b0;
    data_in   = '0;
    addr      = '0;
    reg0x7400 = 16'h1111;
    reg0x7401 = 16'h2222;
    reg0x7402 = 16'h3333;
    #90ns;
    rst_n     = 1'b1;
    #100ns;

    // RAM (Anfang und Ende)
    task_write(RAM_START, 16'hA5A5);
    task_check(RAM_START, 16'hA5A5);
    task_write(RAM_END,   16'h5A5A);
    task_check(RAM_END,   16'h5A5A);

    // Ausgaenge (schreiben + zuruecklesen)
    task_write(LEDG,     16'h00F0);
    task_check(LEDG,     16'h00F0);
    task_write(LEDR,     16'h0F0F);
    task_check(LEDR,     16'h0F0F);
    task_write(SEVENSEG, 16'hBEEF);
    task_check(SEVENSEG, 16'hBEEF);

    // Eingaenge (nur lesen)
    task_check(SW0, 16'h1111);
    task_check(SW1, 16'h2222);
    task_check(KEY, 16'h3333);

    #100ns;
    run_sim = 1'b0;
    $display("TB stops.");
end

task task_write (input logic [14:0] wr_addr, input logic [15:0] wr_data);
    @(negedge clk50m);
    addr    = wr_addr;
    data_in = wr_data;
    we      = 1'b1;
    @(negedge clk50m);
    we      = 1'b0;
endtask

task task_check (input logic [14:0] rd_addr, input logic [15:0] expected_data);
    @(negedge clk50m);
    addr = rd_addr;
    @(negedge clk50m);      // RAM hat 1 Takt Latenz (Adresse registriert)
    if (data_out == expected_data) $display("PASS addr=%h data=%h", rd_addr, data_out);
    else                           $error("FAIL addr=%h data=%h (expected %h)", rd_addr, data_out, expected_data);
endtask

endmodule
