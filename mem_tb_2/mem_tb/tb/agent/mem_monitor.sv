class mem_monitor;
  
  virtual mem_intf INTF; // Required for sampling the interface
  mailbox #(mem_trans) mon2scb; // for sending the item to the scoreboard
  string name = "MON"; // name of component
  mem_trans item; // item to hold sampled values
  semaphore sema; // syncronization purpose if needed

  // function new();
  //   this.INTF = INTF;
  //   this.mon2scb = mon2scb;
  //   this.sema = sema;
  // endfunction

  virtual task run();
    forever begin
      @(posedge INTF.clk)
      item = new();
      
      /*
      Judging the control pins to assume the operation being used.
      
      rstn  |   rd_wr   |   data_in   |   Operation
      ------|-----------|-------------|-------------
        0   |  dontcare |  dontcare   |     RESET
        1   |     1     |  dontcare   |     READ
        1   |     0     | valid  data |     WRITE
        1   |     0     |      0      |     IDLE
      */ 

      if (INTF.rst_n == 0) item.opp = RESET;
      else if (INTF.rd_wr) item.opp = READ;
      else if (INTF.data_in) item.opp = WRITE;
      else item.opp = IDLE;

      /*
      Sampling the control pins
      */
      item.rst_n = INTF.rst_n;
      item.addr = INTF.addr;
      item.rd_wr = INTF.rd_wr;

      @(negedge INTF.clk)

      // Sampling the second phase for READ and WRITE operation only
      if (item.opp inside {READ, WRITE}) begin
        @(posedge INTF.clk)
        item.data_in = INTF.data_in;
        @(negedge INTF.clk)
        item.data_out = INTF.data_out;
        `DISPLAY ({ANALYSIS, ALL},$sformatf("Sampled Operation %s on addr = %0h || data %h", item.opp.name(), item.addr, (item.rd_wr) ? item.data_out:item.data_in))
      end 
      else if (item.opp == RESET) `DISPLAY ({ANALYSIS, ALL}, $sformatf("DUT Reseted"))
      else `DISPLAY ({ANALYSIS, ALL}, $sformatf("DUT IDLE"))
      
      // Sendinf the sampled item to the scoreboard.
      mon2scb.put(item);

    end

  endtask

endclass