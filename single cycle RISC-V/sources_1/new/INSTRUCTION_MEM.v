//`include "memfile.hex"
module instruction_mem(Address,Data,reset);
  input reset;
  input [31:0] Address;
  output [31:0] Data;
  
  reg [31:0] Memory [1023:0];
  
initial begin
  Memory[0]=32'h00000000;
  Memory[1]=32'b00000000101000101000010100010011;
  Memory[2]=32'b000000001000_00101_010_01010_0000011;
  Memory[3]=32'b0000000_01000_00101_010_01010_0100011;
  Memory[4]=32'b000000001010_00101_010_01010_0000011;
  Memory[5]=32'b0000000_00001_00001_000_01000_1100011;
end

  
  assign Data = (reset == 1'b1 ) ? 32'b0 : Memory[Address[31:2]];
  
//  initial begin
//     $readmemh("memfile.hex",Memory);
//  end
  
endmodule
  
  
  //////////////////tb////////////
/*
module tb_instruction_mem;

    // Inputs
    reg Reset;
    reg [31:0] Address;

    // Outputs
    wire [31:0] Data;

    // Instantiate the Unit Under Test (UUT)
    instruction_mem uut (
        .Reset(Reset),
        .Address(Address),
        .Data(Data)
    );

    initial begin
        // Initialize the memory with some values for testing
        uut.Memory[0] = 32'h12345678;
        uut.Memory[1] = 32'h87654321;
        uut.Memory[2] = 32'hABCDEF01;
        uut.Memory[3] = 32'h01010101;

        // Open dump file for waveform analysis
        $dumpfile("instruction_mem_tb.vcd");
        $dumpvars(0, tb_instruction_mem);

        // Test Case 1: Reset is active
        Reset = 1;
        Address = 32'b0;
        #10;
        $display("Reset = %b, Address = %h, Data = %h", Reset, Address, Data);

        // Test Case 2: Read from address 0
        Reset = 0;
        Address = 32'b0;
        #10;
        $display("Reset = %b, Address = %h, Data = %h", Reset, Address, Data);

        // Test Case 3: Read from address 1
        Address = 32'b100;
        #10;
        $display("Reset = %b, Address = %h, Data = %h", Reset, Address, Data);

        // Test Case 4: Read from address 2
        Address = 32'b1000;
        #10;
        $display("Reset = %b, Address = %h, Data = %h", Reset, Address, Data);

        // Test Case 5: Read from address 3
        Address = 32'b1100;
        #10;
        $display("Reset = %b, Address = %h, Data = %h", Reset, Address, Data);

        $finish;
    end

endmodule

*/