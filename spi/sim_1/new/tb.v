
module tb();
  reg clk,reset,enable,slave_clk,miso,s_mosi;
  reg [2:0]mode;
  reg [7:0]master_in;
  reg [7:0]slave_in;
  wire s_clk,mosi,s_miso;
  
  always #5 clk=~clk;
   initial begin
     
     $dumpfile("testfile.vcd");
     $dumpvars(0,tb);
      
     
     clk=1'b0;
     mode=3'b001;
     reset=1'b1;
     enable=1'b0;
     master_in=8'b00000000;
     slave_in=8'b00000000;
     
     #10 reset=1'b0;
     master_in=8'b10101010;
     slave_in=8'b10101010;
     enable=1'b1;
     
     #1000 $finish;
     
   end
  
  
  top xxpp(.clk(clk),.reset(reset),.enable(enable),.master_in(master_in),.slave_in(slave_in),.mode(mode));
  
  
endmodule
  
  
  