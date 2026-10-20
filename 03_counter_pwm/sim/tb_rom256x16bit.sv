`timescale 1ns / 1ps

module tb_rom256x16bit();
    // (1) Declare signals to connect to the DUT
    logic        clk;
    logic [7:0]  addr;
    logic [15:0] q;

    // (2) Instantiate the DUT
    rom256x16bit dut (
        .address    (addr),
        .clock      (clk),
        .q          (q)
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
        addr = '0;
        $display("Init done");
        #100ns;
        // alle 256 Adressen aufsteigend durchlaufen -> Gamma-Kurve am Ausgang q
        // (q kommt mit 2 Takten Latenz, da Adresse und Ausgang registriert sind)
        for (int i = 0; i < 256; i++) begin
            @(negedge clk);
            addr = i[7:0];
        end
        $display("ROM read done");
        #100ns;
        run_sim = 1'b0;
        $display("sim stopped");
    end
endmodule
