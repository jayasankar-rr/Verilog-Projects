

module tb;
  logic clk,reset,in;
  logic detect;
  
  logic [9:0] data;
  
  fsm uut(.clk(clk)
          ,.reset(reset)
          ,.in(in)
          ,.detect(detect));
  
  initial begin
    $dumpfile("pepe.vcd");
    $dumpvars(0,tb);
    
  end
  
  always #5 clk=~clk;
  
  initial begin
    
    clk=0;
    reset=1;
    in=0;

    
    #5 reset=0;
    data=10'b0101001101;
    
    send_data(data);
    
    
  #50 $finish;
    
    
  end
  
  task send_data(input logic [9:0]data);
    int i;
    for(i=0;i<10;i++) begin
      @(posedge clk);
      in=data[i];
    end
  endtask
  
  
endmodule

