// name:array_13_ext depth:64 width:192 masked:true maskGran:24 maskSeg:8
module array_13_ext(
  input RW0_clk,
  input [5:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [191:0] RW0_wdata,
  output [191:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [5:0] reg_RW0_addr;
  reg [191:0] ram [63:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 64; initvar = initvar+1)
        ram[initvar] = {6 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][23:0] <= RW0_wdata[23:0];
      if (RW0_wmask[1]) ram[RW0_addr][47:24] <= RW0_wdata[47:24];
      if (RW0_wmask[2]) ram[RW0_addr][71:48] <= RW0_wdata[71:48];
      if (RW0_wmask[3]) ram[RW0_addr][95:72] <= RW0_wdata[95:72];
      if (RW0_wmask[4]) ram[RW0_addr][119:96] <= RW0_wdata[119:96];
      if (RW0_wmask[5]) ram[RW0_addr][143:120] <= RW0_wdata[143:120];
      if (RW0_wmask[6]) ram[RW0_addr][167:144] <= RW0_wdata[167:144];
      if (RW0_wmask[7]) ram[RW0_addr][191:168] <= RW0_wdata[191:168];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [191:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[191:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule