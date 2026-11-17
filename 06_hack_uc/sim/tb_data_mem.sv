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

    // RAM (0x0000 - 0x3FFF)
    task_write(15'h0000, 16'hA5A5);
    task_check(15'h0000, 16'hA5A5);
    task_write(15'h3FFF, 16'h5A5A);
    task_check(15'h3FFF, 16'h5A5A);

    // Ausgaenge (schreiben + zuruecklesen)
    task_write(15'h7000, 16'h00F0);     // LEDG
    task_check(15'h7000, 16'h00F0);
    task_write(15'h7001, 16'h0F0F);     // LEDR
    task_check(15'h7001, 16'h0F0F);
    task_write(15'h7002, 16'hBEEF);     // SEVENSEG
    task_check(15'h7002, 16'hBEEF);

    // Eingaenge (nur lesen)
    task_check(15'h7400, 16'h1111);     // SW0
    task_check(15'h7401, 16'h2222);     // SW1
    task_check(15'h7402, 16'h3333);     // KEY

    // unbelegte Adresse -> 0
    task_check(15'h5000, 16'h0000);

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
