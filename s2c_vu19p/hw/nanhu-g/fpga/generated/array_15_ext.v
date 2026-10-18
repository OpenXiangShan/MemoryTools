// name:array_15_ext depth:128 width:40 masked:true maskGran:4 maskSeg:10
module array_15_ext(
  input RW0_clk,
  input [6:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [9:0] RW0_wmask,
  input [39:0] RW0_wdata,
  output [39:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [6:0] reg_RW0_addr;
  reg [39:0] ram [127:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 128; initvar = initvar+1)
        ram[initvar] = {2 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][3:0] <= RW0_wdata[3:0];
      if (RW0_wmask[1]) ram[RW0_addr][7:4] <= RW0_wdata[7:4];
      if (RW0_wmask[2]) ram[RW0_addr][11:8] <= RW0_wdata[11:8];
      if (RW0_wmask[3]) ram[RW0_addr][15:12] <= RW0_wdata[15:12];
      if (RW0_wmask[4]) ram[RW0_addr][19:16] <= RW0_wdata[19:16];
      if (RW0_wmask[5]) ram[RW0_addr][23:20] <= RW0_wdata[23:20];
      if (RW0_wmask[6]) ram[RW0_addr][27:24] <= RW0_wdata[27:24];
      if (RW0_wmask[7]) ram[RW0_addr][31:28] <= RW0_wdata[31:28];
      if (RW0_wmask[8]) ram[RW0_addr][35:32] <= RW0_wdata[35:32];
      if (RW0_wmask[9]) ram[RW0_addr][39:36] <= RW0_wdata[39:36];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [63:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[39:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule