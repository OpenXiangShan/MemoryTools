//`include "DWC_ddr_umctl2_all_includes.svh"
//`include "defines.vh"
module ddr4_wrapper (
    output [1:0]   ddr_ck_t,
    output [1:0]   ddr_ck_c,
    output [1:0]   ddr_cke,
    output [1:0]   ddr_cs_n,
    output [1:0]   ddr_odt,
    output         ddr_act_n,
    inout  [7:0]   ddr_dm_n,
    output [1:0]   ddr_bg,
    output [1:0]   ddr_ba,
    output [16:0]  ddr_a,
    output         ddr_reset_n,
    inout  [63:0]  ddr_dq,
    inout  [7:0]   ddr_dqs_t,
    inout  [7:0]   ddr_dqs_c,
    output         ddr_par,
    input          ddr_alert_n,
    output         ddr_ten,

//    output [1:0]   c1_ddr4_ck_t,
//    output [1:0]   c1_ddr4_ck_c,
//    output [1:0]   c1_ddr4_cke,
//    output [1:0]   c1_ddr4_cs_n,
//    output [1:0]   c1_ddr4_odt,
//    output         c1_ddr4_act_n,
//    output [16:0]  c1_ddr4_adr,
//    output [1:0]   c1_ddr4_ba,
//    output [1:0]   c1_ddr4_bg,
//    output         c1_ddr4_reset_n,
//    inout  [7:0]   c1_ddr4_dm_n,
//    inout  [63:0]  c1_ddr4_dq,
//    inout  [7:0]   c1_ddr4_dqs_t,
//    inout  [7:0]   c1_ddr4_dqs_c,

    input          core_ddrc_core_clk,
    input          core_ddrc_rstn,
    input          aresetn_0,
    input          aclk_0,
    input  [15:0]  awid_0,
    input  [35:0]  awaddr_0,
    input  [7:0]   awlen_0,
    input  [2:0]   awsize_0,
    input  [1:0]   awburst_0,
    input  [0:0]   awlock_0,
    input  [3:0]   awcache_0,
    input  [2:0]   awprot_0,
    input  [7:0]   awuser_0,
    input          awvalid_0,
    output         awready_0,
    input  [3:0]   awqos_0,
    input  [3:0]   awregion_0,
    input  [255:0] wdata_0,
    input  [31:0]  wstrb_0,
    input          wlast_0,
    input          wvalid_0,
    output         wready_0,
    input  [7:0]   wuser_0,
    output [15:0]  bid_0,
    output [1:0]   bresp_0,
    output [7:0]   buser_0,
    output         bvalid_0,
    input          bready_0,
    input  [15:0]  arid_0,
    input  [35:0]  araddr_0,
    input  [7:0]   arlen_0,
    input  [2:0]   arsize_0,
    input  [1:0]   arburst_0,
    input  [0:0]   arlock_0,
    input  [3:0]   arcache_0,
    input  [2:0]   arprot_0,
    input  [7:0]   aruser_0,
    input          arvalid_0,
    output         arready_0,
    input  [3:0]   arqos_0,
    input  [3:0]   arregion_0,
    output [15:0]  rid_0,
    output [255:0] rdata_0,
    output [1:0]   rresp_0,
    output [7:0]   ruser_0,
    output         rlast_0,
    output         rvalid_0,
    input          rready_0,

    input          pclk,
    input          presetn,
    input  [15:0]  paddr_mc,
    input  [31:0]  pwdata_mc,
    input          pwrite_mc,
    input          psel_mc,
    input          penable_mc,
    output         pready_mc,
    output [31:0]  prdata_mc,
    output         pslverr_mc,

//    input          error_assert,
//    output         axi_bus_rst_n,
//    inout          rzq,
//    input          dft_mode,
//    input          dft_lgc_rstn,
//    input          scan_mode,
//    input          dft_glb_gt_se,
    output         dfi_init_complete,
//    input          phy_bist_mode,
//    input  [4:0]   bist_dfi_frequency,

    input          sys_rst,
    input          c0_sys_clk_p,
    input          c0_sys_clk_n,
//    input          c1_sys_clk_p,
//    input          c1_sys_clk_n,
    output        c0_ddr4_ui_clk ,
    output         c0_ddr4_ui_clk_sync_rst,
    output         init_calib_complete,
    output         addn_ui_clkout1,
    output         addn_ui_clkout2
//    output         io_end_init_ddr,
//    output         dfi_init_done
);

localparam integer AXI_EXTERNAL_ID_WIDTH = 16;
localparam integer AXI_MC_ID_WIDTH       = 14;
localparam integer AXI_ADDR_WIDTH        = 36;
localparam integer AXI_LEN_WIDTH         = 8;
localparam integer AXI_DATA_WIDTH        = 256;
localparam integer AXI_STRB_WIDTH        = 32;
localparam integer AXI_USER_WIDTH        = 8;
localparam integer DFI_PHASE_ADDR_WIDTH  = 17;
localparam integer DFI_DATA_WIDTH        = 256;
localparam integer DFI_MASK_WIDTH        = 32;
localparam integer DFI_DATAEN_WIDTH      = 16;

wire         o_presetn;
wire         o_core_ddrc_rstn;
wire         o_aresetn_0;
//wire         c1_ddr4_ui_clk;
//wire         c1_ddr4_ui_clk_sync_rst;
//wire         c1_init_calib_complete;
wire         c0_init_calib_complete;
reg          init_rstn_mc;
reg          c0_init_calib_complete_r1;
reg          c0_init_calib_complete_r2;
//reg          c1_init_calib_complete_r1;
//reg          c1_init_calib_complete_r2;
wire [13:0]  mc_bid_0;
wire [13:0]  mc_rid_0;
wire         mc_buser_0;
wire         mc_ruser_0;

wire [16:0] c0_dfi_address_0;
wire [16:0] c0_dfi_address_1;
wire [1:0]  c0_dfi_bank_0;
wire [1:0]  c0_dfi_bank_1;
wire        c0_dfi_ras_n_0;
wire        c0_dfi_ras_n_1;
wire        c0_dfi_cas_n_0;
wire        c0_dfi_cas_n_1;
wire        c0_dfi_we_n_0;
wire        c0_dfi_we_n_1;
wire        c0_dfi_cs_n_0_0;
wire        c0_dfi_cs_n_0_1;
wire        c0_dfi_cs_n_1_0;
wire        c0_dfi_cs_n_1_1;
wire        c0_dfi_act_n_0;
wire        c0_dfi_act_n_1;
wire [1:0]  c0_dfi_bg_0;
wire [1:0]  c0_dfi_bg_1;
wire        c0_dfi_cid;
wire        c0_dfi_cke_0_0;
wire        c0_dfi_cke_0_1;
wire        c0_dfi_cke_1_0;
wire        c0_dfi_cke_1_1;
wire        c0_dfi_odt_0_0;
wire        c0_dfi_odt_0_1;
wire        c0_dfi_odt_1_0;
wire        c0_dfi_odt_1_1;
wire        c0_dfi_reset_n_0_0;
wire        c0_dfi_reset_n_0_1;
wire        c0_dfi_reset_n_1_0;
wire        c0_dfi_reset_n_1_1;
wire [15:0] c0_dfi_wrdata_en;
wire [255:0] c0_dfi_wrdata;
wire [31:0] c0_dfi_wdata_cs_n;
wire [31:0] c0_dfi_wrdata_mask;
wire [15:0] c0_dfi_rddata_en;
wire [255:0] c0_dfi_rddata;
wire [31:0] c0_dfi_rddata_cs_n;
wire [15:0] c0_dfi_rddata_valid;
wire        c0_dfi_ctrlupd_req;
wire        c0_dfi_phyupd_ack;
wire [31:0] c0_dfi_data_byte_disable;
wire [1:0]  c0_dfi_dram_clk_disable;
wire [1:0]  c0_dfi_freq_ratio;
wire        c0_dfi_init_start;
wire        c0_dfi_parity_in;

