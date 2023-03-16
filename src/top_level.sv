module top_level
(
	input         clk,  // Clock input
	              req,  // Sets PC to 0 and starts execution
	output logic  done  // Indicates when execution is
	                    // complete and stops execution
);

parameter PC_WIDTH            = 12,
          REGISTER_FILE_WIDTH = 3,
          ALU_COMMAND_WIDTH   = 5,
          DATA_MEMORY_SIZE    = 256;

/* Control signals */
wire    reg_write_enable,
        acc_write_enable,
        dat_write_enable;
wire    compare_enable,
        reljump_enable,
        absjump_enable;
wire    acc_src;
wire    pc_reset,
        pc_enable;
wire[ALU_COMMAND_WIDTH-1:0] alu_op;

/* Datapaths */

// Wires to/from the program counter
wire[PC_WIDTH-1:0] pc_in, pc_out, pc_added;

// Wires from instruction memory
wire[8:0] instruction;

// Wire from the register file
wire[7:0] reg_read;

// Wires to/from accumulator
wire[7:0] acc_in, acc_read;

// Branching datapath wires already defined elsewhere

// Wires from data memory and ALU
wire[7:0] data_read, alu_out;

/* Modules */

// Control
control ctrl1 (
	.instruction(instruction),
	.req(req),
	.reg_write_enable(reg_write_enable),
	.acc_write_enable(acc_write_enable),
	.dat_write_enable(dat_write_enable),
	.compare_enable(compare_enable),
	.reljump_enable(reljump_enable),
	.absjump_enable(absjump_enable),
	.acc_src(acc_src),
	.alu_op(alu_op),
	.done(done),
	.pc_reset(pc_reset),
	.pc_enable(pc_enable)
);

// Program counter
program_counter #(.D(PC_WIDTH)) pc1 (
	.clock(clk),
	.reset(pc_reset),
	.enable(pc_enable),
	.pc_in(pc_in),
	.pc_out(pc_out),
	.pc_added(pc_added)
);

// Instruction memory
instruction_rom #(.D(PC_WIDTH)) ir1 (
	.address(pc_out),
	.machine_code(instruction)
);

// Register file
register_file #(.pointer_width(REGISTER_FILE_WIDTH)) rf1 (
	.address(instruction[2:0]),
	.is_immediate(instruction[3]),
	.data_in(acc_read),
	.clock(clk),
	.write_enable(reg_write_enable),
	.data_out(reg_read)
);

// Accumulator
accumulator acc1 (
	.data_in(acc_in),
	.clock(clk),
	.write_enable(acc_write_enable),
	.data_out(acc_read)
);

// Branching
branching #(.D(PC_WIDTH)) br1 (
	.pc_in(pc_added),
	.pc_out(pc_in),
	.val(reg_read),
	.acc(acc_read),
	.compare_enable(compare_enable),
	.reljump_enable(reljump_enable),
	.absjump_enable(absjump_enable)
);

// Data memory
data_memory #( .SIZE(DATA_MEMORY_SIZE) ) dm1 (
	.clock(clk),
	.data_in(acc_read),
	.write_enable(dat_write_enable),
	.address(reg_read),
	.data_out(data_read)
);

// ALU
alu alu1 (
	.opcode(alu_op),
	.val_in(reg_read),
	.acc_in(acc_read),
	.result(alu_out)
);

// Connect outputs to accumulator
assign acc_in = (acc_src) ? alu_out : data_read;

endmodule