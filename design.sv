// Code your design here
parameter addrWidth = 5;
parameter dataWidth = 8;
parameter mem_size = 32;

module apb(
  input							clk,
  input 						reset,
  input			[addrWidth-1:0] paddr,
  input 						pwrite,
  input 						psel,
  input							penable,
  input			[dataWidth-1:0]	pwdata,
  output logic	[dataWidth-1:0]	prdata,
  output logic					pready,
);
  
  logic [dataWidth-1:0] mem [mem_size];
  logic [3:0] cnt;
  logic [1:0] apb_st;
  parameter IDLE	= 0;
  parameter SETUP	= 1;
  parameter ACCESS	= 2;
  int i;
  reg [1:0] ps,ps_sync;
  
  // SETUP -> ENABLE
  always@(posedge reset or posedge clk)
    begin
      if(reset)
        begin
          ps <= IDLE;
          for(i=0;i<=mem_size;i=i+1)
            begin
              mem[i] <= 'hx;
            end
        end
      else
        ps_sync <= ps;
    end
  
  always@(posedge reset or posedge clk)
    begin
      if(reset)
        ps_sync <= 0;
      else
        ps_sync <= ps;
    end
  
  always@(*)
    begin
      if(ps_sync==IDLE)
        begin
          case({psel,penable})
            2'b00	: ps = IDLE;
            2'b01	: ps = IDLE;
            2'b10	: ps = SETUP;
            2'b11	: ps = IDLE;
            default : ps = IDLE;
          endcase
        end
      else if(ps_sync==SETUP)
        begin
          case({psel,penable})
            2'b00	: ps = IDLE;
            2'b01	: ps = IDLE;
            2'b10	: ps = SETUP;
            2'b11	: ps = ACCESS;
            default : ps = IDLE;
          endcase
        end
      else if(ps_sync==ACCESS)
        begin
          case({psel,penable})
            2'b00	: ps = IDLE;
            2'b01	: ps = IDLE;
            2'b10	: ps = SETUP;
            2'b11	: ps = ACCESS;
            default : ps = IDLE;
          endcase
        end
    end
  
  always@(posedge clk)
    begin
      if(ps==ACCESS && pwrite==1 && pready==1)
        mem[paddr] = pwdata;
      else if(ps==ACCESS && pwrite==0 && pready==1)
        prdata=mem[paddr];
    end
  
  assign apb_st = ps;
  assign pready = 1;
endmodule   
