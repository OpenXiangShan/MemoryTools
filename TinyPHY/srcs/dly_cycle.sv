/***************************************************************************************
* Copyright (c) 2021-2026 Beijing Institute of Open Source Chip (BOSC)
* Copyright (c) 2020-2026 Institute of Computing Technology, Chinese Academy of Sciences (ICT，CAS)
* 
* YuQuan is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*   
* See the Mulan PSL v2 for more details.
***************************************************************************************/


module dly_cycle #(
    parameter N = 8 // delay cycle
  )
  (
    input   clk,
    input   rst_n,
    input   in_data,
    output  out_data
  );
  
  reg [N+1:0] delay_reg;

  reg out_data_reg;

  assign out_data = (N==0) ? in_data : out_data_reg;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      delay_reg <= 0;
    end else begin
      delay_reg <= {delay_reg[N:0], in_data};
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out_data_reg <= 0;
    end else if (N >= 2)
      out_data_reg <= delay_reg[N-2];
    else
      out_data_reg <= in_data;
  end

endmodule
