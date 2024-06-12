`timescale 10ms/1ms

module IO_test();
reg mem_Clk_s,Clk_s, Reset_s, instruction_memory_en_s;
wire [31:0] instruction_memory_v_s;
wire [31:0] data_memory_in_v_s;
wire [31:0] instruction_memory_a_s;
wire [31:0] data_memory_a_s;
wire [31:0] data_memory_out_v_s;
wire data_memory_read_s;
wire data_memory_write_s;
wire [1:0] decode_error_s;
integer f,i;
IO Test (mem_Clk_s,Clk_s,Reset_s, instruction_memory_en_s, instruction_memory_v_s,data_memory_in_v_s,instruction_memory_a_s,data_memory_a_s,data_memory_out_v_s,data_memory_read_s, data_memory_write_s, decode_error_s);

//Clock
always begin
	Clk_s <= 0;
	#10;
	Clk_s <= 1;
	#10;
end
always begin
	mem_Clk_s <= 0;
	#5;
	mem_Clk_s <= 1;
	#5;
end
initial begin
$dumpvars(0,Test);
f = $fopen("output.txt","w");
Reset_s = 1;
@(posedge Clk_s)
#5 Reset_s = 0;
instruction_memory_en_s = 1;

for (i = 0; i<900; i=i+1) begin
      @(posedge Clk_s)
      if((instruction_memory_a_s == 32'h0000005C) || (instruction_memory_a_s == 32'h00000060)) begin
      $fwrite(f,"%d\n", data_memory_out_v_s );
      end
      if((data_memory_read_s == 1) && (instruction_memory_a_s >= 32'h00000068) && (instruction_memory_v_s != 32'hD0000000) ) begin
        $fwrite(f,"%d\n", data_memory_in_v_s );
      end
    end
$fclose(f);
#10 $finish;
end
endmodule