class input_agent extends uvm_agent;
`uvm_component_utils(input_agent );

typedef uvm_sequencer #(packet) packet_sequencer;
packet_sequencer sqr;
apb_driver drv;
imon i_mon;
uvm_analysis_port #(packet) ap; //passthrough

function new(string name, uvm_component parent);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
sqr=packet_sequencer::type_id::create("sqr",this);
drv=apb_driver::type_id::create("drv",this);
i_mon=imon ::type_id::create("i_mon",this);
ap=new("iagent_ap",this); // passthrough
endfunction

virtual function void connect_phase(uvm_phase phase);
drv.seq_item_port.connect(sqr.seq_item_export);
i_mon.analysis_port.connect(this.ap); //passthrough
endfunction

endclass
