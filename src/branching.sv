module branching #(parameter D=12) (
	input[D-1:0]    pc_in,
	input[7:0]      val,
	                acc,
	input           compare_enable,
	                reljump_enable,
	                absjump_enable,
	output logic[D-1:0]   pc_out
);

wire[D-1:0] target;

// Where to jump to (if at all)
assign target = (absjump_enable) ? val << 2 : (reljump_enable) ? pc_in + val : pc_in;

always_comb begin
	if (compare_enable) begin
		if (acc == 0) begin
			pc_out = target;
		end else begin
			pc_out = pc_in;
		end
	end else begin
		pc_out = target;
	end
end

endmodule