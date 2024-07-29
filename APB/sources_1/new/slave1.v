`timescale 1ns/1ps
module slaver1(

  input pwrite,psel,penable,pclk,preset,
  input [7:0] paddr,pwdata,
  output reg [7:0] prdata,
  output reg pready

);
  
integer i;
  reg [7:0] mem [1023:0];
  
  initial begin
    for ( i = 0; i < 1024; i = i + 1) begin
      mem[i] = 8'b0;
    end
  end
  
 
  
  always @(*) begin
    
    if(preset)
      pready <=0;
    
    else begin
      
      if(psel && pwrite && penable)begin
      
        pready<=1;
        mem[paddr]<=pwdata;
        
        
      end
      
      else if(psel && !pwrite && penable)begin
        
         pready<=1;
        prdata<= mem[paddr];
        
        
      end
      
      else
        pready<=0;
      
    end
      //end of else    
  end// end if always block
  
  
  
endmodule