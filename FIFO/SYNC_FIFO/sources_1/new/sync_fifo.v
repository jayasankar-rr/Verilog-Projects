module fifo(clk,reset,data_in,data_out,write_en,read_en,full,empty);
  input clk,reset,write_en,read_en;
  input [7:0] data_in;
  output full,empty;
  output reg [7:0] data_out;
  
  localparam width = 8;
  localparam depth = 4;
  
  
  reg [width-1:0] regg [depth-1:0] ;
  reg [5:0] wrt_ptr,rd_ptr;
  integer i;
  
  always @(posedge clk) begin
    
    if(reset)begin
      
      for(i=0;i<depth;i=i+1) begin
        regg[i]<=8'b0;
      end
      
      data_out<=8'b0;
      wrt_ptr<=6'b0;
      rd_ptr <=6'b0;
      
    end
    
    else begin
      
      if(write_en && !full) begin
        regg[wrt_ptr]<=data_in;
        wrt_ptr<=wrt_ptr+1;
      end
      
      if(read_en && !empty) begin
        data_out<=regg[rd_ptr];
        rd_ptr<=rd_ptr+1;
        
      end
        
      
    end // else end
    
  end  //always end
  
  
  
  assign empty = (wrt_ptr == rd_ptr ) ? 1'b1 : 1'b0;
  assign full =  (wrt_ptr == depth) ? 1'b1:1'b0; 
endmodule