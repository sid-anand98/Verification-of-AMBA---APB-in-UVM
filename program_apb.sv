
import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "my_test.sv"

program program_apb;
  
  initial
    begin
      //run_test();
      $display("Hello-World");
      $finish;
    end
  
endprogram
