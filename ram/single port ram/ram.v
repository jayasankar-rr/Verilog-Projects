module ram(clk,reset,address,write_en,data_in,data_out);
  input clk,reset,write_en;
  input [7:0] data_in,address;
  output [7:0]data_out;
  
  parameter SIZE=8;
 parameter WIDTH=1024; 
  
  int i;
  
  reg [SIZE-1:0] data_reg [WIDTH-1:0];
  reg [SIZE-1:0]out;
  
  always @(posedge clk) begin
    
    if(reset) begin
      
      for(i=0;i<WIDTH;i=i+1)begin
        data_reg[i]<=0;
      end
       end
    
    
       if(write_en)
        data_reg[address]<=data_in;    
      
    else
      
      out<=data_reg[address];
   
    
  end
  
  assign data_out = out;
  
endmodule
  