// name:array_7_ext depth:128 width:100 masked:true maskGran:50 maskSeg:2
module array_7_ext(
  input RW0_clk,
  input [6:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [1:0] RW0_wmask,
  input [99:0] RW0_wdata,
  output [99:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [6:0] reg_RW0_addr;
  reg [99:0] ram [127:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 128; initvar = initvar+1)
        ram[initvar] = {4 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][49:0] <= RW0_wdata[49:0];
      if (RW0_wmask[1]) ram[RW0_addr][99:50] <= RW0_wdata[99:50];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [127:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[99:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule