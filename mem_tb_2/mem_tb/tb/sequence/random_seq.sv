class random_seq extends base_seq;
  int run_times = 1;
  string name = "RAND_SEQ";

  task body();
    reset ();
    repeat (run_times) begin
      mem_trans item = new;
      item.randomize() ; // with {item.opp != RESET;}
      $display("\n", $time, "ns || [TEST] running operation %s", item.opp.name());
      opp_stack[item.opp] = opp_stack[item.opp]+1;
      seq2drvr.put(item);
      sema.get();
    end
  endtask

endclass