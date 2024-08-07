// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module PC #(parameter D=12)(
  input 					 reset,					// synchronous reset
							 clk,
							 jcnd,
  input        [1:0]  branch,

  input       [D-1:0] target,	// how far/where to jump
  output logic[D-1:0] prog_ctr
);

  always_ff @(posedge clk)
    if(reset)
  	  prog_ctr <= '0;
    else if(branch == 'b11)
      prog_ctr <= target;
    else if(branch == 'b01 && jcnd)
      prog_ctr <= target;
    else if(branch == 'b10 && !jcnd)
      prog_ctr <= target;
    else
	    prog_ctr <= prog_ctr + 'b1;

endmodule