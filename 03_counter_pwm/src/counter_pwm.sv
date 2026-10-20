// Up/Down-Zähler (zählt hoch bis Maximum, dann runter bis 0, usw.)
// mit PWM-Ausgang, der über einen Schwellwert (thr_i) gesteuert wird.
module counter_pwm
// Parameter: BITS = Breite des Zählers, PRELOAD = Startwert beim Laden
#(
    parameter int BITS = 10,
    parameter logic [BITS-1:0] PRELOAD = '0
)//module parameter
// Ports: Takt, Reset (low-aktiv), Enable, Load, Schwellwert -> Zählerstand und PWM-Signal
(
    input logic clk_i,
    input logic res_ni,
    input logic en_i,
    input logic load_i,
    input logic [BITS-1:0] thr_i,
    output logic [BITS-1:0] cnt_o,
    output logic pwm_o
);

// Quasi eine "variable" aber eigentlich hardwaremäßig ein flipflop
logic cnt_up;       //1..up, 0..down
logic cnt_up_new;   // the next cnt_up value
logic pwm_comb;     // combinational logic for pwm_o

/*
                         MUX
                      +-------+
    cnt_up_new ------>| 0     |
                      |       |        +-----------------+
         1'b1 ------->| 1     |------->| D             Q |-------> cnt_up
                      |  sel  |        |                 |
                      +---+---+        |                 |
                          |            |   D-Flipflop    |
    load_i ---------------+            |                 |
                                       |                 |
    clk_i ---------------------------->|> CLK            |
                                       |                 |
                                       |       PRE (o)   |   <- asynchrones SET,
                                       +--------+--------+      low-aktiv
                                                |
    res_ni -------------------------------------+


*/

// Richtungs-Flipflop: speichert, ob gerade hoch- oder runtergezählt wird.
// Reset und Load setzen auf "hoch", sonst wird der von der Logik unten
// berechnete nächste Wert (cnt_up_new) übernommen.
always_ff @( posedge clk_i or negedge res_ni ) begin
    if(!res_ni) begin
        cnt_up <= 1'b1;
    end 
    else if (load_i) begin
        cnt_up <= 1'b1;
    end
    else begin
        cnt_up <= cnt_up_new;
    end
end


// Zählregister: Reset -> 0, Load -> PRELOAD.
// Bei Enable wird je nach Richtung hoch- bzw. runtergezählt,
// an den Grenzen (Maximum bzw. 0) bleibt der Wert stehen.
always_ff @( posedge clk_i or negedge res_ni ) begin
    if(!res_ni) begin
        cnt_o <= '0;
    end
    else if (load_i) begin
        cnt_o <= PRELOAD;
    end
    else if (en_i & cnt_up & (cnt_o < '1)) begin
        cnt_o <= cnt_o + 1'b1;
    end
    else if (en_i & cnt_up & (cnt_o == '1)) begin
        cnt_o <= cnt_o;
    end
    else if (en_i & (!cnt_up) & (cnt_o > '0)) begin
        cnt_o <= cnt_o - 1'b1;
    end
    else if(en_i & (!cnt_up) & (cnt_o == '0)) begin
        cnt_o <= cnt_o;
    end
end

// Kombinatorische Logik für die nächste Zählrichtung:
// berechnet aus aktueller Richtung und Zählerstand, ob als nächstes
// hoch- (1) oder runtergezählt (0) wird. Am oberen Ende (Maximum) -> runter,
// am unteren Ende (0) -> wieder hoch. Der Richtungswechsel passiert sofort
// im naechsten Takt (unabhaengig von en_i), damit der Zaehler an den Grenzen
// nicht eine zusaetzliche Enable-Periode stehen bleibt.
always_comb begin
    if(cnt_up & cnt_o < '1) begin
        cnt_up_new = 1'b1;
    end
    else if (cnt_up & cnt_o == '1) begin
        cnt_up_new = 1'b0;
    end
    else if ((!cnt_up) & (cnt_o > '0)) begin
        cnt_up_new = 1'b0;
    end
    else if((!cnt_up) & (cnt_o == '0)) begin
        cnt_up_new = 1'b1;
    end
    else begin
        cnt_up_new = cnt_up;
    end
end

// PWM-Vergleicher (kombinatorisch): Ausgang ist 1, solange der Zählerstand
// unter dem Schwellwert liegt -> thr_i bestimmt das Tastverhältnis (Duty Cycle).
assign pwm_comb =(cnt_o < thr_i) ? 1'b1 : 1'b0;    // compare the counter value with the threshold value

// PWM-Ausgangsregister: speichert das Vergleichsergebnis mit dem Takt,
// damit pwm_o glitchfrei (ohne kombinatorische Störspitzen) ausgegeben wird.
// Reset -> 0.
always_ff @( posedge clk_i or negedge res_ni ) begin
    if(!res_ni) begin
        pwm_o <= 1'b0;
    end
    else begin
        pwm_o <= pwm_comb;
    end
end



endmodule