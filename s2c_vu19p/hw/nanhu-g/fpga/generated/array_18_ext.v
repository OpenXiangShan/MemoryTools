// name:array_18_ext depth:1024 width:160 masked:true maskGran:20 maskSeg:8
module array_18_ext(
  input RW0_clk,
  input [9:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [159:0] RW0_wdata,
  output [159:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [9:0] reg_RW0_addr;
  reg [159:0] ram [1023:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 1024; initvar = initvar+1)
        ram[initvar] = {5 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][19:0] <= RW0_wdata[19:0];
      if (RW0_wmask[1]) ram[RW0_addr][39:20] <= RW0_wdata[39:20];
      if (RW0_wmask[2]) ram[RW0_addr][59:40] <= RW0_wdata[59:40];
      if (RW0_wmask[3]) ram[RW0_addr][79:60] <= RW0_wdata[79:60];
      if (RW0_wmask[4]) ram[RW0_addr][99:80] <= RW0_wdata[99:80];
      if (RW0_wmask[5]) ram[RW0_addr][119:100] <= RW0_wdata[119:100];
      if (RW0_wmask[6]) ram[RW0_addr][139:120] <= RW0_wdata[139:120];
      if (RW0_wmask[7]) ram[RW0_addr][159:140] <= RW0_wdata[159:140];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [159:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[159:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule