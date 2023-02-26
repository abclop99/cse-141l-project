module accumulator (
        input[7:0]      data_in,

        input           clock,
        input           write_enable,

        output logic[7:0]       data_out
);

reg[7:0]      core;

assign data_out = core;

always @(posedge clock)
begin
        if (write_enable)
                core <= data_in;
end

endmodule