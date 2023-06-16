class output_agent extends uvm_agent;
`uvm_component_utils(output_agent);

omon o_mon;
uvm_analysis_port#(packet) ap;

function new (string name = "output_agent",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
o_mon=omon::type_id::create("o_mon",this);
ap=new("oagent_ap",this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
o_mon.analysis_port.connect(this.ap);
endfunction

endclass
