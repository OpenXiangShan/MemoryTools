//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
//Date        : Sat Apr  4 07:22:08 2026
//Host        : asg-MS-7E07 running 64-bit Ubuntu 22.04.5 LTS
//Command     : generate_target xiangshan_wrapper.bd
//Design      : xiangshan_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module xiangshan_wrapper(
    c0_ddr4_act_n   ,
    c0_ddr4_adr     ,
    c0_ddr4_ba      ,
    c0_ddr4_bg      ,
    c0_ddr4_ck_c    ,
    c0_ddr4_ck_t    ,
    c0_ddr4_cke     ,
    c0_ddr4_cs_n    , 
    c0_ddr4_dm_n      ,
    c0_ddr4_dq      ,
    c0_ddr4_dqs_c   ,
    c0_ddr4_dqs_t   ,
    c0_ddr4_odt     ,
    c0_ddr4_reset_n ,
    c0_sys_clk_p,
    c0_sys_clk_n,
//    main_clk_p,
//    main_clk_n,
//    diff_clock_rtl_0_clk_p,
//    diff_clock_rtl_0_clk_n,
    reset_n,
    uart0_sin ,
    uart0_sout,
    pcie_ep_gt_ref_clk_clk_n,
    pcie_ep_gt_ref_clk_clk_p,
    pcie_ep_perstn,
    pcie_ep_rxn,
    pcie_ep_rxp,
    pcie_ep_txn,
    pcie_ep_txp
);

    output c0_ddr4_act_n;
    output [16:0]c0_ddr4_adr;
    output [1:0]c0_ddr4_ba;
    output [1:0]c0_ddr4_bg;
    output [1:0]c0_ddr4_ck_c;
    output [1:0]c0_ddr4_ck_t;
    output [1:0]c0_ddr4_cke;
    output [1:0]c0_ddr4_cs_n;
    inout [7:0] c0_ddr4_dm_n;
    inout [63:0]c0_ddr4_dq;
    inout [7:0]c0_ddr4_dqs_c;
    inout [7:0]c0_ddr4_dqs_t;
    output[1:0]c0_ddr4_odt;
  //  output c0_ddr4_par;
    output c0_ddr4_reset_n;
 //   output ddr4_mig_calib_done;
    input c0_sys_clk_p;
    input c0_sys_clk_n;
//    input main_clk_p;
//    input main_clk_n;
//    input diff_clock_rtl_0_clk_p;
//    input diff_clock_rtl_0_clk_n;
    input reset_n;
    input uart0_sin ;
    output uart0_sout;
    
    input [0:0]pcie_ep_gt_ref_clk_clk_n;
    input [0:0]pcie_ep_gt_ref_clk_clk_p;
