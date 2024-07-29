
module Main_Decoder(op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp,PCSrc,Zero);
  input Zero;
  input [6:0]op;
    output RegWrite,ALUSrc,MemWrite,ResultSrc,Branch,PCSrc;
    output [1:0]ImmSrc,ALUOp;
  
  /* rtype = 0110011
     itype = 0010011
     lw    = 0000011
     sw   =  0100011
     beq=    1100011
     */


  assign RegWrite = ((op == 7'b0000011) | (op  == 7'b0110011)) |(op == 7'b0010011) ? 1'b1 : 1'b0 ;
    
 assign MemWrite = (op == 7'b0100011) ? 1'b1 : 1'b0 ;
    
  assign ALUSrc = ((op == 7'b0000011) | (op  == 7'b0100011) | (op  == 7'b0010011)) ? 1'b1 : 1'b0 ;
    
 assign Branch = (op == 7'b1100011) ? 1'b1 : 1'b0 ;
    
 assign ResultSrc = (op == 7'b0000011) ? 1'b1 : 1'b0 ;
    
  assign ImmSrc = (op == 7'b0100011) ? 2'b01 : (op == 7'b1100011) ? 2'b10 : (op == 7'b0000011) | (op == 7'b0010011) ? 2'b00 :2'bxx ;
    
  assign ALUOp = (op == 7'b0110011) | (op == 7'b0010011) ? 2'b10 : (op == 7'b1100011) ? 2'b01 : 2'b00;
    
  assign  PCSrc = Zero & Branch;


  endmodule

////////////////////////TESTBENCH///////////////////

/*  


module tb_Main_Decoder();

    // Inputs
  reg [6:0] op;
    
    // Outputs
    wire RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, PCSrc;
    wire [1:0] ImmSrc, ALUOp;

    // Instantiate the module under test
    Main_Decoder dut (
      .op(op),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUOp(ALUOp),
        .PCSrc(PCSrc)
      ,.ImmSrc(ImmSrc)
    );
     
    initial begin
      
      $dumpfile("pp.vcd");
      $dumpvars(0,tb_Main_Decoder);
    end

    // Test case
    initial begin
        // Initialize Op to different values and observe outputs
        op = 7'b0000011; // Load
        #10;
        op = 7'b0100011; // Store
        #10;
        op = 7'b0110011; // R-type
        #10;
        op = 7'b1100011; // Branch
        #10;
        
        // Add more test cases as needed
        
        // Finish simulation
        #10 $finish;
    end

endmodule



*/