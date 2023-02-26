module alu_tb ();

reg [4:0]  opcode;
reg [7:0]  val_in,
           acc_in;

logic [7:0] result;

alu alu1 (opcode, val_in, acc_in, result);

initial begin
	acc_in = 2;
	val_in = 1;

	for (int i = 0; i < 32; i = i + 1) begin
		opcode = i;
		#5;
	end

	// Test if numbers are signed or unsigned
	acc_in = 2;
	val_in = 'hFF;
	opcode = 12;
	#5

	$stop;
end

endmodule