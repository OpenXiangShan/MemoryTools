// name:array_10_ext depth:4 width:1044 masked:true maskGran:261 maskSeg:4
module array_10_ext(
  input RW0_clk,
  input [1:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [1043:0] RW0_wdata,
  output [1043:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [1:0] reg_RW0_addr;
  reg [1043:0] ram [3:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 4; initvar = initvar+1)
        ram[initvar] = {33 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][260:0] <= RW0_wdata[260:0];
      if (RW0_wmask[1]) ram[RW0_addr][521:261] <= RW0_wdata[521:261];
      if (RW0_wmask[2]) ram[RW0_addr][782:522] <= RW0_wdata[782:522];
      if (RW0_wmask[3]) ram[RW0_addr][1043:783] <= RW0_wdata[1043:783];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [1055:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[1043:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule