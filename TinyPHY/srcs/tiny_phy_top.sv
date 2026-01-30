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

`timescale 1ns/1ps
`include "baiyang_parameters.svh"

module tiny_phy_top #(

    parameter                           RANK_W                      = 2                        ,
    parameter                           DFI_ACT_W                   = 2                        ,
    parameter                           DFI_ADDR_W                  = 36                       ,
    parameter                           DFI_BA_W                    = 4                        ,   // 2-bit BA per pseudo-channel
    parameter                           DFI_BG_W                    = 4                        ,
    parameter                           DFI_CAS_W                   = 2                        ,
    parameter                           DFI_CKE_W                   = 4                        ,
    parameter                           DFI_CS_W                    = 4                        ,
    parameter                           DFI_ODT_W                   = 4                        ,
    parameter                           DFI_RAS_W                   = 2                        ,
    parameter                           DFI_RES_W                   = 4                        ,
    parameter                           DFI_WE_W                    = 2                        ,
    parameter                           DFI_DATA_W                  = 256                      ,
    parameter                           DFI_DATA_M_W                = DFI_DATA_W/8             ,
    parameter                           DFI_DATA_EN_W               = 16                       ,
    parameter                           T_PHY_RDLAT                 = 13                       ,
    parameter                           T_PHY_WRDATA                = 0                        ,

    parameter                           BRAM_DATA_WIDTH             = 512                      ,
    // 17 row + 7 col + 2 bank + 2 bank group = 28 bits
    parameter                           BRAM_ADDR_WIDTH             = COL_WIDTH-3 + ROW_WIDTH + DFI_BA_W/2 + DFI_BG_W/2,

    parameter                           COL_WIDTH                   = 10                       ,
    parameter                           ROW_WIDTH                   = 17                   
    )(
    input                                                           axil_clk                   ,
    input                                                           axil_rstn                  ,
    input                                                           c0_init_calib_complete     ,
        ////////////// DFI command interface //////////////
    input                [              DFI_ACT_W   -1: 0]          dfi_act_n                  ,
    input                [              DFI_ADDR_W  -1: 0]          dfi_address                ,
    input                [              DFI_BA_W    -1: 0]          dfi_ba                     ,
    input                [              DFI_BG_W    -1: 0]          dfi_bg                     ,
    input                [              DFI_CAS_W   -1: 0]          dfi_cas_n                  ,
    input                [              DFI_CKE_W   -1: 0]          dfi_cke                    ,
    input                [              DFI_CS_W    -1: 0]          dfi_cs                     ,
    input                [              DFI_ODT_W   -1: 0]          dfi_odt                    ,
    input                [              DFI_RAS_W   -1: 0]          dfi_ras_n                  ,
    input                [              DFI_RES_W   -1: 0]          dfi_reset_n                ,
    input                [              DFI_WE_W    -1: 0]          dfi_we_n                   ,
    ////////////// DFI read data interface ////////////
    input                                                           dfi_rddata_en              ,
    output               [              DFI_DATA_W  -1 : 0]         dfi_rddata                 ,
    output               [              DFI_DATA_W/16-1: 0]         dfi_rddata_valid           ,

    ////////////// DFI write data interface ///////////
    input                [              DFI_DATA_W -1 : 0]          dfi_wrdata_i               ,
    input                [              DFI_DATA_EN_W-1: 0]         dfi_wrdata_en_i            ,
    input                [              DFI_DATA_M_W-1: 0]          dfi_wrdata_mask_i           
);


//------------------------------------------------------------------------------------------------------------
// bram_wrdata_addr_o / bram_rddata_addr_o generate in the module dfi2bram, record the map as follows:
//-------------------------------------------------------------
// | BG (2 bits) | BA (2 bits) | ROW (17 bits) | COL (7 bits) |
//-------------------------------------------------------------
// since the real BRAM is smaller, chose partial bits to test
// for example, as BRAM IP depth = 4096, bram_wdata_addr/ bram_rdata_addr only fits 12 bits, so the map is:
//-------------------------------------------------------------
// | BG (2 bits) | BA (2 bits) | ROW (2 bits) | COL (6 bits) |
//-------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------


    wire                 [              BRAM_DATA_WIDTH-1: 0]       bram_wrdata_o              ;
    wire                                                            bram_wrdata_en_o           ;
    wire                 [              BRAM_ADDR_WIDTH-1: 0]       bram_wrdata_addr_o         ;
    wire                 [              BRAM_DATA_WIDTH-1: 0]       bram_rddata_i              ;
    wire                                                            bram_rddata_en_o           ;
    wire                 [              BRAM_ADDR_WIDTH-1: 0]       bram_rddata_addr_o         ;



    wire [11:0] bram_wdata_addr =  {bram_wrdata_addr_o[BRAM_ADDR_WIDTH -1:BRAM_ADDR_WIDTH -(DFI_BA_W/2 + DFI_BG_W/2)], bram_wrdata_addr_o[8:7], bram_wrdata_addr_o[5:0]};
    wire [11:0] bram_rdata_addr =  {bram_rddata_addr_o[BRAM_ADDR_WIDTH -1:BRAM_ADDR_WIDTH -(DFI_BA_W/2 + DFI_BG_W/2)], bram_rddata_addr_o[8:7], bram_rddata_addr_o[5:0]};


