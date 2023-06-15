//write all

class packet_sequence1 extends uvm_sequence#(packet);
  `uvm_object_utils(packet_sequence1)
  bit 	[4:0] addr;
  bit 	[7:0] wdata;
  bit		  write;
  int rpt_count;
  
  function new(string name="packet_sequence1");
    super.new(name);
  endfunction:new
  
  task pre_start();
    if(uvm_config_db#(int)::get(get_sequencer(),"","pkt_count",rpt_count))
      begin
        `uvm_info("SEQ:Body:Config_DB:Found",get_sequencer).get_full_name(),UVM_MEDIUM);
        $display("....%0d",rpt_count);
      end
    else
      begin
        `uvm_warning("SEQ:Body:Config_DB:NotFound",get_sequencer).get_full_name);
      end
  endtask
  
  task body;
    packet ref_pkt;
    ref_pkt=packet::type_id::create("ref_pkt");
    repeat(rpt_count)
      begin
        `uvm_create(req);
        assert(ref_pkt.randomize with {ref_pkt.psel==1;ref_pkt.penable==0;ref_pkt.pwrite==1;});
        req.copy(ref_pkt);
        addr=req.paddr;
        wdata=req.pwdata;
        write=req.pwrite;
        
        start_item(req);
        req.print(uvm_default_line_printer);
        finish_item(req);
        
        `uvm_create(req);
        assert(ref_pkt.randomize with {req.psel==1;req.penable==1;});
        req.paddr=addr;
        req.pwdata=wdata;
        req.pwrite=write;
        start_item(req);
        req.print(uvm_default_line_printer);
        finish_item(req);
      end
  endtask
endclass:packet_sequence1

//read-all

class packet_sequence2 extends uvm_sequence#(packet);
  `uvm_object_utils(packet_sequence2)
  bit 	[4:0] addr;
  bit 	[7:0] wdata;
  bit		  write;
  int rpt_count;
  
  function new(string name="packet_sequence2");
    super.new(name);
  endfunction:new
  
  task pre_start();
    if(uvm_config_db#(int)::get(get_sequencer(),"","pkt_count",rpt_count))
      begin
        `uvm_info("SEQ:Body:Config_DB:Found",get_sequencer).get_full_name(),UVM_MEDIUM);
        $display("....%0d",rpt_count);
      end
    else
      begin
        `uvm_warning("SEQ:Body:Config_DB:NotFound",get_sequencer).get_full_name);
      end
  endtask
  
  task body;
    packet ref_pkt;
    ref_pkt=packet::type_id::create("ref_pkt");
    repeat(rpt_count)
      begin
        `uvm_create(req);
        assert(ref_pkt.randomize with {ref_pkt.psel==1;ref_pkt.penable==0;ref_pkt.pwrite==0;});
        req.copy(ref_pkt);
        addr=req.paddr;
        //wdata=req.pwdata;
        write=req.pwrite;
        
        start_item(req);
        req.print(uvm_default_line_printer);
        finish_item(req);
        
        `uvm_create(req);
        assert(ref_pkt.randomize with {req.psel==1;req.penable==1;});
        req.paddr=addr;
        //req.pwdata=wdata;
        req.pwrite=write;
        start_item(req);
        req.print(uvm_default_line_printer);
        finish_item(req);
      end
  endtask
endclass:packet_sequence2
