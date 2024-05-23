// control decoder
module Control #(parameter opwidth = 4, mcodebits = 9)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)

  output logic  loadMem,
                storeMem,
                regWrite,
                movInstr,
                invert_sc,
                update_sc,
                immVal,
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
  invert_sc = 'b0;
  update_sc = 'b0;
  immVal = 'b0;
  targetLUT = 'b0000;

  


//   RegDst 	=   'b0;   // 1: not in place  just leave 0
//      // 1: branch (jump)
//   MemWrite  =	'b0;   // 1: store to memory
//   regWrite  =	'b1;   // 0: for store or no op  1: most other operations 
//   MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
//   ALUOp	    =   'b1001; // Do Nothing
// // sample values only -- use what you need

casex(instr)    

  9'b1????????: begin     // mov
    ALUOp = 4'b1000;
    regWrite  =	'b1;
    movInstr = 'b1;
  end
  9'b011010000: begin     //No- op
    //do Nothing
  end
  9'b011011111: begin     //Clear sc
    update_sc = 'b1;
  end
  9'b011010011: begin     //Invert sc
    invert_sc = 'b1;
  end
  9'b01???????: begin     //ALU op
    ALUOp = {1'b0,instr[6:4]};
    regWrite  =	'b1;
    update_sc = 'b1;
  end 
  9'b00100????: begin     //jmp
    Branch = 'b11;
    targetLUT = instr[3:0];
  end
  9'b00101????: begin     //jcnd
    Branch = 'b01;
    targetLUT = instr[3:0];
  end
  9'b00110xxxx: begin     //!jcnd
    Branch = 'b10;
    targetLUT = instr[3:0];
  end
  9'b00111????: begin     //imm
    ALUOp = 4'b1000;
    regWrite  =	'b1;
    immVal = 'b1;
  end
  9'b00010????: begin     //load
    loadMem = 'b1;
    regWrite  =	'b1;
  end
  9'b00011????: begin     //store
    storeMem = 'b1;
  end

endcase

end
	
endmodule