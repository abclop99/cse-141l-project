module register_file #(parameter pointer_width=3)(
	input[pointer_width-1:0] address,
	input           is_immediate,
	input[7:0]      data_in,

	input  clock,
	input  write_enable,

	output logic[7:0] data_out
);

logic[7:0]	core[2**(pointer_width)];

assign data_out = is_immediate ? address : core[address];

always_ff @( posedge clock )
	if ( write_enable )
		core[address] <= data_in;

endmodule