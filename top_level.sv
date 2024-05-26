// sample top level design
module top_level(
  input       clk, 
              reset, 
  output logic done);


  parameter D = 12,             // program counter width
            A = 3;         		  // ALU command bit width
 

  wire[D-1:0] target;         //Driven by PC_LUT

  wire[D-1:0] prog_ctr; 			  // Driven by PC
  

  wire[8:0]   mach_code;     //Driven by Instr ROM

  wire        loadMem,      //Driven by Control
              storeMem,
              regWrite,
              movInstr,
              invert_sc,
              update_sc,
              immVal;
            
  wire[3:0]   ALUOp;
  wire[1:0]   Branch;
  wire[3:0]   targetLUT;
  
  
  wire[7:0]   datA,         // Driven by RegFile 
              datB;                   

  wire[7:0]   alu_out;         //Driven by ALU
  logic       sc_o,
              cnd_o,
              pari,
              zero;

logic         sc_in,          //Driven by ALU next Cycle
              cnd_in;
  
  wire[7:0]   mem_out;        //Driven by Data Mem
  wire[7:0]   register_in;

  wire[3:0] rd_addrA, 
            rd_addrB;    //Set by Machine code

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (
      .addr  (targetLUT),
      .target);   

// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 ( 
      .reset,
      .clk,
      .jcnd(cnd_in),
      .branch(Branch),
      .target,
		  .prog_ctr);

// contains machine code
  instr_ROM ir1(
    .prog_ctr,
    .mach_code);

// control decoder
  Control ctl1(
    .instr(mach_code),
    .loadMem,
    .storeMem,
    .regWrite,
    .movInstr,
    .invert_sc,
    .update_sc,
    .immVal,
    .ALUOp,
    .Branch,
	 .targetLUT
	 );

  assign rd_addrA = mach_code[7:4];
  assign rd_addrB = mach_code[3:0];

  assign register_in = loadMem ? mem_out : alu_out;

  reg_file #(.pw(4)) rf1(
              
              .dat_in(register_in),	   // loads, most ops
              .clk,
              .wr_en(regWrite),
              .movInstr,
              .immVal,
              .addrA(rd_addrA),
              .addrB(rd_addrB),
              .datA_out(datA),
              .datB_out(datB));

//  assign muxB = ALUSrc? immed : datB;

  alu alu1(
    .alu_cmd(ALUOp),
    .inA(datA),
    .inB(datB),
    .sc_i(sc_in),
    .rslt(alu_out),
    .sc_o(sc_o),
    .cnd(cnd_o),
    .pari,
    .zero
  );
    
  dat_mem dm1(
    .dat_in(datA)  ,  // from reg_file
    .clk           ,
    .wr_en  (storeMem), // stores
    .addr   (datB),
    .dat_out(mem_out));

// registered flags from ALU
  always_ff @(posedge clk) begin
    // pariQ <= pari;
	  // zeroQ <= zero;
    cnd_in <= cnd_o;

    if(update_sc) begin
      sc_in <= sc_o;
    end

    if(invert_sc) begin
      sc_in <= ~sc_in;
    end


    // if(sc_clr)
	  // sc_in <= 'b0;
    // else if(sc_en)
    //   sc_in <= sc_o;
  end

  assign done = prog_ctr == 150;
 
endmodule