// combinational -- no clock
// sample -- change as desired
module alu(
  input[4:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  input      sc_i,      // shift_carry in
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               cnd,      // Whether 
               pari,     // reduction XOR (output)
			         zero      // NOR (output)
);

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    
  cnd =  'b0;
  zero = !rslt;
  pari = ^rslt;


    case(alu_cmd)
      4'b0000:
        {sc_o, rslt} = inA + inB + sc_i;    //ADD
      4'b0001:
        {sc_o, rslt} = inA - inB + sc_i;    //SUB
      4'b0010:
        {rslt} = inA & inB;   //AND
      4'b0011:
        {rslt} = inA ^ inB;   //XOR
      4'b0100: begin   //CMP
        if(inA > inB)
          cnd = 'b1;    
      end
      4'b0101: begin     //CEQ
        if(inA > inB)
          cnd = 'b1;
      end
      4'b0110:     
        {sc_o,rslt} = {inA, sc_i};    //LSL
      4'b0111: begin
        {rslt,sc_o} = {sc_i,inA};   //LSR
      end
      4'b1000: 
        {rslt} = {inB}      //MOV
      default: begin
        //do Nothing

      end
    endcase
  
  //   3'b000: // add 2 8-bit unsigned; automatically makes carry-out
  //     {sc_o,rslt} = inA + inB + sc_i;
	// 3'b001: // left_shift
	//   {sc_o,rslt} = {inA, sc_i};
  //     /*begin
	// 	rslt[7:1] = ina[6:0];
	// 	rslt[0]   = sc_i;
	// 	sc_o      = ina[7];
  //     end*/
  //   3'b010: // right shift (alternative syntax -- works like left shift
	//   {rslt,sc_o} = {sc_i,inA};
  //   3'b011: // bitwise XOR
	//   rslt = inA ^ inB;
	// 3'b100: // bitwise AND (mask)
	//   rslt = inA & inB;
	// 3'b101: // left rotate
	//   rslt = {inA[6:0],inA[7]};
	// 3'b110: // subtract
	//   {sc_o,rslt} = inA - inB + sc_i;
	// 3'b111: // pass A
	//   rslt = inA;
  
end
   
endmodule