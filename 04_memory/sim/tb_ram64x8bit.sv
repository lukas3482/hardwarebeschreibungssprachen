module tb_ram64x8bit();
    logic[5:0]  addr;                         
    logic[7:0]  data_in;                      
    logic       we;                       
    logic[7:0]  data_out;  

    ram64x8bit dut (.*); //.* initialisiert alles

    initial begin
        // init all inputs
        addr    = '0;
        data_in = '0;
        we      = 1'b0;

        // init the memory $readmemh (das h bedeutet das der inthalt in hex ist bei einem d wären es dezimal zahlen)
        $readmemh("mem_init_ascending_integers.txt", tb_ram64x8bit.dut.mem);
        // now check by reading back
        #100ns; 
        // write FF to address 9
        addr    = 8'd9;     // -> 8bit breit d steht für dezimal
        data_in = 8'hFF;    // -> 8 bit breit h steht für hex
        we      = 1'b1;
        #10ns;
        we      = 1'b0;
        #10ns;
        // check: wurde FF an Adresse 9 geschrieben?
        if (data_out == 8'hFF) begin
            $display("PASS");
        end else begin
            $error("FAIL");
        end

    end

endmodule