module shift(shift_in,shift_out);
  
  input [31:0] shift_in;
  output [31:0] shift_out;
  
  assign shift_out = shift_in << 1;
  
endmodule