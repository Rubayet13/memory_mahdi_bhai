// the base seq will hold the fundamental tasks 

class base_seq;

  string name = "BASE_SEQ"; 
  mailbox #(mem_trans) seq2drvr;
  semaphore sema;


  int opp_stack [OPERATION] = '{
    RESET : 0,
    IDLE : 0,
    WRITE : 0,
    READ :0
  };

  virtual task body();
    reset();

    read('h0);
    write('h0, 'hFACE);
    read('h0);

  endtask

  task reset();
    mem_trans item = new();
    $display("\n", $time, "ns || [TEST] Running RESET");
    item.opp = RESET;

    seq2drvr.put(item);
    sema.get();
    opp_stack[item.opp] = opp_stack[item.opp]+1;
    $display($time, "ns || [TEST] RESET Done");
  endtask

  task write (ADDR_VAL addr, DATA_VAL data);
    mem_trans item = new();
    $display("\n", $time, "ns || [TEST] Running WRITE");
    item.data_in = data;
    item.addr = addr;
    item.opp = WRITE;

    seq2drvr.put(item);
    sema.get();
    opp_stack[item.opp] = opp_stack[item.opp]+1;
    $display($time, "ns || [TEST] WRITE Done");
  endtask

  task idle();
    mem_trans item = new();
    $display("\n", $time, "ns || [TEST] Running IDLE");
    seq2drvr.put(item);
    item.opp = IDLE;
    sema.get();
    opp_stack[item.opp] = opp_stack[item.opp]+1;
    $display($time, "ns || [TEST] IDLE Done");
  endtask

  task read(ADDR_VAL addr);
    mem_trans item = new();
    $display("\n", $time, "ns || [TEST] Running READ");
    item.addr = addr;
    item.opp = READ;

    seq2drvr.put(item);
    sema.get();
    opp_stack[item.opp] = opp_stack[item.opp]+1;
    $display($time, "ns || [TEST] READ Done");
  endtask


endclass