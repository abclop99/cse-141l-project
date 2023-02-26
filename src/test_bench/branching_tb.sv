module branching_tb();
parameter D=12;

reg             clock;
reg             reset;
reg[7:0]        val, acc;
reg             compare_enable,
                reljump_enable,
                absjump_enable;

wire[D-1:0]     pc_current,
                pc_added,
                pc_next;
wire[8:0]       machine_code;

program_counter #(.D(D)) pc1(
	.clock(clock),
	.reset(reset),
	.pc_in(pc_next),
	.pc_out(pc_current),
	.pc_added(pc_added)
);

branching #(.D(D)) branch1(
	.val(val),
	.acc(acc),
	.compare_enable(compare_enable),
	.reljump_enable(reljump_enable),
	.absjump_enable(absjump_enable),
	.pc_in(pc_added),
	.pc_out(pc_next)
);

instruction_rom #(.D(D)) rom1(
	.address(pc_current),
	.machine_code(machine_code)
);

initial begin

	// Reset the processor
	clock = 0;
	reset = 1;
	val = 0;
	acc = 0;
	compare_enable = 0;
	reljump_enable = 0;
	absjump_enable = 0;
	#5 clock = 1;
	#5 clock = 0;
	reset = 0;

	// Run a few clock cycles
	for (int i = 0; i < 5; i = i + 1) begin
		#5 clock = 1;
		#5 clock = 0;
	end

	// Loop a bit with a few "instructions"
	val = 6;
	for (int i = 0; i < 4; i = i + 1) begin
		for (int j = 0; j < 5; j = j + 1) begin
			#5 clock = 1;
			#5 clock = 0;
		end

		absjump_enable = 1;
		#5 clock = 1;
		absjump_enable = 0;
		#5 clock = 0;
	end

	// Test the compare_enable
	val = 5;
	compare_enable = 1;
	absjump_enable = 1;
	for (int i = 0; i < 10; i = i + 1) begin
		acc = pc_current - 10;
		#5 clock = 1;
		#5 clock = 0;
	end

	$stop;
end

endmodule