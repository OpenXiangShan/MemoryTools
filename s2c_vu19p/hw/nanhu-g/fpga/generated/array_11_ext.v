// name:array_11_ext depth:4 width:2672 masked:true maskGran:334 maskSeg:8
module array_11_ext(
  input RW0_clk,
  input [1:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [2671:0] RW0_wdata,
  output [2671:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [1:0] reg_RW0_addr;
  reg [2671:0] ram [3:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 4; initvar = initvar+1)
        ram[initvar] = {84 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][333:0] <= RW0_wdata[333:0];
      if (RW0_wmask[1]) ram[RW0_addr][667:334] <= RW0_wdata[667:334];
      if (RW0_wmask[2]) ram[RW0_addr][1001:668] <= RW0_wdata[1001:668];
      if (RW0_wmask[3]) ram[RW0_addr][1335:1002] <= RW0_wdata[1335:1002];
      if (RW0_wmask[4]) ram[RW0_addr][1669:1336] <= RW0_wdata[1669:1336];
      if (RW0_wmask[5]) ram[RW0_addr][2003:1670] <= RW0_wdata[2003:1670];
      if (RW0_wmask[6]) ram[RW0_addr][2337:2004] <= RW0_wdata[2337:2004];
      if (RW0_wmask[7]) ram[RW0_addr][2671:2338] <= RW0_wdata[2671:2338];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [2687:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[2671:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule