module ddr_crg (
    //DFT
    input   wire            dft_mode            ,
    input   wire            dft_lgc_rstn        ,
    input   wire            scan_mode           ,
    input   wire            dft_glb_gt_se       ,
    //----------
    input   wire            core_ddrc_core_clk ,
    input   wire            core_ddrc_rstn     ,
    input   wire            aclk_0             ,
    input   wire            aresetn_0          ,
    input   wire            pclk               ,
    input   wire            presetn            ,
    input   wire            init_rstn_mc       ,
    //----------
    output  wire            o_core_ddrc_rstn   ,      
    output  wire            o_aresetn_0        ,      
    output  wire            axi_bus_rst_n      ,      


    output  wire            o_presetn                
);
    wire                    core_ddrc_rstn_tep  ;
    wire                    aresetn_0_tep       ;

assign core_ddrc_rstn_tep = core_ddrc_rstn && init_rstn_mc;
RST_SYNC core_ddrc_rstn_sync (
    .i_clk          (core_ddrc_core_clk        ),
    .i_rstn         (core_ddrc_rstn_tep        ),
    .i_dft_mode     (dft_mode                  ),
    .i_dft_rstn     (dft_lgc_rstn              ),
    .i_scan_mode    (scan_mode                 ),
    .o_rstn         (o_core_ddrc_rstn          )
);
assign aresetn_0_tep = aresetn_0 && init_rstn_mc;
RST_SYNC aresetn_0_sync (
    .i_clk          (aclk_0                    ),
    .i_rstn         (aresetn_0_tep             ),
    .i_dft_mode     (dft_mode                  ),
    .i_dft_rstn     (dft_lgc_rstn              ),
    .i_scan_mode    (scan_mode                 ),
    .o_rstn         (o_aresetn_0               )
);

RST_SYNC axi_bus_rst_sync (
    .i_clk          (aclk_0                    ),
    .i_rstn         (aresetn_0                 ),
    .i_dft_mode     (dft_mode                  ),
    .i_dft_rstn     (dft_lgc_rstn              ),
    .i_scan_mode    (scan_mode                 ),
    .o_rstn         (axi_bus_rst_n             )
);
RST_SYNC presetn_sync (
    .i_clk          (pclk                      ),
    .i_rstn         (presetn                   ),
    .i_dft_mode     (dft_mode                  ),
    .i_dft_rstn     (dft_lgc_rstn              ),
    .i_scan_mode    (scan_mode                 ),
    .o_rstn         (o_presetn                 )
);

endmodule