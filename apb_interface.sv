interface apb_interface(input bit clk);
  logic 				reset;
  logic [addrWidth-1:0] paddr;
  logic					pwrite;
  logic					psel;
  logic					penable;
  logic [dataWidth-1:0] prdata;
  logic					pready;
  
  clocking drv_cb@(posedge clk);
    default input #0 output #0;
    output penable,psel,pwrite,paddr,pwdata;
  endclocking
  
  clocking imon_cb@(posedge clk);
    default input #0 output #0;
    input penable,psel,pwrite,paddr,pwdata;
  endclocking
  
  clocking omon_cb@(posedge clk);
    default input #0 output #0;
    input pwdata,penable,psel,pwrite,paddr,prdata,pready;
  endclocking
  
  modport DRV(clocking drv_cb,output reset);
    modport IMON(clocking imon_cb,input reset);
      modport OMON(clocking omon_cb,input reset);
        endinterface
      
