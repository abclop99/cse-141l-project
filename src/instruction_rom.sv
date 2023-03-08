// lookup table
// deep 
// 9 bits wide; as deep as you wish
module instruction_rom #(parameter D=12)(
	input       [D-1:0]  address,
	output logic[ 8:0]   machine_code);

	logic[8:0] core[2**D];
	// load the program
	//initial
	//	$readmemb("machine_code.txt",core);

	always_comb machine_code = core[address];

endmodule


/*
sample machine_code.txt:

001111110		 // ADD r0 r1 r0
001100110
001111010
111011110
101111110
001101110
001000010
111011110
*/