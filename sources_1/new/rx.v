module receiver(clk,reset,serial_in,parallel_out,r_busy);
  input clk,reset,serial_in;
  output  [7:0] parallel_out;
  output r_busy;
 //parameter   BIT_RATE        = 115200; // bits / sec
//localparam  BIT_P           = 1_000_000_000 * 1/BIT_RATE; // nanoseconds

//
// Clock frequency in hertz.
//parameter   CLK_HZ          =    50_000_000;
//localparam  CLK_P           = 1_000_000_000 * 1/CLK_HZ;
  
 localparam       CYCLES_PER_BIT     = 868;
  
  
 // reg [7:0] parallel_out=8'b0;
  reg [2:0] state=0;
  reg [2:0] next_state=0;
  // localparam CYCLES_PER_BIT= 5;
  localparam size = 8;
  localparam IDLE = 0;
  localparam START= 1;
  localparam RECV = 2;
  localparam STOP = 3;
  
  reg [3:0] bit_counter;
  reg[9:0] cycle_counter;
  reg [7:0] rdata_reg=8'b0;
  reg [7:0] luck=8'b0;
  reg rxd=1'b1;
  //reg [7:0] parallel_out=8'b0;
    assign parallel_out=rdata_reg;

  
   wire next_bit = cycle_counter == CYCLES_PER_BIT-1;
   wire trmsn_complete = bit_counter == size;
   wire stop_done = cycle_counter == 100 && state == STOP;
   assign r_busy = state != IDLE;
   
   
  
   
  always@(posedge clk)
    begin
      
     state<=next_state;
     
     if(reset)
      begin
       cycle_counter<=10'b0; 
        bit_counter<=4'b0;
       // rdata_reg<=8'b0;
        next_state<=IDLE;
      end
      
      
      if(state == IDLE)
        begin
          bit_counter<=4'b0;
          cycle_counter<=10'b0;
          rdata_reg<=8'b00000000;
         
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
            rdata_reg<={rdata_reg[6:0],rxd};
            cycle_counter<=10'b0;
          end
        else
          
          cycle_counter<=cycle_counter+1;
      end
      else if (state ==STOP)
        begin
        rxd<=1'b1;
        bit_counter=4'b0;
       // luck<=rdata_reg;
        
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