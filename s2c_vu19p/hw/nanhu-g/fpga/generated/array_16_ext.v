// name:array_16_ext depth:128 width:230 masked:true maskGran:23 maskSeg:10
module array_16_ext(
  input RW0_clk,
  input [6:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [9:0] RW0_wmask,
  input [229:0] RW0_wdata,
  output [229:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [6:0] reg_RW0_addr;
  reg [229:0] ram [127:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 128; initvar = initvar+1)
        ram[initvar] = {8 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][22:0] <= RW0_wdata[22:0];
      if (RW0_wmask[1]) ram[RW0_addr][45:23] <= RW0_wdata[45:23];
      if (RW0_wmask[2]) ram[RW0_addr][68:46] <= RW0_wdata[68:46];
      if (RW0_wmask[3]) ram[RW0_addr][91:69] <= RW0_wdata[91:69];
      if (RW0_wmask[4]) ram[RW0_addr][114:92] <= RW0_wdata[114:92];
      if (RW0_wmask[5]) ram[RW0_addr][137:115] <= RW0_wdata[137:115];
      if (RW0_wmask[6]) ram[RW0_addr][160:138] <= RW0_wdata[160:138];
      if (RW0_wmask[7]) ram[RW0_addr][183:161] <= RW0_wdata[183:161];
      if (RW0_wmask[8]) ram[RW0_addr][206:184] <= RW0_wdata[206:184];
      if (RW0_wmask[9]) ram[RW0_addr][229:207] <= RW0_wdata[229:207];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [255:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[229:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule