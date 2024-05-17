class write_read_seq extends base_seq;
  int run_times = 1;
  string name = "WR_RD_SEQ";

  task body();
    reset ();
    repeat (run_times) begin
      mem_trans item = new;      
      item.randomize() with {
        item.data_in != 0;
      };

      item.opp = WRITE;
      $display("\n", $time, "ns || [%s] running operation %s", name, item.opp.name());
      opp_stack[item.opp] = opp_stack[item.opp]+1;
      seq2drvr.put(item);
      sema.get();
      $display($time, "ns || [%s] WRITE Done", name);

      item.opp = READ;
      $display("\n", $time, "ns || [%s] running operation %s", name, item.opp.name());
      opp_stack[item.opp] = opp_stack[item.opp]+1;
      seq2drvr.put(item);
      sema.get();
      $display($time, "ns || [%s] READ Done", name);

    end
  endtask

endclass