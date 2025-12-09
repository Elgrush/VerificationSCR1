`timescale 1 ns / 1 ps

module tb;
	integer fd;

	reg clk = 1;
	always #1 clk = ~clk;

	reg resetn = 1;
	initial begin
		
		repeat (10) @(posedge clk);
		resetn <= 0;
	end
	
	initial begin
			$dumpfile(".cache/bin/system.vcd");
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
		#1_000_000;
		$finish;
	end

endmodule
