// Simple test bench just to make sure it can run code
module simple_tb();

	bit clk, reset;
	wire done;

	top_level dut(
		.clk,
		.reset,
		.done
	);

	always begin
		#5 clk = 1;
		#5 clk = 0;
	end

	initial begin
		$readmemb("src/machine_code/simple_loop.txt", dut.ir1.core);

		#10 reset = 1;
		#10 reset = 0;
		#10 wait(done);
		$stop;
	end

endmodule