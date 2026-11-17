module tb_uart_tx ();

// (1) DUT signals
    localparam int      FCLK_TB = 50000000;
    localparam int      BAUD_TB =  1000000;
    logic               rst_ni;         //active low async reset
    logic               clk_i;          //clock
    logic               tx_en_i;        //enables the module, if low everything shall be cleared
    logic               tx_start_i;     //posedge starts the transmit
    logic [7:0]         tx_data_i;      //the 8 data bits to be sent
    logic               tx_o;           //UART TX line connected to pin
    logic               tx_idle_o;      //indicates that we are in IDLE state
    logic               tx_done_o;      //short strobe that indicates that a byte was sent


// (2) DUT instance
    uart_tx #(.FCLK(FCLK_TB), .BAUD(BAUD_TB)) dut (.*);

// (3) DUT stimuli
logic run_sim = 1'b1;
initial begin
    clk_i = 1'b0;
    while (run_sim) begin
        #10ns;
        clk_i = ~clk_i;
    end
end

initial begin
    rst_ni      = 1'b0;
    tx_en_i     = 1'b0;
    tx_data_i   = '0;
    tx_start_i  = 1'b0;
    #90ns;
    $display("POR ends");
    rst_ni      = 1'b1;
    #100ns;
    @ (negedge clk_i);
    tx_en_i     = 1'b1;
    $display("uart_tx enabled.");
    #1000ns;
    
    task_send_byte(8'hff);
    #100ns;
    task_send_byte(8'h00);
    #100ns;
    task_send_byte(8'ha5);
    #100ns;
    task_send_byte(8'h5a);
    #100ns;
    #100ns
    run_sim = 1'b0;
    $display("TB stops.");
end

task task_send_byte (input logic [7:0] tx_data);
    @(negedge clk_i);
    $display("Send %h",tx_data);
    tx_data_i = tx_data;
    tx_start_i = 1'b1;
    @(negedge clk_i);
    tx_start_i = 1'b0;
    #20us;
endtask



endmodule