//wire [16:0] c1_dfi_address_0;
//wire [16:0] c1_dfi_address_1;
//wire [1:0]  c1_dfi_bank_0;
//wire [1:0]  c1_dfi_bank_1;
//wire        c1_dfi_ras_n_0;
//wire        c1_dfi_ras_n_1;
//wire        c1_dfi_cas_n_0;
//wire        c1_dfi_cas_n_1;
//wire        c1_dfi_we_n_0;
//wire        c1_dfi_we_n_1;
//wire        c1_dfi_cs_n_0_0;
//wire        c1_dfi_cs_n_0_1;
//wire        c1_dfi_cs_n_1_0;
//wire        c1_dfi_cs_n_1_1;
//wire        c1_dfi_act_n_0;
//wire        c1_dfi_act_n_1;
//wire [1:0]  c1_dfi_bg_0;
//wire [1:0]  c1_dfi_bg_1;
//wire        c1_dfi_cid;
//wire        c1_dfi_cke_0_0;
//wire        c1_dfi_cke_0_1;
//wire        c1_dfi_cke_1_0;
//wire        c1_dfi_cke_1_1;
//wire        c1_dfi_odt_0_0;
//wire        c1_dfi_odt_0_1;
//wire        c1_dfi_odt_1_0;
//wire        c1_dfi_odt_1_1;
//wire        c1_dfi_reset_n_0_0;
//wire        c1_dfi_reset_n_0_1;
//wire        c1_dfi_reset_n_1_0;
//wire        c1_dfi_reset_n_1_1;
//wire [15:0] c1_dfi_wrdata_en;
//wire [255:0] c1_dfi_wrdata;
//wire [31:0] c1_dfi_wdata_cs_n;
//wire [31:0] c1_dfi_wrdata_mask;
//wire [15:0] c1_dfi_rddata_en;
//wire [255:0] c1_dfi_rddata;
//wire [31:0] c1_dfi_rddata_cs_n;
//wire [15:0] c1_dfi_rddata_valid;
//wire        c1_dfi_ctrlupd_req;
//wire        c1_dfi_phyupd_ack;
//wire [31:0] c1_dfi_data_byte_disable;
//wire [1:0]  c1_dfi_dram_clk_disable;
//wire [1:0]  c1_dfi_freq_ratio;
//wire        c1_dfi_init_start;
//wire        c1_dfi_parity_in;

