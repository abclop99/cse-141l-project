module control (
	input[8:0]      instruction,
	output logic    reg_write_enable,
	                acc_write_enable,
	                dat_write_enable,
	                compare_enable,
	                reljump_enable,
	                absjump_enable,
	                acc_src,
	output logic[4:0]  alu_op,
	output logic       done
);

assign alu_op = instruction[8:4];
assign acc_write_enable = 1;

always_comb begin
	// Set default values
	reg_write_enable = 0;
	// acc_write_enable = 1;
	dat_write_enable = 0;
	compare_enable = 0;
	reljump_enable = 0;
	absjump_enable = 0;
	acc_src = 1;
	done = 0;

	// Set values based on instruction
	case (alu_op)
		// 0-16: ALU operations

		17: acc_src          = 0;  // 17: loadm: A <- Mem[val]
		                           // 19: loadv: A <- val
		19: dat_write_enable = 1;  // 20: storem: Mem[val] <- A
		20: reg_write_enable = 1;  // 21: storev: val <- A
		                           // 21: slt: A <- (A < val) ? 1 : 0
		22: begin // 22: beq
			compare_enable = 1;
			reljump_enable = 1;
		end
		23: reljump_enable = 1;    // 23: rb
		24: absjump_enable = 1;    // 24: ab

		'1: done = 1;  // 31: done
	endcase
end

endmodule