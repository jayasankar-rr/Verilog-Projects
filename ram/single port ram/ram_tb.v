module tb();
  reg clk, reset, write_en;
  reg [7:0] data_in, address;
  wire [7:0] data_out; 


  ram dutram(
    .clk(clk),
    .reset(reset),
    .address(address),
    .write_en(write_en),
    .data_in(data_in),
    .data_out(data_out)
  );

 
  always #5 clk = ~clk;

  initial begin
   
     $dumpfile("pp.vcd");
    $dumpvars(0, tb);
    
    clk = 1'b0;
    reset = 1'b1;
    write_en = 1'b0;
    data_in = 8'b0;
    address = 8'b0;

  
    #10 reset = 1'b0;

  
    data_in = 8'b00000001;
    address = 8'b00000001;
    write_en = 1'b1;
    #10 write_en = 1'b0;

  
    address = 8'b00000001;
    #10;

   
   

  
    #50 $finish;
  end

endmodule
