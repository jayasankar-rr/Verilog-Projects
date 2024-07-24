module top(clk,reset,t_enable,serial_out,parallel_in,busy,serial_in,parallel_out);
  input clk,reset,t_enable,serial_in;
  input [7:0] parallel_in;
  output serial_out,busy;
  output [7:0]parallel_out;
  
  
  
parameter CLK_HZ = 100000000;
parameter BIT_RATE =   115200;
parameter PAYLOAD_BITS = 8;
  
  //assign serial_in=serial_out;
  transmitter weewee(.clk(clk),.reset(reset),.parallel_in(parallel_in),.t_enable(t_enable),.serial_out(serial_out),.busy(busy));
  
  receiver veevee(.clk(clk),.reset(reset),.serial_in(serial_out),.parallel_out(parallel_out));
  
endmodule