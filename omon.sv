class omon extends uvm_monitor;
`uvm_component_utils(omon);

virtual apb_interface.OMON vif;
packet pkt;
int wr_pkt,rd_pkt;

//tlm passthrough
uvm_analysis_port #(packet) analysis_port;


//covergroup

covergroup apb_mon_cg;
	cp_PRDATA: coverpoint pkt.prdata {bins b_dataout ={[0:255]};}
endgroup




function new (string name = "omon",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(virtual apb_interface.OMON)::get(get_parent(),"","omon_if",vif)) begin
`uvm_fatal(get_type_name()," Output-Monitor Virtual Interface failed ");
end

//tlm passthrough
analysis_port=new("o_mon_analysis_port",this);
endfunction

task run_phase(uvm_phase phase);
repeat(2)
@(vif.omon_cb);
forever
begin
@(vif.omon_cb);
`uvm_info("OMON","Output - Monitor Started",UVM_MEDIUM);
pkt=packet::type_id::create("pkt",this);

if(vif.omon_cb.psel==1 && vif.omon_cb.penable==1 && vif.omon_cb.pwrite==0)
begin

pkt.prdata = vif.omon_cb.prdata;
pkt.psel = vif.omon_cb.psel;
pkt.penable = vif.omon_cb.penable;
pkt.pwrite = vif.omon_cb.pwrite;
pkt.paddr = vif.omon_cb.paddr;
rd_pkt++;

`uvm_info("OMON", $sformatf("psel=%0d,penable=%0d,pwrite=%0d,paddr=%0d,data_out=%0d",pkt.psel,pkt.penable,pkt.pwrite,pkt.paddr,pkt.prdata),UVM_MEDIUM);
end

else if (vif.omon_cb.psel==1 && vif.omon_cb.penable==1 && vif.omon_cb.pwrite==1) begin


wr_pkt++;
pkt.pwdata = vif.omon_cb.pwdata;
pkt.psel = vif.omon_cb.psel;
pkt.penable = vif.omon_cb.penable;
pkt.pwrite = vif.omon_cb.pwrite;
pkt.paddr = vif.omon_cb.paddr;

`uvm_info("OMON", $sformatf("psel=%0d,penable=%0d,pwrite=%0d,paddr=%0d,data_in=%0d",pkt.psel,pkt.penable,pkt.pwrite,pkt.paddr,pkt.pwdata),UVM_MEDIUM);

end
//coverage sampling
apb_mon_cg.sample();

//tlm passthrough send
analysis_port.write(pkt);

end
endtask

endclass