//    output pcie_ep_lnk_up;
    input pcie_ep_perstn;
 //   output [0:0]pcie_ep_phy_ready;
    input   [7:0]pcie_ep_rxn;
    input   [7:0]pcie_ep_rxp;
    output [7:0]pcie_ep_txn;
    output [7:0]pcie_ep_txp;



  wire [35:0] m_ddr_mem_araddr;
  wire [1:0]  m_ddr_mem_arburst;
  wire [3:0]  m_ddr_mem_arcache;
  wire [15:0] m_ddr_mem_arid;
  wire [7:0]  m_ddr_mem_arlen;
  wire [0:0]  m_ddr_mem_arlock;
  wire [2:0]  m_ddr_mem_arprot;
  wire [3:0]  m_ddr_mem_arqos;
  wire        m_ddr_mem_arready;
  wire [3:0]  m_ddr_mem_arregion;
  wire [2:0]  m_ddr_mem_arsize;
  wire        m_ddr_mem_arvalid;
  wire [35:0] m_ddr_mem_awaddr;
  wire [1:0]  m_ddr_mem_awburst;
  wire [3:0]  m_ddr_mem_awcache;
  wire [15:0] m_ddr_mem_awid;
  wire [7:0]  m_ddr_mem_awlen;
  wire [0:0]  m_ddr_mem_awlock;
  wire [2:0]  m_ddr_mem_awprot;
  wire [3:0]  m_ddr_mem_awqos;
  wire        m_ddr_mem_awready;
  wire [3:0]  m_ddr_mem_awregion;
  wire [2:0]  m_ddr_mem_awsize;
  wire        m_ddr_mem_awvalid;
  wire [15:0] m_ddr_mem_bid;
  wire        m_ddr_mem_bready;
  wire [1:0]  m_ddr_mem_bresp;
  wire        m_ddr_mem_bvalid;
  wire [255:0]m_ddr_mem_rdata;
  wire [15:0] m_ddr_mem_rid;
  wire        m_ddr_mem_rlast;
  wire        m_ddr_mem_rready;
  wire [1:0]  m_ddr_mem_rresp;
  wire        m_ddr_mem_rvalid;
  wire [255:0]m_ddr_mem_wdata;
  wire        m_ddr_mem_wlast;
  wire        m_ddr_mem_wready;
  wire [31:0] m_ddr_mem_wstrb;
  wire        m_ddr_mem_wvalid;
  
  wire      c0_init_calib_complete;
//  wire [0:0]pcie_ep_gt_ref_clk_clk_n;
//  wire [0:0]pcie_ep_gt_ref_clk_clk_p;
  //wire pcie_ep_lnk_up;
  //wire pcie_ep_perstn;
//  wire [0:0]pcie_ep_phy_ready;
//  wire [15:0]pcie_ep_rxn;
//  wire [15:0]pcie_ep_rxp;
//  wire [15:0]pcie_ep_txn;
//  wire [15:0]pcie_ep_txp;

  wire      uart0_sin ;
  wire      uart0_sout;  

  wire      addn_ui_clk_30m;
  wire      c0_ddr4_ui_clk ;
  wire      rtc_clock_20m  ;
  wire      axil_clk;
  
//  wire      mc_clock_40m;
//  wire      mc_clock_10m;
  wire      mc_clock_32m;
  wire      mc_clock_8m;
  
  
  
  
  
