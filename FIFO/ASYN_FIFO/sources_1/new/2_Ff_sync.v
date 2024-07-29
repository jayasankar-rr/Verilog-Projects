module cdc(clk,reset,ptr,out_ptr);
  input clk,reset;
  input [4:0] ptr;
  output  [4:0] out_ptr;
  
  reg [4:0]ff1,ff2;
  
  assign out_ptr = ff2;
  
  always @(posedge clk or posedge reset) begin
    
    if(reset) begin
      ff1<=0;
      ff2<=0;
    end
    
    else begin
      
      ff1<=ptr;
      ff2<=ff1;
      
    end
    
  end
  
endmodule