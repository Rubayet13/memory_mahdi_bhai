import env_pkg::* ; 
import agent_pkg::* ;
import seq_pkg::* ;

program basetest (input clk, mem_intf INTF);

  // The environment is the container class that holds all other components
  mem_environment env;

  // The sequences are classes where we declare the sequence of operations that make up the test
  write_read_seq seq;
  // base_seq seq;

  semaphore sema;
  string name = "TEST";
  mailbox #(mem_trans) test2drvr;


  
  initial begin
    $display("test initiated");

    env = new();
    seq = new();

    // calls agent::new() which in turn calls driver::new() and monitor::new()
    // also calls scb::new(), thus ensuring all components are built

    // now we create the synchronization elements 
    // and connect them to thier appropiate components in te env.connect() function
    test2drvr = new();
    sema = new();
    env.connect(INTF, test2drvr, sema);
    seq.sema = sema;
    seq.seq2drvr = test2drvr;

    // The environment run() task will initiate all the subcomponent run() tasks in parallel
    env.run();
    seq.run_times = 100;
    seq.body();

    // Here we will declare the sequence of operations that will comprise of the test.
    // to avoid cluttering, and utilizing .randomize() we will declare some new classes.
    // They will be called sequences and will act as their name suggests, sequence of operations.
    // A new component will be used called the sequencer, this will act as a bridge between the sequnce
    // and the driver i.e., it will carray the inputs declared in the sequences to the driver.

    
    /*
      // Followig codes have been used in the seq now
      // reset();

      // read('h10);
      // read('h10);
      // write('h10, 'hFFFF);
      // read('h10);
      // write('h10, 'hEEEE);
      // write('h10, 'hDDDD);
      // read('h10);
      // write('h30, 'hAAAA);
      // read('h30);
      // read('h40);
      // reset();
      // read('hA);
      // read('hA);
      // write('hA, 'hFFFF);
      // read('hA);
      // write('hA, 'hEEEE);
      // write('hA, 'hDDDD);
      // read('hA);
      // write('hB, 'hAAAA);
      // read('hB);
      // read('hC);
      // repeat (1000) begin
      //   mem_trans item;
      //   item.randomize() ; // with {item.opp != RESET;}
      //   $display("\n", $time, "ns || [TEST] running operation %s", item.opp.name());
      //   opp_stack[item.opp] = opp_stack[item.opp]+1;
      //   test2drvr.put(item);
      //   sema.get();
      // end

    */

    
    @(negedge clk);
    $display ("\n ----- 0 ----- 0 ----- 0 ----- 0 ----- 0 -----");
    $display ("[TEST] TEST DONE @time: %0t ns", $time/1000);
    foreach (seq.opp_stack[i]) begin
      $display("%s Used %d", i.name(), seq.opp_stack[i]);
    end
    env.scb.report();

    $finish;
    
  end


endprogram
