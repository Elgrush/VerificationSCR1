`timescale 1 ns / 1 ps

module tb;
	integer fd;

	reg clk = 1;
	always #1 clk = ~clk;

	reg resetn = 0;
	initial begin
		#1 resetn <= 1;
	end
	
	initial begin
			$dumpfile("res/system.vcd");
			$dumpvars(0);
	end

    wire [31:0] gpio,gpio1;

	SoC #(
		.FIRMWARE_FILE(".cache/work/firmware.mem"),
		.ARRAY_FILE(".cache/work/array.mem")
      ) uut (
		.clk	(clk),
		.rst_n	(resetn),
		.gpio	(gpio),
		.gpio1	(gpio1)
	);
	

	initial begin
		#500_000;
		$writememh("res/array_done.mem", uut.array_ram.mem, 0, 4095);
		$finish;
	end

endmodule
