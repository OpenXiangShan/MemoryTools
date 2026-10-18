// name:array_1_ext depth:512 width:308 masked:true maskGran:77 maskSeg:4
module array_1_ext(
  input RW0_clk,
  input [8:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [307:0] RW0_wdata,
  output [307:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [8:0] reg_RW0_addr;
  reg [307:0] ram [511:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 512; initvar = initvar+1)
        ram[initvar] = {10 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][76:0] <= RW0_wdata[76:0];
      if (RW0_wmask[1]) ram[RW0_addr][153:77] <= RW0_wdata[153:77];
      if (RW0_wmask[2]) ram[RW0_addr][230:154] <= RW0_wdata[230:154];
      if (RW0_wmask[3]) ram[RW0_addr][307:231] <= RW0_wdata[307:231];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [319:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[307:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule