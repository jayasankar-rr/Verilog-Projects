module fsm (clk, reset, in, detect);
  input logic clk, reset;
  input logic in;
  output logic detect=0;
  
  logic [1:0] state, next_state;
  logic [3:0] counter=0;

  localparam idle = 2'b00,
             zero = 2'b01,
             one  = 2'b10,
             pepe = 2'b11;

  
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
     state<=idle;
    end else begin
      state <= next_state;
    end
  end

 
  always@(*) begin
    case (state)
      idle: next_state <= (in) ? one : zero;
      zero: next_state <= (in) ? one : pepe;
      one:  next_state <= (in) ? pepe : zero;
      pepe: next_state <= (in) ? one : zero;
      default: next_state <= idle; 
    endcase

    detect <= (state == pepe)?1'b1 : 1'b0;
  end
endmodule
