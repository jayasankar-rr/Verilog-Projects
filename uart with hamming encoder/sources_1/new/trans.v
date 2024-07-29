module transmitter(clk,reset,t_enable,parallel_in,serial_out,busy);
  input clk,reset,t_enable;
  input [7:0] parallel_in;
  output serial_out,busy;
  
  //parameter   BIT_RATE        = 115200; // bits / sec
//localparam  BIT_P           = 1_000_000_000 * 1/BIT_RATE; // nanoseconds

//
// Clock frequency in hertz.
//parameter   CLK_HZ          =    50_000_000;
//localparam  CLK_P           = 1_000_000_000 * 1/CLK_HZ; // nanoseconds

  localparam       CYCLES_PER_BIT     = 868;
  
  reg [7:0] data_reg=8'b0;
  reg [11:0] encoded_data=12'b0;
  reg [9:0] cycle_counter=4'b0;
  reg [3:0] bit_counter=4'b0;
  reg txd =1'b1;
  reg p1,p2,p4,p8;
  
  reg [2:0] state=0;
  reg [2:0] next_state=0;
 // localparam CYCLES_PER_BIT=5;
  localparam size = 12;
  localparam IDLE = 0;
  localparam START= 1;
  localparam DATA = 2;
  localparam STOP = 3;
  
  
  
  assign serial_out = txd;
  assign busy = state != IDLE;
  
  wire next_bit = cycle_counter == CYCLES_PER_BIT-1;
  wire trmsn_complete = bit_counter == size;
   wire stop_done = cycle_counter == 100 && state == STOP;
  integer i=0;
  
  always@(posedge clk)begin
      
    state<=next_state;
    if(reset)
      begin
       cycle_counter<=10'b0; 
        bit_counter<=4'b0;
        data_reg<=8'b0;
        next_state<=IDLE;
      end
    if (state == IDLE)
      begin
        txd<=1'b1;
        bit_counter=4'b0;
       cycle_counter<=10'b0; 
      end
    else if (state == START) 
      begin
         bit_counter=4'b0;
         txd<=1'b0;
        data_reg<=parallel_in;
        
         p1 = data_reg[0] ^ data_reg[1] ^ data_reg[3] ^ data_reg[4] ^ data_reg[6] ;
    p2 = data_reg[0] ^ data_reg[2] ^ data_reg[3] ^ data_reg[5] ^ data_reg[6]  ;
    p4 = data_reg[1] ^ data_reg[2] ^ data_reg[3]^data_reg[7];
    p8 = data_reg[4] ^ data_reg[5] ^ data_reg[6]^data_reg[7] ;
        
        encoded_data<={data_reg[7:4],p8,data_reg[3:1],p4,data_reg[0],p2,p1};
        
        if(next_bit)
         cycle_counter<=10'b1101100011;
        else
          cycle_counter<=cycle_counter+1;
      end
    else if(state == DATA)
      begin
      
        if (next_bit)begin
          cycle_counter<=10'b0;
          txd <= encoded_data[size-1];
          encoded_data <= {encoded_data[size-2:0],1'b0}; 
          bit_counter<=bit_counter+1;
         
         end
        else
          cycle_counter<=cycle_counter+1;
      end
    else if(state==STOP)
      begin
      txd<=1'b1;
        bit_counter<=4'b0;  
        cycle_counter<=cycle_counter+1;
        
         
      end
      
    end
  always@(*)begin
    case(state)
      IDLE :begin
        next_state <= t_enable ? START : IDLE;
        
      end
        
      START:begin
        next_state <= next_bit? DATA : START;
        
      end
      
      DATA: begin
        next_state <= trmsn_complete && next_bit  ? STOP : DATA;
      
      end
      
      STOP: begin
           next_state <= stop_done ? IDLE : STOP;
      end
      
   
    endcase
    
   
  end
endmodule
