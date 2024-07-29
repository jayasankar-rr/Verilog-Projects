/*`include "ALU_DECODER.v"
`include "MAIN_DECODER.v"
*/

module control_unit(op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,PCSrc,Zero,ALUControl,Funct3,Funct7);
                    
  input [6:0]op,Funct7;
                    input Zero;
  input [2:0]Funct3;
    output RegWrite,ALUSrc,MemWrite,ResultSrc,Branch,PCSrc;
    output [1:0]ImmSrc;
    output [2:0]ALUControl;

                    
                    
 wire [1:0]ALUOp;
                    
 Main_Decoder main_dec(.op(op)
             ,.RegWrite(RegWrite)
             ,.ImmSrc(ImmSrc)
             ,.ALUSrc(ALUSrc)
             ,.MemWrite(MemWrite)
             ,.ResultSrc(ResultSrc)
             ,.Branch(Branch)
             ,.ALUOp(ALUOp)
             ,.PCSrc(PCSrc)
             ,.Zero(Zero));
                    
                    
alu_decoder alu_dec (.ALUOp(ALUOp)
             ,.op(op)
             ,.ALUControl(ALUControl)
             ,.Funct3(Funct3)
             ,.Funct7(Funct7));                    
  
endmodule