//===================================================================
//  Desiger   : zhangjunming
//  Date      : 2020.11.18    
//  Called by : Called by CRG
//  Company   : Peng Cheng Labiratory(PCL)  
//  Version   : V1.0 Function is OK.
//===================================================================
module RST_SYNC
#(
        parameter   SYN_NUM = 3
)
(
    input       wire            i_clk       ,
    input       wire            i_rstn      ,
    input       wire            i_dft_mode  ,
    input       wire            i_dft_rstn  ,
    input       wire            i_scan_mode ,
    output      wire            o_rstn      
);
//===================================================================
wire    dft_rstn    ;

assign  dft_rstn    = i_dft_mode ? i_dft_rstn : i_rstn;

reg     [SYN_NUM -1:0]      pip_rst;

always @(posedge i_clk or negedge dft_rstn)begin
    if(dft_rstn == 1'b0)begin
        pip_rst <= {SYN_NUM{1'b0}};
    end
    else begin
        pip_rst <= {pip_rst[SYN_NUM -2:0], 1'b1};
    end
end
//For DFT required, can contorl the rstn.
assign o_rstn = i_scan_mode ? i_dft_rstn : pip_rst[SYN_NUM -1];

//===================================================================
endmodule
