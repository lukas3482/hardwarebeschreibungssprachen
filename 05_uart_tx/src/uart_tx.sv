module uart_tx 
#(
    parameter int FCLK = 50000000,
    parameter int BAUD = 115200
) (
    input   logic               rst_ni,         //active low async reset
    input   logic               clk_i,          //clock
    input   logic               tx_en_i,        //enables the module, if low everything shall be cleared
    input   logic               tx_start_i,     //posedge starts the transmit
    input   logic [7:0]         tx_data_i,      //the 8 data bits to be sent
    output  logic               tx_o,           //UART TX line connected to pin
    output  logic               tx_idle_o,      //indicates that we are in IDLE state
    output  logic               tx_done_o       //short strobe that indicates that a byte was sent
);

// internal signals
typedef enum logic[1:0] {IDLE, START, DATA, STOP} state_t;
state_t     state;
state_t     state_next;

localparam WC_INIT = FCLK/BAUD - 1;     //start value of the width counter
localparam WC_W    = $clog2(WC_INIT);   //width of the width counter
logic [WC_W-1:0]        wc_cnt;         //width counter
logic                   wc_load;        //loads wc_cnt with WC_INIT
logic                   wc_zero;        //indicates that wc_cnt == 0

logic [2:0]             bc_cnt;         //bit counter
logic                   bc_inc;         //increments bc_cnt
logic                   bc_clr;         //clears the bc_cnt

logic [9:0]             sr;             //shift register
logic                   sr_shift;       //shifts the shift register
logic                   sr_load;        //loads the shift register

logic                   tx_start_old;   //previous value of tx_start
logic                   tx_start_posedge; //positive edge of tx_start

// FSM sequential part
always_ff @( posedge clk_i or negedge rst_ni ) begin
    if (~rst_ni) begin  //asyn reset -- usually a POR (power on reset)
        state <= IDLE;
    end
    else if (~tx_en_i) begin    // sync reset --> Software
        state <= IDLE;
    end
    else begin
        state <= state_next;
    end
end

// FSM combinatorial part
always_comb begin
    // defaults
    state_next          = state;
    wc_load             = 1'b0;
    bc_inc              = 1'b0;
    bc_clr              = 1'b0;
    sr_shift            = 1'b0;
    sr_load             = 1'b0;
    tx_idle_o           = 1'b0;
    tx_done_o           = 1'b0;

    case (state)
        IDLE : begin
            tx_idle_o           = 1'b1;
            if (tx_start_posedge) begin
                state_next = START;
                wc_load    = 1'b1;
                sr_load    = 1'b1;      //load tx_data into the shift register
            end
        end
        START : begin
            if (wc_zero) begin
                state_next = DATA;
                wc_load    = 1'b1;
                sr_shift   = 1'b1;
            end
        end
        DATA : begin
            if (wc_zero && (bc_cnt < 3'd7)) begin
                state_next = DATA;
                wc_load    = 1'b1;
                sr_shift   = 1'b1;
                bc_inc     = 1'b1;
            end
            else if (wc_zero) begin
                state_next = STOP;
                wc_load    = 1'b1;
                sr_shift   = 1'b1;
            end
        end
        STOP : begin
            if (wc_zero) begin
                state_next = IDLE;
                bc_clr     = 1'b1;
                tx_done_o  = 1'b1;
            end
        end
    endcase

end


// Implement the shift register here
always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        sr <= '1; //ensures that tx_o = 1
    end
    else if (~tx_en_i) begin
        sr <= '1; //ensures that tx_o = 1
    end
    else if (sr_load) begin
        sr <= {1'b1, tx_data_i, 1'b0};
    end
    else if (sr_shift) begin
        sr <= {1'b1, sr[9:1]};      //shift right and shift in 1'b1
    end
end
assign tx_o = sr[0];    //the output is the LSB of the shift register

// Implement the width counter
always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        wc_cnt <= '0;
    end
    else if (~tx_en_i) begin
        wc_cnt <= '0;
    end
    else if (wc_load) begin
        wc_cnt <= WC_INIT;
    end
    else if (~wc_zero) begin
        wc_cnt = wc_cnt - 1'b1;
    end
end
assign wc_zero = (wc_cnt == '0);

// Implement the bit counter
always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
        bc_cnt <= '0;
    end
    else if (~tx_en_i) begin
        bc_cnt <= '0;
    end
    else if (bc_clr) begin
        bc_cnt <= '0;
    end
    else if (bc_inc) begin
        bc_cnt <= bc_cnt + 1'b1;
    end
end

// Implement the posedge detection
always_ff @ (negedge rst_ni or posedge clk_i) begin
    if (~rst_ni) begin
        tx_start_old <= 1'b0;
    end
    else if (~tx_en_i) begin
        tx_start_old <= 1'b0;
    end
    else begin
        tx_start_old <= tx_start_i;
    end
end
assign tx_start_posedge = ~tx_start_old & tx_start_i;
    
endmodule