module top(clk,reset,master_in,mosi,miso,s_mosi,s_miso,mode,s_clk,enable,slave_in,slave_clk,le,te,s_leading_edge,s_trailing_edge);
 input clk,reset,enable,slave_clk,miso,s_mosi,s_leading_edge,s_trailing_edge;
  input [2:0]mode;
  input [7:0]master_in;
  input [7:0]slave_in;
  output s_clk,mosi,s_miso,le,te;
  
  
  assign s_mosi=mosi;
  assign miso=s_miso;
  assign slave_clk=s_clk;
  assign s_leading_edge=le;
  assign s_trailing_edge=te;
  
  master xx(.clk(clk),.reset(reset),.master_in(master_in),.mosi(mosi),.miso(miso),.s_clk(s_clk),.enable(enable),.mode(mode),.le(le),.te(te));
  
  slave pp(.slave_clk(slave_clk),.slave_in(slave_in),.s_miso(s_miso),.s_mosi(s_mosi),.mode(mode),.enable(enable),.clk(clk),.s_leading_edge(s_leading_edge),.s_trailing_edge(s_trailing_edge));
  
endmodule