xiangshan xiangshan_i
       (//.c0_ddr4_ui_clk(c0_ddr4_ui_clk),
        //.clk_50m(clk_50m),
        //.addn_ui_clk_30m()         ,
        //.c0_ddr4_ui_clk (c0_ddr4_ui_clk )         ,
        //.rtc_clock_20m  (  )         ,
        //.axil_clk       (),
       // .clock_40m      (mc_clock_40m),
       // .clock_10m      (mc_clock_10m),
        .ddr4_mig_calib_done(c0_init_calib_complete),
        .m_axi_ddr_mem_araddr   (m_ddr_mem_araddr      ),
        .m_axi_ddr_mem_arburst  (m_ddr_mem_arburst    ),
        .m_axi_ddr_mem_arcache  (m_ddr_mem_arcache    ),
        .m_axi_ddr_mem_arid     (m_ddr_mem_arid          ),
        .m_axi_ddr_mem_arlen    (m_ddr_mem_arlen        ),
        .m_axi_ddr_mem_arlock   (m_ddr_mem_arlock      ),
        .m_axi_ddr_mem_arprot   (m_ddr_mem_arprot      ),
        .m_axi_ddr_mem_arqos    (m_ddr_mem_arqos        ),
        .m_axi_ddr_mem_arready  (m_ddr_mem_arready    ),
        .m_axi_ddr_mem_arregion (m_ddr_mem_arregion  ),
        .m_axi_ddr_mem_arsize   (m_ddr_mem_arsize      ),
        .m_axi_ddr_mem_arvalid  (m_ddr_mem_arvalid    ),
        .m_axi_ddr_mem_awaddr   (m_ddr_mem_awaddr      ),
        .m_axi_ddr_mem_awburst  (m_ddr_mem_awburst    ),
        .m_axi_ddr_mem_awcache  (m_ddr_mem_awcache    ),
        .m_axi_ddr_mem_awid     (m_ddr_mem_awid          ),
        .m_axi_ddr_mem_awlen    (m_ddr_mem_awlen        ),
        .m_axi_ddr_mem_awlock   (m_ddr_mem_awlock      ),
        .m_axi_ddr_mem_awprot   (m_ddr_mem_awprot      ),
        .m_axi_ddr_mem_awqos    (m_ddr_mem_awqos        ),
        .m_axi_ddr_mem_awready  (m_ddr_mem_awready    ),
        .m_axi_ddr_mem_awregion (m_ddr_mem_awregion  ),
        .m_axi_ddr_mem_awsize   (m_ddr_mem_awsize      ),
        .m_axi_ddr_mem_awvalid  (m_ddr_mem_awvalid    ),
        .m_axi_ddr_mem_bid      (m_ddr_mem_bid            ),
        .m_axi_ddr_mem_bready   (m_ddr_mem_bready      ),
        .m_axi_ddr_mem_bresp    (m_ddr_mem_bresp        ),
        .m_axi_ddr_mem_bvalid   (m_ddr_mem_bvalid      ),
        .m_axi_ddr_mem_rdata    (m_ddr_mem_rdata        ),
        .m_axi_ddr_mem_rid      (m_ddr_mem_rid            ),
        .m_axi_ddr_mem_rlast    (m_ddr_mem_rlast        ),
        .m_axi_ddr_mem_rready   (m_ddr_mem_rready      ),
        .m_axi_ddr_mem_rresp    (m_ddr_mem_rresp        ),
        .m_axi_ddr_mem_rvalid   (m_ddr_mem_rvalid      ),
        .m_axi_ddr_mem_wdata    (m_ddr_mem_wdata        ),
        .m_axi_ddr_mem_wlast    (m_ddr_mem_wlast        ),
        .m_axi_ddr_mem_wready   (m_ddr_mem_wready      ),
        .m_axi_ddr_mem_wstrb    (m_ddr_mem_wstrb        ),
        .m_axi_ddr_mem_wvalid   (m_ddr_mem_wvalid      ),
                
        .clock_32m      (mc_clock_32m),        
        .clock_8m       (mc_clock_8m),
        .pcie_ep_gt_ref_clk_clk_n(pcie_ep_gt_ref_clk_clk_n),
        .pcie_ep_gt_ref_clk_clk_p(pcie_ep_gt_ref_clk_clk_p),
        .pcie_ep_perstn(pcie_ep_perstn),
        .pcie_ep_rxn(pcie_ep_rxn),
        .pcie_ep_rxp(pcie_ep_rxp),
        .pcie_ep_txn(pcie_ep_txn),
        .pcie_ep_txp(pcie_ep_txp));



