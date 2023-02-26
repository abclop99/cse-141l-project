module accumulator_tb();

reg     clock, write_enable;
reg[7:0]        data_in;
wire[7:0]       data_out;

accumulator uut(
        .clock,
        .write_enable,
        .data_in,
        .data_out
);

initial begin
        clock = 0;
        write_enable = 0;
        data_in = 0;

        for (int i = 0; i < 10; i = i + 1) begin
                write_enable = ~write_enable;
                data_in = data_in + 1;
                #5;
                clock = 1;
                #5;
                clock = 0;
                #10;
        end
        $stop;

end

endmodule