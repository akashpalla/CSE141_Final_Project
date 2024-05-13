module alutestbench;

  reg [4:0] alu_cmd;
  reg [7:0] inA, inB;
  reg sc_i;
  wire [7:0] rslt;
  wire sc_o, cnd, pari, zero;

  alu uut (
    .alu_cmd(alu_cmd),
    .inA(inA),
    .inB(inB),
    .sc_i(sc_i),
    .rslt(rslt),
    .sc_o(sc_o),
    .cnd(cnd),
    .pari(pari),
    .zero(zero)
  );

  initial begin

    alu_cmd = 4'b0000; // ADD WITHOUT CARRY IN
    inA = 8'b00000100;
    inB = 8'b00000011;
    sc_i = 1'b0;
    #10;
    $display("ADD: %b", rslt, ", sc_o %b", sc_o);
    
    alu_cmd = 4'b0000; // ADD WITH CARRY IN
    inA = 8'b11001100;
    inB = 8'b00110011;
    sc_i = 1'b1;
    #10;
	  $display("ADD: %b, sc_o: %b", rslt, sc_o);
    
    alu_cmd = 4'b0001; // SUB WITHOUT CARRY IN
    inA = 8'b11001100;
    inB = 8'b00110011;
    sc_i = 1'b0;
    #10;
    $display("SUB: %b", rslt, ", sc_o %b", sc_o);
    
    alu_cmd = 4'b0001; // SUB WITH CARRY IN
    inA = 8'b11001100;
    inB = 8'b00110011;
    sc_i = 1'b1;
    #10;
    $display("SUB: %b", rslt, ", sc_o %b", sc_o);
    
    alu_cmd = 4'b0010; // AND
    inA = 8'b00000001;
    inB = 8'b00000001;
    #10;
    $display("AND: %b", rslt);
    
    alu_cmd = 4'b0011; // XOR
    inA = 8'b00000001;
    inB = 8'b00000001;
    #10;
    $display("XOR: %b", rslt);
    
    alu_cmd = 4'b0100; // CMP
    inA = 8'b00000011;
    inB = 8'b00000001;
    #10;
    $display("CMP: %b", cnd);

    alu_cmd = 4'b0101; // CEX
    inA = 8'b00000011;
    inB = 8'b00000001;
    #10;
    $display("CEX: %b", cnd);
    
    alu_cmd = 4'b0110; // LSL WITH CARRY IN
    inA = 8'b00000011;
    sc_i = 1'b1;
    #10;
    $display("LSL: %b", rslt, ", sc_o %b", sc_o);
    
    alu_cmd = 4'b0110; // LSL WITHOUT CARRY IN
    inA = 8'b00000011;
    sc_i = 1'b0;
    #10;
    $display("LSL: %b", rslt, ", sc_o %b", sc_o);
    
    alu_cmd = 4'b0111; // LSR WITH CARRY IN
    inA = 8'b00000011;
    sc_i = 1'b1;
    #10;
    $display("LSR: %b", rslt, ", sc_o %b", sc_o);
    
    alu_cmd = 4'b0111; // LSR WITHOUT CARRY IN
    inA = 8'b00000011;
    sc_i = 1'b0;
    #10;
    $display("LSR: %b", rslt, ", sc_o %b", sc_o);
    
    alu_cmd = 4'b1000; // MOV
    inB = 8'b00000001;
    #10;
    $display("MOV: %b", rslt);


  end

endmodule
