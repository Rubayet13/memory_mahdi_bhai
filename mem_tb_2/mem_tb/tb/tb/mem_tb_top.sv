module tb_top();
  
  // Clock generator
  bit clk;
  always #5 clk = ~clk;

  // Interface
  mem_intf INTF (clk);

  // DUT
  mem DUT_1 (
    .clk (INTF.clk),
    .rst_n(INTF.rst_n),
    .enb(INTF.enb),
    .rd_wr(INTF.rd_wr),
    .addr(INTF.addr),
    .data_in(INTF.data_in),
    .data_out(INTF.data_out)
  );

  // Program to run the TEST
  basetest test0 (clk, INTF);

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_top);
  end

endmodule