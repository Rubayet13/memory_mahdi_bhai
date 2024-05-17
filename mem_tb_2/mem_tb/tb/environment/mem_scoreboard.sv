class mem_scoreboard;

  string name = "SCB"; // name of component
  int results [VALIDITY] = '{PASSED: 0, FAILED: 0}; // to keep count of test results
  mailbox #(mem_trans) mon2scb; // mailbox to recieve item from monitor
  mem_trans item; // item to hold recieved values from the monitor


  DATA_VAL mem_arr [ADDR_VAL];  // referance model || we used a associative array to hold values written to any address, and the index of the array wil
  // be the address being operated upon, like writing value 'hac10 to address 13 will create an entry index 13 with value 'hac10

  semaphore sema; // for synchronization with the test, each operation started by the test will wait for the scorebaord to finish its analysis by 
  // waiting for the scoreboard to put a key into the semaphore, the test will recieve the key and end its current operation

  function new();
    // this.mon2scb = mon2scb;
    // this.sema = sema;
    mon2scb = new();
  endfunction

  virtual task run ();
    forever begin
      mon2scb.get(item);

      /*
      Now that the scoreboard has recieved an analysis item from the monitor.
      The scoreboard has to update the referance according to the operations used on the DUT.
      For write the reference will be updated with the write data value to the appropiate address used as index.
      For read we must first consider, if the address has been written to or not.
      For addresses previousy written to the expected value should be the written value.
      And for addresses for which no write has been done, the expected value should be 'ha.
      So, the scoreboard must keep track of which operations has happened to the address in use.
      */

      if (item.opp == RESET) begin 
        `DISPLAY({ALL, SCB}, $sformatf("Reseting Reference"))
        mem_arr.delete();
      end
      else begin
        if (item.opp == READ) begin
          if (!mem_arr.exists(item.addr)) compare ('ha);
          else compare (mem_arr[item.addr]);
        end
        else if (item.opp == WRITE) update();
      end
    end
  endtask

  virtual function void compare (DATA_VAL exp, act = item.data_out);
    `DISPLAY({ALL, SCB}, $sformatf("Comparing Exp %h || Read %h", exp, act))
    if (exp == act) begin
      results [PASSED] = results [PASSED]+1;
      item.valid = PASSED;
      `DISPLAY({ALL, SCB}, $sformatf(" <<<<<<<<<<<<<<<<< PASSED >>>>>>>>>>>>>>>>>"));
    end
    else begin 
      results [FAILED] = results [FAILED]+1;
      item.valid = FAILED;
      `DISPLAY({ALL, SCB}, $sformatf("!!!!!!!!!!!!!!!!!! FAILED !!!!!!!!!!!!!!!!!! "));
    end
  endfunction

  virtual function void update();
    mem_arr[item.addr] = item.data_in;    
    `DISPLAY({ALL, SCB}, $sformatf("Updating Referance for Address %0d with value xh%0h", item.addr, item.data_in))
  endfunction

  function void report ();
    $display ("====== RUN Complete ======");
    $display ("Duration %0t ns", $time/1000);
    $display ("TOTAL TESTS = %0d", results[PASSED] + results[FAILED]);
    $display ("PASSED TESTS = %0d", results[PASSED]);
    $display ("FAILED TESTS = %0d", results[FAILED]);

  endfunction

endclass