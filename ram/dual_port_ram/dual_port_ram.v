module dual_portram(clk,reset,address_a,address_b,write_en_a,write_en_b,data_in_a,data_in_b,data_out_a,data_out_b);
  input clk,reset,write_en_a,write_en_b;
  input [7:0] data_in_a,data_in_b,address_a,address_b;
  output [7:0]data_out_a,data_out_b;
  
  parameter SIZE=8;
 parameter WIDTH=1024; 
  
  int i;
  
  reg [SIZE-1:0] data_reg [WIDTH-1:0];
  reg [SIZE-1:0]out_a,out_b;
  
  always @(posedge clk) begin
    
    if(reset) begin
      
      for(i=0;i<WIDTH;i=i+1)begin
        data_reg[i]<=0;
      end
      out_a<=8'b0;
      out_b<=8'b0;
       end
    
    
    if(write_en_a)
      data_reg[address_a]<=data_in_a;    
      
    else
      
      out_a<=data_reg[address_a];
    
    if(write_en_b)
      data_reg[address_b]<=data_in_b;    
      
    else
      
      out_b<=data_reg[address_b];
   
    
  end
  
  assign data_out_a = out_a;
  assign data_out_b = out_b;
  
endmodule
  