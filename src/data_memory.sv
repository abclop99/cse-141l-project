// 8-bit wide, 256-word (byte) deep memory array
module data_memory #(parameter SIZE = 256) (
  input[7:0] data_in,
  input      clock,
  input      write_enable,	          // write enable
  input[7:0] address,		      // address pointer
  output logic[7:0] data_out);

  logic[7:0] core[SIZE];       // 2-dim array  8 wide  256 deep

// reads are combinational; no enable or clock required
  assign data_out = core[address];

// writes are sequential (clocked) -- occur on stores or pushes 
  always_ff @(posedge clock)
    if(write_enable)			// write_enable usually = 0; = 1 		
      core[address] <= data_in; 

endmodule