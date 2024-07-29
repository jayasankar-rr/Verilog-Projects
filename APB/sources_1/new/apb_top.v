`timescale 1ns/1ps




module apb_top(
 input pclk, preset, transfer, read_write,
 input [8:0] apb_write_paddr, apb_read_paddr,
 input [7:0] apb_write_data,
 output [7:0] apb_read_data
);

  wire pready, pwrite, psel1, psel2, penable;
  wire [7:0] prdata, pwdata;
  wire [8:0] paddr;

  master mast (
    .pclk(pclk),
    .preset(preset),
    .transfer(transfer),
    .read_write(read_write),
    .pready(pready),
    .pwrite(pwrite),
    .psel1(psel1),
    .psel2(psel2),
    .penable(penable),
    .apb_write_data(apb_write_data),
    .prdata(prdata),
    .apb_write_paddr(apb_write_paddr),
    .apb_read_paddr(apb_read_paddr),
    .apb_read_data(apb_read_data),
    .pwdata(pwdata),
    .paddr(paddr),
    .perror()
  );

  slaver1 slv1 (
    .pwrite(pwrite),
    .psel(psel1),
    .penable(penable),
    .pclk(pclk),
    .preset(preset),
    .paddr(paddr[7:0]),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready)
  );

/*  slaver2 slv2 (
    .pwrite(pwrite),
    .psel(psel2),
    .penable(penable),
    .pclk(pclk),
    .preset(preset),
    .paddr(paddr[7:0]),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready)
  );*/
endmodule
