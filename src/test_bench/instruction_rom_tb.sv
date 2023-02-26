module instruction_rom_tb ();
parameter D=12;

reg [D-1:0]     address;
wire [8:0]     machine_code;

instruction_rom #(.D(D)) rom (.address(address), .machine_code);

initial begin
        $dumpfile("instruction_rom_tb.vcd");
        $dumpvars(0, instruction_rom_tb);
        $display("address machine_code");
        for (address=0; address<25; address=address+1) begin
                #10;
                $display("%d %b", address, machine_code);
        end

        $stop;

end

endmodule