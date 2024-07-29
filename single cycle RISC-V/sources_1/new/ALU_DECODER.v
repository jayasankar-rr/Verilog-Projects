module alu_decoder (ALUOp,op,ALUControl,Funct3,Funct7);
  input [6:0] op,Funct7;
  input [1:0]ALUOp;
  input [2:0]Funct3;
  output [2:0] ALUControl;
  
  wire [1:0] concat;
  assign concat = {op[5],Funct7[5]};

  
  assign ALUControl = 
     (ALUOp == 2'b00) ? 3'b000:
     (ALUOp == 2'b01) ? 3'b001:
    ((ALUOp == 2'b10) & (Funct3 == 3'b010)) ? 3'b101 :
    ((ALUOp == 2'b10) & (Funct3 == 3'b110)) ? 3'b011 :
    ((ALUOp == 2'b10) & (Funct3 == 3'b111)) ? 3'b010 :
    ((ALUOp == 2'b10) & (Funct3 == 3'b000) & (concat == 2'b11)) ? 3'b001 :
    ((ALUOp == 2'b10) & (Funct3 == 3'b000) & (concat != 2'b11)) ? 3'b000 :3'b000;
    
    
    endmodule


/////////////////////// TESTBENCH ////////////////////

/*

module tb_alu_decoder;

    reg [1:0] ALUOp;
    reg op;
    reg [2:0] Funct3;
    reg [2:0] Funct7;
    wire [2:0] ALUControl;

    alu_decoder uut (
        .ALUOp(ALUOp),
        .op(op),
        .Funct3(Funct3),
        .Funct7(Funct7),
        .ALUControl(ALUControl)
    );

    initial begin
        $dumpfile("alu_decoder_tb.vcd");
        $dumpvars(0, tb_alu_decoder);

        // Test case 1
        ALUOp = 2'b00;
        op = 1'b0;
        Funct3 = 3'b010;
        Funct7 = 3'b000;
        #10;

        // Test case 2
        ALUOp = 2'b10;
        op = 1'b1;
        Funct3 = 3'b000;
        Funct7 = 3'b011;
        #10;

        // Add more test cases as needed

        $finish;
    end

endmodule


*/
  