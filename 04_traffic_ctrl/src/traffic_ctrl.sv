module traffic_ctrl 
import traffic_ctrl_pkg::*;
#(
    parameter logic[7:0] TO_MAIN_GREEN  = 8'h3f, 
    parameter logic[7:0] TO_MAIN_YELLOW = 8'h7f, 
    parameter logic[7:0] TO_MAIN_RED    = 8'hff
) (
    input logic         rst_ni,
    input logic         clk_i,
    input logic         sensor_i,
    output logic        main_green_o,
    output logic        main_yellow_o,
    output logic        main_red_o,
    output logic        side_green_o,
    output logic        side_yellow_o,
    output logic        side_red_o
);

// Declare the state signals
state_t         state;
state_t         state_next;
// Declare the timeout counter signals
logic [7:0]     to_cnt;         //timeout counter
logic [7:0]     to_value;       //load value
logic           to_load;        //load command
logic           to_zero;        //counter is zero


// FSM sequential part
always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        state <= M_GREEN_S_RED;
    end
    else begin
        state <= state_next;
    end
end

// FSM comb part
always_comb begin
    //defaults
    state_next = state;
    main_green_o    = 1'b0;
    main_yellow_o   = 1'b0;
    main_red_o      = 1'b0;
    side_green_o    = 1'b0;
    side_yellow_o   = 1'b0;
    side_red_o      = 1'b0;
    to_load         = 1'b0;
    to_value        = '0;

    case (state)
        M_GREEN_S_RED: begin
            main_green_o    = 1'b1;
            side_red_o      = 1'b1;
            if (sensor_i) begin
                state_next  = CAR_DET;
                to_load     = 1'b1;
                to_value    = TO_MAIN_GREEN; 
            end
        end
        CAR_DET: begin
            main_green_o    = 1'b1;
            side_red_o      = 1'b1;
            if (to_zero) begin
                state_next  = M_YELLOW_S_RED;
                to_load     = 1'b1;
                to_value    = TO_MAIN_YELLOW;
            end
        end
        M_YELLOW_S_RED: begin
            main_yellow_o   = 1'b1;
            side_red_o   = 1'b1;
            if (to_zero) begin
                state_next  = M_RED_S_YELLOW;
                to_load     = 1'b1;
                to_value    = TO_MAIN_YELLOW;
            end
        end
        M_RED_S_YELLOW: begin
            main_red_o      = 1'b1;
            side_yellow_o   = 1'b1;
            if (to_zero) begin
                state_next  = M_RED_S_GREEN;
                to_load     = 1'b1;
                to_value    = TO_MAIN_RED;
            end
        end
        M_RED_S_GREEN: begin
            main_red_o      = 1'b1;
            side_green_o    = 1'b1;
            if (to_zero) begin
                state_next  = M_YELLOW_S_YELLOW;
                to_load     = 1'b1;
                to_value    = TO_MAIN_YELLOW;
            end
        end
        M_YELLOW_S_YELLOW: begin
            main_yellow_o   = 1'b1;
            side_yellow_o   = 1'b1;
            if (to_zero) begin
                state_next  = M_GREEN_S_RED;
            end
        end
    endcase
end

// Timeout counter
always_ff @ (negedge rst_ni or posedge clk_i) begin
    if (~rst_ni) begin
        to_cnt <= '0;
    end
    else if (to_load) begin
        to_cnt <= to_value;
    end
    else if (~to_zero) begin
        to_cnt <= to_cnt - 1'b1;
    end
end
assign to_zero = (to_cnt == '0);
    
endmodule