/*`include "fifo_memory.v"
`include "wptr_handle.v"
`include "rptr_handle.v"
`include "2_ff_sync.v"
*/

module top (wclk,rclk,wreset,rreset,data_in,w_en,r_en,data_out);
  input wclk,rclk,wreset,rreset,w_en,r_en;
  input [7:0] data_in;
  output [7:0] data_out;
  
  wire fullwire;
  wire [3:0] write_addr,read_addr;
  wire [4:0] wptr_cdc,rptr_cdc,cdc_wptr,cdc_rptr;
  
  fifo_memory fifo_mem(.clk(wclk)
                       ,.reset(wreset)
                       ,.write_data(data_in)
                       ,.read_data(data_out)
                       ,.write_en(w_en)
                       ,.waddr(write_addr)
                       ,.raddr(read_addr)
                       ,.full(fullwire));
  
  cdc write(.clk(wclk)
            ,.reset(wreset)
            ,.ptr(rptr_cdc)
            ,.out_ptr(cdc_wptr));
  
  cdc read(.clk(rclk)
           ,.reset(rreset)
           ,.ptr(wptr_cdc)
           ,.out_ptr(cdc_rptr));
  
  wptr_handle #(.width(4)) wptr_inst(.clk(wclk)
                                        ,.reset(wreset)
                                        ,.rptr_sync(cdc_wptr)
                                        ,.w_en(w_en)
                                        ,.full(fullwire)
                                        ,.wptr(wptr_cdc)
                                        ,.w_addr(write_addr));
  
  rptr_handle #(.width(4)) rptr_inst(.clk(rclk)
                                   ,.reset(rreset)
                                   ,.r_en(r_en)
                                   ,.wptr_sync(cdc_rptr)
                                   ,.rptr(rptr_cdc)
                                   ,.empty()
                                   ,.r_addr(read_addr));
  
  
endmodule