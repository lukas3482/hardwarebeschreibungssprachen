package prescaler_pkg;
    // Sowas wie ein headerfile
    // drei neuener weglöschen
    localparam PRELOAD_0 = 49999999;
    localparam PRELOAD_1 = 24999999;  
    localparam PRELOAD_2 = 9999999;
    localparam PRELOAD_3 = 4999999;
    localparam PRELOAD_4 = 2499999;
    localparam PRELOAD_5 = 999999;
    localparam PRELOAD_6 = 499999;
    localparam PRELOAD_DEFAULT = PRELOAD_6;

    localparam int NBITS = $clog2(PRELOAD_0);
endpackage

