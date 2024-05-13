
module pctestbench;

  parameter D = 12;

  logic clk = 0;
  logic reset = 1;
  logic jcnd = 0;
  logic [2:0] branch = 0;
  logic [D-1:0] target = 0;

  logic [D-1:0] prog_ctr;

  PC #(D) pc1 (
    .reset(reset),
    .clk(clk),
    .jcnd(jcnd),
    .branch(branch),
    .target(target),
    .prog_ctr(prog_ctr)
  );

  always #5 clk = ~clk;

  initial begin
    #10;
    reset = 0;
    #10;
  end

  initial begin
    #100;
    $display("prog_ctr: %b", prog_ctr);
    assert(prog_ctr === 9); //check if the program counter correctly increments

    branch = 'b11;
    target = 'b10;
    #10;
    $display("prog_ctr: %b", prog_ctr);
    assert(prog_ctr === 'b10); //test branch to target address

    jcnd = 1;
    branch = 'b01;
    target = 'b11;
    #10;
    $display("prog_ctr: %b", prog_ctr);
    assert(prog_ctr === 'b11); //check if counter conditionally jumps

    branch = 'b10;
    jcnd = 0;
    target = 'b01;
    #10;
    $display("prog_ctr: %b", prog_ctr);
    assert(prog_ctr === 'b01); //check if program counter jumps unconditionally
    
    $display("testbench completed");
    
  end
  initial #200 $finish;

endmodule
