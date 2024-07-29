module sign_extend(in,out,ImmSrc);
  input [31:0] in;
  input [1:0] ImmSrc;
  output [31:0] out;
  
  assign out = (ImmSrc == 2'b00 ) ? {{20{in[31]}},in[31:20]} :( ImmSrc == 2'b01) ? {{20{in[31]}},in[31:25],in[11:7]}: 
    (ImmSrc == 2'b10) ? {{20{in[31]}},in[7],in[30:25],in[11:8],1'b0} :
    ({20{in[31:0]}});
  
endmodule