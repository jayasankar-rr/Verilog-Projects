module tb();
  reg clk, reset, write_en_a, write_en_b;
  reg [7:0] data_in_a, data_in_b, address_a, address_b;
  wire [7:0] data_out_a, data_out_b;

 
  dual_portram dut (
    .clk(clk),
    .reset(reset),
    .write_en_a(write_en_a),
    .write_en_b(write_en_b),
    .data_in_a(data_in_a),
    .data_in_b(data_in_b),
    .address_a(address_a),
    .address_b(address_b),
    .data_out_a(data_out_a),
    .data_out_b(data_out_b)
  );


  always #5 clk = ~clk;

  initial begin
   
    clk = 1'b0;
    reset = 1'b1;
    write_en_a = 1'b0;
    write_en_b = 1'b0;
    data_in_a = 8'b0;
    data_in_b = 8'b0;
    address_a = 8'b0;
    address_b = 8'b0;

   
    $dumpfile("pp.vcd");
    $dumpvars(0, tb);

  
    #10 reset = 1'b0;

   
    #10;
    data_in_a = 8'b00000001;
    address_a = 8'b00000001;
    write_en_a = 1'b1;
    #10 write_en_a = 1'b0;

   
    #10;
    data_in_b = 8'b00000010;
    address_b = 8'b00000010;
    write_en_b = 1'b1;
    #10 write_en_b = 1'b0;

   
    #10;
    address_a = 8'b00000001;
    #10;

  
    #10;
    address_b = 8'b00000010;
    #10;

 
    #50 $finish;
  end

endmodule
