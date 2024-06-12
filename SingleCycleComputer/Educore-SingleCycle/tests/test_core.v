`timescale 1ns/1ps
`include "../FINAL_SCC/IO.v"
module test_core();

    // dump waveform
    event START_LOG;
    initial begin
        @(START_LOG);
        $dumpvars(0, test_core);
    end

    // Clock instantiations
    reg main_clk = 0;
    always #1 main_clk = ~ main_clk;
    reg core_clk = 0;
    always #2 core_clk = ~core_clk;

    // --------- Signal instantiations ------------ //

    //inputs
    reg Reset_t;
    reg instruction_memory_en_t;

    //outputs
    wire [31:0] instruction_memory_value;
    wire [31:0] instruction_memory_address;
    wire [31:0] data_memory_address;
    wire [31:0] data_memory_out_value;
    wire data_memory_read_t;
    wire data_memory_write_t;

    wire [31:0] data_memory_in_value;

    // --------- Signal instantiations ------------ //

    // Core instantiation
    IO SCC(
        //inputs
        .Clk(core_clk),
        .mem_Clk(main_clk),
        .Reset(Reset_t),
        .instruction_memory_en(instruction_memory_en_t),
        //outputs
        .instruction_memory_v(instruction_memory_value),
        .data_memory_in_v(data_memory_in_value),
        .instruction_memory_a(instruction_memory_address),
        .data_memory_a(data_memory_address),
        .data_memory_out_v(data_memory_out_value),
        .data_memory_read(data_memory_read_t),
        .data_memory_write(data_memory_write_t)
    );

    initial begin
        -> START_LOG;
        $dumpvars(0, SCC);
        Reset_t <= 1;
        #10;
        instruction_memory_en_t <= 1;
        @(posedge main_clk);
        Reset_t <= 0;
        repeat (100) @(posedge main_clk);
        $finish;
    end


endmodule
