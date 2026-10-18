// name:array_2_ext depth:256 width:16 masked:true maskGran:1 maskSeg:16
module array_2_ext(
  input RW0_clk,
  input [7:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [15:0] RW0_wmask,
  input [15:0] RW0_wdata,
  output [15:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [7:0] reg_RW0_addr;
  reg [15:0] ram [255:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 256; initvar = initvar+1)
        ram[initvar] = {1 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][0:0] <= RW0_wdata[0:0];
      if (RW0_wmask[1]) ram[RW0_addr][1:1] <= RW0_wdata[1:1];
      if (RW0_wmask[2]) ram[RW0_addr][2:2] <= RW0_wdata[2:2];
      if (RW0_wmask[3]) ram[RW0_addr][3:3] <= RW0_wdata[3:3];
      if (RW0_wmask[4]) ram[RW0_addr][4:4] <= RW0_wdata[4:4];
      if (RW0_wmask[5]) ram[RW0_addr][5:5] <= RW0_wdata[5:5];
      if (RW0_wmask[6]) ram[RW0_addr][6:6] <= RW0_wdata[6:6];
      if (RW0_wmask[7]) ram[RW0_addr][7:7] <= RW0_wdata[7:7];
      if (RW0_wmask[8]) ram[RW0_addr][8:8] <= RW0_wdata[8:8];
      if (RW0_wmask[9]) ram[RW0_addr][9:9] <= RW0_wdata[9:9];
      if (RW0_wmask[10]) ram[RW0_addr][10:10] <= RW0_wdata[10:10];
      if (RW0_wmask[11]) ram[RW0_addr][11:11] <= RW0_wdata[11:11];
      if (RW0_wmask[12]) ram[RW0_addr][12:12] <= RW0_wdata[12:12];
      if (RW0_wmask[13]) ram[RW0_addr][13:13] <= RW0_wdata[13:13];
      if (RW0_wmask[14]) ram[RW0_addr][14:14] <= RW0_wdata[14:14];
      if (RW0_wmask[15]) ram[RW0_addr][15:15] <= RW0_wdata[15:15];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[15:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule