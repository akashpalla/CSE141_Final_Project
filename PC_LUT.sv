module PC_LUT #(parameter D=12)(
  input       [ 3:0]  addr,	   // target 16 values
  output logic[D-1:0] target);

always_comb begin
	
	case(addr)
		0: target = 0;   
		1: target = 20;   
		2: target = 25;   
		3: target = 5;
		4: target = 30;
		5: target = 0;
		6: target = 0;
		7: target = 0;
		8: target = 0;
		9: target = 0;
		10: target = 0;
		11: target = 0;
		12: target = 0;
		13: target = 0;
		14: target = 0;
		15: target = 0;
	endcase
end
endmodule

/*

	   pc = 4    0000_0000_0100	  4
	             1111_1111_1111	 -1

                 0000_0000_0011   3

				 (a+b)%(2**12)


   	  1111_1111_1011      -5
      0000_0001_0100     +20
	  1111_1111_1111      -1
	  0000_0000_0000     + 0


  */
