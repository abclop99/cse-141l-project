module program_counter_tb #(parameter D=12);

reg         reset, enable, clock;
reg [D-1:0] pc_in;

wire [D-1:0] pc_out;
wire [D-1:0] pc_added;

program_counter #( .D(D) ) pc (
	.reset,
	.enable,
	.clock,
	.pc_in,
	.pc_out,
	.pc_added
);

initial begin
	reset = 1;
	clock = 0;
	pc_in = 0;
	#5
	reset = 0;
	clock = 1;
	#5

	for (int i = 0; i < 10; i = i + 1) begin
		pc_in = pc_added;
		#5 clock = 1;
		pc_in = pc_added;
		#5 clock = 0;
	end

	pc_in = 3;
	for (int i = 0; i < 10; i = i + 1) begin
		#5 clock = 1;
		#5 clock = 0;
	end
	#10
	enable = 1;
	reset = 1;
	clock = 0;
	pc_in = 0;
	#5
	reset = 0;
	clock = 1;
	#5

	for (int i = 0; i < 10; i = i + 1) begin
		pc_in = pc_added;
		#5 clock = 1;
		pc_in = pc_added;
		#5 clock = 0;
	end

	pc_in = 3;
	for (int i = 0; i < 10; i = i + 1) begin
		#5 clock = 1;
		#5 clock = 0;
	end

	$stop;
end

endmodule