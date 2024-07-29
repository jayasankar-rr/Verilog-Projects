module tb();
  reg wclk,rclk,wreset,rreset,w_en,r_en;
  reg [7:0] data_in;
  wire [7:0] data_out;
  
  always #10 wclk=~wclk;
  
  always #5 rclk=~rclk;
  
  top duut(.wclk(wclk),.rclk(rclk),.wreset(wreset),.rreset(rreset),
           .data_in(data_in),.data_out(data_out),.w_en(w_en),.r_en(r_en));
  
  initial begin
    $dumpfile("pp.vcd");
    $dumpvars(0,tb);
  end
  
  initial begin
    wclk=0;
    rclk=0;
    rreset=1;
    wreset=1;
    w_en=0;
    r_en=0;
    data_in=8'b00000000;
    #20 rreset=0;
        wreset=0;
        w_en=1;
        r_en=1;
    #10 data_in=8'b01100110;
    #20 data_in=8'b00000001;
    #20 data_in=8'b00000010;
    #20 data_in=8'b00000011;
    #20 data_in=8'b00000001;
    #20 data_in=8'b00000010;
    #20 data_in=8'b00000011;
    #20 data_in=8'b00000001;
    #20 data_in=8'b00000010;
    #20 data_in=8'b00000011;
    #20 data_in=8'b00000001;
    #20 data_in=8'b00000010;
    #20 data_in=8'b00000011;
    #20 data_in=8'b11111111;
    #20 data_in=8'b01111111;
    #20 data_in=8'b00111111;
    #20 w_en=0;
     #20  r_en=0;
    
    
    
    #100 $finish;
  end
  
endmodule