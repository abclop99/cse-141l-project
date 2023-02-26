module register_file_tb #(parameter pointer_width=3);

reg     clock, write_enable;

reg[pointer_width-1:0]    address;
reg[7:0]                data_in;
reg                     is_immediate;

wire[7:0]               data_out;

register_file #(pointer_width) rf(
        .clock, .write_enable, .address, .data_in, .is_immediate, .data_out
        );

initial begin

        // Initialize Inputs
        clock = 0;
        write_enable = 0;
        address = 0;
        data_in = 0;
        is_immediate = 0;

        // Fill register file with data
        // Reverse order to test for correct indexing
        $display("Writing data to register file");
        write_enable = 1;
        for (int i = 0; i < 2**pointer_width; i = i + 1) begin
                address = i;
                data_in = (2**pointer_width - 1) - i;
                #5;
                clock = 1;
                #5;
                clock = 0;
        end

        // Read data from register file
        $display("Testing register mode");
        is_immediate = 0;
        write_enable = 0;
        for (int i = 0; i < 2**pointer_width; i = i + 1) begin
                address = i;
                #5;
                clock = 1;
                #5;
                clock = 0;
                $display("data_out[%d] = %d", i, data_out);
        end

        // Test immediate mode
        $display("Testing immediate mode");
        is_immediate = 1;
        write_enable = 0;
        for (int i = 0; i < 2**pointer_width; i = i + 1) begin
                address = i;
                #5;
                clock = 1;
                #5;
                clock = 0;
                $display("data_out[%d] = %d", i, data_out);
        end

        $stop;

end

endmodule