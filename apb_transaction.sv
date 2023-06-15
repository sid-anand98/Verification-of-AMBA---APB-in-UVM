class packet extends uvm_sequence_item;
  
  rand bit [addrWidth-1:0] paddr;
  rand bit [dataWidth-1:0] pwaddr;
  rand bit pwrite;
  rand bit psel;
  rand bit penable;
  
  logic [dataWidth-1:0] prdata,data_out_monin;
  logic [dataWidth-1:0] comp_out;
  int al_addr;
  
  constraint valid {
    pwdata inside {[0:255]};
    paddr inside {[0:31]};
    
    paddr = al_addr;
  }
  
  function void post_randomize();
    if(paddr<mem_size)
      al_addr=al+addr+1;
    else
      al_addr=0;
  endfunction
  
  `uvm_object_utils_begin(packet)
  `uvm_field_int(paddr,UVM_ALL_ON|UVM_DEC)
  `uvm_field_int(pwdata,UVM_ALL_ON|UVM_DEC)
  `uvm_field_int(pwrite,UVM_ALL_ON|UVM_DEC)
  `uvm_field_int(psel,UVM_ALL_ON|UVM_DEC)
  `uvm_field_int(penable,UVM_ALL_ON|UVM_DEC)
  `uvm_object_utils_end
  
  function new(string name="apb_transaction");
    super.new(name);
  endfunction:new
  
endclass:packet

  