ddr_top ddr_top1
   (
    .DDR0_ACT_N          (c0_ddr4_act_n  ), 
    .DDR0_A              (c0_ddr4_adr    ),
    .DDR0_BA             (c0_ddr4_ba     ),
    .DDR0_BG             (c0_ddr4_bg     ),
    .DDR0_CK_C           (c0_ddr4_ck_c   ),
    .DDR0_CK_T           (c0_ddr4_ck_t   ),
    .DDR0_CKE            (c0_ddr4_cke    ),
    .DDR0_CS_N           (c0_ddr4_cs_n   ),
    .DDR0_DM             (c0_ddr4_dm_n     ),
    .DDR0_DQ             (c0_ddr4_dq     ),
    .DDR0_DQS_C          (c0_ddr4_dqs_c  ),
    .DDR0_DQS_T          (c0_ddr4_dqs_t  ),
    .DDR0_ODT            (c0_ddr4_odt    ),
    .DDR0_RESET_N        (c0_ddr4_reset_n),
    .c0_sys_clk_p        (c0_sys_clk_p   ),
    .c0_sys_clk_n        (c0_sys_clk_n   ),
//    .diff_clock_rtl_0_clk_p(diff_clock_rtl_0_clk_p),
//    .diff_clock_rtl_0_clk_n(diff_clock_rtl_0_clk_n),
    .reset_n             (reset_n),
    .vio_clk             (),
    .uart0_sin           (uart0_sin ),
    .uart0_sout          (uart0_sout),
    .c0_ddr4_ui_clk      (c0_ddr4_ui_clk ),
//    .addn_ui_clkout1     (addn_ui_clk_30m),
//    .addn_ui_clkout2     (rtc_clock_20m),
    .core_ddrc_core_clk  (mc_clock_8m),
    .aclk                (mc_clock_32m),
//xdma&nanhu 2 mc
    .cpu2mc_araddr  (m_ddr_mem_araddr ),
    .cpu2mc_arburst (m_ddr_mem_arburst),
    .cpu2mc_arcache (m_ddr_mem_arcache),
    .cpu2mc_arid    (m_ddr_mem_arid   ),
    .cpu2mc_arlen   (m_ddr_mem_arlen  ),
    .cpu2mc_arlock  (m_ddr_mem_arlock ),
    .cpu2mc_arprot  (m_ddr_mem_arprot ),
    .cpu2mc_arqos   (m_ddr_mem_arqos  ),
    .cpu2mc_arready (m_ddr_mem_arready ),
    .cpu2mc_arregion(m_ddr_mem_arregion ),
    .cpu2mc_arsize  (m_ddr_mem_arsize  ),
    .cpu2mc_arvalid (m_ddr_mem_arvalid ),
    .cpu2mc_awaddr  (m_ddr_mem_awaddr  ),
    .cpu2mc_awburst (m_ddr_mem_awburst ),
    .cpu2mc_awcache (m_ddr_mem_awcache ),
    .cpu2mc_awid    (m_ddr_mem_awid    ),
    .cpu2mc_awlen   (m_ddr_mem_awlen   ),
    .cpu2mc_awlock  (m_ddr_mem_awlock  ),
    .cpu2mc_awprot  (m_ddr_mem_awprot  ),
    .cpu2mc_awqos   (m_ddr_mem_awqos   ),
    .cpu2mc_awready (m_ddr_mem_awready  ),
    .cpu2mc_awregion(m_ddr_mem_awregion ),
    .cpu2mc_awsize  (m_ddr_mem_awsize    ),
    .cpu2mc_awvalid (m_ddr_mem_awvalid   ),
    .cpu2mc_bid     (m_ddr_mem_bid      ),
    .cpu2mc_bready  (m_ddr_mem_bready   ),
    .cpu2mc_bresp   (m_ddr_mem_bresp    ),
    .cpu2mc_bvalid  (m_ddr_mem_bvalid   ),
    .cpu2mc_rdata   (m_ddr_mem_rdata   ),
    .cpu2mc_rid     (m_ddr_mem_rid     ),
    .cpu2mc_rlast   (m_ddr_mem_rlast   ),
    .cpu2mc_rready  (m_ddr_mem_rready   ),
    .cpu2mc_rresp   (m_ddr_mem_rresp    ),
    .cpu2mc_rvalid  (m_ddr_mem_rvalid   ),
    .cpu2mc_wdata   (m_ddr_mem_wdata     ),
    .cpu2mc_wlast   (m_ddr_mem_wlast    ),
    .cpu2mc_wready  (m_ddr_mem_wready  ),
    .cpu2mc_wstrb   (m_ddr_mem_wstrb   ),
    .cpu2mc_wvalid  (m_ddr_mem_wvalid ),
    .c0_init_calib_complete(c0_init_calib_complete)
);

endmodule
