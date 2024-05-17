class mem_trans;

  bit rst_n = 1;
  bit enb;
  bit rd_wr;
  rand bit [addrWidth -1:0] addr;
  rand bit [dataWidth -1:0] data_in;
  logic [dataWidth -1:0] data_out;

  rand OPERATION opp; // used by to denote operation under use
  VALIDITY valid = NA; // the scoreboard will assign Passed of failed for the address used 

  int accesses [OPERATION] = '{READ:0, WRITE:0}; // the scoreboard will use this to keep track of operations on an address
  

  constraint opp_co {
    opp != RESET;
  }

  constraint addr_co {
    addr dist {[0:'hF] :=100, 
               ['hF0: 'h10F] :=10,   
               ['hFF0: 'h100F] :=2, 
               ['hFFF0: 'h1000F] :=1};
  }
  
  constraint data_in_co {
    if (opp == WRITE) data_in != 0;
    else data_in == 0;
  }



  /*
  use a copy of the item for memory isolation
  */
  virtual function mem_trans do_copy();
    do_copy = new();

    do_copy.addr = addr;
    do_copy.accesses = accesses;
    do_copy.data_in = data_in;
    do_copy.data_out = data_out;

  endfunction

endclass