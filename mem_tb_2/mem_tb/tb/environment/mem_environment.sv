class mem_environment;

  string name = "ENV";
  mem_agent agent;
//  mem_scoreboard scb;
  mem_scb_2 scb;

  function new();
    agent = new();
    scb = new(); 
  endfunction

  virtual function void connect(virtual mem_intf INTF, mailbox #(mem_trans) test2drvr, semaphore sema);
    agent.driver.INTF = INTF;
    agent.driver.test2drvr = test2drvr;

    agent.monitor.INTF = INTF;
    agent.monitor.mon2scb = scb.mon2scb; 
    // environment::new() triggers scoreboard::new() which in turn triggers mntr2scb::new()
    // thus this assignmnet DOES NOT assign an uncreated object.

    scb.sema = sema;
  endfunction

  virtual task run();
    fork
      agent.driver.run();
      agent.monitor.run();
      scb.run();  
    join_none
  endtask

endclass