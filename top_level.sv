// sample top level design
module top_level(
  input       clk, 
              reset, 
              req, 
  output logic done);


  parameter D = 12,             // program counter width
            A = 3;         		  // ALU command bit width
 
  wire[D-1:0] target, 			  // Driven by PC
              prog_ctr;

  wire[8:0]   mach_code;     //Driven by Instr ROM

  wire        loadVal,      //Driven by Control
              loadAddr,
              storeVal,
              storeAddr,
              regWrite,
              movInstr;
  wire[3:0]   ALUOp;
  wire[2:0]   Branch;
  
  
  wire[7:0]   datA,         // Driven by RegFile 
              datB;                   


  wire[7:0]   rslt;         //Driven by ALU
  logic       sc_o,
              cnd,
              pari,
              zero;

 	                    
  wire[3:0] rd_addrA, rd_adrB;    //Set by Machine code


// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 ( 
      .reset,
      .clk,
      .jcnd(cnd),
      .branch(Branch),
      .target,
		  .prog_ctr);

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (.addr  (how_high),
         .target          );   

// contains machine code
  instr_ROM ir1(
    .prog_ctr,
    .mach_code);

// control decoder
  Control ctl1(
    .instr(mach_code),
    .loadVal,
    .loadAddr,
    .storeVal,
    .storeAddr,
    .regWrite,
    .movInstr,
    .ALUOp,
    .Branch);

  assign cmd_type = mach_code[8:7];
  assign rd_addrA = mach_code[6:4];
  assign rd_addrB = mach_code[3:1];

  reg_file #(.pw(3)) rf1(
              
              .dat_in(rslt),	   // loads, most ops
              .clk,
              .wr_en(regWrite),
              .movInstr,
              .addrA(rd_addrA),
              .addrB(rd_addrB),
              .datA_out(datA)
              .datB_out(datB));

  assign muxB = ALUSrc? immed : datB;

  alu alu1(
    .alu_cmd(ALUOp),
    .inA(datA),
    .inB(datB),
    .sc_i(),
    .rslt(rslt),
    .sc_o(),
    .cnd,
    .pari,
    .zero,
  );
    
  dat_mem dm1(.dat_in(datB)  ,  // from reg_file
             .clk           ,
			 .wr_en  (MemWrite), // stores
			 .addr   (datA),
             .dat_out());

// registered flags from ALU
  always_ff @(posedge clk) begin
    pariQ <= pari;
	zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end

  assign done = prog_ctr == 128;
 
endmodule