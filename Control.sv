// control decoder
module Control #(parameter opwidth = 4, mcodebits = 9)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)

  output logic  loadMem,
                storeMem,
                regWrite,
                movInstr,
  output logic[opwidth-1:0] ALUOp,
  output logic[1:0] Branch,
  output logic[3:0] targetLUT
  
  );	 

always_comb begin
// defaults
  ALUOp	=   'b1001;
  Branch =   'b00;
  loadMem = 'b0;
  storeMem = 'b0;
  regWrite = 'b0;
  movInstr = 'b0;
  targetLUT = 'b0000;
  


//   RegDst 	=   'b0;   // 1: not in place  just leave 0
//      // 1: branch (jump)
//   MemWrite  =	'b0;   // 1: store to memory
//   regWrite  =	'b1;   // 0: for store or no op  1: most other operations 
//   MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
//   ALUOp	    =   'b1001; // Do Nothing
// // sample values only -- use what you need



case(instr)    

  9'b1xxxxxxxx: begin     // mov
    ALUOp = 4'b1000;
    regWrite  =	'b1;
    movInstr = 'b1;
  end
  9'b01xxxxxxx: begin     //ALU op
    ALUOp = {0,instr[7:4]};
    regWrite  =	'b1;
  end 
  9'b00100xxxx: begin     //jmp
    Branch = 'b11;
    targetLUT = instr[3:0];
  end
  9'b00101xxxx: begin     //jcnd
    Branch = 'b01;
    targetLUT = instr[3:0];
  end
  9'b00110xxxx: begin     //!jcnd
    Branch = 'b10;
    targetLUT = instr[3:0];
  end
  9'b00111xxxx: begin     //No- op
    //do Nothing
  end
  9'b00010xxxx: begin     //load
    loadMem = 'b1;
    regWrite  =	'b1;
  end
  9'b00011xxxx: begin     //store
    storeMem = 'b1;
  end

endcase

end
	
endmodule