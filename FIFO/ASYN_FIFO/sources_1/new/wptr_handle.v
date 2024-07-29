module wptr_handle #(parameter width=4)(clk,reset,rptr_sync,w_en,full,wptr,w_addr);
  input clk,reset,w_en;
  input [width:0]rptr_sync;
  output [width:0]wptr;
  output [width-1:0]w_addr;
  output full;
  
  wire [width:0] addr_next,greycode_next;
  reg [width:0] addr,greycode;
  
  wire wrap_around ;
  
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
      
  assign addr_next = addr+(w_en && !full);
  assign greycode_next = addr_next >> 1 ^(addr_next);
  
  assign w_addr = addr[width-1:0];
  assign wptr = greycode;
  
  assign wrap_around = (greycode[width] ^ rptr_sync[width]);
  
  assign full = wrap_around && (greycode_next[width-1:0] == rptr_sync[width-1:0]);
      
  
endmodule
  