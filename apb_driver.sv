
class apb_driver extends uvm_driver# (packet); 
`uvm_component_utils (apb_driver);
virtual apb_interface. DRV vif;


//coverage
packet pkt1;
covergroup apb_drv_cg;

cp_PSEL: coverpoint pkt1.psel {bins b_sel[]={0,1};}
cp_PENABLE: coverpoint pkt1.penable {bins b_enable[]={0,1};}
cp_PWRITE: coverpoint pkt1.pwrite {bins b_write[]={0,1};}
cp_PWDATA: coverpoint pkt1.pwdata {bins b_datain[]={[0:255]};}
cp_ADDRESS: coverpoint pkt1.paddr {

bins b_addrlow[]={[0:10]};
bins b_addrmid[]={[11:mem_size-10]};
bins b_addrhigh[]={[mem_size-10+1:mem_size]};
}

cr_PSELXPENABLE: cross cp_PSEL,cp_PENABLE {
ignore_bins cr_sel0_enable0 = binsof(cp_PSEL) intersect {0} && binsof(cp_PENABLE) intersect {0};

illegal_bins cr_sel0_enable1 = binsof(cp_PSEL) intersect {0} && binsof(cp_PENABLE) intersect {1};
}
endgroup


function new(string name, uvm_component parent=null);
super.new(name, parent);
apb_drv_cg=new(); //cg mem
endfunction


function void build_phase (uvm_phase phase);
super.build_phase (phase);
void' (uvm_config_db# (virtual apb_interface. DRV)::get(get_parent(), "", "drv_if", vif)); 
assert(vif != null) else
`uvm_fatal (get_type_name(), "Virtual interface in driver is NULL "); 
endfunction


task reset_phase (uvm_phase phase);
phase.raise_objection(this, "RESET raised obj");
`uvm_info("DRVR: reset_phase"," Reset started...", UVM_MEDIUM);
vif.reset <=1;
repeat (2) @(vif.drv_cb);
vif.reset <=0;
`uvm_info("DRVR: reset_phase"," Reset ended ", UVM_MEDIUM); 
phase.drop_objection(this, "RESET dropped obj");
endtask


virtual task run_phase (uvm_phase phase);
forever
begin
wait( !vif.reset)
seq_item_port.get_next_item(req);
$display("********Driver********");
req.print();

drive_to_design(req);

apb_drv_cg.sample(); //samples from driver

seq_item_port.item_done();
end
endtask


task drive_to_design (input packet pkt);
@(vif.drv_cb);
`uvm_info("DRVR", "Driving started...", UVM_MEDIUM);
vif.drv_cb.psel <= pkt.psel;
vif.drv_cb.penable<= pkt.penable;
vif.drv_cb.pwrite <= pkt.pwrite; 
vif.drv_cb.paddr <= pkt.paddr; 
vif.drv_cb.pwdata <= pkt.pwdata;
endtask
endclass
