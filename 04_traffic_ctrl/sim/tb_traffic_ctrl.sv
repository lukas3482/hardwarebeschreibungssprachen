`timescale 10ns/10ns
module tb_traffic_ctrl();
    import traffic_ctrl_pkg::*;
    // (1) DUT wiring
    localparam logic[7:0] TO_MAIN_GREEN  = 8'h3f;
    localparam logic[7:0] TO_MAIN_YELLOW = 8'h7f;
    localparam logic[7:0] TO_MAIN_RED    = 8'hff; 

    logic           rst_ni;       
    logic           clk_i;        
    logic           sensor_i;     
    logic           main_green_o; 
    logic           main_yellow_o;
    logic           main_red_o;   
    logic           side_green_o; 
    logic           side_yellow_o;
    logic           side_red_o;   

    // (2) DUT instance
    traffic_ctrl dut (.*);

    // (3) DUT stimuli
    logic   run_sim = 1'b1;
    int     error_cnt = 0;

    initial begin
        clk_i = 1'b0;
        while (run_sim) begin
            #250ns;
            clk_i = ~clk_i;
        end
    end

    initial begin
        $display("------------------------");
        $display("tb_traffic_ctrl started.");
        rst_ni      = 1'b0;
        sensor_i    = 1'b0;
        #2700ns;
        rst_ni      = 1'b1;
        $display("\tPOR ends.");
        #1000ns;
        //-----
        t_check_state(M_GREEN_S_RED);
        t_check_lights(3'b100, 3'b001);
        #100ns;
        @ (negedge clk_i);
        sensor_i = 1'b1;
        $display("\tSensor goes high.");
        @ (negedge clk_i);
        sensor_i = 1'b0;
        //-----
        t_check_state(CAR_DET);
        t_check_lights(3'b100, 3'b001);
        t_wait_n_clk_negedges(TO_MAIN_GREEN);
        //-----
        t_check_state(M_YELLOW_S_RED);
        t_check_lights(3'b010, 3'b001);
        t_wait_n_clk_negedges(TO_MAIN_YELLOW);
        //-----
        t_check_state(M_RED_S_YELLOW);
        t_check_lights(3'b001, 3'b010);
        t_wait_n_clk_negedges(TO_MAIN_YELLOW);
        //-----
        t_check_state(M_RED_S_GREEN);
        t_check_lights(3'b001, 3'b100);
        t_wait_n_clk_negedges(TO_MAIN_RED);
        //-----
        t_check_state(M_YELLOW_S_YELLOW);
        t_check_lights(3'b010, 3'b010);
        t_wait_n_clk_negedges(TO_MAIN_YELLOW);
        //-----
        t_check_state(M_GREEN_S_RED);
        t_check_lights(3'b100, 3'b001);
        #1us;
        run_sim = 1'b0;
        $display("tb_traffic_ctrl finished.");
        $display("------------------------");
        if (error_cnt == 0) begin
            $display("Pass, no errors found :-)");
        end
        else begin
            $error("FAIL, %d errors found",error_cnt);
        end
        $display("------------------------");
    end

    task t_check_lights (logic[2:0] main_expected, logic[2:0] side_expected);
        if (main_expected == {main_green_o,main_yellow_o, main_red_o}) begin
            $display("\t TASK t_check_lights: Pass main lights");
        end
        else begin
            $error("\t TASK t_check_lights: FAIL for main light in state (%s)!",dut.state.name());
            $display("\t\t Expected GYR = %b",main_expected);
            $display("\t\t DUT GYR = %b",{main_green_o,main_yellow_o, main_red_o});
            error_cnt++;
        end
        if (side_expected == {side_green_o,side_yellow_o, side_red_o}) begin
            $display("\t TASK t_check_lights: Pass side lights");
        end
        else begin
            $error("\t TASK t_check_lights: FAIL for side light in state (%s)!",dut.state.name());
            $display("\t\t Expected GYR = %b",side_expected);
            $display("\t\t DUT GYR = %b",{side_green_o,side_yellow_o, side_red_o});
            error_cnt++;
        end
    endtask
    task t_check_state  (state_t state_expected);
        if (dut.state == state_expected) begin
            $display("\t TASK t_check_state: Pass: State is as expected (%s)",dut.state.name());
        end
        else begin
            $error("\t TASK t_check_state: Fail: State is %s, expected is %s",dut.state.name(), state_expected);
            error_cnt++;
        end
    endtask
    task t_wait_n_clk_negedges (logic [7:0] n_clk_wait);
        repeat (n_clk_wait+1) begin
            @ (negedge clk_i);
        end
        $display("\t TASK t_wait_n_clk_negedges: Waited for %d negedges",n_clk_wait);    
    endtask

endmodule