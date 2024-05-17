
class mem_scb_2 extends mem_scoreboard;

  /*
  Here the referance model is used to hold mem_trans type objects, contrasting from the previous integer storage.
  But similarly,  here the address being used will be condsidered as the index of the associative array.
  mem_trans has the been given the property (accesses) to keep track of how many READ or WRITE operation is being used for a given address
  */

  mem_trans item_stack [ADDR_VAL];

  function new ();
    super.new();
    name = "SCB 2";
  endfunction

  task run ();
    forever begin
      mon2scb.get(item);

      /*
      Now that the scoreboard has recieved an analysis item from the monitor.
      The scoreboard has to update the referance according to the operations used on the DUT.
      As stated above the referance will store a mem_trans object for each index (address being used) of the array.
      each read and write operation on that address will increment the respective "asscesses" slot (READ/WRITE).

      Reset will clear (delete()) the referance.

      for operation either READ or WRITE, the referance will be checked if an entry exists with the index == address
      if not then the scb will create an entry eith index according to the address,
      and insert copy of the analysis_item into the item_stack.

      Write operation will update the referance with an item entry to the index specified by the address.
      We will use the data_in of the entered item as the exp_value for the address.
      The WRITE access will also be updated of the entry.

      for read operation, the data_out of the analysis item will be checked with the expected output. 
      exp_data = 'ha; if previosuly unwritten 
      exp_data = data_in of the entry; if previosuly written to
      The READ access will also be updated of the entry.


      */

      if (item.opp == RESET) begin 
        `DISPLAY({ALL, SCB}, $sformatf("Reseting Reference"))
        item_stack.delete();
      end
      else if (item.opp inside {READ,WRITE}) begin
        if (!item_stack.exists(item.addr)) begin // if the address has not been previously accessed, item.addr will not exist in item_stack
          item_stack[item.addr] = item.do_copy(); // storing the item in the referance. 
          //notice we will not store the item directly, we will copy it first then store the copy.
        end
  
        if (item.opp == READ) begin // ensuring the operation is READ

          if (item_stack[item.addr].accesses[WRITE] == 0) compare ('ha);
          // checking if the address is unwritten, if yes the expected data will be 'ha  
          else compare (item_stack[item.addr].data_in); // else the expected data will be data_in

          item_stack[item.addr].accesses[READ]++; // As the operation is read we will increment the READ count in access.
          item_stack[item.addr].data_out = item.data_out; // the out_data will be recorded as well (not mandatory)
          item_stack[item.addr].valid = item.valid; // storing the result of the comparison
        end
    
        else if (item.opp == WRITE) update();
      end
      sema.put();
    end
  endtask

  virtual function void update();
    `DISPLAY({ALL, SCB}, $sformatf("Updating Access for %s || Address %0h", item.opp.name(), item.addr))
    item_stack[item.addr].data_in = item.data_in;
    item_stack[item.addr].accesses[WRITE]++;    
  endfunction

  function void report ();
    super.report();
    foreach (item_stack[i]) begin
      mem_trans tmp = item_stack[i]; 
      `DISPLAY({ALL}, $sformatf("item %h || Accesses %p || Data In = xh'%0h | Data Out = xh'%0h || Validity = %s", i, tmp.accesses, tmp.data_in, tmp.data_out, tmp.valid.name()));
    end
  endfunction

endclass
