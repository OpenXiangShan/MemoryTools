`timescale 1 ps / 1 ps
//`define SIMULATION
module ddr_top
   (
    DDR0_ACT_N,
    DDR0_A,
    DDR0_BA,
    DDR0_BG,
    DDR0_CK_C,
    DDR0_CK_T,
    DDR0_CKE,
    DDR0_CS_N,
    DDR0_DM,
    DDR0_DQ,
    DDR0_DQS_C,
    DDR0_DQS_T,
    DDR0_ODT,
    DDR0_RESET_N,
    c0_sys_clk_p,
    c0_sys_clk_n,
//    diff_clock_rtl_0_clk_p,
//    diff_clock_rtl_0_clk_n,
    reset_n,
    vio_clk,
    uart0_sin ,
    uart0_sout,
    c0_ddr4_ui_clk,
    addn_ui_clkout1,
    addn_ui_clkout2,
    addn_ui_clkout4,
    core_ddrc_core_clk,
    aclk,
//xdma&nanhu 2 mc
    cpu2mc_araddr  ,
    cpu2mc_arburst ,
    cpu2mc_arcache ,
    cpu2mc_arid    ,
    cpu2mc_arlen   ,
    cpu2mc_arlock  ,
    cpu2mc_arprot  ,
    cpu2mc_arqos   ,
    cpu2mc_arready ,
    cpu2mc_arregion,
    cpu2mc_arsize  ,
    cpu2mc_arvalid ,
    cpu2mc_awaddr  ,
    cpu2mc_awburst ,
    cpu2mc_awcache ,
    cpu2mc_awid    ,
    cpu2mc_awlen   ,
    cpu2mc_awlock  ,
    cpu2mc_awprot  ,
    cpu2mc_awqos   ,
    cpu2mc_awready ,
    cpu2mc_awregion,
    cpu2mc_awsize  ,
    cpu2mc_awvalid ,
    cpu2mc_bid     ,
    cpu2mc_bready  ,
    cpu2mc_bresp   ,
    cpu2mc_bvalid  ,
    cpu2mc_rdata   ,
    cpu2mc_rid     ,
    cpu2mc_rlast   ,
    cpu2mc_rready  ,
    cpu2mc_rresp   ,
    cpu2mc_rvalid  ,
    cpu2mc_wdata   ,
    cpu2mc_wlast   ,
    cpu2mc_wready  ,
    cpu2mc_wstrb   ,
    cpu2mc_wvalid  ,
    c0_init_calib_complete
);

    

  output DDR0_ACT_N;
  output [16:0]DDR0_A;
  output [1:0]DDR0_BA;
  output [1:0]DDR0_BG;
  output [1:0]DDR0_CK_C;
  output [1:0]DDR0_CK_T;
  output [1:0]DDR0_CKE;
  output [1:0]DDR0_CS_N;
  inout [7:0]DDR0_DM;
  inout [63:0]DDR0_DQ;
  inout [7:0]DDR0_DQS_C;
  inout [7:0]DDR0_DQS_T;
  output [1:0]DDR0_ODT;
  output DDR0_RESET_N;
//  input  diff_clock_rtl_0_clk_p;
//  input diff_clock_rtl_0_clk_n;
  input c0_sys_clk_p;
  input c0_sys_clk_n;
 
  input reset_n;
  input vio_clk;
  input uart0_sin;
  output uart0_sout;
  output c0_ddr4_ui_clk;
  output addn_ui_clkout1;
  output addn_ui_clkout2;
  output addn_ui_clkout4;
  input aclk;
  input core_ddrc_core_clk;
  output c0_init_calib_complete;
 ///FAMSE//////////////////
  input   [35:0]   cpu2mc_araddr   ;
  input   [1:0]    cpu2mc_arburst  ;
  input   [3:0]    cpu2mc_arcache  ;
  input   [15:0]   cpu2mc_arid     ;
  input   [7:0]    cpu2mc_arlen    ;
  input   [0:0]    cpu2mc_arlock   ;
  input   [2:0]    cpu2mc_arprot   ;
  input   [3:0]    cpu2mc_arqos    ;
  output  [0:0]    cpu2mc_arready  ;
  input   [3:0]    cpu2mc_arregion ;
  input   [2:0]    cpu2mc_arsize   ;
  input   [0:0]    cpu2mc_arvalid  ;
  input   [35:0]   cpu2mc_awaddr   ;
  input   [1:0]    cpu2mc_awburst  ;
  input   [3:0]    cpu2mc_awcache  ;
  input   [15:0]   cpu2mc_awid     ;
  input   [7:0]    cpu2mc_awlen    ;
  input   [0:0]    cpu2mc_awlock   ;
  input   [2:0]    cpu2mc_awprot   ;
  input   [3:0]    cpu2mc_awqos    ;
  output  [0:0]    cpu2mc_awready  ;
  input   [3:0]    cpu2mc_awregion ;
  input   [2:0]    cpu2mc_awsize   ;
  input   [0:0]    cpu2mc_awvalid  ;
  output  [15:0]   cpu2mc_bid      ;
  input   [0:0]    cpu2mc_bready   ;
  output  [1:0]    cpu2mc_bresp    ;
  output  [0:0]    cpu2mc_bvalid   ;
  output  [255:0]  cpu2mc_rdata    ;
  output  [15:0]   cpu2mc_rid      ;
  output  [0:0]    cpu2mc_rlast    ;
  input   [0:0]    cpu2mc_rready   ;
  output  [1:0]    cpu2mc_rresp    ;
  output  [0:0]    cpu2mc_rvalid   ;
  input   [255:0]  cpu2mc_wdata    ;
  input   [0:0]    cpu2mc_wlast    ;
  output  [0:0]    cpu2mc_wready   ;
  input   [31:0]   cpu2mc_wstrb    ;
  input   [0:0]    cpu2mc_wvalid   ;

  wire        addn_ui_clkout1      ;
  wire        addn_ui_clkout2      ;
  wire        c0_ddr4_ui_clk_sync_rst      ;
reg          rd_start ;
reg          wr_start ;
wire         rd_start_w ;
wire         wr_start_w ;
wire [32:0] inc_addr_w;
reg  [32:0]  inc_addr;

///FAMSE END//////////////
  wire [31:0]  APB_M_0_paddr     ;
  wire         APB_M_0_penable   ;
  wire [31:0]  APB_M_0_prdata    ;
  wire [0:0]   APB_M_0_pready    ;
  wire [0:0]   APB_M_0_psel      ;
  wire [0:0]   APB_M_0_pslverr   ;
  wire [31:0]  APB_M_0_pwdata    ;
  wire         APB_M_0_pwrite    ;
  // wire [31:0]  S00_AXI_0_araddr  ;
  // wire [1:0]   S00_AXI_0_arburst ;
  // wire [3:0]   S00_AXI_0_arcache ;
  // wire [7:0]   S00_AXI_0_arlen   ;
  // wire [0:0]   S00_AXI_0_arlock  ;
  // wire [2:0]   S00_AXI_0_arprot  ;
  // wire [3:0]   S00_AXI_0_arqos   ;
  // wire [0:0]   S00_AXI_0_arready ;
  // wire [3:0]   S00_AXI_0_arregion;
  // wire [2:0]   S00_AXI_0_arsize  ;
  // wire [0:0]   S00_AXI_0_arvalid ;
  // wire [31:0]  S00_AXI_0_awaddr  ;
  // wire [1:0]   S00_AXI_0_awburst ;
  // wire [3:0]   S00_AXI_0_awcache ;
  // wire [7:0]   S00_AXI_0_awlen   ;
  // wire [0:0]   S00_AXI_0_awlock  ;
  // wire [2:0]   S00_AXI_0_awprot  ;
  // wire [3:0]   S00_AXI_0_awqos   ;
  // wire [0:0]   S00_AXI_0_awready ;
  // wire [3:0]   S00_AXI_0_awregion;
  // wire [2:0]   S00_AXI_0_awsize  ;
  // wire [0:0]   S00_AXI_0_awvalid ;
  // wire [0:0]   S00_AXI_0_bready  ;
  // wire [1:0]   S00_AXI_0_bresp   ;
  // wire [0:0]   S00_AXI_0_bvalid  ;
  // wire [255:0] S00_AXI_0_rdata   ;
  // wire [0:0]   S00_AXI_0_rlast   ;
  // wire [0:0]   S00_AXI_0_rready  ;
  // wire [1:0]   S00_AXI_0_rresp   ;
  // wire [0:0]   S00_AXI_0_rvalid  ;
  // wire [255:0] S00_AXI_0_wdata   ;
  // wire [0:0]   S00_AXI_0_wlast   ;
  // wire [0:0]   S00_AXI_0_wready  ;
  // wire [31:0]  S00_AXI_0_wstrb   ;
  // wire [0:0]   S00_AXI_0_wvalid  ;
  wire axi4_clk;
  wire axi4_rstn;
//  wire axil_clk;
  wire [0:0]axil_rstn;
  wire clk_out_apb;
  wire DDR0_ACT_N;
  wire [16:0]DDR0_A;
  wire [1:0]DDR0_BA;
  wire [1:0]DDR0_BG;
  wire [1:0]DDR0_CK_C;
  wire [1:0]DDR0_CK_T;
  wire [1:0]DDR0_CKE;
  wire [1:0]DDR0_CS_N;
  wire [7:0]DDR0_DM;
  wire [63:0]DDR0_DQ;
  wire [7:0]DDR0_DQS_C;
  wire [7:0]DDR0_DQS_T;
  wire [1:0]DDR0_ODT;
  wire DDR0_RESET_N;
  //wire diff_clock_rtl_0_clk_n;
  //wire diff_clock_rtl_0_clk_p;
  wire init_calib_complete;
  wire intr;
  wire sys_rst_n;
  wire [0:0]resetn_apb;
  wire uart0_sin;
  wire uart0_sout;
  wire ddr_alert_n;
  wire c0_init_calib_complete;
  wire aresetn;
  wire aresetn_50m;
  reg master_rstn;
  wire master_rstn_w;
  reg [35:0] test_num_wr;
  wire [35:0] test_num_wr_w;
  reg [35:0] test_num_rd;
  wire [35:0] test_num_rd_w;
  reg test_mode;
  wire test_mode_w;   
  reg  read_start;
  wire [32:0] start_addr_w;
  reg [32:0] start_addr;

 wire [37:0]    araddr   ;
wire [1:0]     arburst  ;
 wire [3:0]     arcache  ;
 wire [15:0]    arid     ;
 wire [7:0]     arlen    ;
  wire [0:0]     arlock   ;
  wire [2:0]     arprot   ;
  wire [3:0]     arqos    ;
  wire           arready  ;
 wire [3:0]     arregion ;
  wire [2:0]     arsize   ;
  wire           arvalid  ;
  wire [37:0]   awaddr;
  wire [1:0]    awburst;
  wire [3:0]    awcache;
  wire [17:0]   awid;
  wire [7:0]    awlen;
  wire [0:0]    awlock;
  wire [2:0]    awprot;
  wire [3:0]    awqos;
  wire          awready;
  wire [3:0]    awregion;
  wire [2:0]    awsize;
  wire          awvalid;
  wire [17:0]   bid;
  wire          bready;
  wire [1:0]    bresp;
  wire          bvalid;
  wire [255:0]  rdata;
  wire [17:0]   rid;
  wire          rlast;
  wire          rready;
  wire [1:0]    rresp;
  wire          rvalid;
  wire [255:0]  wdata    ;
  wire          wlast    ;
  wire          wready   ;
  wire [31:0]   wstrb    ;
  wire          wvalid   ;
  wire          read_error   ;
  wire          test_complet   ;


/**
`ifdef SIMULATION  begin 
  reg [31:0] write_counter;
  always @(posedge clk_out_apb or negedge reset_n) begin : proc_read_start
    if(~reset_n) begin
      rd_start <= 0;
    end else if(write_counter == 500) begin
      rd_start <= 1;
    end
  end
  always @(posedge addn_ui_clkout1 or negedge master_rstn) begin : proc_write_counter
    if(~master_rstn) begin
      write_counter <= 0;
    end else if (awvalid && awready) begin
      write_counter <= write_counter + 1;
    end
  end
  always @(posedge clk_out_apb or negedge reset_n) begin : proc_master_rstn
   if(~reset_n) begin
     master_rstn <= 0;
   end else if((APB_M_0_paddr == 'h44a0_fffc) && APB_M_0_psel && APB_M_0_penable) begin
     master_rstn <= 1;
   end
  end
  always @(posedge clk_out_apb or negedge reset_n) begin : proc_wr_start
   if(~reset_n) begin
     wr_start <= 0;
   end else if((APB_M_0_paddr == 'h44a0_fffc) && APB_M_0_psel && APB_M_0_penable) begin
     wr_start <= 1;
   end
  end
  always @(posedge addn_ui_clkout1 ) begin
       test_num_wr <= 1000;
       test_num_rd <= 1000;
       // master_rstn <= 1;
       test_mode   <= 0;
       // rd_start   <= rd_start_w;
       // wr_start   <= wr_start_w;
       inc_addr   <= 64;
       start_addr   <= 33'b0_0001_0000_0100_0000_0000_0000_0000_0000;
  end
end
`else begin 
    vio_0 u_vio(
   .clk        (addn_ui_clkout1),
   .probe_out0 (master_rstn_w),
   .probe_out1 (test_num_wr_w),
   .probe_out2 (test_num_rd_w),
   .probe_out3 (test_mode_w),
   .probe_out4 (rd_start_w),
   .probe_out5 (wr_start_w),
   .probe_out6 (inc_addr_w),
   .probe_out7 (start_addr_w)
    );
    always @(posedge addn_ui_clkout1 ) begin
         test_num_wr <= test_num_wr_w;
         test_num_rd <= test_num_rd_w;
         master_rstn <= master_rstn_w;
         test_mode   <= test_mode_w;
         rd_start   <= rd_start_w;
         wr_start   <= wr_start_w;
         inc_addr   <= inc_addr_w;
         start_addr   <= start_addr_w;
    end
end
`endif
  axi_master #( 
    .READ_NUM(1000000),
    .WRITE_NUM(1000000),
    .RANDOM(0), 
    .BL(1)
    ) 
  u_axi_master
  (
//        .clk     (axil_clk) ,    // Clock
         .clk     (addn_ui_clkout1) ,    // Clock
//        .rst_n   (axil_rstn && master_rstn) ,  // Asynchronous reset active low
         .rst_n   (aresetn_50m && master_rstn) ,  // Asynchronous reset active low
        .read_start  (rd_start) ,
        .write_start (wr_start) ,
        .araddr  (araddr   ) ,
        .arburst (arburst  ) ,
        .arcache (arcache  ) ,
        .arid    (arid     ) ,
        .arlen   (arlen    ) ,
        .arlock  (arlock   ) ,
        .arprot  (arprot   ) ,
        .arqos   (arqos    ) ,
        .arready (arready  ) ,
        .arsize  (arsize   ) ,
        .arregion(arregion ) ,
        .arvalid (arvalid  ) ,
        .awregion(awregion ) ,
        .awaddr  (awaddr   ) ,
        .awburst (awburst  ) ,
        .awcache (awcache  ) ,
        .awid    (awid     ) ,
        .awlen   (awlen    ) ,
        .awlock  (awlock   ) ,
        .awprot  (awprot   ) ,
        .awqos   (awqos    ) ,
        .awready (awready  ) ,
        .awsize  (awsize   ) ,
        .awvalid (awvalid  ) ,
        .bid     (bid      ) ,
        .bready  (bready   ) ,
        .bresp   (bresp    ) ,
        .bvalid  (bvalid   ) ,
        .rdata   (rdata    ) ,
        .rid     (rid      ) ,
        .rlast   (rlast    ) ,
        .rready  (rready   ) ,
        .rresp   (rresp    ) ,
        .rvalid  (rvalid   ) ,
        .wdata   (wdata    ) ,
        .wlast   (wlast    ) ,
        .wready  (wready   ) ,
        .wstrb   (wstrb    ) ,
        .wvalid  (wvalid   ) ,
        .read_error    (read_error   ),
        .test_num_wr   (test_num_wr   ), 
        .test_num_rd   (test_num_rd   ), 
        .test_mode     (test_mode   ),  
        .test_complet  (test_complet   ),
        .inc_addr (inc_addr),
        .start_addr(start_addr) 
);***/



  ddr ddr_subsys2_i
       (.APB_M_0_paddr          ( APB_M_0_paddr           ) ,
        .APB_M_0_penable        ( APB_M_0_penable         ) ,
        .APB_M_0_prdata         ( APB_M_0_prdata          ) ,
        .APB_M_0_pready         ( APB_M_0_pready          ) ,
        .APB_M_0_psel           ( APB_M_0_psel            ) ,
        .APB_M_0_pslverr        ( APB_M_0_pslverr         ) ,
        .APB_M_0_pwdata         ( APB_M_0_pwdata          ) ,
        .APB_M_0_pwrite         ( APB_M_0_pwrite          ) ,
        .axil_clk               ( core_ddrc_core_clk                ) ,
        .axil_rstn              ( axil_rstn               ) ,
        .clk_out_apb            ( clk_out_apb             ) ,
//        .intr                   ( 1'b0                    ) ,
        .reset_n                ( reset_n                 ) ,
        .resetn_apb             ( resetn_apb              ) 
//        .uart_rtl_0_rxd         ( uart0_sin               ) ,
//        .uart_rtl_0_txd         ( uart0_sout              ) 
        );
        

 //    *******************************/
