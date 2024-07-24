
module tb();
  reg clk,reset,t_enable;
  reg [7:0] parallel_in;
  wire serial_out;
  wire busy,tx_output;
  wire [7:0] parallel_out;
  
  top DUT(.clk(clk),.reset(reset),.parallel_in(parallel_in),.busy(busy),.serial_out(serial_out),.t_enable(t_enable),.serial_in(serial_in),.parallel_out(parallel_out));
  

  

  
  localparam BIT_RATE = 115200;
localparam BIT_P    = (1000000000/BIT_RATE);

//
// Period and frequency of the system clock.
localparam CLK_HZ   = 100000000;
localparam CLK_P    = 1000000000/ CLK_HZ;
localparam CLK_P_2   = 500000000/ CLK_HZ;
  
always #CLK_P_2 clk=~clk;
  
  initial begin
  $dumpfile("file.vcd");
    $dumpvars(0,tb);
    
    clk=1'b1;
    t_enable=1'b0;
    parallel_in =8'b00000000;
    #10 t_enable=1'b1;
    parallel_in =8'b10101010;
    
    

     #100000 $finish;
 
  end
endmodule
  
  
  