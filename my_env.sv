`include "packet.sv"
`include "apb_sequences.sv"
`include "apb_driver.sv"
`include "omon.sv"
`include "imon.sv"
`include "input_agent.sv"
`include "output_agent.sv"
`include "scoreboard.sv"

class my_env extends uvm_env;
  `uvm_component_uitls(my_env);
  
  input_agent i_agt;
  output_agent o_agt;
  scoreboard scb;
  int item_count;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    i_agt = input_agent::type_id::create("i_agt",this);
    o_agt = output_agent::type_id::create("o_agt",this);
    scb = scoreboard::type_id::create("scb",this);
    
    if(!uvm_config_db#(int)::get(null,"uvm_test_top.env.i_agt.sqr","pkt_count",item_count))
      begin
        `uvm_error(get_full_name(),"item_count is not set");
      end
  endfunction
  
  function void connect_phase(uvm_phase phase);
    i_agt.ap.connect(scb.ap_imp_i_mon); //with passthrough
    o_agt.ap.connect(scb.ap_imp_o_mon); //with passthrough
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    wait(2*item_count==scb.i_mon_rcvd);
    begin
      #2;
      $display("Reached END OF TEST");
    end
    phase.drop_objection(this);
  endtask
  
  function void report_phase(uvm_phase phase)
    `uvm_info("ENV",  $sformatf ("  TOTAL NO OF PKTS                   =%0d",item_count),UVM_MEDIUM);
    `uvm_info("ENV",  $sformatf ("  TOTAL WRITE                        =%0d",scb.match_write),UVM_MEDIUM);
    `uvm_info("ENV",  $sformatf ("  TOTAL READ MATCHES                 =%0d",scb.match),UVM_MEDIUM);
    `uvm_info("ENV",  $sformatf ("  TOTAL ADDR NOT WRITTEN             =%0d",scb.match_read),UVM_MEDIUM);
    `uvm_info("ENV",  $sformatf ("  TOTAL MISMATCHES                   =%0d",scb.match_read),UVM_MEDIUM);
    
    if(2*item_count==scb.o_mon_rcvd && scb.mismatch==0)
      begin
        `uvm_info("ENV","**************************************************************************",UVM_MEDIUM);
        `uvm_info("ENV","***********************************PASSED**********************************",UVM_MEDIUM);
        `uvm_info("ENV","**************************************************************************",UVM_MEDIUM);
      end
    else
      begin
        `uvm_info("ENV","**************************************************************************",UVM_MEDIUM);
        `uvm_info("ENV","***********************************FAILED**********************************",UVM_MEDIUM);
        `uvm_info("ENV","**************************************************************************",UVM_MEDIUM);
      end
  endfunction
endclass
