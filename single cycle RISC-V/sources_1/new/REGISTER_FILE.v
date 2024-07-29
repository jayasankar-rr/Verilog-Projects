module register_file(clk,reset,A1,A2,A3,WD3,WE3,RD1,RD2);
  input [4:0] A1,A2,A3;
  input clk,reset,WE3;
  input [31:0] WD3;
  output [31:0] RD1,RD2;
  
  reg [31:0] Reg [31:0];
   integer i;
  initial begin
   
    for (i = 0; i < 32; i = i + 1) begin
        Reg[i] = 32'b0;
    end
end
  
  always@(posedge clk) begin
      
    if(WE3) begin
        Reg[A3] <= WD3;
      end
    
  end
  
  assign RD1 = (reset) ? 32'b0 : Reg[A1];
  assign RD2 = (reset) ? 32'b0 : Reg[A2];
  
  initial begin
    Reg[2] = 32'h00000005;
    Reg[5] = 32'h00000003;
    Reg[6] = 32'h00000004;
    Reg[8] = 32'hDEADBEEF;
    Reg[1] = 32'hDADE;
        
    end
  
endmodule

//////////////////////tb///////////////////////

/*
module tb_register_file;

    // Inputs
    reg clk;
    reg reset;
    reg [4:0] A1, A2, A3;
    reg [31:0] WD3;
    reg WE3;

    // Outputs
    wire [31:0] RD1, RD2;

    // Instantiate the Unit Under Test (UUT)
    register_file uut (
        .clk(clk),
        .reset(reset),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .WE3(WE3),
        .RD1(RD1),
        .RD2(RD2)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        A1 = 0;
        A2 = 0;
        A3 = 0;
        WD3 = 0;
        WE3 = 0;

        // Open dump file for waveform analysis
        $dumpfile("register_file_tb.vcd");
        $dumpvars(0, tb_register_file);

        // Reset the register file
        #5 reset = 1;
        #5 reset = 0;

        // Test Case 1: Write to register 1
        A3 = 5'b00001;
        WD3 = 32'hDEADBEEF;
        WE3 = 1;
        #10 WE3 = 0;

        // Test Case 2: Read from register 1
        A1 = 5'b00001;
        A2 = 5'b00001;
        #10;

        // Test Case 3: Write to register 2 and read from register 1 and 2
        A3 = 5'b00010;
        WD3 = 32'hCAFEBABE;
        WE3 = 1;
        #10 WE3 = 0;
        A1 = 5'b00001;
        A2 = 5'b00010;
        #10;

        $finish;
    end

    // Clock generator
    always begin
        #5 clk = ~clk;
    end

endmodule

*/