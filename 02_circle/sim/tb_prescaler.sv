module tb_prescaler();
    // (1) Declare singals to connect to the DUT
    logic       rst_n;
    logic       clk;
    logic[2:0]  sel;
    logic       en;

    // (2) Instantinalte the DUT
    prescaler dut(
        .rst_ni     (rst_n),
        .clk_i      (clk),
        .sel_i      (sel),
        .en_o       (en)
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
    // init al singals at t=0
    rst_n = 1'b0;
    sel = '0;
    $display("Init done");
    #90ns;
    rst_n = 1'b1;
    $display("POR done");
    #100ns;
    sel = '1;
    $display("sel changed to %d", sel);
    #100us;
    run_sim = 1'b0;
    $display("sim stopped");
   end
endmodule