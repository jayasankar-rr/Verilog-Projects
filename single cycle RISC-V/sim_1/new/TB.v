module tb;
  reg clk,reset;
  
  initial begin
    $dumpfile("pp.vcd");
    $dumpvars(0,tb);
  end
  
  top TOP(.clk(clk)
          ,.reset(reset));
  
  always #5 clk=~clk;
  
  initial begin
    clk=1'b0;
    reset=1'b1;
    #5 reset=1'b0;
    
    #100 $finish ;
  end
  
endmodule