//  .clk(addn_ui_clkout1),
//  .clk_12_5(axil_clk),
//  .aresetn(aresetn),
//  .aresetn_50m(aresetn_50m),
//  .complete(c0_init_calib_complete),
//  .aclk(aclk),
//    .CLK_IN1_D_0_clk_p(diff_clock_rtl_0_clk_p),
//    .CLK_IN1_D_0_clk_n(diff_clock_rtl_0_clk_n),
//  .rst_n(reset_n && master_rstn)
//  );
        
ddr4_wrapper i_ddr_wrapper (
        .ddr_ck_t                       (  DDR0_CK_T                              ),
        .ddr_ck_c                       (  DDR0_CK_C                              ),
        .ddr_cke                        (  DDR0_CKE                               ),
        .ddr_cs_n                       (  DDR0_CS_N                              ),
        .ddr_odt                        (  DDR0_ODT                               ),
        .ddr_act_n                      (  DDR0_ACT_N                             ),
        .ddr_dm_n                       (  DDR0_DM                                ),
        .ddr_bg                         (  DDR0_BG                                ),
        .ddr_ba                         (  DDR0_BA                                ),
        .ddr_a                          (  DDR0_A                                 ),
        .ddr_reset_n                    (  DDR0_RESET_N                           ),
        .ddr_dq                         (  DDR0_DQ                                ),
        .ddr_dqs_t                      (  DDR0_DQS_T                             ),
        .ddr_dqs_c                      (  DDR0_DQS_C                             ),
        .ddr_par                        (                                         ),
        .ddr_alert_n                    (  ddr_alert_n                            ),
        .ddr_ten                        (                                         ),
        .core_ddrc_core_clk             (  core_ddrc_core_clk                     ),
        .core_ddrc_rstn                 (  axil_rstn                               ),
        .aresetn_0                      (  axil_rstn                               ),
        .aclk_0                         (  core_ddrc_core_clk/*axil_clk*/                    ),

        .awid_0                         (  cpu2mc_awid                            ),
        .awaddr_0                       (  cpu2mc_awaddr                          ),
        .awlen_0                        (  cpu2mc_awlen                           ),
        .awsize_0                       (  cpu2mc_awsize                          ),
        .awburst_0                      (  cpu2mc_awburst                         ),
        .awlock_0                       (  cpu2mc_awlock                          ),
        .awcache_0                      (  cpu2mc_awcache                         ),
        .awprot_0                       (  cpu2mc_awprot                          ),
        .awuser_0                       (  8'b00000000                            ),
        .awvalid_0                      (  cpu2mc_awvalid                         ),
        .awready_0                      (  cpu2mc_awready                         ),
        .awqos_0                        (  cpu2mc_awqos                           ),
        .awregion_0                     (  cpu2mc_awregion                        ),
        .wdata_0                        (  cpu2mc_wdata                           ),
        .wstrb_0                        (  cpu2mc_wstrb                           ),
        .wlast_0                        (  cpu2mc_wlast                           ),
        .wvalid_0                       (  cpu2mc_wvalid                          ),
        .wready_0                       (  cpu2mc_wready                          ),
        .wuser_0                        (  8'b00000000                            ),
        .bid_0                          (  cpu2mc_bid                             ),//
        .bresp_0                        (  cpu2mc_bresp                           ),
        .buser_0                        (                                         ),//
        .bvalid_0                       (  cpu2mc_bvalid                          ),
        .bready_0                       (  cpu2mc_bready                          ),
        .arid_0                         (  cpu2mc_arid                            ),
        .araddr_0                       (  cpu2mc_araddr                          ),
        .arlen_0                        (  cpu2mc_arlen                           ),
        .arsize_0                       (  cpu2mc_arsize                          ),
        .arburst_0                      (  cpu2mc_arburst                         ),
        .arlock_0                       (  cpu2mc_arlock                          ),
        .arcache_0                      (  cpu2mc_arcache                         ),
        .arprot_0                       (  cpu2mc_arprot                          ),
        .aruser_0                       (  8'b00000000                            ),
        .arvalid_0                      (  cpu2mc_arvalid                         ),
        .arready_0                      (  cpu2mc_arready                         ),
        .arqos_0                        (  cpu2mc_arqos                           ),
        .arregion_0                     (  cpu2mc_arregion                        ),
        .rid_0                          (  cpu2mc_rid                             ),//
        .rdata_0                        (  cpu2mc_rdata                           ),
        .rresp_0                        (  cpu2mc_rresp                           ),
        .ruser_0                        (                                         ),//
        .rlast_0                        (  cpu2mc_rlast                           ),
        .rvalid_0                       (  cpu2mc_rvalid                          ),
        .rready_0                       (  cpu2mc_rready                          ),
//        .mc_scanmode                    (  1'b0                                    ),
//        .mc_scan_resetn                 (  1'b0                                    ),
//        .bist_mode                      (  1'b0                                    ),
//        .bist_mux                       (  1'b0                                    ),
//        .bist_start                     (  1'b0                                    ),
//        .bist_complete                  (                                          ),
//        .bist_error                     (                                          ),
//        .bscan_TDI                      (  1'b0                                    ),
//        .bscan_TDO                      (                                          ),
//        .bscan_clockDR                  (  1'b0                                    ),
//        .bscan_mode                     (  1'b0                                    ),
//        .bscan_shiftDR                  (  1'b0                                    ),
//        .bscan_updateDR                 (  1'b0                                    ),
//        .ddr_plllock                    (                                          ),
//        .phy_scanclk                    (  pclk                                    ),
//        .phy_scanrstn                   (  1'b1                                    ),
//        .phy_scanmode                   (  1'b0                                    ),
//        .phy_scanen                     (  1'b0                                    ),
//        .phy_scanin                     (  165'h0                                  ),
//        .phy_scanout                    (                                          ),
        .pclk                           (  clk_out_apb                             ),
        .presetn                        (  resetn_apb                              ),
        .paddr_mc                       (  APB_M_0_paddr                           ),
//        .paddr_phy                      (                                          ),
        .pwdata_mc                      (  APB_M_0_pwdata                          ),
//        .pwdata_phy                     (                                          ),
        .pwrite_mc                      (  APB_M_0_pwrite                          ),
//        .pwrite_phy                     (                                          ),
        .psel_mc                        (  APB_M_0_psel                            ),
//        .psel_phy                       (                                          ),
        .penable_mc                     (  APB_M_0_penable                         ),
//        .penable_phy                    (                                          ),
        .pready_mc                      (  APB_M_0_pready                          ),
//        .pready_phy                     (                                          ),
        .prdata_mc                      (  APB_M_0_prdata                          ),
//        .prdata_phy                     (                                          ),
        .pslverr_mc                     (  APB_M_0_pslverr                         ),
//.pslverr_phy                    (    pslverr_phy                           ),
//        .bist_dfi_init_start            (                                          ),
        .dfi_init_complete              (                                          ),
//    .dft_mode                                     (   1'b0                                   ),
//    .dft_lgc_rstn                                 (   1'b1                                   ),
//    .scan_mode                                    (   1'b0                                   ),
//    .dft_glb_gt_se                (   1'b0                                                                                                               ),
//    .bist_dfi_frequency           (   5'b00000                               ),
//    .bist_bufferen_core           (   1'b1                                   ),
    // .bufferen_core             (   1'b1                                   ),
//    .phy_bist_mode                (   1'b0                                   ),
    .sys_rst                      (    !reset_n                                ),
    .c0_sys_clk_p                 (   c0_sys_clk_p                           ),
    .c0_sys_clk_n                 (   c0_sys_clk_n                           ),
    .c0_ddr4_ui_clk               (     c0_ddr4_ui_clk                       ),
    .c0_ddr4_ui_clk_sync_rst      (    c0_ddr4_ui_clk_sync_rst               ),
    .init_calib_complete       (    c0_init_calib_complete                ),
    .addn_ui_clkout1              (    addn_ui_clkout1           ),
    .addn_ui_clkout2              (    addn_ui_clkout2           )
//    .addn_ui_clkout4              (    addn_ui_clkout4           )

);

endmodule

