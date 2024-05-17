interface  mem_intf (input clk);

  // Declared as logic as, the pins can act as both like inputs or outputs, 
  //depending on who's accessing
  
  logic rst_n, enb, rd_wr;
  logic [addrWidth -1:0] addr;
  logic [dataWidth -1:0] data_in;
  logic [dataWidth -1:0] data_out;

endinterface