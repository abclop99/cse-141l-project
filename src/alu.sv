module alu(
	input[4:0]      opcode,
	input[7:0]      val_in, acc_in,
	output logic[7:0]       result
);

always_comb begin : alu_logic
	// Local variables for the ALU that hopefully organize things a bit
	logic[7:0]    emsw_result, elsw_result, dmsw_result, dlsw_result, xp4_result, xp2_result, xp1_result;

	emsw_result[7:1] = {acc_in, val_in}[10:4];
	emsw_result[0]   = 'b0;

	elsw_result[7:5] = val_in[3:1];
	elsw_result[4:0] = 'b0;

	dmsw_result[7:3] = 'b0;
	dmsw_result[2:0] = {acc_in, val_in}[15:13];

	dlsw_result[7:4] = {acc_in, val_in}[12:9];
	dlsw_result[3:1] = {acc_in, val_in}[7:5];
	dlsw_result[0]   = {acc_in, val_in}[3];

	xp4_result[7:4] = {acc_in, val_in}[15:12];
	xp4_result[3:0] = {acc_in, val_in}[7:4];

	xp2_result[7:6] = {acc_in, val_in}[15:14];
	xp2_result[5:4] = {acc_in, val_in}[11:10];
	xp2_result[3:2] = {acc_in, val_in}[7:6];
	xp2_result[1:0] = {acc_in, val_in}[3:2];

	xp1_result[7] = {acc_in, val_in}[15];
	xp1_result[6] = {acc_in, val_in}[13];
	xp1_result[5] = {acc_in, val_in}[11];
	xp1_result[4] = {acc_in, val_in}[9];
	xp1_result[3] = {acc_in, val_in}[7];
	xp1_result[2] = {acc_in, val_in}[5];
	xp1_result[1] = {acc_in, val_in}[3];
	xp1_result[0] = {acc_in, val_in}[1];

	// Simple test operations for now
	result = acc_in;
	case (opcode)
		0 : result = acc_in + val_in;
		1 : result = acc_in - val_in;
		2 : result = acc_in & val_in;
		3 : result = acc_in | val_in;
		4 : result = acc_in ^ val_in;
		5 : result = &acc_in & &val_in;
		6 : result = |acc_in | |val_in;
		7 : result = ^acc_in ^ ^val_in;
		8 : result = acc_in << val_in[3:0];
		9 : result = acc_in >> val_in[3:0];
		10: result = emsw_result;
		11: result = elsw_result;
		12: result = dmsw_result;
		13: result = dlsw_result;
		14: result = xp4_result;
		15: result = xp2_result;
		16: result = xp1_result;
		// 17: loadm
		18: result = val_in;                 // loadv
		// 19: storem
		// 20: storev
		21: result = acc_in < val_in;        // slt
		// 22: beq
		// 23: rb
		// 24: ab

		// '1: done
	endcase
end

endmodule