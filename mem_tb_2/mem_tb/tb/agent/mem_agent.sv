class mem_agent;

  string name = "AGENT";
  mem_driver_v2 driver;
  mem_monitor monitor;

  function new();
    driver = new();
    monitor = new(); 
  endfunction

  virtual function void connect();
    // the driver connection is done at the test, as it is easier. so won't be done here
    // the monitor would be connected to the coverage here though.
  endfunction

  virtual task run();
    // agent subclasses have been started from the enviornment, could have been done here as well
  endtask

endclass