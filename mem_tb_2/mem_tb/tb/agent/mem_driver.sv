class mem_driver;

  virtual mem_intf INTF;
  mailbox #(mem_trans) test2drvr;
  mem_trans item;
  semaphore sema;
  string name = "Driver";

  // function new(virtual mem_intf INTF, mailbox #(mem_trans) test2drvr, semaphore sema);
  //   this.INTF = INTF;
  //   this.test2drvr = test2drvr;
  //   this.sema = sema;
  // endfunction

  virtual task run();
    $display($time, "ns || [Driver] INITIATED");
    
    forever begin
      test2drvr.get(item);  
      $display($time, "ns || [Driver] Got Item");

      case (item.opp)
        RESET: reset();
        WRITE: write();
        READ: read();
        IDLE: idle();
      endcase

    end

  endtask

  task reset ();
    $display($time, "ns || [DRVR] Running RESET");
    INTF.rst_n <= 0;
    INTF.rd_wr <= 0;
    INTF.enb <= 0;
    INTF.data_in <= 0;
    INTF.addr <= 0;
    @(negedge INTF.clk);
    $display($time, "ns || [DRVR] done RESET");
    sema.put();
  endtask

  task write ();
    $display($time, "ns || [DRVR] Running WRITE");
    INTF.rst_n <= 1;
    INTF.rd_wr <= 0;
    INTF.enb <= 0;
    INTF.data_in <= item.data_in;
    INTF.addr <= item.addr;
    @(negedge INTF.clk);
    INTF.enb <= 1;
    @(negedge INTF.clk);
    $display($time, "ns || [Driver] WRITE Done");
    sema.put();
    // now signal done to test
  endtask

  task read ();
    $display($time, "ns || [DRVR] Running READ");
    INTF.rst_n <= 1;
    INTF.rd_wr <= 1;
    INTF.enb <= 0;
    INTF.data_in <= 0;
    INTF.addr <= item.addr;
    @(negedge INTF.clk);
    INTF.enb <= 1;
    @(negedge INTF.clk);
    $display($time, "ns || [DRVR] done READ");
    sema.put();
  endtask

  task idle ();
    $display($time, "ns || [DRVR] Running IDLE");
    INTF.rst_n <= 1;
    INTF.rd_wr <= 0;
    INTF.enb <= 0;
    INTF.data_in <= 0;
    INTF.addr <= 0;
    @(negedge INTF.clk);
    $display($time, "ns || [DRVR] done IDLE");
    sema.put();
  endtask

endclass