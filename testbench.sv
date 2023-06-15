`include "apb_interface.sv"
`include "program_apb.sv"

module top;
  bit clk;
  
  initial
    begin
      clk = 0;
      forever #5 clk = ~clk;
    end
  
  apb_interface apbif(clk);
  apb duv(.clk(clk),.reset(apbif.reset),.paddr(apbif.paddr),.pwrite(apbif.pwrite),.psel(apbif.psel),.penable(apbif.penable),.pwdata(apbif.pwdata),.prdata(apbif.prdata),.pready(apbif.pready));
  program_apb pgm();
endmodule
 
