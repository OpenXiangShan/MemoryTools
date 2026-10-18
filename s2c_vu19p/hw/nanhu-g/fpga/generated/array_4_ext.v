// name:array_4_ext depth:2048 width:4 masked:true maskGran:2 maskSeg:2
module array_4_ext(
  input R0_clk,
  input [10:0] R0_addr,
  input R0_en,
  output [3:0] R0_data,
  input W0_clk,
  input [10:0] W0_addr,
  input W0_en,
  input [3:0] W0_data,
  input [1:0] W0_mask
);


  reg reg_R0_ren;
  reg [10:0] reg_R0_addr;
  reg [3:0] ram [2047:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 2048; initvar = initvar+1)
        ram[initvar] = {1 {$random}};
      reg_R0_addr = {1 {$random}};
    end
  `endif
  always @(posedge R0_clk)
    reg_R0_ren <= R0_en;
  always @(posedge R0_clk)
    if (R0_en) reg_R0_addr <= R0_addr;
  always @(posedge W0_clk)
    if (W0_en) begin
      if (W0_mask[0]) ram[W0_addr][1:0] <= W0_data[1:0];
      if (W0_mask[1]) ram[W0_addr][3:2] <= W0_data[3:2];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] R0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      R0_random = {$random};
      reg_R0_ren = R0_random[0];
    end
  `endif
  always @(posedge R0_clk) R0_random <= {$random};
  assign R0_data = reg_R0_ren ? ram[reg_R0_addr] : R0_random[3:0];
  `else
  assign R0_data = ram[reg_R0_addr];
  `endif

endmodule