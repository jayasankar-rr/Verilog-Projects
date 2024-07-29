module Program_Counter(clk,reset,pc_next,pc_out);
  input clk,reset;
  input [31:0] pc_next;
  output reg [31:0] pc_out;
  
  initial begin
    pc_out=32'b0;
  end
  
  always @(posedge clk) begin
    
    if(reset) begin
      pc_out<=32'b0;
    end
    else begin
    pc_out<=pc_next;
    end
  end
  
endmodule

//////////////////testbench////////////////////
/*
module tb_Program_Counter;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] pc_next;

    // Outputs
    wire [31:0] pc_out;

    // Instantiate the Unit Under Test (UUT)
    Program_Counter uut (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_out(pc_out)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 0;
        pc_next = 32'b0;

        // Open dump file for waveform analysis
        $dumpfile("Program_Counter_tb.vcd");
        $dumpvars(0, tb_Program_Counter);

        // Test Case 1: Reset is active
        reset = 1;
        #10;
        $display("Time = %0t | Reset = %b | PC_Out = %h", $time, reset, pc_out);

        // Test Case 2: Normal operation
        reset = 0;
        pc_next = 32'h00000004;
        #10;
        $display("Time = %0t | Reset = %b | PC_Next = %h | PC_Out = %h", $time, reset, pc_next, pc_out);

        // Test Case 3: Increment PC
        pc_next = 32'h00000008;
        #10;
        $display("Time = %0t | Reset = %b | PC_Next = %h | PC_Out = %h", $time, reset, pc_next, pc_out);

        // Test Case 4: Reset during operation
        reset = 1;
        #10;
        $display("Time = %0t | Reset = %b | PC_Out = %h", $time, reset, pc_out);

        $finish;
    end

    // Clock generator
    always begin
        #5 clk = ~clk;
    end

endmodule

*/