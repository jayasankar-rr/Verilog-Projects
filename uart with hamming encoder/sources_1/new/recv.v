module receiver(clk,reset,serial_in,parallel_out,r_enable,r_busy);
  input clk,reset,serial_in,r_enable;
  output [7:0] parallel_out;
  output r_busy;
  
 //parameter   BIT_RATE        = 115200; // bits / sec
//localparam  BIT_P           = 1_000_000_000 * 1/BIT_RATE; // nanoseconds

//
// Clock frequency in hertz.
//parameter   CLK_HZ          =    50_000_000;
//localparam  CLK_P           = 1_000_000_000 * 1/CLK_HZ;
  
 localparam       CYCLES_PER_BIT     = 868;
  
  reg p1=0,p2=0,p4=0,p8=0;
  
  
  reg [2:0] state=0;
  reg [2:0] next_state=0;
  // localparam CYCLES_PER_BIT= 5;
  localparam size = 12;
  localparam IDLE = 0;
  localparam START= 1;
  localparam RECV = 2;
  localparam STOP = 3;
  
  reg [3:0] bit_counter;
  reg[9:0] cycle_counter;
  reg [7:0] rdata_reg=8'b0;
  reg [11:0] decoded_data=12'b0;
  reg [11:0] syndrome=12'b0;
  reg [11:0] syndrome_calculation=12'b0;
  reg rxd=1'b1;
  //reg [7:0] parallel_out=8'b0;
  
   wire next_bit = cycle_counter == CYCLES_PER_BIT-1;
   wire trmsn_complete = bit_counter == size;
   wire stop_done = cycle_counter == 100 && state == STOP;
   assign r_busy = state != IDLE;
   
   assign parallel_out = rdata_reg;
  
   
  always@(posedge clk)
    begin
      
     state<=next_state;
     
     if(reset)
      begin
       cycle_counter<=10'b0; 
        bit_counter<=4'b0;
        rdata_reg<=8'b0;
        next_state<=IDLE;
      end
      
      
      if(state == IDLE)
        begin
          bit_counter<=4'b0;
          cycle_counter<=10'b0;
          rdata_reg<=8'b0;
         
        end
     else if (state == START) 
      begin
         bit_counter=4'b0;
         rxd<=1'b0;
        if(next_bit)
          cycle_counter<=10'b1101100011;
        else
          cycle_counter<=cycle_counter+1;
      end
      else if(state == RECV) begin
        if(next_bit)
          begin
           rxd<=serial_in;
            bit_counter<=bit_counter+1;
            decoded_data<={decoded_data[10:0],rxd};
            cycle_counter<=10'b0;
            
            
          end
        else
          
          cycle_counter<=cycle_counter+1;
      end
      else if (state ==STOP)
        begin
        rxd<=1'b1;
        bit_counter=4'b0;
          
          p1 <= decoded_data[0] ^ decoded_data[2] ^ decoded_data[4] ^ decoded_data[6] ^ decoded_data[8] ^ decoded_data[10];
          p2 <= decoded_data[1] ^ decoded_data[2] ^ decoded_data[5] ^ decoded_data[6] ^ decoded_data[9] ^ decoded_data[10];
          p4 <= decoded_data[3] ^ decoded_data[4] ^ decoded_data[5] ^ decoded_data[6] ^ decoded_data[11];
          p8 <= decoded_data[7] ^ decoded_data[8] ^ decoded_data[9] ^ decoded_data[10] ^ decoded_data[11];
          
       //   p1<=0;
        //  p2<=0;
        //  p4<=0;
        //  p8<=0;
          
          
          case({p8,p4,p2,p1})
        4'd1: syndrome = 12'b000000000001;
        4'd2: syndrome = 12'b000000000010;
        4'd3: syndrome = 12'b000000000100;
        4'd4: syndrome = 12'b000000001000;
        4'd5: syndrome = 12'b000000010000;
        4'd6: syndrome = 12'b000000100000;
        4'd7: syndrome = 12'b000001000000;
        4'd8: syndrome = 12'b000010000000;
        4'd9: syndrome = 12'b000100000000;
        4'd10: syndrome = 12'b001000000000;
        4'd11: syndrome = 12'b010000000000;
        4'd12: syndrome = 12'b100000000000;
        default : syndrome = 12'b000000000000;
      endcase
    syndrome_calculation <= syndrome ^ decoded_data;
      
      rdata_reg<={syndrome_calculation[11:8],syndrome_calculation[6:4],syndrome_calculation[2]};
          
          
        cycle_counter<=cycle_counter+1;
        
         
      end
    end
  
  always @(*)
    begin
      case(state)
        IDLE:begin 
         next_state <= !serial_in ? START :IDLE;
        end
        START:begin
          next_state <= next_bit ? RECV : START;
        end
        RECV :begin
          
         next_state = trmsn_complete && next_bit? STOP : RECV ;
       end
        STOP: begin
           next_state <= stop_done ? IDLE : STOP;
      end
      endcase
    end
  
 
endmodule