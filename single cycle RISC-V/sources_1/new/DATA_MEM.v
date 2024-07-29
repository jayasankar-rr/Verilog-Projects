module data_memory(clk,reset,A,WD,RD,WE);
  input clk,reset,WE;
  input [31:0] A,WD;
  output [31:0] RD;
  
  reg [31:0] data_mem [1023:0];
  
  always @(posedge clk) begin
    
    if(WE) begin
      
      data_mem[A]<=WD;
      
    end
    
  end
  
  assign RD = (reset) ? 32'b0 : data_mem[A];
  
  initial begin
    data_mem[11] = 32'h00000020;
        //mem[40] = 32'h00000002;
    end
  
endmodule



///////////////////////////tb//////////////////

/*


module tb_data_memory;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] A;
    reg [31:0] WD;
    reg WE;

    // Outputs
    wire [31:0] RD;

    // Instantiate the Unit Under Test (UUT)
    data_memory uut (
        .clk(clk),
        .reset(reset),
        .A(A),
        .WD(WD),
        .WE(WE),
        .RD(RD)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        A = 0;
        WD = 0;
        WE = 0;

        // Open dump file for waveform analysis
        $dumpfile("data_memory_tb.vcd");
        $dumpvars(0, tb_data_memory);

        // Test Case 1: Reset the memory
        #5 reset = 1;
        #5 reset = 0;

        // Test Case 2: Write to address 0
        A = 32'b0;
        WD = 32'hDEADBEEF;
        WE = 1;
        #10 WE = 0;

        // Test Case 3: Read from address 0
        A = 32'b0;
        #10;

        // Test Case 4: Write to address 1
        A = 32'b1;
        WD = 32'hCAFEBABE;
        WE = 1;
        #10 WE = 0;

        // Test Case 5: Read from address 1
        A = 32'b1;
        #10;

        // Test Case 6: Read from address 0 again
        A = 32'b0;
        #10;

        $finish;
    end

    // Clock generator
    always begin
        #5 clk = ~clk;
    end

endmodule


*/