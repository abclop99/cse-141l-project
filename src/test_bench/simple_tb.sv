// Simple test bench just to make sure it can run code
module simple_tb();

	bit clk, req;
	wire done;

	top_level dut(
		.clk,
		.req,
		.done
	);

	always begin
		#5 clk = 1;
		#5 clk = 0;
	end

	initial begin
		$readmemb("src/machine_code/simple_loop.txt", dut.ir1.core);

		#20;
		#10 req = 1;
		#10 req = 0;
		#10 wait(done);
		#20;
		$stop;
	end

endmodule