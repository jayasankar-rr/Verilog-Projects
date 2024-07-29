module slave(clk,slave_clk,reset,s_miso,s_mosi,mode,slave_in,enable,s_leading_edge,s_trailing_edge);
  input slave_clk,reset,s_mosi,enable,clk,s_leading_edge,s_trailing_edge;
  input [2:0]mode;
  input [7:0]slave_in;
  output reg s_miso=0;
  
  parameter size=9;
  
  localparam IDLE=3'b000;
  localparam LOAD=3'b001;
  localparam SHIFT=3'b010;
  localparam STOP=3'b011;
  
  reg [7:0]s_mosi_data=8'b0;
  reg [7:0]s_miso_data=8'b0;
  reg [2:0] s_current_state=0,s_next_state=0;
 // reg s_leading_edge,s_trailing_edge;
  reg [9:0]s_clk_shifter=0;
  reg [4:0]s_edge_counter=0;
  reg [2:0]counter=3'b111;
  
  reg s=1'b1;
  

  
  wire cpol,cpha;
  assign cpol = (mode == 2)|(mode == 3);
  assign cpha = (mode == 1)|(mode == 3);
 
 
  always @(negedge s_leading_edge)begin
    
     if(s_current_state == SHIFT) begin
       
       if(cpha)begin
          s_mosi_data[7:0]<={s_mosi_data[6:0],s_mosi};
              s_edge_counter<=s_edge_counter+1;
       end
       else begin
          s_miso<=s_miso_data[counter];
              s_miso_data[counter]<=0;
              counter<=counter-1;
              s_edge_counter<=s_edge_counter+1;
       end
       
     end
    
  end
  always @(negedge s_trailing_edge)begin
    
    if(s_current_state == SHIFT) begin
      
      if(cpha)begin
        s_miso<=s_miso_data[counter];
              s_miso_data[counter]<=0;
              counter<=counter-1;
              s_edge_counter<=s_edge_counter+1;
      end
      
      else begin
        
        s_mosi_data[7:0]<={s_mosi_data[6:0],s_mosi};
              s_edge_counter<=s_edge_counter+1;
        
      end
    end
    
  end
   
  always @(posedge clk)
    begin
     s_current_state<=s_next_state;
      
      if( s_current_state == SHIFT)begin
        if(s & ~cpha)
            begin
              if(s_clk_shifter == 1) begin
              s<=1'b0;
               s_mosi_data[7:0]<={s_mosi_data[6:0],s_mosi};
               s_edge_counter<=s_edge_counter+1;
              end
              else
                s_clk_shifter<=s_clk_shifter+1;
            end
      end
    end
  
  always @(*)begin
    case(s_current_state)
    
      IDLE: begin
       
        if(enable)
        s_next_state<=LOAD;
        s_mosi_data<=8'b0;
      end
      
      LOAD:begin
         s_miso_data<=slave_in;
        s_next_state<=SHIFT;
      end
      
      SHIFT:begin
        if(s_edge_counter==18)begin
          s_next_state<=STOP;
      end
        else begin
          s_next_state<=SHIFT;
      end
        end
        STOP:begin
          s_next_state<=IDLE;
          s_edge_counter<=4'b0;
          
        end
      
      endcase
    end
       
       endmodule