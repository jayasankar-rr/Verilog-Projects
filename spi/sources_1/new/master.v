module master (clk,reset,enable,master_in,miso,mosi,mode,s_clk,le,te);
  input clk,reset,enable,miso;
  input [7:0]master_in;
  input [2:0]mode;
  output reg mosi=0;
  output reg s_clk;
  output le,te;
  
  parameter freq=4;
  parameter size=9;
  reg spi_clk=0;
  reg [9:0]clk_counter;
  reg [9:0]spi_clk_counter;
  reg [4:0]edge_counter=0;
  reg [2:0]counter=3'b0;
  reg e=1'b0;
  reg [3:0]cycle_counter=4'b0;
  
  localparam IDLE=3'b000;
  localparam LOAD=3'b001;
  localparam SHIFT=3'b010;
  localparam STOP=3'b011;
  
  reg [7:0]mosi_data=8'b0;
  reg [7:0]miso_data=8'b0;
  reg [2:0] current_state=0,next_state=0;
  reg leading_edge=0,trailing_edge=0;
  
  wire cpol,cpha,bit_success;
  assign cpol = (mode == 2)|(mode == 3);
  assign cpha = (mode == 1)|(mode == 3);
  assign bit_success = (spi_clk_counter == 15);
  assign le = leading_edge;
  assign te = trailing_edge;
  
  wire next_bit = spi_clk_counter==9;
  
  
  always@(posedge clk)
    begin
      
      if(reset)
        begin
          spi_clk_counter<=10'b0;
          clk_counter<=10'b0;
          spi_clk<=cpol;
          leading_edge<=1'b0;
          trailing_edge<=1'b0;
          miso_data<=8'b0;
          mosi_data<=8'b0;
          counter<=3'b0111;
        end
      
      if(enable & current_state == SHIFT)
        begin
         
          
          leading_edge  <= 1'b0;
          trailing_edge <= 1'b0;
          
          if(clk_counter == freq-1)
            begin
              leading_edge<=1'b1;
              spi_clk<=~spi_clk;
              clk_counter<=clk_counter+1;
              spi_clk_counter<=spi_clk_counter+1;
              
            end
          
          
          else if(clk_counter == freq*2-1)
            begin
              trailing_edge<=1'b1;
              spi_clk<=~spi_clk;
              clk_counter<=10'b0;
            
            end
          
          else
            begin
              clk_counter<=clk_counter+1;
            end
          
        end
      
    end
  
   always@(*) begin
    case(current_state)
    IDLE: next_state <= enable ? LOAD : IDLE ;
  
    LOAD: begin
          mosi_data<=master_in;
          next_state <= SHIFT;
    end
      
    SHIFT: begin
      
      if(edge_counter==18)
        next_state<=STOP;
      else
        next_state <= SHIFT;
      
     end
      
     STOP:begin
       counter<=3'b111;
       next_state<=IDLE;
    //   mosi_data<=miso_data;
     end
    endcase
  end

  always@(posedge clk)
    begin
     
      current_state<=next_state;
      
      if(current_state == IDLE)
        begin
          miso_data<=8'b00000000;
          mosi_data<=8'b00000000;
          edge_counter<=8'b0;
         clk_counter<=10'b0;
          e<=1'b1;
          
        end
      
      if(current_state == SHIFT)
        begin
          
           if(e & ~cpha)
            begin
              
              e<=1'b0;
              mosi<=mosi_data[counter];
              mosi_data[counter]<=0;
              counter<=counter-1;
              edge_counter<=edge_counter+1;
            end
    
         
          
          if(leading_edge & cpha | trailing_edge & ~cpha)
            begin
              
              mosi<=mosi_data[counter];
              mosi_data[counter]<=0;
              counter<=counter-1;
              edge_counter<=edge_counter+1;

            end
          
          if(leading_edge & ~cpha | trailing_edge & cpha)
            begin
            
              miso_data[7:0]<={miso_data[6:0],miso};
              edge_counter<=edge_counter+1;
             
            end
          
        end
      
      if(current_state ==STOP)
        begin
          edge_counter<=8'b0;
          
        end
      
      
    end
  
  always@(posedge clk)
    begin
      s_clk<=spi_clk;
    end
  
endmodule