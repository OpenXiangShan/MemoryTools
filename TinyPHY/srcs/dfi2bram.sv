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

    `timescale 1ns / 1ps


    module dfi2bram #(

    parameter                           RANK_W                      = 2                    ,
    parameter                           DFI_ACT_W                   = 2                    ,
    parameter                           DFI_ADDR_W                  = 36                   ,
    parameter                           DFI_BA_W                    = 4                    ,   // 2 bit BA per pseudo-channel
    parameter                           DFI_BG_W                    = 4                    ,
    parameter                           DFI_CAS_W                   = 2                    ,
    parameter                           DFI_CKE_W                   = 4                    ,
    parameter                           DFI_CS_W                    = 4                    ,
    parameter                           DFI_ODT_W                   = 4                    ,
    parameter                           DFI_RAS_W                   = 2                    ,
    parameter                           DFI_RES_W                   = 4                    ,
    parameter                           DFI_WE_W                    = 2                    ,
    parameter                           DFI_DATA_W                  = 256                  ,
    parameter                           DFI_DATA_M_W                = DFI_DATA_W/8         ,
    parameter                           DFI_DATA_EN_W               = 16                   ,
    parameter                           T_PHY_RDLAT                 = 13                   ,
    parameter                           T_PHY_WRDATA                = 0                    ,

    parameter                           BRAM_DATA_WIDTH             = 512                  ,
    // 17 row + 7 col + 2 bank + 2 bank group = 28 bits
    parameter                           BRAM_ADDR_WIDTH             = COL_WIDTH-3 + ROW_WIDTH + DFI_BA_W/2 + DFI_BG_W/2,

    parameter                           COL_WIDTH                   = 10                   ,
    parameter                           ROW_WIDTH                   = 17                   
    )(
    input                                                                dfi_clk  ,// DFI clock
    input                                                                rst_n    ,// Async reset, active low
    input                                                                calDone  ,// PHY calibration done

    ////////////// DFI command interface //////////////
    (* mark_debug="true" *)    input        [DFI_ACT_W   -1:0]           dfi_act_n,
    (* mark_debug="true" *)    input        [DFI_ADDR_W  -1:0]           dfi_address,
    (* mark_debug="true" *)    input        [DFI_BA_W    -1:0]           dfi_ba,
    (* mark_debug="true" *)    input        [DFI_BG_W    -1:0]           dfi_bg,
    (* mark_debug="true" *)    input        [DFI_CAS_W   -1:0]           dfi_cas_n,
    (* mark_debug="true" *)    input        [DFI_CKE_W   -1:0]           dfi_cke,
    (* mark_debug="true" *)    input        [DFI_CS_W    -1:0]           dfi_cs,
    (* mark_debug="true" *)    input        [DFI_ODT_W   -1:0]           dfi_odt,
    (* mark_debug="true" *)    input        [DFI_RAS_W   -1:0]           dfi_ras_n,
    (* mark_debug="true" *)    input        [DFI_RES_W   -1:0]           dfi_reset_n,
    (* mark_debug="true" *)    input        [DFI_WE_W    -1:0]           dfi_we_n,

    ////////////// DFI read data interface ////////////
    (* mark_debug="true" *)    input                                     dfi_rddata_en,
    (* mark_debug="true" *)    output       [DFI_DATA_W  -1:0]           dfi_rddata,
    (* mark_debug="true" *)    output       [DFI_DATA_W/16-1:0]          dfi_rddata_valid,

    ////////////// DFI write data interface ///////////
    (* mark_debug="true" *)    input        [DFI_DATA_W  -1:0]           dfi_wrdata_i,
    (* mark_debug="true" *)    input        [DFI_DATA_EN_W-1:0]          dfi_wrdata_en_i,
    (* mark_debug="true" *)    input        [DFI_DATA_M_W-1:0]           dfi_wrdata_mask_i,

    ////////////// BRAM write interface ///////////////
    (* mark_debug="true" *)    output       [BRAM_DATA_WIDTH-1:0]        bram_wrdata_o,
    (* mark_debug="true" *)    output                                    bram_wrdata_en_o,
    (* mark_debug="true" *)    output       [BRAM_ADDR_WIDTH-1:0]        bram_wrdata_addr_o,

    ////////////// BRAM read interface ////////////////
    (* mark_debug="true" *)    input        [BRAM_DATA_WIDTH-1:0]        bram_rddata_i,
    (* mark_debug="true" *)    output                                    bram_rddata_en_o,
    (* mark_debug="true" *)    output       [BRAM_ADDR_WIDTH-1:0]        bram_rddata_addr_o
    );

    //--------------------------------------------------------------------------
    // Internal signals
    //--------------------------------------------------------------------------
    localparam                 BANK_NUM                       = (1 << (DFI_BG_W/2)) * (1 << (DFI_BA_W/2));


    // ACT & PRE detection
    wire               [                        1: 0]        act_en                      ;
    wire               [                        1: 0]        pre_en                      ;

    // Encoded command (RAS, CAS, WE) for each pseudo-channel
    wire               [                        2: 0]        dfi_cmd_p0                  ;
    wire               [                        2: 0]        dfi_cmd_p1                  ;

    // Write command enables
    wire                                                     write_en_0                  ;
    wire                                                     write_en_1                  ;
    wire                                                     w_dfi_wrdata_en             ;

    // Read command enables
    wire                                                     read_en_0                   ;
    wire                                                     read_en_1                   ;

    // Per-bank active row storage (open-row tracking)
    reg                [              ROW_WIDTH-1: 0]        act_bank_row_mem[BANK_NUM-1:0]  ;

    // Write address/data pipeline
    reg                [        BRAM_ADDR_WIDTH-1: 0]        r_bram_wrdata_addr          ;
    reg                [        BRAM_DATA_WIDTH-1: 0]        r_bram_wrdata_o             ;
    reg                                                      r_bram_wrdata_en_o          ;

    // Read address pipeline
    reg                [        BRAM_ADDR_WIDTH-1: 0]        r_bram_rddata_addr          ;

    // Read data timing control
    reg                                                      r_bram_rddata_en_o          ;
    reg                [        BRAM_ADDR_WIDTH-1: 0]        r_bram_rddata_addr_o        ;
    reg                [        BRAM_DATA_WIDTH-1: 0]        r_bram_rddata_i             ;

    // Delayed write command flags
    reg                                                      write_en_0_d1               ;
    reg                                                      write_en_1_d1               ;
    reg                                                      write_en_flag               ;

    // Read data enable delay chain
    wire                                                     dfi_rddata_en_d             ;
    reg                                                      dfi_rddata_en_d1            ;
    reg                                                      dfi_rddata_en_d2            ;
    reg                                                      dfi_rddata_en_d3            ;

    // Read data toggle and data register
    reg                                                      dfi_rddata_flag             ;
    reg                [             DFI_DATA_W-1: 0]        r_dfi_rddata                ;

    // Toggle for read-data and read-address FIFO control
    reg                                                      dfi_rddata_en_flag          ;

    // Delayed read command flags
    reg                                                      read_en_0_d1                ;
    reg                                                      read_en_1_d1                ;

    //--------------------------------------------------------------------------
    // Command encoding (per pseudo-channel)
    //--------------------------------------------------------------------------

    assign                     dfi_cmd_p0                     = {dfi_ras_n[0], dfi_cas_n[0], dfi_we_n[0]};
    assign                     dfi_cmd_p1                     = {dfi_ras_n[1], dfi_cas_n[1], dfi_we_n[1]};

    // ACT command detect (low ACT_N, CS active, CKE high)
    assign act_en[0] = calDone &&
    (dfi_cke == {DFI_CKE_W{1'b1}}) &&
    (dfi_act_n[0] == 1'b0) &&
    (dfi_cs[1:0] == 2'b10);

    assign act_en[1] = calDone &&
    (dfi_cke == {DFI_CKE_W{1'b1}}) &&
    (dfi_act_n[1] == 1'b0) &&
    (dfi_cs[3:2] == 2'b10);

    // PRE command detect (PRECHARGE: RAS low, CAS high, WE low)
    assign pre_en[0] = calDone &&
    (dfi_cke == {DFI_CKE_W{1'b1}}) &&
    (dfi_cmd_p0 == 3'b010) &&
    (dfi_cs[1:0] == 2'b10);

    assign pre_en[1] = calDone &&
    (dfi_cke == {DFI_CKE_W{1'b1}}) &&
    (dfi_cmd_p1 == 3'b010) &&
    (dfi_cs[3:2] == 2'b10);

    //--------------------------------------------------------------------------
    // Open row tracking per bank (ACT/PRE handling)
    //--------------------------------------------------------------------------

    integer                                                  i                           ;
    always @(posedge dfi_clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all open-row entries on reset
            for (i = 0; i < BANK_NUM; i = i + 1) begin
            act_bank_row_mem[i] <= {ROW_WIDTH{1'b0}};
        end
    end
    else if (|act_en) begin
        // Store row address on ACT command
    if (act_en[0] && act_en[1]) begin
        // Channel 0
        act_bank_row_mem[{dfi_bg[DFI_BG_W/2 - 1 :0], dfi_ba[DFI_BA_W /2 - 1 :0]}]
        <= dfi_address[ROW_WIDTH-1:0];
        // Channel 1
        act_bank_row_mem[{dfi_bg[DFI_BG_W - 1: DFI_BG_W/2], dfi_ba[DFI_BA_W - 1:DFI_BA_W /2]}]
        <= dfi_address[DFI_ADDR_W/2 + ROW_WIDTH -1 : DFI_ADDR_W/2];
    end
    else if (act_en[0]) begin
        act_bank_row_mem[{dfi_bg[DFI_BG_W/2 - 1 :0], dfi_ba[DFI_BA_W /2 - 1 :0]}]
        <= dfi_address[ROW_WIDTH-1:0];
    end
    else if (act_en[1]) begin
        act_bank_row_mem[{dfi_bg[DFI_BG_W - 1: DFI_BG_W/2], dfi_ba[DFI_BA_W - 1:DFI_BA_W /2]}]
        <= dfi_address[DFI_ADDR_W/2 + ROW_WIDTH -1 : DFI_ADDR_W/2];
    end
    end
    else if (|pre_en) begin
        // Clear row entry on PRE command
    if (pre_en[0] && pre_en[1]) begin
        act_bank_row_mem[{dfi_bg[DFI_BG_W/2 - 1 :0], dfi_ba[DFI_BA_W /2 - 1 :0]}] <= {ROW_WIDTH{1'b0}};
        act_bank_row_mem[{dfi_bg[DFI_BG_W - 1: DFI_BG_W/2], dfi_ba[DFI_BA_W - 1:DFI_BA_W /2]}] <= {ROW_WIDTH{1'b0}};
    end
    else if (pre_en[0]) begin
        act_bank_row_mem[{dfi_bg[DFI_BG_W/2 - 1 :0], dfi_ba[DFI_BA_W /2 - 1 :0]}] <= {ROW_WIDTH{1'b0}};
    end
    else if (pre_en[1]) begin
        act_bank_row_mem[{dfi_bg[DFI_BG_W - 1: DFI_BG_W/2], dfi_ba[DFI_BA_W - 1:DFI_BA_W /2]}] <= {ROW_WIDTH{1'b0}};
    end
    end
    end

    //--------------------------------------------------------------------------
    // Write command detect
    //--------------------------------------------------------------------------

    assign                      bram_wrdata_o                 = r_bram_wrdata_o      ;
    assign                      bram_wrdata_en_o              = r_bram_wrdata_en_o   ;

    // Write command (WR: RAS high, CAS low, WE low) - example pattern 3'b100
    assign write_en_0 = calDone &&
    (dfi_cke == {DFI_CKE_W{1'b1}}) &&
    (dfi_cmd_p0 == 3'b100) &&
    (dfi_cs[1:0] == 2'b10);

    assign write_en_1 = calDone &&
    (dfi_cke == {DFI_CKE_W{1'b1}}) &&
    (dfi_cmd_p1 == 3'b100) &&
    (dfi_cs[3:2] == 2'b10);

    //--------------------------------------------------------------------------
    // Write address build (bank-group + bank + row + column)
    //--------------------------------------------------------------------------

    always @(posedge dfi_clk or negedge rst_n) begin
        if (!rst_n) begin
            r_bram_wrdata_addr <= {BRAM_ADDR_WIDTH{1'b0}};
        end
        else if (write_en_0) begin
            // Channel 0 write address
            r_bram_wrdata_addr <= {
            dfi_bg[DFI_BG_W/2 - 1 :0],                              // bank group
            dfi_ba[DFI_BA_W /2 - 1 :0],                             // bank
            act_bank_row_mem[{dfi_bg[DFI_BG_W/2 - 1 :0], dfi_ba[DFI_BA_W /2 - 1 :0]}],// row
            dfi_address[COL_WIDTH-1:3]                              // column (word aligned)
            };
        end
        else if (write_en_1) begin
            // Channel 1 write address
            r_bram_wrdata_addr <= {
            dfi_bg[DFI_BG_W - 1: DFI_BG_W/2],
            dfi_ba[DFI_BA_W - 1:DFI_BA_W /2],
            act_bank_row_mem[{dfi_bg[DFI_BG_W - 1: DFI_BG_W/2], dfi_ba[DFI_BA_W - 1:DFI_BA_W /2]}],
            dfi_address[DFI_ADDR_W/2 + COL_WIDTH - 1 : DFI_ADDR_W/2 + 3]
            };
        end
    end

    // Delay write_en by one cycle for FIFO write-enable
    always @(posedge dfi_clk or negedge rst_n) begin
        if (!rst_n) begin
            write_en_0_d1 <= 1'b0;
            write_en_1_d1 <= 1'b0;
        end
        else begin
            write_en_0_d1 <= write_en_0;
            write_en_1_d1 <= write_en_1;
        end
    end

    //--------------------------------------------------------------------------
    // FIFO for write addresses (align with write data)
    //--------------------------------------------------------------------------

    sync_fifo_tiny #(
    .BUF_SIZE                           (4                         ),
    .BUF_WIDTH                          (BRAM_ADDR_WIDTH           ) 
    ) write_addr_fifo_p0 (
    .i_clk                              (dfi_clk                   ),
    .i_rst                              (~rst_n                    ),
    .i_w_en                             (write_en_0_d1 | write_en_1_d1),// push address on write cmd
    .i_data                             (r_bram_wrdata_addr        ),
    .i_r_en                             (w_dfi_wrdata_en && write_en_flag),
    .o_data                             (bram_wrdata_addr_o        ),
    .o_buf_full                         (                          ),
    .o_buf_empty                        (                          ) 
    );

    //--------------------------------------------------------------------------
    // Delay DFI write-data enable to align with BRAM write address
    //--------------------------------------------------------------------------

    dly_cycle #(
    .N                                  (T_PHY_WRDATA              ) 
    ) u_dly_write (
    .clk                                (dfi_clk                   ),
    .rst_n                              (rst_n                     ),
    // Only valid when all write strobes active
    .in_data                            (dfi_wrdata_en_i == {DFI_DATA_EN_W{1'b1}}),
    .out_data                           (w_dfi_wrdata_en           ) 
    );

    // Toggle flag used to pop from FIFO every other data beat
    always @(posedge dfi_clk or negedge rst_n) begin
        if (!rst_n) begin
            write_en_flag <= 1'b0;
        end
        else if (w_dfi_wrdata_en) begin
            write_en_flag <= ~write_en_flag;
        end
        else begin
            write_en_flag <= 1'b0;
        end
    end

    // Generate BRAM write-enable (one cycle pulse)
    always @(posedge dfi_clk or negedge rst_n) begin
        if (!rst_n) begin
            r_bram_wrdata_en_o <= 1'b0;
        end
        else if (w_dfi_wrdata_en && write_en_flag) begin
            r_bram_wrdata_en_o <= 1'b1;
        end
        else begin
            r_bram_wrdata_en_o <= 1'b0;
        end
    end

    // 512-bit BRAM write data built from two 256-bit DFI beats
    always @(posedge dfi_clk or negedge rst_n) begin
        if (!rst_n) begin
            r_bram_wrdata_o <= {BRAM_DATA_WIDTH{1'b0}};
        end
        else if (w_dfi_wrdata_en) begin
            // Shift in new 256-bit data
            r_bram_wrdata_o <= {r_bram_wrdata_o[255:0], dfi_wrdata_i};
        end
    end

    //--------------------------------------------------------------------------
    // Read command detect
    //--------------------------------------------------------------------------

    // Read command (RD: RAS high, CAS low, WE high) - example pattern 3'b101
    assign read_en_0 = calDone &&
    (dfi_cke == {DFI_CKE_W{1'b1}}) &&
    (dfi_cmd_p0 == 3'b101) &&
    (dfi_cs[1:0] == 2'b10);

    assign read_en_1 = calDone &&
    (dfi_cke == {DFI_CKE_W{1'b1}}) &&
    (dfi_cmd_p1 == 3'b101) &&
    (dfi_cs[3:2] == 2'b10);

    //--------------------------------------------------------------------------
    // Read address build (bank-group + bank + row + column)
    //--------------------------------------------------------------------------

    always @(posedge dfi_clk or negedge rst_n) begin
        if (!rst_n) begin
            r_bram_rddata_addr <= {BRAM_ADDR_WIDTH{1'b0}};
        end
        else if (read_en_0) begin
            // Channel 0 read address
            r_bram_rddata_addr <= {
            dfi_bg[DFI_BG_W/2 - 1 :0],
            dfi_ba[DFI_BA_W /2 - 1 :0],
            act_bank_row_mem[{dfi_bg[DFI_BG_W/2 - 1 :0], dfi_ba[DFI_BA_W /2 - 1 :0]}],
            dfi_address[COL_WIDTH-1:3]
            };
        end
        else if (read_en_1) begin
            // Channel 1 read address
            r_bram_rddata_addr <= {
            dfi_bg[DFI_BG_W - 1: DFI_BG_W/2],
            dfi_ba[DFI_BA_W - 1:DFI_BA_W /2],
            act_bank_row_mem[{dfi_bg[DFI_BG_W - 1: DFI_BG_W/2], dfi_ba[DFI_BA_W - 1:DFI_BA_W /2]}],
            dfi_address[DFI_ADDR_W/2 + COL_WIDTH -1 : DFI_ADDR_W/2 + 3]
            };
        end
    end

    // Delay read_en by one cycle for FIFO write-enable
    always @(posedge dfi_clk or negedge rst_n) begin
        if (!rst_n) begin
            read_en_0_d1 <= 1'b0;
            read_en_1_d1 <= 1'b0;
        end
        else begin
            read_en_0_d1 <= read_en_0;
            read_en_1_d1 <= read_en_1;
        end
    end

    //--------------------------------------------------------------------------
    // FIFO for read addresses (align with read-data return)
    //--------------------------------------------------------------------------

    sync_fifo_tiny #(
    .BUF_SIZE                           (32                        ),
    .BUF_WIDTH                          (BRAM_ADDR_WIDTH           ) 
    ) read_addr_fifo (
    .i_clk                              (dfi_clk                   ),
    .i_rst                              (~rst_n                    ),
    .i_w_en                             (read_en_0_d1 | read_en_1_d1),
    .i_data                             (r_bram_rddata_addr        ),
    // Pop address every first beat of a read burst
    .i_r_en                             (dfi_rddata_en_d & ~dfi_rddata_en_flag),
    .o_data                             (bram_rddata_addr_o        ),
    .o_buf_full                         (                          ),
    .o_buf_empty                        (                          ) 
    );

    //--------------------------------------------------------------------------
    // Read data enable & BRAM read enable
    //--------------------------------------------------------------------------
    
    // BRAM read enable: second stage of delayed read enable and toggle flag
    assign                              bram_rddata_en_o            = dfi_rddata_en_d1 & dfi_rddata_en_flag;

    // DFI read-data valid: 2-cycle delayed plus one more stage
    assign                              dfi_rddata_valid            = {{(DFI_DATA_W/16){dfi_rddata_en_d3}}};

    // 3-stage pipeline for dfi_rddata_en_d
    always @(posedge dfi_clk or negedge rst_n) begin
        if (!rst_n) begin
            dfi_rddata_en_d1 <= 1'b0;
            dfi_rddata_en_d2 <= 1'b0;
            dfi_rddata_en_d3 <= 1'b0;
        end
        else begin
            dfi_rddata_en_d1 <= dfi_rddata_en_d;
            dfi_rddata_en_d2 <= dfi_rddata_en_d1;
            dfi_rddata_en_d3 <= dfi_rddata_en_d2;
        end
    end

    // Delay read-enable from DFI to BRAM in accordance with PHY read latency
    dly_cycle #(
    .N                                  (T_PHY_RDLAT - 3           ) 
    ) u_dly_read_en (
    .clk                                (dfi_clk                   ),
    .rst_n                              (rst_n                     ),
    .in_data                            (dfi_rddata_en             ),
    .out_data                           (dfi_rddata_en_d           ) 
    );

    // Toggle flag for read-data beat alignment
    always @(posedge dfi_clk or negedge rst_n) begin
        if (!rst_n) begin
            dfi_rddata_en_flag <= 1'b0;
        end
        else if (dfi_rddata_en_d) begin
            dfi_rddata_en_flag <= ~dfi_rddata_en_flag;
        end
    end

    //--------------------------------------------------------------------------
    // Read data return path (BRAM -> DFI)
    //--------------------------------------------------------------------------

    assign                              dfi_rddata                  = r_dfi_rddata         ;

    // Toggle which half of BRAM data goes to DFI interface
    always @(posedge dfi_clk or negedge rst_n) begin
        if (!rst_n) begin
            dfi_rddata_flag <= 1'b0;
        end
        else if (dfi_rddata_en_d1) begin
            dfi_rddata_flag <= ~dfi_rddata_flag;
        end
    end

    // Select upper or lower 256 bits from 512-bit BRAM data
    always @(posedge dfi_clk or negedge rst_n) begin
        if (!rst_n) begin
            r_dfi_rddata <= {DFI_DATA_W{1'b0}};
        end
        else if (dfi_rddata_flag) begin
            r_dfi_rddata <= bram_rddata_i[255:0];
        end
        else begin
            r_dfi_rddata <= bram_rddata_i[511:256];
        end
    end


    // synthesis translate_off
    `ifdef ASSERT_ON

    // 同拍双通道 WR 命令：禁止（否则地址/数据对不齐）
    assert_no_dual_wr: assert property (@(posedge dfi_clk) disable iff(!rst_n || !calDone)
    !(write_en_0 && write_en_1)
    ) else $fatal(1, "[dfi2bram] Dual-channel WRITE cmd in same cycle is not supported.");

    // 同拍双通道 RD 命令：禁止
    assert_no_dual_rd: assert property (@(posedge dfi_clk) disable iff(!rst_n || !calDone)
    !(read_en_0 && read_en_1)
    ) else $fatal(1, "[dfi2bram] Dual-channel READ cmd in same cycle is not supported.");

    `endif
    // synthesis translate_on



    endmodule