assign ddr_par = 1'b0;
assign ddr_ten = 1'b0;
assign dfi_init_complete = c0_init_calib_complete_r2 ;
//assign dfi_init_done = (c0_dfi_init_start ) & dfi_init_complete;
//assign io_end_init_ddr = dfi_init_done;
assign bid_0 = {2'b00, mc_bid_0};
assign rid_0 = {2'b00, mc_rid_0};
assign buser_0 = {7'b0000000, mc_buser_0};
assign ruser_0 = {7'b0000000, mc_ruser_0};

always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
        init_rstn_mc <= 1'b0;
    end else if ((paddr_mc == 16'h0058) && psel_mc && pwrite_mc && !pready_mc) begin
        init_rstn_mc <= 1'b1;
    end
end
reg apb_cfg_done ;
always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
        apb_cfg_done <= 1'b0;
    end else if ((paddr_mc == 16'h0ff4) && psel_mc && pwrite_mc && !pready_mc) begin
        apb_cfg_done <= 1'b1;
    end
end

always_ff @(posedge core_ddrc_core_clk or negedge core_ddrc_rstn) begin
    if (!core_ddrc_rstn) begin
        c0_init_calib_complete_r1 <= 1'b0;
        c0_init_calib_complete_r2 <= 1'b0;
//        c1_init_calib_complete_r1 <= 1'b0;
//        c1_init_calib_complete_r2 <= 1'b0;
    end else begin
        c0_init_calib_complete_r1 <= c0_init_calib_complete;
        c0_init_calib_complete_r2 <= c0_init_calib_complete_r1;
//        c1_init_calib_complete_r1 <= c1_init_calib_complete;
//        c1_init_calib_complete_r2 <= c1_init_calib_complete_r1;
    end
end

vio_0 u_vio (
  .clk(core_ddrc_core_clk),              // input wire clk
  .probe_in0(c0_init_calib_complete),  // input wire [0 : 0] probe_in0
  .probe_in1(apb_cfg_done)  // input wire [0 : 0] probe_in1
);

assign init_calib_complete = c0_init_calib_complete && apb_cfg_done ;
ddr_crg ddr_crg_i (
    .dft_mode           (dft_mode),
    .dft_lgc_rstn       (dft_lgc_rstn),
    .scan_mode          (scan_mode),
    .dft_glb_gt_se      (dft_glb_gt_se),
    .core_ddrc_core_clk (core_ddrc_core_clk),
    .core_ddrc_rstn     (core_ddrc_rstn),
    .aclk_0             (aclk_0),
    .aresetn_0          (aresetn_0),
    .pclk               (pclk),
    .presetn            (presetn),
    .init_rstn_mc       (init_rstn_mc),
    .o_core_ddrc_rstn   (o_core_ddrc_rstn),
    .o_aresetn_0        (o_aresetn_0),
    .axi_bus_rst_n      (axi_bus_rst_n),
    .o_presetn          (o_presetn)
);

ddr4_famse_mig_channel #(
    .CHANNEL_ID (0)
) u_channel0 (
    .sys_rst                    (sys_rst),
    .sys_clk_p                  (c0_sys_clk_p),
    .sys_clk_n                  (c0_sys_clk_n),
    .dfi_clk                    (core_ddrc_core_clk),
    .rst_n                      (o_aresetn_0),
    .ddr4_ui_clk                (c0_ddr4_ui_clk),
    .ddr4_ui_clk_sync_rst       (c0_ddr4_ui_clk_sync_rst),
    .init_calib_complete        (c0_init_calib_complete),
    .addn_ui_clkout1            (addn_ui_clkout1),
    .addn_ui_clkout2            (addn_ui_clkout2),
    .dfi_address_0              (c0_dfi_address_0),
    .dfi_address_1              (c0_dfi_address_1),
    .dfi_bank_0                 (c0_dfi_bank_0),
    .dfi_bank_1                 (c0_dfi_bank_1),
    .dfi_ras_n_0                (c0_dfi_ras_n_0),
    .dfi_ras_n_1                (c0_dfi_ras_n_1),
    .dfi_cas_n_0                (c0_dfi_cas_n_0),
    .dfi_cas_n_1                (c0_dfi_cas_n_1),
    .dfi_we_n_0                 (c0_dfi_we_n_0),
    .dfi_we_n_1                 (c0_dfi_we_n_1),
    .dfi_cs_n_0_0               (c0_dfi_cs_n_0_0),
    .dfi_cs_n_0_1               (c0_dfi_cs_n_0_1),
    .dfi_cs_n_1_0               (c0_dfi_cs_n_1_0),
    .dfi_cs_n_1_1               (c0_dfi_cs_n_1_1),
    .dfi_act_n_0                (c0_dfi_act_n_0),
    .dfi_act_n_1                (c0_dfi_act_n_1),
    .dfi_bg_0                   (c0_dfi_bg_0),
    .dfi_bg_1                   (c0_dfi_bg_1),
    .dfi_cke_0_0                (c0_dfi_cke_0_0),
    .dfi_cke_0_1                (c0_dfi_cke_0_1),
    .dfi_cke_1_0                (c0_dfi_cke_1_0),
    .dfi_cke_1_1                (c0_dfi_cke_1_1),
    .dfi_odt_0_0                (c0_dfi_odt_0_0),
    .dfi_odt_0_1                (c0_dfi_odt_0_1),
    .dfi_odt_1_0                (c0_dfi_odt_1_0),
    .dfi_odt_1_1                (c0_dfi_odt_1_1),
    .dfi_reset_n_0_0            (c0_dfi_reset_n_0_0),
    .dfi_reset_n_0_1            (c0_dfi_reset_n_0_1),
    .dfi_reset_n_1_0            (c0_dfi_reset_n_1_0),
    .dfi_reset_n_1_1            (c0_dfi_reset_n_1_1),
    .dfi_wrdata_en              (c0_dfi_wrdata_en),
    .dfi_wrdata                 (c0_dfi_wrdata),
    .dfi_wrdata_mask            (c0_dfi_wrdata_mask),
    .dfi_rddata_en              (c0_dfi_rddata_en),
    .dfi_rddata                 (c0_dfi_rddata),
    .dfi_rddata_valid           (c0_dfi_rddata_valid),
    .ddr_ck_t                   (ddr_ck_t),
    .ddr_ck_c                   (ddr_ck_c),
    .ddr_cke                    (ddr_cke),
    .ddr_cs_n                   (ddr_cs_n),
    .ddr_odt                    (ddr_odt),
    .ddr_act_n                  (ddr_act_n),
    .ddr_adr                    (ddr_a),
    .ddr_ba                     (ddr_ba),
    .ddr_bg                     (ddr_bg),
    .ddr_reset_n                (ddr_reset_n),
    .ddr_dm_dbi_n               (ddr_dm_n),
    .ddr_dq                     (ddr_dq),
    .ddr_dqs_c                  (ddr_dqs_c),
    .ddr_dqs_t                  (ddr_dqs_t)
);

//ddr4_famse_mig_channel #(
//    .CHANNEL_ID (1)
//) u_channel1 (
//    .sys_rst                    (sys_rst),
//    .sys_clk_p                  (c1_sys_clk_p),
//    .sys_clk_n                  (c1_sys_clk_n),
//    .dfi_clk                    (core_ddrc_core_clk),
//    .rst_n                      (o_aresetn_0),
//    .ddr4_ui_clk                (c1_ddr4_ui_clk),
//    .ddr4_ui_clk_sync_rst       (c1_ddr4_ui_clk_sync_rst),
//    .init_calib_complete        (c1_init_calib_complete),
//    .addn_ui_clkout1            (),
//    .addn_ui_clkout2            (),
//    .dfi_address_0              (c1_dfi_address_0),
//    .dfi_address_1              (c1_dfi_address_1),
//    .dfi_bank_0                 (c1_dfi_bank_0),
//    .dfi_bank_1                 (c1_dfi_bank_1),
//    .dfi_ras_n_0                (c1_dfi_ras_n_0),
//    .dfi_ras_n_1                (c1_dfi_ras_n_1),
//    .dfi_cas_n_0                (c1_dfi_cas_n_0),
//    .dfi_cas_n_1                (c1_dfi_cas_n_1),
//    .dfi_we_n_0                 (c1_dfi_we_n_0),
//    .dfi_we_n_1                 (c1_dfi_we_n_1),
//    .dfi_cs_n_0_0               (c1_dfi_cs_n_0_0),
//    .dfi_cs_n_0_1               (c1_dfi_cs_n_0_1),
//    .dfi_cs_n_1_0               (c1_dfi_cs_n_1_0),
//    .dfi_cs_n_1_1               (c1_dfi_cs_n_1_1),
//    .dfi_act_n_0                (c1_dfi_act_n_0),
//    .dfi_act_n_1                (c1_dfi_act_n_1),
//    .dfi_bg_0                   (c1_dfi_bg_0),
//    .dfi_bg_1                   (c1_dfi_bg_1),
//    .dfi_cke_0_0                (c1_dfi_cke_0_0),
//    .dfi_cke_0_1                (c1_dfi_cke_0_1),
//    .dfi_cke_1_0                (c1_dfi_cke_1_0),
//    .dfi_cke_1_1                (c1_dfi_cke_1_1),
//    .dfi_odt_0_0                (c1_dfi_odt_0_0),
//    .dfi_odt_0_1                (c1_dfi_odt_0_1),
//    .dfi_odt_1_0                (c1_dfi_odt_1_0),
//    .dfi_odt_1_1                (c1_dfi_odt_1_1),
//    .dfi_reset_n_0_0            (c1_dfi_reset_n_0_0),
//    .dfi_reset_n_0_1            (c1_dfi_reset_n_0_1),
//    .dfi_reset_n_1_0            (c1_dfi_reset_n_1_0),
//    .dfi_reset_n_1_1            (c1_dfi_reset_n_1_1),
//    .dfi_wrdata_en              (c1_dfi_wrdata_en),
//    .dfi_wrdata                 (c1_dfi_wrdata),
//    .dfi_wrdata_mask            (c1_dfi_wrdata_mask),
//    .dfi_rddata_en              (c1_dfi_rddata_en),
//    .dfi_rddata                 (c1_dfi_rddata),
//    .dfi_rddata_valid           (c1_dfi_rddata_valid),
//    .ddr_ck_t                   (c1_ddr4_ck_t),
//    .ddr_ck_c                   (c1_ddr4_ck_c),
//    .ddr_cke                    (c1_ddr4_cke),
//    .ddr_cs_n                   (c1_ddr4_cs_n),
//    .ddr_odt                    (c1_ddr4_odt),
//    .ddr_act_n                  (c1_ddr4_act_n),
//    .ddr_adr                    (c1_ddr4_adr),
//    .ddr_ba                     (c1_ddr4_ba),
//    .ddr_bg                     (c1_ddr4_bg),
//    .ddr_reset_n                (c1_ddr4_reset_n),
//    .ddr_dm_dbi_n               (c1_ddr4_dm_n),
//    .ddr_dq                     (c1_ddr4_dq),
//    .ddr_dqs_c                  (c1_ddr4_dqs_c),
//    .ddr_dqs_t                  (c1_ddr4_dqs_t)
//);

BY_mc_top u_mc_top (
    .io_clk                                  (core_ddrc_core_clk),
    .io_rst                                  (!core_ddrc_rstn),
//        .io_axi_wch_aw_ready                   (awready_0),
//    .io_axi_wch_aw_valid                   (awvalid_0),
//    .io_axi_wch_aw_bits_id                 (awid_0[13:0]),
//    .io_axi_wch_aw_bits_addr               (awaddr_0),    
//    .io_axi_wch_aw_bits_len                (awlen_0),    
//    .io_axi_wch_aw_bits_size               (awsize_0),    
//    .io_axi_wch_aw_bits_burst              (awburst_0),    
//    .io_axi_wch_aw_bits_lock               (awlock_0),    
//    .io_axi_wch_aw_bits_cache              (awcache_0),    
//    .io_axi_wch_aw_bits_prot               (awprot_0),    
//    .io_axi_wch_aw_bits_qos                (awqos_0),    
//    .io_axi_wch_w_ready                    (wready_0),
//    .io_axi_wch_w_valid                    (wvalid_0),
//    .io_axi_wch_w_bits_data                (wdata_0),    
//    .io_axi_wch_w_bits_strb                (wstrb_0),    
//    .io_axi_wch_w_bits_last                (wlast_0),    
//    .io_axi_wch_b_ready                    (bready_0),
//    .io_axi_wch_b_valid                    (bvalid_0),
//    .io_axi_wch_b_bits_id                  (mc_bid_0),
//    .io_axi_wch_b_bits_resp                (bresp_0),    
//    .io_axi_rch_ar_ready                   (arready_0),
//    .io_axi_rch_ar_valid                   (arvalid_0),
//    .io_axi_rch_ar_bits_id                 (arid_0[13:0]),
//    .io_axi_rch_ar_bits_addr               (araddr_0),    
//    .io_axi_rch_ar_bits_len                (arlen_0),    
//    .io_axi_rch_ar_bits_size               (arsize_0),    
//    .io_axi_rch_ar_bits_burst              (arburst_0),    
//    .io_axi_rch_ar_bits_lock               (arlock_0),    
//    .io_axi_rch_ar_bits_cache              (arcache_0),    
//    .io_axi_rch_ar_bits_prot               (arprot_0),    
//    .io_axi_rch_ar_bits_qos                (arqos_0),    
//    .io_axi_rch_r_ready                    (rready_0),
//    .io_axi_rch_r_valid                    (rvalid_0),
//    .io_axi_rch_r_bits_id                  (mc_rid_0),
//    .io_axi_rch_r_bits_data                (rdata_0),    
//    .io_axi_rch_r_bits_resp                (rresp_0),    
//    .io_axi_rch_r_bits_last                (rlast_0),

.io_awio_awid                            (awid_0[13:0]),
    .io_awio_awaddr                          (awaddr_0),
    .io_awio_awlen                           (awlen_0),
    .io_awio_awsize                          (awsize_0),
    .io_awio_awburst                         (awburst_0),
    .io_awio_awuser                          (awuser_0[0]),
    .io_awio_awqos                           (awqos_0),
    .io_awio_awvalid                         (awvalid_0),
    .io_awio_awready                         (awready_0),
    .io_wio_wuser                            (wuser_0[0]),
    .io_wio_wdata                            (wdata_0),
    .io_wio_wstrb                            (wstrb_0),
    .io_wio_wlast                            (wlast_0),
    .io_wio_wvalid                           (wvalid_0),
    .io_wio_wready                           (wready_0),
    .io_bio_bid                              (mc_bid_0),
    .io_bio_bresp                            (bresp_0),
    .io_bio_buser                            (mc_buser_0),
    .io_bio_bvalid                           (bvalid_0),
    .io_bio_bready                           (bready_0),
    .io_ario_arid                            (arid_0[13:0]),
    .io_ario_araddr                          (araddr_0),
    .io_ario_arlen                           (arlen_0),
    .io_ario_arsize                          (arsize_0),
    .io_ario_arburst                         (arburst_0),
    .io_ario_aruser                          (aruser_0[0]),
    .io_ario_arqos                           (arqos_0),
    .io_ario_arvalid                         (arvalid_0),
    .io_ario_arready                         (arready_0),
    .io_rio_rid                              (mc_rid_0),
    .io_rio_ruser                            (mc_ruser_0),
    .io_rio_rdata                            (rdata_0),
    .io_rio_rresp                            (rresp_0),
    .io_rio_rlast                            (rlast_0),
    .io_rio_rvalid                           (rvalid_0),
    .io_rio_rready                           (rready_0),
    .io_dfi_dfictrl_dfi_address_0           (c0_dfi_address_0),
    .io_dfi_dfictrl_dfi_address_1           (c0_dfi_address_1),
    .io_dfi_dfictrl_dfi_bank_0              (c0_dfi_bank_0),
    .io_dfi_dfictrl_dfi_bank_1              (c0_dfi_bank_1),
    .io_dfi_dfictrl_dfi_ras_n_0             (c0_dfi_ras_n_0),
    .io_dfi_dfictrl_dfi_ras_n_1             (c0_dfi_ras_n_1),
    .io_dfi_dfictrl_dfi_cas_n_0             (c0_dfi_cas_n_0),
    .io_dfi_dfictrl_dfi_cas_n_1             (c0_dfi_cas_n_1),
    .io_dfi_dfictrl_dfi_we_n_0              (c0_dfi_we_n_0),
    .io_dfi_dfictrl_dfi_we_n_1              (c0_dfi_we_n_1),
    .io_dfi_dfictrl_dfi_cs_n_0_0            (c0_dfi_cs_n_0_0),
    .io_dfi_dfictrl_dfi_cs_n_0_1            (c0_dfi_cs_n_0_1),
    .io_dfi_dfictrl_dfi_cs_n_1_0            (c0_dfi_cs_n_1_0),
    .io_dfi_dfictrl_dfi_cs_n_1_1            (c0_dfi_cs_n_1_1),
    .io_dfi_dfictrl_dfi_act_n_0             (c0_dfi_act_n_0),
    .io_dfi_dfictrl_dfi_act_n_1             (c0_dfi_act_n_1),
    .io_dfi_dfictrl_dfi_bg_0                (c0_dfi_bg_0),
    .io_dfi_dfictrl_dfi_bg_1                (c0_dfi_bg_1),
    .io_dfi_dfictrl_dfi_cid                 (c0_dfi_cid),
    .io_dfi_dfictrl_dfi_cke_0_0             (c0_dfi_cke_0_0),
    .io_dfi_dfictrl_dfi_cke_0_1             (c0_dfi_cke_0_1),
    .io_dfi_dfictrl_dfi_cke_1_0             (c0_dfi_cke_1_0),
    .io_dfi_dfictrl_dfi_cke_1_1             (c0_dfi_cke_1_1),
    .io_dfi_dfictrl_dfi_odt_0_0             (c0_dfi_odt_0_0),
    .io_dfi_dfictrl_dfi_odt_0_1             (c0_dfi_odt_0_1),
    .io_dfi_dfictrl_dfi_odt_1_0             (c0_dfi_odt_1_0),
    .io_dfi_dfictrl_dfi_odt_1_1             (c0_dfi_odt_1_1),
    .io_dfi_dfictrl_dfi_reset_n_0_0         (c0_dfi_reset_n_0_0),
    .io_dfi_dfictrl_dfi_reset_n_0_1         (c0_dfi_reset_n_0_1),
    .io_dfi_dfictrl_dfi_reset_n_1_0         (c0_dfi_reset_n_1_0),
    .io_dfi_dfictrl_dfi_reset_n_1_1         (c0_dfi_reset_n_1_1),
    .io_dfi_dfiwrdata_dfi_wrdata_en         (c0_dfi_wrdata_en),
    .io_dfi_dfiwrdata_dfi_wdata             (c0_dfi_wrdata),
    .io_dfi_dfiwrdata_dfi_wdata_cs_n        (c0_dfi_wdata_cs_n),
    .io_dfi_dfiwrdata_dfi_wdata_mask        (c0_dfi_wrdata_mask),
    .io_dfi_dfirddata_dfi_rddata_en         (c0_dfi_rddata_en),
    .io_dfi_dfirddata_dfi_rddata            (c0_dfi_rddata),
    .io_dfi_dfirddata_dfi_rddata_cs_n       (c0_dfi_rddata_cs_n),
    .io_dfi_dfirddata_dfi_rddata_valid      (c0_dfi_rddata_valid),
    .io_dfi_dfirddata_dfi_rddata_dbi_n      (32'hFFFF_FFFF),
    .io_dfi_dfiupdate_dfi_ctrlupd_req       (c0_dfi_ctrlupd_req),
    .io_dfi_dfiupdate_dfi_ctrlupd_ack       (1'b0),
    .io_dfi_dfiupdate_dfi_phyupd_req        (1'b0),
    .io_dfi_dfiupdate_dfi_phyupd_type       (2'b00),
    .io_dfi_dfiupdate_dfi_phyupd_ack        (c0_dfi_phyupd_ack),
    .io_dfi_dfistatus_dfi_data_byte_disable (c0_dfi_data_byte_disable),
    .io_dfi_dfistatus_dfi_dram_clk_disable  (c0_dfi_dram_clk_disable),
    .io_dfi_dfistatus_dfi_freq_ratio        (c0_dfi_freq_ratio),
    .io_dfi_dfistatus_dfi_init_start        (c0_dfi_init_start),
    .io_dfi_dfistatus_dfi_init_complete     (c0_init_calib_complete_r2),
    .io_dfi_dfistatus_dfi_parity_in         (c0_dfi_parity_in),
    .io_dfi_dfistatus_dfi_alert_n           (2'b11),
//.io_dfi_1_dfictrl_dfi_address_0           (c1_dfi_address_0),
//    .io_dfi_1_dfictrl_dfi_address_1           (c1_dfi_address_1),
//    .io_dfi_1_dfictrl_dfi_bank_0              (c1_dfi_bank_0),
//    .io_dfi_1_dfictrl_dfi_bank_1              (c1_dfi_bank_1),
//    .io_dfi_1_dfictrl_dfi_ras_n_0             (c1_dfi_ras_n_0),
//    .io_dfi_1_dfictrl_dfi_ras_n_1             (c1_dfi_ras_n_1),
//    .io_dfi_1_dfictrl_dfi_cas_n_0             (c1_dfi_cas_n_0),
//    .io_dfi_1_dfictrl_dfi_cas_n_1             (c1_dfi_cas_n_1),
//    .io_dfi_1_dfictrl_dfi_we_n_0              (c1_dfi_we_n_0),
//    .io_dfi_1_dfictrl_dfi_we_n_1              (c1_dfi_we_n_1),
//    .io_dfi_1_dfictrl_dfi_cs_n_0_0            (c1_dfi_cs_n_0_0),
//    .io_dfi_1_dfictrl_dfi_cs_n_0_1            (c1_dfi_cs_n_0_1),
//    .io_dfi_1_dfictrl_dfi_cs_n_1_0            (c1_dfi_cs_n_1_0),
//    .io_dfi_1_dfictrl_dfi_cs_n_1_1            (c1_dfi_cs_n_1_1),
//    .io_dfi_1_dfictrl_dfi_act_n_0             (c1_dfi_act_n_0),
//    .io_dfi_1_dfictrl_dfi_act_n_1             (c1_dfi_act_n_1),
//    .io_dfi_1_dfictrl_dfi_bg_0                (c1_dfi_bg_0),
//    .io_dfi_1_dfictrl_dfi_bg_1                (c1_dfi_bg_1),
//    .io_dfi_1_dfictrl_dfi_cid                 (c1_dfi_cid),
//    .io_dfi_1_dfictrl_dfi_cke_0_0             (c1_dfi_cke_0_0),
//    .io_dfi_1_dfictrl_dfi_cke_0_1             (c1_dfi_cke_0_1),
//    .io_dfi_1_dfictrl_dfi_cke_1_0             (c1_dfi_cke_1_0),
//    .io_dfi_1_dfictrl_dfi_cke_1_1             (c1_dfi_cke_1_1),
//    .io_dfi_1_dfictrl_dfi_odt_0_0             (c1_dfi_odt_0_0),
//    .io_dfi_1_dfictrl_dfi_odt_0_1             (c1_dfi_odt_0_1),
//    .io_dfi_1_dfictrl_dfi_odt_1_0             (c1_dfi_odt_1_0),
//    .io_dfi_1_dfictrl_dfi_odt_1_1             (c1_dfi_odt_1_1),
//    .io_dfi_1_dfictrl_dfi_reset_n_0_0         (c1_dfi_reset_n_0_0),
//    .io_dfi_1_dfictrl_dfi_reset_n_0_1         (c1_dfi_reset_n_0_1),
//    .io_dfi_1_dfictrl_dfi_reset_n_1_0         (c1_dfi_reset_n_1_0),
//    .io_dfi_1_dfictrl_dfi_reset_n_1_1         (c1_dfi_reset_n_1_1),
//    .io_dfi_1_dfiwrdata_dfi_wrdata_en         (c1_dfi_wrdata_en),
//    .io_dfi_1_dfiwrdata_dfi_wdata             (c1_dfi_wrdata),
//    .io_dfi_1_dfiwrdata_dfi_wdata_cs_n        (c1_dfi_wdata_cs_n),
//    .io_dfi_1_dfiwrdata_dfi_wdata_mask        (c1_dfi_wrdata_mask),
//    .io_dfi_1_dfirddata_dfi_rddata_en         (c1_dfi_rddata_en),
//    .io_dfi_1_dfirddata_dfi_rddata            (c1_dfi_rddata),
//    .io_dfi_1_dfirddata_dfi_rddata_cs_n       (c1_dfi_rddata_cs_n),
//    .io_dfi_1_dfirddata_dfi_rddata_valid      (c1_dfi_rddata_valid),
//    .io_dfi_1_dfirddata_dfi_rddata_dbi_n      (32'hFFFF_FFFF),
//    .io_dfi_1_dfiupdate_dfi_ctrlupd_req       (c1_dfi_ctrlupd_req),
//    .io_dfi_1_dfiupdate_dfi_ctrlupd_ack       (1'b0),
//    .io_dfi_1_dfiupdate_dfi_phyupd_req        (1'b0),
//    .io_dfi_1_dfiupdate_dfi_phyupd_type       (2'b00),
//    .io_dfi_1_dfiupdate_dfi_phyupd_ack        (c1_dfi_phyupd_ack),
//    .io_dfi_1_dfistatus_dfi_data_byte_disable (c1_dfi_data_byte_disable),
//    .io_dfi_1_dfistatus_dfi_dram_clk_disable  (c1_dfi_dram_clk_disable),
//    .io_dfi_1_dfistatus_dfi_freq_ratio        (c1_dfi_freq_ratio),
//    .io_dfi_1_dfistatus_dfi_init_start        (c1_dfi_init_start),
//    .io_dfi_1_dfistatus_dfi_init_complete     (c1_init_calib_complete_r2),
//    .io_dfi_1_dfistatus_dfi_parity_in         (c1_dfi_parity_in),
//    .io_dfi_1_dfistatus_dfi_alert_n           (2'b11),
    .io_apb_pclk                             (pclk),
    .io_apb_presetn                          (o_presetn),
    .io_apb_paddr                            (paddr_mc),
    .io_apb_pwdata                           (pwdata_mc),
    .io_apb_pwrite                           (pwrite_mc),
    .io_apb_psel                             (psel_mc),
    .io_apb_penable                          (penable_mc),
    .io_apb_pready                           (pready_mc),
    .io_apb_prdata                           (prdata_mc),
    .io_apb_pslverr                          (pslverr_mc),
    .io_mig_phy_done                      (c0_init_calib_complete_r2)
//    .io_Phy_init_done_1                      (c1_init_calib_complete_r2)
);

endmodule


module ddr4_famse_mig_channel #(
    parameter integer CHANNEL_ID = 0
) (
    input          sys_rst,
    input          sys_clk_p,
    input          sys_clk_n,
    input          dfi_clk,
    input          rst_n,
    output         ddr4_ui_clk,
    output         ddr4_ui_clk_sync_rst,
    output         init_calib_complete,
    output         addn_ui_clkout1,
    output         addn_ui_clkout2,

    input  [16:0]  dfi_address_0,
    input  [16:0]  dfi_address_1,
    input  [1:0]   dfi_bank_0,
    input  [1:0]   dfi_bank_1,
    input          dfi_ras_n_0,
    input          dfi_ras_n_1,
    input          dfi_cas_n_0,
    input          dfi_cas_n_1,
    input          dfi_we_n_0,
    input          dfi_we_n_1,
    input          dfi_cs_n_0_0,
    input          dfi_cs_n_0_1,
    input          dfi_cs_n_1_0,
    input          dfi_cs_n_1_1,
    input          dfi_act_n_0,
    input          dfi_act_n_1,
    input  [1:0]   dfi_bg_0,
    input  [1:0]   dfi_bg_1,
    input          dfi_cke_0_0,
    input          dfi_cke_0_1,
    input          dfi_cke_1_0,
    input          dfi_cke_1_1,
    input          dfi_odt_0_0,
    input          dfi_odt_0_1,
    input          dfi_odt_1_0,
    input          dfi_odt_1_1,
    input          dfi_reset_n_0_0,
    input          dfi_reset_n_0_1,
    input          dfi_reset_n_1_0,
    input          dfi_reset_n_1_1,
    input  [15:0]  dfi_wrdata_en,
    input  [255:0] dfi_wrdata,
    input  [31:0]  dfi_wrdata_mask,
    input  [15:0]  dfi_rddata_en,
    output [255:0] dfi_rddata,
    output [15:0]  dfi_rddata_valid,

    output [1:0]   ddr_ck_t,
    output [1:0]   ddr_ck_c,
    output [1:0]   ddr_cke,
    output [1:0]   ddr_cs_n,
    output [1:0]   ddr_odt,
    output         ddr_act_n,
    output [16:0]  ddr_adr,
    output [1:0]   ddr_ba,
    output [1:0]   ddr_bg,
    output         ddr_reset_n,
    inout  [7:0]   ddr_dm_dbi_n,
    inout  [63:0]  ddr_dq,
    inout  [7:0]   ddr_dqs_c,
    inout  [7:0]   ddr_dqs_t
);

wire [35:0]  famse_dfi_address;
wire [5:0]   famse_dfi_ba;
wire [3:0]   famse_dfi_bg;
wire [1:0]   famse_dfi_act_n;
wire [1:0]   famse_dfi_cas_n;
wire [1:0]   famse_dfi_ras_n;
wire [1:0]   famse_dfi_we_n;
wire [3:0]   famse_dfi_cke;
wire [3:0]   famse_dfi_cs_n;
wire [3:0]   famse_dfi_odt;
wire [3:0]   famse_dfi_reset_n;
wire [7:0]   famse_dfi_rddata_valid;
wire         famseV2_dfi_rddata_valid;
wire [511:0] mig_wrData;
wire [63:0]  mig_wrDataMask;
wire [511:0] mig_rdData;
wire [0:0]   mig_rdDataEn;
wire [0:0]   mig_per_rd_done;
wire [0:0]   mig_wrDataEn;
wire [7:0]   mig_mc_ACT_n;
wire [135:0] mig_mc_ADR;
wire [15:0]  mig_mc_BA;
wire [15:0]  mig_mc_BG;
wire [15:0]  mig_mc_CKE;
wire [15:0]  mig_mc_CS_n;
wire [15:0]  mig_mc_ODT;
wire [1:0]   mig_mcCasSlot;
wire [0:0]   mig_mcCasSlot2;
wire [0:0]   mig_mcRdCAS;
wire [0:0]   mig_mcWrCAS;
wire [0:0]   mig_winInjTxn;
wire [4:0]   mig_winBuf;
wire [1:0]   mig_winRank;
wire [5:0]   mig_tCWL;
wire         mig_gt_data_ready;

assign famse_dfi_address      = {1'b0, dfi_address_1, 1'b0, dfi_address_0};
assign famse_dfi_ba           = {1'b0, dfi_bank_1, 1'b0, dfi_bank_0};
assign famse_dfi_bg           = {dfi_bg_1, dfi_bg_0};
assign famse_dfi_act_n        = {dfi_act_n_1, dfi_act_n_0};
assign famse_dfi_cas_n        = {dfi_cas_n_1, dfi_cas_n_0};
assign famse_dfi_ras_n        = {dfi_ras_n_1, dfi_ras_n_0};
assign famse_dfi_we_n         = {dfi_we_n_1, dfi_we_n_0};
assign famse_dfi_cke          = {dfi_cke_1_1, dfi_cke_1_0, dfi_cke_0_1, dfi_cke_0_0};
assign famse_dfi_cs_n         = {dfi_cs_n_1_1, dfi_cs_n_1_0, dfi_cs_n_0_1, dfi_cs_n_0_0};
assign famse_dfi_odt          = {dfi_odt_1_1, dfi_odt_1_0, dfi_odt_0_1, dfi_odt_0_0};
assign famse_dfi_reset_n      = {dfi_reset_n_1_1, dfi_reset_n_1_0, dfi_reset_n_0_1, dfi_reset_n_0_0};

`ifdef FAMSEV1
assign dfi_rddata_valid       = {2{famse_dfi_rddata_valid}};
`else
assign dfi_rddata_valid       = {16{famseV2_dfi_rddata_valid}};
`endif

`ifdef FAMSEV1
    famse_top #(
	 .NUMREF               ( 1               ),
	 .RANKS                ( 2               ),
	 .RANK_SLOT            ( 2               ),  
	 .tREFI                ( 8315            ),
	 .tRFC                 ( 374             ),
	 .tRFC_dlr             ( 9  	         ),
	 .tRP                  ( 16  	         ),
	 .tWR                  ( 16  	         ),
	 .ZQINTVL              ( 1066098082  	 ),
	 .tZQCS                ( 128  	         ),
	 .TCQ                  ( 0.1  	         ),
	 .REG_CTRL             ("OFF"  	         ),
	 .PARTIAL_RECONFIG     ("Disable"        ),
	 .RANK_W  			   ( 2               ),
	 .DFI_ACT_W  		   ( 2               ),
	 .DFI_ADDR_W 		   ( 36              ),
	 .DFI_BA_W   		   ( 6               ), //3bit one more bit
	 .DFI_BG_W   		   ( 4               ),
	 .DFI_CAS_W  		   ( 2               ),
	 .DFI_CKE_W  		   ( 4               ),
	 .DFI_CS_W   		   ( 4               ),
	 .DFI_ODT_W  		   ( 4               ),
	 .DFI_RAS_W  		   ( 2               ),
	 .DFI_RES_W  		   ( 4               ),
	 .DFI_WE_W   		   ( 2               ),
	 .DFI_DATA_M_W         ( 256/8    ),
     .DFI_DATA_W           ( 256             ),
     .DFI_DATA_EN_W        ( 16             ),
     .T_PHY_RDLAT    	   ( 13	             ), 
     .PER_RD_INTVL    	   ( 32'd267         ), //vt tracing
     .MIG_DATA_W          (	512              ),
	 .MIG_DATA_M_W        (	512/8     ),
	 .MIG_ACT_N_W          ( 8               ),  
	 .MIG_ADR_W            ( 136             ),  
	 .MIG_BA_W             ( 16              ),  
	 .MIG_BG_W             ( 16              ),  
	 .MIG_CKE_W            ( 16              ),  
	 .MIG_CS_N_W           ( 16              ),  
	 .MIG_ODT_W            ( 16              ),
	 .ACT_WAIT_NUM	      (	2	             ),
	 .WRITE_WAIT_NUM	  (	2	             ),
	 .READ_WAIT_NUM	      (	2	             ),
	 .PRE_WAIT_NUM	      (	2	             ),
	 .REF_WAIT_NUM	      (	2	             ),
	 .ZQ_CAL_WAIT_NUM	  (	2     			 )
	)
	 u_famse
	(
		.dfi_clk           (dfi_clk) ,
		.mig_clk           (ddr4_ui_clk) ,
		.rst_n             (rst_n) ,
		.calDone           (init_calib_complete) ,
		.tCWL              (mig_tCWL) ,
		
		.dfi_act_n         (famse_dfi_act_n         ) ,
		.dfi_address       (famse_dfi_address    ) ,
		.dfi_ba            ({1'b0, famse_dfi_ba[3:2], 1'b0, famse_dfi_ba[1:0] }          ) ,
		.dfi_bg            (famse_dfi_bg            ) ,
		.dfi_cas_n         (famse_dfi_cas_n         ) ,
		.dfi_cke           (famse_dfi_cke        ) ,
		.dfi_cs            (famse_dfi_cs_n       ) ,
		.dfi_odt           (famse_dfi_odt        ) ,
		.dfi_ras_n         (famse_dfi_ras_n         ) ,
		.dfi_reset_n       (famse_dfi_reset_n       ) ,
		.dfi_we_n          (famse_dfi_we_n          ) ,
		.dfi_rddata_en     (dfi_rddata_en  ) ,
		.dfi_rddata        (dfi_rddata        ) ,
		.dfi_rddata_valid  (famse_dfi_rddata_valid  ) ,
		.dfi_wrdata_i      (dfi_wrdata        ) ,
		.dfi_wrdata_en_i   (dfi_wrdata_en  ) ,
		.dfi_wrdata_mask_i (dfi_wrdata_mask   ) ,
		
		.mc_ACT_n          (mig_mc_ACT_n) ,
		.mc_ADR            (mig_mc_ADR) ,
		.mc_BA             (mig_mc_BA) ,
		.mc_BG             (mig_mc_BG) ,
		.mc_CKE            (mig_mc_CKE) ,
		.mc_CS_n           (mig_mc_CS_n) ,
		.mc_ODT            (mig_mc_ODT) ,
		.winRank           (mig_winRank) ,
		.mcRdCAS           (mig_mcRdCAS) ,
		.mcWrCAS           (mig_mcWrCAS) ,
		.mcCasSlot         (mig_mcCasSlot) ,
		.mcCasSlot2        (mig_mcCasSlot2) ,
		.per_rd_done       (mig_per_rd_done) ,
		.mig_rddata        (mig_rdData) ,
		.mig_rddata_en     (mig_rdDataEn) ,
		.winInjTxn         (mig_winInjTxn) ,
		.winBuf			   (mig_winBuf) ,
		.gt_data_ready     (mig_gt_data_ready) ,
//		.wrdata_en         (mig_wrDataEn),
		.mig_wdata         (mig_wrData) ,
		.mig_wdata_mask    (mig_wrDataMask) 
);
`else 
famsev2_top u_famsev2_top(      
    .dfi_clk                    (dfi_clk),        
    .mig_clk                    (ddr4_ui_clk),        
    .rst_n                      (rst_n),    
    .calDone                    (init_calib_complete),

    //////////////dfi cmd interface/////////////                 
    .dfi_reset_n                (famse_dfi_reset_n),                 
    .dfi_cke                    (famse_dfi_cke),             
    .dfi_odt                    (famse_dfi_odt),             
    .dfi_address                (famse_dfi_address),                 
    .dfi_ba                     (famse_dfi_ba),            
    .dfi_bg                     (famse_dfi_bg),            
    .dfi_cs_n                   (famse_dfi_cs_n),              
    .dfi_act_n                  (famse_dfi_act_n),               
    .dfi_ras_n                  (famse_dfi_ras_n),               
    .dfi_cas_n                  (famse_dfi_cas_n),               
    .dfi_we_n                   (famse_dfi_we_n),
    //////////////dfi rddata interface//////////////
    .dfi_rddata_en              (dfi_rddata_en[0]),
    .dfi_rddata                 (dfi_rddata),
    .dfi_rddata_valid           (famseV2_dfi_rddata_valid),
    //////////////dfi wrdata interface//////////////
    .dfi_wrdata_en              (dfi_wrdata_en[0]),
    .dfi_wrdata                 (dfi_wrdata),
    .dfi_wrdata_mask            (dfi_wrdata_mask),

    //////////////mig cmd interface/////////////           
    .mc_ACT_n                   (mig_mc_ACT_n),       
    .mc_ADR                     (mig_mc_ADR),     
    .mc_BA                      (mig_mc_BA),    
    .mc_BG                      (mig_mc_BG),    
    .mc_CKE                     (mig_mc_CKE),     
    .mc_CS_n                    (mig_mc_CS_n),      
    .mc_ODT                     (mig_mc_ODT),     
    .winRank                    (mig_winRank),      
    .mcRdCAS                    (mig_mcRdCAS),      
    .mcWrCAS                    (mig_mcWrCAS),      
    .mcCasSlot                  (mig_mcCasSlot),        
    .mcCasSlot2                 (mig_mcCasSlot2),         
    .winBuf                     (mig_winBuf),     
    .winInjTxn                  (mig_winInjTxn),
    //////////////mig rddata interface/////////////    
    .mig_rddata_en              (mig_rdDataEn), 
    .mig_rddata                 (mig_rdData),
    .per_rd_done                (mig_per_rd_done),
    .gt_data_ready              (mig_gt_data_ready),
    //////////////mig wrdata interface//////////////
    .mig_wrdata_en              (mig_wrDataEn),
    .mig_wrdata                 (mig_wrData),
    .mig_wrdata_mask            (mig_wrDataMask)
);
`endif
generate
if (CHANNEL_ID == 0) begin : gen_ddr4_0
    ddr4_0 u_ddr4_phy (
        .sys_rst                  (sys_rst),
        .c0_sys_clk_p             (sys_clk_p),
        .c0_sys_clk_n             (sys_clk_n),
        .c0_ddr4_ui_clk           (ddr4_ui_clk),
        .c0_ddr4_ui_clk_sync_rst  (ddr4_ui_clk_sync_rst),
        .dbg_clk                  (),
        .c0_ddr4_act_n            (ddr_act_n),
        .c0_ddr4_adr              (ddr_adr),
        .c0_ddr4_ba               (ddr_ba),
        .c0_ddr4_bg               (ddr_bg),
        .c0_ddr4_cke              (ddr_cke),
        .c0_ddr4_odt              (ddr_odt),
        .c0_ddr4_cs_n             (ddr_cs_n),
        .c0_ddr4_ck_t             (ddr_ck_t),
        .c0_ddr4_ck_c             (ddr_ck_c),
        .c0_ddr4_reset_n          (ddr_reset_n),
        .c0_ddr4_dm_dbi_n         (ddr_dm_dbi_n),
        .c0_ddr4_dq               (ddr_dq),
        .c0_ddr4_dqs_c            (ddr_dqs_c),
        .c0_ddr4_dqs_t            (ddr_dqs_t),
        .c0_init_calib_complete   (init_calib_complete),
        .addn_ui_clkout1          (addn_ui_clkout1),
        .addn_ui_clkout2          (addn_ui_clkout2),
//        .addn_ui_clkout3          (),
//        .addn_ui_clkout4          (),
        .dBufAdr                  (5'b00000),
        .wrData                   (mig_wrData),
        .wrDataMask               (mig_wrDataMask),
        .rdData                   (mig_rdData),
        .rdDataAddr               (),
        .rdDataEn                 (mig_rdDataEn),
        .rdDataEnd                (),
        .per_rd_done              (mig_per_rd_done),
        .rmw_rd_done              (),
        .wrDataAddr               (),
        .wrDataEn                 (mig_wrDataEn),
        .mc_ACT_n                 (mig_mc_ACT_n),
        .mc_ADR                   (mig_mc_ADR),
        .mc_BA                    (mig_mc_BA),
        .mc_BG                    (mig_mc_BG),
        .mc_CKE                   (mig_mc_CKE),
        .mc_CS_n                  (mig_mc_CS_n),
        .mc_ODT                   (mig_mc_ODT),
        .mcCasSlot                (mig_mcCasSlot),
        .mcCasSlot2               (mig_mcCasSlot2),
        .mcRdCAS                  (mig_mcRdCAS),
        .mcWrCAS                  (mig_mcWrCAS),
        .winInjTxn                (mig_winInjTxn),
        .winRmw                   (1'b0),
        .gt_data_ready            (mig_gt_data_ready),
        .winBuf                   (mig_winBuf),
        .winRank                  (mig_winRank),
        .tCWL                     (mig_tCWL),
        .dbg_bus                  ()
    );
end 
//else begin : gen_ddr4_1
//    assign addn_ui_clkout1 = 1'b0;
//    assign addn_ui_clkout2 = 1'b0;

//    ddr4_1 u_ddr4_phy (
//        .sys_rst                  (sys_rst),
//        .c0_sys_clk_p             (sys_clk_p),
//        .c0_sys_clk_n             (sys_clk_n),
//        .c0_ddr4_ui_clk           (ddr4_ui_clk),
//        .c0_ddr4_ui_clk_sync_rst  (ddr4_ui_clk_sync_rst),
//        .dbg_clk                  (),
//        .c0_ddr4_act_n            (ddr_act_n),
//        .c0_ddr4_adr              (ddr_adr),
//        .c0_ddr4_ba               (ddr_ba),
//        .c0_ddr4_bg               (ddr_bg),
//        .c0_ddr4_cke              (ddr_cke),
//        .c0_ddr4_odt              (ddr_odt),
//        .c0_ddr4_cs_n             (ddr_cs_n),
//        .c0_ddr4_ck_t             (ddr_ck_t),
//        .c0_ddr4_ck_c             (ddr_ck_c),
//        .c0_ddr4_reset_n          (ddr_reset_n),
//        .c0_ddr4_dm_dbi_n         (ddr_dm_dbi_n),
//        .c0_ddr4_dq               (ddr_dq),
//        .c0_ddr4_dqs_c            (ddr_dqs_c),
//        .c0_ddr4_dqs_t            (ddr_dqs_t),
//        .c0_init_calib_complete   (init_calib_complete),
//        .dBufAdr                  (5'b00000),
//        .wrData                   (mig_wrData),
//        .wrDataMask               (mig_wrDataMask),
//        .rdData                   (mig_rdData),
//        .rdDataAddr               (),
//        .rdDataEn                 (mig_rdDataEn),
//        .rdDataEnd                (),
//        .per_rd_done              (mig_per_rd_done),
//        .rmw_rd_done              (),
//        .wrDataAddr               (),
//        .wrDataEn                 (mig_wrDataEn),
//        .mc_ACT_n                 (mig_mc_ACT_n),
//        .mc_ADR                   (mig_mc_ADR),
//        .mc_BA                    (mig_mc_BA),
//        .mc_BG                    (mig_mc_BG),
//        .mc_CKE                   (mig_mc_CKE),
//        .mc_CS_n                  (mig_mc_CS_n),
//        .mc_ODT                   (mig_mc_ODT),
//        .mcCasSlot                (mig_mcCasSlot),
//        .mcCasSlot2               (mig_mcCasSlot2),
//        .mcRdCAS                  (mig_mcRdCAS),
//        .mcWrCAS                  (mig_mcWrCAS),
//        .winInjTxn                (mig_winInjTxn),
//        .winRmw                   (1'b0),
//        .gt_data_ready            (mig_gt_data_ready),
//        .winBuf                   (mig_winBuf),
//        .winRank                  (mig_winRank),
//        .tCWL                     (mig_tCWL),
//        .dbg_bus                  ()
//    );
//end
endgenerate

endmodule

