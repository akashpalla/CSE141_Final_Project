// control decoder
module Control #(parameter opwidth = 4, mcodebits = 9)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)

  output logic  loadVal,
                loadAddr,
                storeVal,
                storeAddr,
                regWrite,
                movInstr,
  output logic[opwidth-1:0] ALUOp,
  output logic[1:0] Branch
  
  );	 

always_comb begin
// defaults
  ALUOp	=   'b1001;
  Branch =   'b00;
  loadVal = 'b0;
  loadAddr = 'b0;
  storeVal = 'b0;
  storeAddr = 'b0;
  regWrite = 'b0;
  movInstr = 'b0;
  


//   RegDst 	=   'b0;   // 1: not in place  just leave 0
//      // 1: branch (jump)
//   MemWrite  =	'b0;   // 1: store to memory
//   regWrite  =	'b1;   // 0: for store or no op  1: most other operations 
//   MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
//   ALUOp	    =   'b1001; // Do Nothing
// // sample values only -- use what you need



case(instr)    

  9'b00xxxxxxx: begin     //ALU op
    ALUOp = {0,instr[8:4]};
    regWrite  =	'b1;
  end
  9'b01xxxxxx0: begin     // MOV
    ALUOp = 4'b10000;
    regWrite  =	'b1;
    movInstr = 'b1;
  end
  9'b01xxxxxx1: begin     //No - op

  end
  9'b1000xxxxx: begin     //load-addr
    loadAddr = 'b1;
    regWrite  =	'b1;
  end
  9'b1001xxxxx: begin     //load-val
    loadVal = 'b1;
    regWrite  =	'b1;
  end
  9'b1010xxxxx: begin     //store-addr
    storeAddr = 'b1;
  end
  9'b1011xxxxx: begin      //store-val
    storeVal = 'b1;
  end
  9'b1100xxxxx: begin     //jmp
    Branch = 'b11;
  end
  9'b1101xxxxx: begin     //jcnd
    Branch = 'b01;
  end
  9'b1101xxxxx: begin     //!jcnd
    Branch = 'b10;
  end



// override defaults with exceptions
  'b0000:  begin					// store operation
               MemWrite = 'b1;      // write to data mem
               regWrite = 'b0;      // typically don't also load reg_file
			 end
  'b00001:  ALUOp      = 'b000;  // add:  y = a+b
  'b00010:  begin				  // load
			   MemtoReg = 'b1;    // 
             end
// ...
endcase

end
	
endmodule