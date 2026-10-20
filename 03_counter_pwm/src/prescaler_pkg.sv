package prescaler_pkg;
    // Sowas wie ein headerfile
    // drei neuener weglöschen
    localparam PRELOAD_0 = 4999999;     // 100 ms @ 50 MHz
    localparam PRELOAD_1 = 2499999;     //  50 ms
    localparam PRELOAD_2 = 999999;      //  20 ms
    localparam PRELOAD_3 = 499999;      //  10 ms
    localparam PRELOAD_4 = 249999;      //   5 ms
    localparam PRELOAD_5 = 99999;       //   2 ms
    localparam PRELOAD_6 = 49999;       //   1 ms
    localparam PRELOAD_DEFAULT = 9;     // 200 ns (sel = 3'b111)

    localparam int NBITS = $clog2(PRELOAD_0);
endpackage

