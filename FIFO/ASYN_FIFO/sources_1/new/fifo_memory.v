module fifo_memory(clk,reset,write_data,read_data,write_en,waddr,raddr,full);
  input clk,reset,write_en,full;
  input [7:0] write_data;
  input [3:0] waddr,raddr;
  output [7:0] read_data;
    
  integer i;
  
  reg [7:0] memory [15:0];
  
  always @(posedge clk) begin
    
    if(reset) begin
      for(i=0 ; i<8;i=i+1) begin
      memory[i]<=8'b0;
      end
      end
    
    if(write_en && !full && !reset) begin
      
      memory[waddr]<=write_data;
      
    end
    
    
  end
    
    assign read_data = memory[raddr];
    
endmodule// Code your design here
