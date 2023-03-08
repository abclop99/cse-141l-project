module program_counter #(parameter D=12) (
	input           reset,
	                enable,
	                clock,
	input[D-1:0]    pc_in,

	output logic[D-1:0]     pc_out,
	                        pc_added
);

assign pc_added = pc_out + 1;

always_ff @(posedge clock or posedge reset) begin
	if (reset)
		pc_out <= 0;
	else if (enable)
		pc_out <= pc_in;
end

endmodule