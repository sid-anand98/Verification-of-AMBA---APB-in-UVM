class scoreboard extends uvm_scoreboard;

packet pkt_rcvd_from_o_mon;
packet pkt_rcvd_from_i_mon;

int i_mon_rcvd;
int o_mon_rcvd;
int item_count;
event compare_pkt;
int mismatch;
int match_write;
int match_read;
int match;

`uvm_component_utils(scoreboard)

`uvm_analysis_imp_decl(_from_i_mon);
uvm_analysis_imp_from_i_mon #(packet,scoreboard) ap_imp_i_mon;
`uvm_analysis_imp_decl(_from_o_mon);
uvm_analysis_imp_from_o_mon #(packet,scoreboard) ap_imp_o_mon;

function new(string name="scoreboard",uvm_component parent=null);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build(phase);
ap_imp_i_mon=new("ap_imp_i_mon",this);
ap_imp_o_mon=new("ap_imp_o_mon",this);

if(!uvm_config_db#(int)::get(null,"uvm_test_top.env.i_agt.sqr","pkt_count",item_count))
begin
`uvm_error(get_full_name(),"item_count is not set");
end
endfunction

//writing from imon

virtual function void write_from_i_mon(input packet pkt);

pkt_rcvd_from_i_mon=pkt;
if(pkt_rcvd_from_i_mon.penable==1)
i_mon_rcvd=i_mon_rcvd+1;
$display("imon_rcvd:%0d",i_mon_rcvd);
`uvm_info("IMON to SCB",$sformatf("input-mon_rcvd=%0d",pkt_rcvd_from_i_mon.prdata),UVM_MEDIUM);
endfunction

//write from output-mon


virtual function void write_from_o_mon(input packet pkt);
pkt_rcvd_from_o_mon=pkt;
if(pkt_rcvd_from_o_mon.penable==1)
o_mon_rcvd=o_mon_rcvd+1;
$display("output-mon_rcvd:%0d",o_mon_rcvd);
`uvm_info("OUTPUT-MON to SCB",$sformatf("output-mon_rcvd=%0d",pkt_rcvd_from_o_mon.prdata),UVM_MEDIUM);

if(o_mon_rcvd<=(2*item_count)+1);
->compare_pkt;
endfunction

task run_phase(uvm_phase phase);
forever begin
@(compare_pkt)

if(pkt_rcvd_from_i_mon.prdata==pkt_rcvd_from_o_mon.prdata)
begin
`uvm_info("SCOREBOARD",$sformatf("MATCH input-mon=%0d, output_mon=%0d",pkt_rcvd_from_i_mon.prdata,pkt_rcvd_from_o_mon.prdata),UVM_MEDIUM);
match=match+1;
end

else if(pkt_rcvd_from_i_mon.prdata===8'bx && pkt_rcvd_from_o_mon.prdata===8'bx && pkt_rcvd_from_o_mon.pwrite==1 && pkt_rcvd_from_o_mon.penable==1)
begin
`uvm_info("SCOREBOARD",$sformatf("MATCH_write input-mon=%0d,output-mon=%0d",pkt_rcvd_from_i_mon.prdata,pkt_rcvd_from_o_mon.prdata),UVM_MEDIUM);
match_write=match_write+1;
end

else if (pkt_rcvd_from_i_mon.prdata===8'bx && pkt_rcvd_from_o_mon.prdata===8'bx && pkt_rcvd_from_o_mon.pwrite==0 && pkt_rcvd_from_o_mon.penable==1)
begin
`uvm_info("SCOREBOARD",$sformatf("MATCH_read not written input-mon=%0d,output-mon=%0d",pkt_rcvd_from_i_mon.prdata,pkt_rcvd_from_o_mon.prdata),UVM_MEDIUM);
match_read=match_read+1;
end

else if(pkt_rcvd_from_i_mon.prdata!=pkt_rcvd_from_o_mon.prdata)
begin
`uvm_info("SCOREBOARD", $sformatf("MISMATCH input-mon=%0d, output-mon=%0d",pkt_rcvd_from_i_mon.prdata,pkt_rcvd_from_o_mon.prdata),UVM_MEDIUM);
mismatch=mismatch+1;
end
else
begin
`uvm_info("SCOREBOARD",$sformatf("IGNORE input-mon=%0d, output-mon=%0d",pkt_rcvd_from_i_mon.prdata,pkt_rcvd_from_o_mon.prdata),UVM_MEDIUM);
end
end

endtask

endclass
