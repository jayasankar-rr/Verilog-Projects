`timescale 1ns/1ps

module fifo_tb();
  reg clk;
  reg reset;
  reg write_en;
  reg read_en;
  reg [7:0] data_in;
  wire full;
  wire empty;
  wire [7:0] data_out;

  // Instantiate the FIFO module
  fifo dut (
    .clk(clk),
    .reset(reset),
    .write_en(write_en),
    .read_en(read_en),
    .data_in(data_in),
    .full(full),
    .empty(empty),
    .data_out(data_out)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Stimulus generation
  initial begin
    // Initialize inputs
    clk = 0;
    reset = 1;
    write_en = 0;
    read_en = 0;
    data_in = 8'b0;

    // Apply reset
    #10 reset = 0;

    // Write some data
    #5 write_en = 1; data_in = 8'hA1;
    #10 read_en = 1; data_in = 8'hB2;
    #10  data_in = 8'hC3;
     #10  data_in = 8'hC4;
    

    // Read the data
   
   // #30 read_en = 0;

    // End simulation
    #50 $finish;
  end

  // Dump waveforms
  initial begin
    $dumpfile("fifo_tb.vcd");
    $dumpvars(0, fifo_tb);
    #20 $display("Starting simulation...");
  end

endmodule
