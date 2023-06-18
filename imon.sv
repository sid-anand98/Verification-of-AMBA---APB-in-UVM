class imon extends uvm_monitor;
`uvm_component_utils(imon)

virtual apb_interface.IMON vif; packet pkt;
int no_of_pkts_recvd; int wr_pkt,rd_pkt; logic [7:0]ass_a[*];

//tlm port
uvm_analysis_port #(packet) analysis_port;

function new (string name = "imon",uvm_component parent); 
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase); 
 super.build_phase(phase);
if(!uvm_config_db#(virtual apb_interface.IMON)::get(get_parent(),"","imon_if",vif)) 
 begin
`uvm_fatal(get_type_name(),"Input monitor Virtual Interface Defective"); 
 end

//tlm port memory creation 
 analysis_port=new("i_mon_analysis_port",this);
endfunction

task run_phase(uvm_phase phase); repeat(2)
@(vif.imon_cb); forever
begin @(vif.imon_cb);
pkt=packet::type_id::create("pkt",this);

`uvm_info("IMON","Input-monitor started",UVM_MEDIUM);
 
 pkt.psel = vif.imon_cb.psel; 
 pkt.penable			= vif.imon_cb.penable; 
 pkt.pwrite		= vif.imon_cb.pwrite;
 pkt.paddr	= vif.imon_cb.paddr; 
 pkt.pwdata		= vif.imon_cb.pwdata; 
 pkt.prdata = 'hx;

if(vif.imon_cb.psel==1 && vif.imon_cb.penable==1 && vif.imon_cb.pwrite==1) 
 begin
 ass_a[pkt.paddr] = vif.imon_cb.pwdata; wr_pkt++;
 `uvm_info("IMON",$sformatf("Tr:%0d,psel:%0d,penable:%0d,pwrite:%0d,paddr:%0d,data_in:%0d",no_of_pkts_recvd,pkt.psel,pkt.penable,pkt.pwrite,pkt.paddr,pkt.pwdata),UVM_MEDIUM); 
 end

 else if(vif.imon_cb.psel==1 && vif.imon_cb.penable==1 && vif.imon_cb.pwrite==0) 
  begin
   rd_pkt++;
   if(ass_a.exists(pkt.paddr)) begin pkt.prdata=ass_a[pkt.paddr]; 
   end

`uvm_info("IMON",$sformatf("Tr:%0d,psel:%0d,penable:%0d,pwrite:%0d,paddr:%0d,data_out:%0d", no_of_pkts_recvd,pkt.psel,pkt.penable,pkt.pwrite,pkt.paddr,pkt.prdata),UVM_MEDIUM); 
  end

//sending through tlm 
 analysis_port.write(pkt); 
end

$display("@%0t [MONIN] RUN ENDED ",$time); 
endtask
endclass