dfi2bram#(
    .RANK_W                                          (RANK_W                         ),
    .DFI_ACT_W                                       (DFI_ACT_W                      ),
    .DFI_ADDR_W                                      (DFI_ADDR_W                     ),
    .DFI_BA_W                                        (DFI_BA_W                       ),
    .DFI_BG_W                                        (DFI_BG_W                       ),
    .DFI_CAS_W                                       (DFI_CAS_W                      ),
    .DFI_CKE_W                                       (DFI_CKE_W                      ),
    .DFI_CS_W                                        (DFI_CS_W                       ),
    .DFI_ODT_W                                       (DFI_ODT_W                      ),
    .DFI_RAS_W                                       (DFI_RAS_W                      ),
    .DFI_RES_W                                       (DFI_RES_W                      ),
    .DFI_WE_W                                        (DFI_WE_W                       ),
    .DFI_DATA_W                                      (DFI_DATA_W                     ),
    .DFI_DATA_M_W                                    (DFI_DATA_M_W                   ),
    .DFI_DATA_EN_W                                   (DFI_DATA_EN_W                  ),
    .T_PHY_RDLAT                                     (T_PHY_RDLAT                    ),
    .T_PHY_WRDATA                                    (T_PHY_WRDATA                   ),
    .BRAM_DATA_WIDTH                                 (BRAM_DATA_WIDTH                ),
    .BRAM_ADDR_WIDTH                                 (BRAM_ADDR_WIDTH                ),
    .COL_WIDTH                                       (COL_WIDTH                      ),
    .ROW_WIDTH                                       (ROW_WIDTH                      ) 
)

u_dfi2bram(
// 17 row + 7 col + 2 bank + 1 bank group = 27 bits
    .dfi_clk                                         (axil_clk                       ),// DFI clock
    .rst_n                                           (axil_rstn                      ),// Async reset, active low
    .calDone                                         (c0_init_calib_complete         ),// PHY calibration done
////////////// DFI command interface //////////////
    .dfi_act_n                                       (dfi_act_n                      ),
    .dfi_address                                     (dfi_address                    ),
    .dfi_ba                                          (dfi_ba                         ),
    .dfi_bg                                          (dfi_bg                         ),
    .dfi_cas_n                                       (dfi_cas_n                      ),
    .dfi_cke                                         (dfi_cke                        ),
    .dfi_cs                                          (dfi_cs                         ),
    .dfi_odt                                         (dfi_odt                        ),
    .dfi_ras_n                                       (dfi_ras_n                      ),
    .dfi_reset_n                                     (dfi_reset_n                    ),
    .dfi_we_n                                        (dfi_we_n                       ),
////////////// DFI read data interface ////////////
    .dfi_rddata_en                                   (dfi_rddata_en                  ),
    .dfi_rddata                                      (dfi_rddata                     ),
    .dfi_rddata_valid                                (dfi_rddata_valid               ),
////////////// DFI write data interface ///////////
    .dfi_wrdata_i                                    (dfi_wrdata_i                   ),
    .dfi_wrdata_en_i                                 (dfi_wrdata_en_i                ),
    .dfi_wrdata_mask_i                               (dfi_wrdata_mask_i              ),
////////////// BRAM write interface ///////////////
    .bram_wrdata_o                                   (bram_wrdata_o                  ),
    .bram_wrdata_en_o                                (bram_wrdata_en_o               ),
    .bram_wrdata_addr_o                              (bram_wrdata_addr_o             ),
////////////// BRAM read interface ////////////////
    .bram_rddata_i                                   (bram_rddata_i                  ),
    .bram_rddata_en_o                                (bram_rddata_en_o               ),
    .bram_rddata_addr_o                              (bram_rddata_addr_o             ) 
);


blk_mem_gen_1 ddr_blk (
    .clka                                            (axil_clk                       ),// input wire clka
    .ena                                             (bram_wrdata_en_o               ),// input wire ena
    .wea                                             (bram_wrdata_en_o               ),// input wire [0 : 0] wea
    .addra                                           (bram_wdata_addr                ),//bg[1:0] + bank[2:0] + row [7:0] +col   [14 : 0] addra
    .dina                                            (bram_wrdata_o                  ),// input wire [511 : 0] dina
    .clkb                                            (axil_clk                       ),// input wire clkb
    .enb                                             (bram_rddata_en_o               ),// input wire enb
    .addrb                                           (bram_rdata_addr                ),//bg[1:0] + bank[2:0] + row [7:0] +col   [14 : 0] addra
    .doutb                                           (bram_rddata_i                  ) // output wire [511 : 0] doutb
);


endmodule
