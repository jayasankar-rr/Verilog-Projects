`timescale 1ns/1ps

module apb_top_tb();

  // Define parameters
  reg pclk;
  reg preset;
  reg transfer;
  reg read_write;
  reg [8:0] apb_write_paddr;
  reg [8:0] apb_read_paddr;
  reg [7:0] apb_write_data;
  wire [7:0] apb_read_data;

  // Instantiate the top module
  apb_top dut (
    .pclk(pclk),
    .preset(preset),
    .transfer(transfer),
    .read_write(read_write),
    .apb_write_paddr(apb_write_paddr),
    .apb_read_paddr(apb_read_paddr),
    .apb_write_data(apb_write_data),
    .apb_read_data(apb_read_data)
  );

  // Clock generation
  always begin
    #5 pclk = ~pclk;  // Toggle clock every 5 time units
  end

  // Stimulus generation
  initial begin
    // Initialize inputs
    pclk = 0;
    preset = 1;
    transfer = 0;
    read_write = 0;
    apb_write_data = 8'b0;
    apb_write_paddr = 9'b0;
    apb_read_paddr = 9'b0;

    // Apply reset
    #10 preset = 1'b0;
    transfer = 1;  // Initiate transfer
    
    // Write operation
    read_write = 0;
    apb_write_data = 8'b10101010;
    apb_write_paddr = 9'b001100110;
    
    #30 read_write = 1;
    apb_read_paddr =  9'b001100110;

    #100 $finish;  // End simulation after 100 time units
  end

  // Dump waveforms
  initial begin
    $dumpfile("apb_top_tb.vcd");
    $dumpvars(0, apb_top_tb);
    #20 $display("Starting simulation...");
  end

endmodule
