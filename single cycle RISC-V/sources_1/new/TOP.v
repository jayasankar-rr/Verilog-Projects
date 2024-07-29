/*`include "INSTRUCTION_MEM.v"
`include "REGISTER_FILE.v"
`include "CONTROL_UNIT.v"
`include "PC.v"
`include "SIGN_EXTEND.v"
`include "MUX.v"
`include "ALU.v"
`include "DATA_MEM.v"
`include "ADDER.v"
`include "SHIFT.v"
`include "AND.v"
*/
module top(clk,reset);
  input clk,reset;
  
  
  wire [31:0] pc_instmem,instmem_cu,reg_mux,extend_top,srcA,srcB,ALU_datamem,datamem_out,mux_reg,bmux_pc,adder_mux,pc_input,shiftleft_wire,b_adder_wire,branch_pc;
  wire regwritewire,alusrc_wire,zero_wire,memwrite_wire,resultsrc_wire,pcsrc_wire,branch_wire,b_mux_control;
  wire [1:0] immsrc_wire;
  wire [2:0] alu_Control;
  
  Program_Counter pc(.clk(clk)
                     ,.reset(reset)
                     ,.pc_next(bmux_pc)
                     ,.pc_out(pc_instmem));
  
  instruction_mem inst_mem(.Address(pc_instmem)
                           ,.Data(instmem_cu)
                           ,.reset(reset));
  
  register_file regfile(.clk(clk)
                ,.reset(reset)
                ,.A1(instmem_cu[19:15])
                ,.A2(instmem_cu[24:20])
                ,.A3(instmem_cu[11:7])
                ,.WD3(mux_reg)
                ,.WE3(regwritewire)
                ,.RD1(srcA)
                ,.RD2(reg_mux)); 
  
  
  control_unit cu(.op(instmem_cu[6:0])
                  ,.RegWrite(regwritewire)
                  ,.ImmSrc(immsrc_wire)
                  ,.ALUSrc(alusrc_wire)
                  ,.MemWrite(memwrite_wire)
                  ,.ResultSrc(resultsrc_wire)
                  ,.Branch(branch_wire)
                  ,.PCSrc(pcsrc_wire)
                  ,.Zero(zero_wire)
                  ,.ALUControl(alu_Control)
                  ,.Funct3(instmem_cu[14:12])
                  ,.Funct7(instmem_cu[31:25])); 
  
  
  sign_extend sign_ext (.in(instmem_cu)
                        ,.out(extend_top)
                        ,.ImmSrc(immsrc_wire));
  
  MUX mux_alu (.a(reg_mux)
               ,.b(extend_top)
               ,.c(srcB)
               ,.s(alusrc_wire));
  
  ALU alu(.A(srcA)
          ,.B(srcB)
          ,.Result(ALU_datamem)
          ,.ALUControl(alu_Control)
          ,.OverFlow()
          ,.Carry()
          ,.Zero(zero_wire)
          ,.Negative());
  
  data_memory data_mem(.clk(clk)
                       ,.reset(reset)
                       ,.A(ALU_datamem)
                       ,.WD(reg_mux)
                       ,.RD(datamem_out)
                       ,.WE(memwrite_wire));
  
  MUX mux_datamem (.a(ALU_datamem)
               ,.b(datamem_out)
               ,.c(mux_reg)
               ,.s(resultsrc_wire));
  
  pc_adder moxxi(.a(pc_instmem)
           ,.b(extend_top)
                 ,.c(adder_mux));
  
  pc_adder addermux(.a(pc_instmem)
           ,.b(32'd4)
           ,.c(branch_pc));
  
   MUX mux_pc (.a(adder_pc)
               ,.b(adder_mux)
               ,.c(pc_input)
               ,.s(pcsrc_wire));
 
  
  shift shifter(.shift_in(extend_top)
                ,.shift_out(shiftleft_wire));
  
  
  pc_adder branch_adder(.a(pc_instmem)
                        ,.b(shiftleft_wire)
                        ,.c(b_adder_wire));
  
  
  MUX branch_mux (.a(branch_pc)
                  ,.b(b_adder_wire)
                  ,.c(bmux_pc)
                  ,.s(b_mux_control));
  
  and_gate andgate (.a(branch_wire)
                    ,.b(zero_wire)
                    ,.c(b_mux_control));
  
endmodule