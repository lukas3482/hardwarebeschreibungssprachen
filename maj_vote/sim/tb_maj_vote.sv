module tb_maj_vote();

// (1) Declare signals to connect to the DUT
logic tb_x0;
logic tb_x1;
logic tb_x2;
logic tb_y_gates;
logic tb_y_behav;

// (2) Instantiate the DUT
maj_vote dut (
    // |        |
    // Module   |
    //      Instance name
    // Now connections
    .x0         (tb_x0),
    .x1         (tb_x1),
    .x2         (tb_x2),
    .y_gates    (tb_y_gates),
    .y_behav    (tb_y_behav)

);

// (3) Drive the DUT
initial begin
    // executed line by line
    // here we are at simulation time = 0
    tb_x2 = 1'b0;
    tb_x1 = 1'b0;
    tb_x0 = 1'b0;

    #100ns; // wait for 100ns

    for(int i = 0; i <= 7; i++) begin
        {tb_x2, tb_x1, tb_x0} = i;
        #100ns;
    end
end

endmodule