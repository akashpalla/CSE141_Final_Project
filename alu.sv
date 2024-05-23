// combinational -- no clock
// sample -- change as desired
module alu(
  input[3:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  input      sc_i,      // shift_carry in
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               cnd,      // Whether 
               pari,     // reduction XOR (output)
			         zero      // NOR (output)
);

logic [7:0] b_invert;

assign b_invert = ~inB;

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    
  cnd =  'b0;
  zero = !rslt;
  pari = ^rslt;
  rslt = inA;


    case(alu_cmd)
      4'b0000:
        {sc_o, rslt} = inA + inB + sc_i;    //ADD
      4'b0001:
        {sc_o, rslt} = inA + b_invert + 1 - sc_i;    //SUB
      4'b0010:
        {rslt} = inA & inB;   //AND
      4'b0011:
        {rslt} = inA ^ inB;   //XOR
      4'b0100: begin   //CMP
        if(inA > inB)
          cnd = 'b1;    
      end
      4'b0101: begin     //CEQ
        if(inA == inB)
          cnd = 'b1;
        //Shouldnt be executed
      end
      4'b0110:     
        {sc_o,rslt} = {inB, sc_i};    //LSL
      4'b0111: begin
        {rslt,sc_o} = {sc_i,inB};   //LSR
      end
      4'b1000: 
        {rslt} = {inB};      //MOV
    endcase
  
end
   
endmodule
//01 0100 xxxx