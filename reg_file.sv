// cache memory/register file
// default address pointer width = 4, for 16 registers
module reg_file #(parameter pw=3)(
  input[7:0] dat_in,
  input      clk,
  input      wr_en,           // write enable
			 movInstr,
  input[pw:0] addrA,		  // read address pointers
			  addrB,
  output logic[7:0] datA_out, // read data
                    datB_out);

  logic[7:0] core[2**pw];    // 2-dim array  8 wide  16 deep

// reads are combinational

  always_comb begin 
	if(movInstr)
		datA_out = core[addrA];
	else
		datA_out = core[addrA];
	
  	datB_out = core[addrB];

  end

// writes are sequential (clocked)
  always_ff @(posedge clk)
    if(wr_en && movInstr)				   // anything but stores or no ops
    	core[addrA] <= dat_in; 
	else if(wr_en)
		core[0] <=dat_in;

endmodule
/*
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
*/