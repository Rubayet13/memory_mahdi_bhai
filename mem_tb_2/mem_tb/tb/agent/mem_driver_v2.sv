class mem_driver_v2 extends mem_driver;

  string name = "Driver V2";

  virtual task run();
    $display($time, "ns || [%s] INITIATED", name);
    
    forever begin
      test2drvr.get(item);  

      `DISPLAY({DRVR, ALL}, $sformatf(" Running %s || Address %0h", item.opp.name(), item.addr));
      
      if (item.opp == RESET) INTF.rst_n <= 0;
      else INTF.rst_n <= 1;

      if (item.opp == READ) INTF.rd_wr <= 1;
      else INTF.rd_wr <= 0;

      INTF.enb <= 0;
      INTF.data_in <= item.data_in;
      INTF.addr <= item.addr;
      @(negedge INTF.clk);

      if (item.opp == WRITE || item.opp == READ) begin
        INTF.enb <= 1;
        @(negedge INTF.clk);
      end

      `DISPLAY({DRVR, ALL}, $sformatf(" %s Done", item.opp.name()));
      // sema.put();
    end

  endtask


endclass