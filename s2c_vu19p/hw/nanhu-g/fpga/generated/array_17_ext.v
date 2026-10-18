// name:array_17_ext depth:1024 width:56 masked:true maskGran:7 maskSeg:8
module array_17_ext(
  input RW0_clk,
  input [9:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [55:0] RW0_wdata,
  output [55:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [9:0] reg_RW0_addr;
  reg [55:0] ram [1023:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 1024; initvar = initvar+1)
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
      if (RW0_wmask[0]) ram[RW0_addr][6:0] <= RW0_wdata[6:0];
      if (RW0_wmask[1]) ram[RW0_addr][13:7] <= RW0_wdata[13:7];
      if (RW0_wmask[2]) ram[RW0_addr][20:14] <= RW0_wdata[20:14];
      if (RW0_wmask[3]) ram[RW0_addr][27:21] <= RW0_wdata[27:21];
      if (RW0_wmask[4]) ram[RW0_addr][34:28] <= RW0_wdata[34:28];
      if (RW0_wmask[5]) ram[RW0_addr][41:35] <= RW0_wdata[41:35];
      if (RW0_wmask[6]) ram[RW0_addr][48:42] <= RW0_wdata[48:42];
      if (RW0_wmask[7]) ram[RW0_addr][55:49] <= RW0_wdata[55:49];
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
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[55:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule