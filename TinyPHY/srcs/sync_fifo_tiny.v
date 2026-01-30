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

module sync_fifo_tiny #(
	    parameter BUF_SIZE=8, BUF_WIDTH=8
	) (

    input                                                    i_clk                      ,
    input                                                    i_rst                      ,
    input                                                    i_w_en                     ,
    input                                                    i_r_en                     ,
    input              [              BUF_WIDTH-1: 0]        i_data                     ,

    output reg         [              BUF_WIDTH-1: 0]        o_data                     ,
    output                                                   o_buf_empty                ,
    output                                                   o_buf_full                 
	
	);

    reg                [                        3: 0]        fifo_cnt                    ;
    reg                [       $clog2(BUF_SIZE)-1: 0]        r_ptr,w_ptr                 ;
    reg                [              BUF_WIDTH-1: 0]        buf_mem[0:BUF_SIZE-1]       ;



    assign             o_buf_empty                  =        (fifo_cnt==4'd0)?1'b1:1'b0;
    assign             o_buf_full                   =        (fifo_cnt==BUF_SIZE)?1'b1:1'b0;


    always@(posedge i_clk or posedge i_rst)
    begin
        if(i_rst)
            fifo_cnt<=4'd0;
        else if((!o_buf_full&&i_w_en)&&(!o_buf_empty&&i_r_en))
            fifo_cnt<=fifo_cnt;
        else if(!o_buf_full&&i_w_en)
            fifo_cnt<=fifo_cnt+1;
        else if(!o_buf_empty&&i_r_en)
            fifo_cnt<=fifo_cnt-1;
        else
            fifo_cnt <= fifo_cnt;
        end

    always@(posedge i_clk or posedge i_rst) 
	begin
        if(i_rst)
            o_data<=8'd0;
        else if(!o_buf_empty&&i_r_en)
            o_data<=buf_mem[r_ptr];
        else
            o_data<='b0;
    end

    always@(posedge i_clk)
    begin
        if(!o_buf_full&&i_w_en)
             buf_mem[w_ptr]<=i_data;
    end

    always@(posedge i_clk or posedge i_rst)
    begin
        if(i_rst) begin
            w_ptr <= 0;
            r_ptr <= 0;
        end
        else begin
            if(!o_buf_full&&i_w_en)
                w_ptr <= w_ptr + 1;
            if(!o_buf_empty&&i_r_en)
                r_ptr <= r_ptr + 1;
        end
    end

endmodule
