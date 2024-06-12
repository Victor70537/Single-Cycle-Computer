module Data_mem_tb();
    reg Clk_s;
    reg [31:0] Data_address_s;
    reg [31:0] Data_in_s;
    reg we_s;
    reg re_s;
    wire [31:0] Data_out_s;

    Data_mem Data_mem_test (
        Clk_s,
        Data_address_s,
        Data_in_s,
        we_s,
        re_s,
        Data_out_s
    );

    always begin
        Clk_s <= 0;
        #10;
        Clk_s <= 1;
        #10;
    end

    integer inc = 0;
    parameter OFFSET = 0;
    // Testing
    initial begin
    $dumpvars(0, Data_mem_tb);
        
        //wait one cycle to show startup state
        @(posedge Clk_s);

        // First Tick/TOCK show enable working
        @(posedge Clk_s);//TICK
        we_s <= 0;  //nothing to write
        re_s <= 0;  //nothing to read
        Data_address_s <= OFFSET; // place offset onto address
        @(posedge Clk_s); //TOCK

        // Read
        @(posedge Clk_s);//TICK
        we_s <= 0;  
        re_s <= 1;  //to read
        Data_address_s <= OFFSET; // place offset onto address
        @(posedge Clk_s); //TOCK

        // Write
        @(posedge Clk_s);//TICK
        we_s <= 1;  // to write
        re_s <= 0;  
        Data_address_s <= OFFSET; // place offset onto address
        Data_in_s <= 32'hFFFFFFFF;
        @(posedge Clk_s); //TOCK

        // Read
        @(posedge Clk_s);//TICK
        we_s <= 0;  
        re_s <= 1;  //to read
        Data_address_s <= OFFSET; // place offset onto address
        @(posedge Clk_s); //TOCK
        #10

        $finish;
    end
endmodule