// Simple test bench just to make sure it can run code
module program_1_tb();

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
		// Load program into instruction memory
		$readmemb("src/machine_code/program_1.txt", dut.ir1.core);

		// TODO: Load test data into data mem
		// Initialize data memory [0:29] to 0
		for (int i = 0; i < 30; i = i + 1) begin
			dut.dm1.core[i] = 0;
		end

		// Initialize first message to the example given in the word document
		dut.dm1.core[0] = 8'b00000101;
		dut.dm1.core[1] = 8'b01010101;

		// Print input data [0:29]
		$display("Input data [0:29]:");
		$display("================");
		$display("  Address\tData");
		$display("---------\t----");
		for (int i = 0; i < 30; i = i + 1) begin
			$display("%d\t%b", i, dut.dm1.core[i]);
		end

		#20;
		#10 req = 1;
		#10 req = 0;
		#10 wait(done);
		#20;

		// Print output from data memory [30:59]
		$display("Output from data memory [30:59]:");
		$display("================================");
		$display("  Address \tData");
		$display("----------\t----");
		for (int i = 30; i < 60; i = i + 1) begin
			$display("%d\t%b", i, dut.dm1.core[i]);
		end

		$stop;
	end

endmodule