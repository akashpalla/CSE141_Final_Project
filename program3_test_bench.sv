// program 3    CSE141L   double precision two's comp. multiplication
module test_bench;

// connections to DUT: clock, start (request), done (acknowledge) 
  bit  clk,
       start = 'b1;			          // request to DUT
  wire done;                          // acknowledge from DUT

  logic signed[15:0]  Tmp[32];	      // caches all 32 2-byte operands
  logic signed[31:0] Prod[16];	      // caches all 16 4-byte products
  
 top_level D1(.clk  (clk  ),	        // your design goes here
		 .reset(start),
		 .done (done )); 


  always begin
    #50ns clk = 'b1;
	#50ns clk = 'b0;
  end

  initial begin
// load operands for program 3 into data memory
// 32 double-precision operands go into data_mem [0:63]
// first operand = {data_mem[0],data_mem[1]}  

    $readmemb("mach_code_3.txt",D1.ir1.core);
    D1.sc_in =0;
    D1.rf1.core[0] = 0;
    D1.rf1.core[1] = 0;
    D1.rf1.core[2] = 0;
    D1.rf1.core[3] = 0;
    D1.rf1.core[4] = 0;
    D1.rf1.core[5] = 0;
    D1.rf1.core[6] = 0;
    D1.rf1.core[7] = 0;
    D1.rf1.core[8] = 0;
    D1.rf1.core[9] = 0;
    D1.rf1.core[10] = 0;
    D1.rf1.core[11] = 0;
    D1.rf1.core[12] = 0;
    D1.rf1.core[13] = 0;
    D1.rf1.core[14] = 64;
    D1.rf1.core[15] = 63;

    D1.pl1.core[0] = 0;
    D1.pl1.core[1] = 62;
    D1.pl1.core[2] = 116;
    D1.pl1.core[3] = 173;
    D1.pl1.core[4] = 0;
    D1.pl1.core[5] = 16;
    D1.pl1.core[6] = 14;
    D1.pl1.core[7] = 1;
    D1.pl1.core[8] = 0;
    D1.pl1.core[9] = 0;
    D1.pl1.core[10] = 0;
    D1.pl1.core[11] = 0;
    D1.pl1.core[12] = 0;
    D1.pl1.core[13] = 0;
    D1.pl1.core[14] = 0;
    D1.pl1.core[15] = 0;

    #100ns;
    for(int i=0; i<32; i++) begin
      {D1.dm1.core[2*i],D1.dm1.core[2*i+1]} = $random;  // or try other values
      Tmp[i] = {D1.dm1.core[2*i],D1.dm1.core[2*i+1]};	  // load values into mem, copy to Tmp array
      $display("%d:  %d",i,Tmp[i]);
	end
// 	compute correct answers
    for(int j=0; j<16; j++) 			              // pull pairs of operands from memory
	    #1ns Prod[j] = Tmp[2*j+1]*Tmp[2*j];		      // compute prod.
	  #200ns start = 'b0; 							  
    #200ns wait (done);						          // avoid false done signals on startup
	for(int k=0; k<16; k++)
	  if({D1.dm1.core[64+4*k],D1.dm1.core[65+4*k],D1.dm1.core[66+4*k],D1.dm1.core[67+4*k]} == Prod[k])
	    $display("Yes! %d * %d = %d",Tmp[2*k+1],Tmp[2*k],Prod[k]);
	  else
	    $display("Boo! %d * %d should = %d",Tmp[2*k+1],Tmp[2*k],Prod[k]);    
// check results in data_mem[66:67] and [68:69] (Minimum and Maximum distances, respectively)
   
    #200ns start = 'b1;
	#200ns start = 'b0;
	$stop;
  end

endmodule