module rptr_handle #(parameter width=4)(clk,reset,r_en,wptr_sync,rptr,empty,r_addr);
  input clk,reset,r_en;
  input [width:0] wptr_sync;
  output empty;
  output [width-1:0] r_addr;
  output [width:0] rptr;
  
  wire [width:0] addr_next,greycode_next;
  reg [width:0] addr,greycode;
  
  always @(posedge clk) begin
    
    if(reset) begin
      
      greycode<=5'b0;
      addr<=5'b0;
      
    end
    
    else begin
      
      addr<=addr_next;
    greycode<=greycode_next;
    
  end
    
  end
  
  assign addr_next = addr +(r_en && !empty);
  assign greycode_next = (addr_next>>1)^addr_next;
  
  assign rptr = greycode;
  assign r_addr = addr[width-1:0];
  
  assign empty = (wptr_sync == greycode);
  
endmodule
  
  