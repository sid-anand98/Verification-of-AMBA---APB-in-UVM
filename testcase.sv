
`include "my_env.sv"
class my_test1 extends uvm_test; 
`uvm_component_utils (my_test1);

my_env env;
packet_sequence1 pkt_sq1;
packet_sequence2 pkt_sq2;

function new(string name, uvm_component parent); 
super.new(name, parent);
endfunction

virtual function void build_phase (uvm_phase phase); 
super.build_phase (phase);
env = my_env::type_id::create("env", this);
pkt_sql = packet_sequence1::type_id::create("pkt_sql");
pkt_sq2 = packet_sequence2::type_id::create("pkt_sq2");


uvm_config_db# (virtual apb_interface. DRV)::set(this, "env.i_agt", "drv_if", top.apbif. DRV); 
uvm_config_db# (virtual apb_interface. IMON)::set(this, "env.i_agt", "imon_if", top.apbif. IMON); 
uvm_config_db# (virtual apb_interface.OMON)::set(this, "env.o_agt", "omon_if", top.apbif.OMON); 
uvm_config_db# (int)::set(this, "env.i_agt.sqr","pkt_count", 20);
endfunction

task main_phase (uvm_phase phase);|
$display ("We are starting the main phase of my_test");
phase.raise_objection (this);
phase.phase_done.set_drain_time(this, 10ns);
pkt_sq1.start(env.i_agt.sqr); 
pkt_sq2.start(env.i_agt.sqr);
phase.drop_objection (this);
$display("We are ending the main phase of my_test");
endtask

virtual function void start_of_simulation_phase (uvm_phase phase); 
uvm_factory::get().print();
endfunction
endclass
