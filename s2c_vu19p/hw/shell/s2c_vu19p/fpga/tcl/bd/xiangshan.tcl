
################################################################
# This is a generated script based on design: xiangshan
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2024.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source xiangshan_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# role_top, f2s_rising_intr_sync

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu19p-fsva3824-2-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name xiangshan

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:xdma:4.1\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:axi_register_slice:2.1\
xilinx.com:ip:clk_wiz:6.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
role_top\
f2s_rising_intr_sync\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set pcie_ep_gt_ref_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_ep_gt_ref_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $pcie_ep_gt_ref_clk

  set dut_rtc_ref_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dut_rtc_ref_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $dut_rtc_ref_clk

  set m_axi_ddr_mem [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_ddr_mem ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {36} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {10000000} \
   CONFIG.HAS_BRESP {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {0} \
   CONFIG.NUM_READ_OUTSTANDING {10} \
   CONFIG.NUM_WRITE_OUTSTANDING {10} \
   CONFIG.PROTOCOL {AXI4} \
   ] $m_axi_ddr_mem


  # Create ports
  set pcie_ep_perstn [ create_bd_port -dir I -type rst pcie_ep_perstn ]
  set pcie_ep_rxn [ create_bd_port -dir I -from 7 -to 0 pcie_ep_rxn ]
  set pcie_ep_rxp [ create_bd_port -dir I -from 7 -to 0 pcie_ep_rxp ]
  set pcie_ep_txn [ create_bd_port -dir O -from 7 -to 0 pcie_ep_txn ]
  set pcie_ep_txp [ create_bd_port -dir O -from 7 -to 0 pcie_ep_txp ]
  set ddr4_mig_calib_done [ create_bd_port -dir I ddr4_mig_calib_done ]
  set clock_8m [ create_bd_port -dir O clock_8m ]
  set clock_32m [ create_bd_port -dir O clock_32m ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {40000000} \
 ] $clock_32m

  # Create instance: u_role, and set properties
  set block_name role_top
  set block_cell_name u_role
  if { [catch {set u_role [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $u_role eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xdma_ep, and set properties
  set xdma_ep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_ep ]
  set_property -dict [list \
    CONFIG.axilite_master_en {true} \
    CONFIG.axilite_master_scale {Megabytes} \
    CONFIG.axilite_master_size {32} \
    CONFIG.axist_bypass_en {true} \
    CONFIG.axist_bypass_scale {Megabytes} \
    CONFIG.axist_bypass_size {256} \
    CONFIG.cfg_mgmt_if {false} \
    CONFIG.en_gt_selection {true} \
    CONFIG.functional_mode {DMA} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.pcie_blk_locn {PCIE4C_X0Y5} \
    CONFIG.pciebar2axibar_axil_master {0x10000000} \
    CONFIG.pf0_base_class_menu {Processing_accelerators} \
    CONFIG.pf0_sub_class_interface_menu {Unknown} \
    CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X8} \
    CONFIG.select_quad {GTY_Quad_232} \
    CONFIG.xdma_axi_intf_mm {AXI_Memory_Mapped} \
    CONFIG.xdma_pcie_64bit_en {false} \
  ] $xdma_ep


  # Create instance: axi_ic_ddr_mem, and set properties
  set axi_ic_ddr_mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_ddr_mem ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {2} \
  ] $axi_ic_ddr_mem


  # Create instance: axi_ic_ddr_mem_pcie, and set properties
  set axi_ic_ddr_mem_pcie [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_ddr_mem_pcie ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $axi_ic_ddr_mem_pcie


  # Create instance: axi_ic_ep_bar_axi_lite, and set properties
  set axi_ic_ep_bar_axi_lite [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_ep_bar_axi_lite ]
  set_property -dict [list \
    CONFIG.NUM_MI {4} \
    CONFIG.NUM_SI {1} \
  ] $axi_ic_ep_bar_axi_lite


  # Create instance: axi_ic_role_io_cross_domain, and set properties
  set axi_ic_role_io_cross_domain [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_role_io_cross_domain ]
  set_property -dict [list \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_SI {1} \
  ] $axi_ic_role_io_cross_domain


  # Create instance: host_uart, and set properties
  set host_uart [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 host_uart ]
  set_property CONFIG.C_BAUDRATE {115200} $host_uart


  # Create instance: role_uart, and set properties
  set role_uart [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 role_uart ]
  set_property CONFIG.C_BAUDRATE {115200} $role_uart


  # Create instance: bootrom_bram, and set properties
  set bootrom_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bootrom_bram ]
  set_property CONFIG.Memory_Type {True_Dual_Port_RAM} $bootrom_bram


  # Create instance: bootrom_bram_ctrl, and set properties
  set bootrom_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bootrom_bram_ctrl ]
  set_property -dict [list \
    CONFIG.PROTOCOL {AXI4LITE} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $bootrom_bram_ctrl


  # Create instance: axi_mm_base_reg, and set properties
  set axi_mm_base_reg [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_mm_base_reg ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x00000000} \
    CONFIG.C_GPIO_WIDTH {8} \
  ] $axi_mm_base_reg


  # Create instance: const_vcc, and set properties
  set const_vcc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_vcc ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x1} \
    CONFIG.CONST_WIDTH {1} \
  ] $const_vcc


  # Create instance: const_gnd, and set properties
  set const_gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_gnd ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x0} \
    CONFIG.CONST_WIDTH {1} \
  ] $const_gnd


  # Create instance: pcie_ep_ref_clk_buf, and set properties
  set pcie_ep_ref_clk_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 pcie_ep_ref_clk_buf ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $pcie_ep_ref_clk_buf


  # Create instance: ep_perst_gen, and set properties
  set ep_perst_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 ep_perst_gen ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $ep_perst_gen


  # Create instance: ddr4_mig_sync_reset, and set properties
  set ddr4_mig_sync_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ddr4_mig_sync_reset ]

  # Create instance: dut_rst_gen, and set properties
  set dut_rst_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 dut_rst_gen ]

  # Create instance: const_28b0, and set properties
  set const_28b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_28b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x0} \
    CONFIG.CONST_WIDTH {28} \
  ] $const_28b0


  # Create instance: slice_xdma_ep_m_axib_araddr, and set properties
  set slice_xdma_ep_m_axib_araddr [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_xdma_ep_m_axib_araddr ]
  set_property -dict [list \
    CONFIG.DIN_FROM {27} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {64} \
  ] $slice_xdma_ep_m_axib_araddr


  # Create instance: concat_axi_ic_ddr_mem_pcie_S00_AXI_araddr, and set properties
  set concat_axi_ic_ddr_mem_pcie_S00_AXI_araddr [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_axi_ic_ddr_mem_pcie_S00_AXI_araddr ]
  set_property CONFIG.NUM_PORTS {3} $concat_axi_ic_ddr_mem_pcie_S00_AXI_araddr


  # Create instance: slice_xdma_ep_m_axib_awaddr, and set properties
  set slice_xdma_ep_m_axib_awaddr [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_xdma_ep_m_axib_awaddr ]
  set_property -dict [list \
    CONFIG.DIN_FROM {27} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {64} \
  ] $slice_xdma_ep_m_axib_awaddr


  # Create instance: concat_axi_ic_ddr_mem_pcie_S00_AXI_awaddr, and set properties
  set concat_axi_ic_ddr_mem_pcie_S00_AXI_awaddr [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_axi_ic_ddr_mem_pcie_S00_AXI_awaddr ]
  set_property CONFIG.NUM_PORTS {3} $concat_axi_ic_ddr_mem_pcie_S00_AXI_awaddr


  # Create instance: intr_sync_pcie_slow, and set properties
  set block_name f2s_rising_intr_sync
  set block_cell_name intr_sync_pcie_slow
  if { [catch {set intr_sync_pcie_slow [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $intr_sync_pcie_slow eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.INTR_WIDTH {16} \
    CONFIG.SYNC_STAGE {2} \
  ] $intr_sync_pcie_slow


  # Create instance: role_intr_concat, and set properties
  set role_intr_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 role_intr_concat ]
  set_property CONFIG.NUM_PORTS {16} $role_intr_concat


  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property CONFIG.C_NUM_MONITOR_SLOTS {2} $system_ila_0


  # Create instance: axi_reg_slice_slr_xing, and set properties
  set axi_reg_slice_slr_xing [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_reg_slice_slr_xing ]
  set_property CONFIG.ID_WIDTH {16} $axi_reg_slice_slr_xing


  # Create instance: pcie_slow_clk_gen, and set properties
  set pcie_slow_clk_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 pcie_slow_clk_gen ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {159.975} \
    CONFIG.CLKOUT1_PHASE_ERROR {154.678} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {40.000} \
    CONFIG.CLKOUT2_JITTER {213.887} \
    CONFIG.CLKOUT2_PHASE_ERROR {154.678} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {10.000} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLKOUT3_JITTER {184.746} \
    CONFIG.CLKOUT3_PHASE_ERROR {154.678} \
    CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {20.000} \
    CONFIG.CLKOUT3_USED {true} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {24.000} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {30.000} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {120} \
    CONFIG.MMCM_CLKOUT2_DIVIDE {60} \
    CONFIG.MMCM_DIVCLK_DIVIDE {5} \
    CONFIG.NUM_OUT_CLKS {3} \
    CONFIG.RESET_PORT {resetn} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
  ] $pcie_slow_clk_gen


  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
  set_property CONFIG.SINGLE_PORT_BRAM {1} $axi_bram_ctrl_0


  # Create instance: axi_ic_dma, and set properties
  set axi_ic_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_dma ]
  set_property CONFIG.NUM_MI {1} $axi_ic_dma


  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins bootrom_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_ic_ddr_mem_M00_AXI [get_bd_intf_pins axi_ic_ddr_mem/M00_AXI] [get_bd_intf_pins axi_reg_slice_slr_xing/S_AXI]
  connect_bd_intf_net -intf_net axi_ic_ddr_mem_pcie_M00_AXI [get_bd_intf_pins axi_ic_ddr_mem_pcie/M00_AXI] [get_bd_intf_pins axi_ic_ddr_mem/S01_AXI]
  connect_bd_intf_net -intf_net axi_ic_dma_M00_AXI [get_bd_intf_pins axi_ic_dma/M00_AXI] [get_bd_intf_pins u_role/s_axi_dma]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_ic_dma_M00_AXI] [get_bd_intf_pins axi_ic_dma/M00_AXI] [get_bd_intf_pins system_ila_0/SLOT_0_AXI]
  connect_bd_intf_net -intf_net axi_ic_ep_bar_axi_lite_M00_AXI [get_bd_intf_pins host_uart/S_AXI] [get_bd_intf_pins axi_ic_ep_bar_axi_lite/M00_AXI]
  connect_bd_intf_net -intf_net axi_ic_ep_bar_axi_lite_M01_AXI [get_bd_intf_pins axi_ic_ep_bar_axi_lite/M01_AXI] [get_bd_intf_pins bootrom_bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_ic_ep_bar_axi_lite_M02_AXI [get_bd_intf_pins axi_mm_base_reg/S_AXI] [get_bd_intf_pins axi_ic_ep_bar_axi_lite/M02_AXI]
  connect_bd_intf_net -intf_net axi_ic_ep_bar_axi_lite_M03_AXI [get_bd_intf_pins axi_ic_ep_bar_axi_lite/M03_AXI] [get_bd_intf_pins u_role/s_axi_ctrl]
  connect_bd_intf_net -intf_net axi_ic_role_io_cross_domain_M00_AXI [get_bd_intf_pins role_uart/S_AXI] [get_bd_intf_pins axi_ic_role_io_cross_domain/M00_AXI]
  connect_bd_intf_net -intf_net axi_ic_role_io_cross_domain_M01_AXI [get_bd_intf_pins axi_ic_role_io_cross_domain/M01_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_reg_slice_slr_xing_M_AXI [get_bd_intf_ports m_axi_ddr_mem] [get_bd_intf_pins axi_reg_slice_slr_xing/M_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_reg_slice_slr_xing_M_AXI] [get_bd_intf_ports m_axi_ddr_mem] [get_bd_intf_pins system_ila_1/SLOT_0_AXI]
  connect_bd_intf_net -intf_net bootrom_bram_ctrl_BRAM_PORTA [get_bd_intf_pins bootrom_bram_ctrl/BRAM_PORTA] [get_bd_intf_pins bootrom_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net pcie_ep_gt_ref_clk [get_bd_intf_ports pcie_ep_gt_ref_clk] [get_bd_intf_pins pcie_ep_ref_clk_buf/CLK_IN_D]
  connect_bd_intf_net -intf_net u_role_m_axi_io [get_bd_intf_pins u_role/m_axi_io] [get_bd_intf_pins axi_ic_role_io_cross_domain/S00_AXI]
  connect_bd_intf_net -intf_net u_role_m_axi_mem [get_bd_intf_pins u_role/m_axi_mem] [get_bd_intf_pins axi_ic_ddr_mem/S00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets u_role_m_axi_mem] [get_bd_intf_pins u_role/m_axi_mem] [get_bd_intf_pins system_ila_0/SLOT_1_AXI]
  connect_bd_intf_net -intf_net xdma_ep_M_AXI [get_bd_intf_pins xdma_ep/M_AXI] [get_bd_intf_pins axi_ic_dma/S00_AXI]
  connect_bd_intf_net -intf_net xdma_ep_M_AXI_BYPASS [get_bd_intf_pins xdma_ep/M_AXI_BYPASS] [get_bd_intf_pins axi_ic_ddr_mem_pcie/S00_AXI]
  connect_bd_intf_net -intf_net xdma_ep_M_AXI_LITE [get_bd_intf_pins xdma_ep/M_AXI_LITE] [get_bd_intf_pins axi_ic_ep_bar_axi_lite/S00_AXI]

  # Create port connections
  connect_bd_net -net axi_mm_base_reg_gpio_io_o  [get_bd_pins axi_mm_base_reg/gpio_io_o] \
  [get_bd_pins concat_axi_ic_ddr_mem_pcie_S00_AXI_araddr/In1] \
  [get_bd_pins concat_axi_ic_ddr_mem_pcie_S00_AXI_awaddr/In1]
  connect_bd_net -net concat_axi_ic_ddr_mem_pcie_S00_AXI_araddr_dout  [get_bd_pins concat_axi_ic_ddr_mem_pcie_S00_AXI_araddr/dout] \
  [get_bd_pins axi_ic_ddr_mem_pcie/S00_AXI_araddr]
  connect_bd_net -net concat_axi_ic_ddr_mem_pcie_S00_AXI_awaddr_dout  [get_bd_pins concat_axi_ic_ddr_mem_pcie_S00_AXI_awaddr/dout] \
  [get_bd_pins axi_ic_ddr_mem_pcie/S00_AXI_awaddr]
  connect_bd_net -net const_28b0_dout  [get_bd_pins const_28b0/dout] \
  [get_bd_pins concat_axi_ic_ddr_mem_pcie_S00_AXI_araddr/In2] \
  [get_bd_pins concat_axi_ic_ddr_mem_pcie_S00_AXI_awaddr/In2]
  connect_bd_net -net const_gnd_dout  [get_bd_pins const_gnd/dout] \
  [get_bd_pins role_intr_concat/In1] \
  [get_bd_pins role_intr_concat/In2] \
  [get_bd_pins role_intr_concat/In3] \
  [get_bd_pins role_intr_concat/In4] \
  [get_bd_pins role_intr_concat/In5] \
  [get_bd_pins role_intr_concat/In6] \
  [get_bd_pins role_intr_concat/In7] \
  [get_bd_pins role_intr_concat/In8] \
  [get_bd_pins role_intr_concat/In9] \
  [get_bd_pins role_intr_concat/In10] \
  [get_bd_pins role_intr_concat/In11] \
  [get_bd_pins role_intr_concat/In12] \
  [get_bd_pins role_intr_concat/In13] \
  [get_bd_pins role_intr_concat/In14] \
  [get_bd_pins role_intr_concat/In15]
  connect_bd_net -net ddr4_mig_sync_reset_peripheral_aresetn  [get_bd_pins ddr4_mig_sync_reset/peripheral_aresetn] \
  [get_bd_pins axi_ic_ddr_mem/S00_ARESETN] \
  [get_bd_pins axi_ic_ddr_mem/S01_ARESETN] \
  [get_bd_pins axi_ic_ddr_mem/M00_ARESETN] \
  [get_bd_pins axi_reg_slice_slr_xing/aresetn] \
  [get_bd_pins system_ila_1/resetn]
  connect_bd_net -net dut_rst_gen_peripheral_aresetn  [get_bd_pins dut_rst_gen/peripheral_aresetn] \
  [get_bd_pins u_role/aresetn] \
  [get_bd_pins system_ila_0/resetn] \
  [get_bd_pins axi_ic_ddr_mem_pcie/M00_ARESETN] \
  [get_bd_pins axi_ic_role_io_cross_domain/S00_ARESETN] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M03_ARESETN] \
  [get_bd_pins axi_ic_dma/M00_ARESETN] \
  [get_bd_pins axi_ic_dma/ARESETN] \
  [get_bd_pins axi_ic_ddr_mem/ARESETN]
  connect_bd_net -net host_uart_interrupt  [get_bd_pins host_uart/interrupt] \
  [get_bd_pins xdma_ep/usr_irq_req]
  connect_bd_net -net host_uart_tx  [get_bd_pins host_uart/tx] \
  [get_bd_pins role_uart/rx]
  connect_bd_net -net intr_sync_pcie_slow_slow_intr  [get_bd_pins intr_sync_pcie_slow/slow_intr] \
  [get_bd_pins u_role/s2r_intr]
  connect_bd_net -net mig_calib_done  [get_bd_ports ddr4_mig_calib_done] \
  [get_bd_pins ddr4_mig_sync_reset/dcm_locked] \
  [get_bd_pins dut_rst_gen/dcm_locked]
  connect_bd_net -net pcie_clk  [get_bd_pins xdma_ep/axi_aclk] \
  [get_bd_pins axi_ic_ddr_mem_pcie/ACLK] \
  [get_bd_pins axi_ic_ddr_mem_pcie/S00_ACLK] \
  [get_bd_pins axi_ic_role_io_cross_domain/ACLK] \
  [get_bd_pins axi_ic_role_io_cross_domain/M00_ACLK] \
  [get_bd_pins axi_ic_role_io_cross_domain/M01_ACLK] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/ACLK] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/S00_ACLK] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M00_ACLK] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M01_ACLK] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M02_ACLK] \
  [get_bd_pins axi_mm_base_reg/s_axi_aclk] \
  [get_bd_pins bootrom_bram_ctrl/s_axi_aclk] \
  [get_bd_pins role_uart/s_axi_aclk] \
  [get_bd_pins host_uart/s_axi_aclk] \
  [get_bd_pins intr_sync_pcie_slow/fast_clk] \
  [get_bd_pins pcie_slow_clk_gen/clk_in1] \
  [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] \
  [get_bd_pins axi_ic_dma/S00_ACLK]
  connect_bd_net -net pcie_ep_perstn  [get_bd_ports pcie_ep_perstn] \
  [get_bd_pins xdma_ep/sys_rst_n] \
  [get_bd_pins ddr4_mig_sync_reset/ext_reset_in] \
  [get_bd_pins dut_rst_gen/ext_reset_in] \
  [get_bd_pins ep_perst_gen/Op1] \
  [get_bd_pins pcie_slow_clk_gen/resetn]
  connect_bd_net -net pcie_ep_rxn_1  [get_bd_ports pcie_ep_rxn] \
  [get_bd_pins xdma_ep/pci_exp_rxn]
  connect_bd_net -net pcie_ep_rxp_1  [get_bd_ports pcie_ep_rxp] \
  [get_bd_pins xdma_ep/pci_exp_rxp]
  connect_bd_net -net pcie_ep_sys_clk  [get_bd_pins pcie_ep_ref_clk_buf/IBUF_DS_ODIV2] \
  [get_bd_pins xdma_ep/sys_clk]
  connect_bd_net -net pcie_ep_sys_clk_gt  [get_bd_pins pcie_ep_ref_clk_buf/IBUF_OUT] \
  [get_bd_pins xdma_ep/sys_clk_gt]
  connect_bd_net -net pcie_slow_clk_gen_clk_out1  [get_bd_pins pcie_slow_clk_gen/clk_out1] \
  [get_bd_pins dut_rst_gen/slowest_sync_clk] \
  [get_bd_pins intr_sync_pcie_slow/slow_clk] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M03_ACLK] \
  [get_bd_pins u_role/aclk] \
  [get_bd_pins axi_ic_ddr_mem_pcie/M00_ACLK] \
  [get_bd_pins system_ila_0/clk] \
  [get_bd_pins axi_ic_role_io_cross_domain/S00_ACLK] \
  [get_bd_ports clock_32m] \
  [get_bd_pins axi_ic_ddr_mem/ACLK] \
  [get_bd_pins axi_ic_ddr_mem/S00_ACLK] \
  [get_bd_pins axi_ic_ddr_mem/S01_ACLK] \
  [get_bd_pins axi_ic_dma/M00_ACLK] \
  [get_bd_pins axi_ic_dma/ACLK]
  connect_bd_net -net pcie_slow_clk_gen_clk_out2  [get_bd_pins pcie_slow_clk_gen/clk_out2] \
  [get_bd_ports clock_8m] \
  [get_bd_pins axi_ic_ddr_mem/M00_ACLK] \
  [get_bd_pins axi_reg_slice_slr_xing/aclk] \
  [get_bd_pins system_ila_1/clk] \
  [get_bd_pins ddr4_mig_sync_reset/slowest_sync_clk]
  connect_bd_net -net pcie_slow_clk_gen_clk_out3  [get_bd_pins pcie_slow_clk_gen/clk_out3] \
  [get_bd_pins u_role/rtc_clock]
  connect_bd_net -net role_intr_concat_dout  [get_bd_pins role_intr_concat/dout] \
  [get_bd_pins intr_sync_pcie_slow/fast_intr]
  connect_bd_net -net role_uart_interrupt  [get_bd_pins role_uart/interrupt] \
  [get_bd_pins role_intr_concat/In0]
  connect_bd_net -net role_uart_tx  [get_bd_pins role_uart/tx] \
  [get_bd_pins host_uart/rx]
  connect_bd_net -net slice_xdma_ep_m_axib_araddr_Dout  [get_bd_pins slice_xdma_ep_m_axib_araddr/Dout] \
  [get_bd_pins concat_axi_ic_ddr_mem_pcie_S00_AXI_araddr/In0]
  connect_bd_net -net slice_xdma_ep_m_axib_awaddr_Dout  [get_bd_pins slice_xdma_ep_m_axib_awaddr/Dout] \
  [get_bd_pins concat_axi_ic_ddr_mem_pcie_S00_AXI_awaddr/In0]
  connect_bd_net -net xdma_ep_axi_aresetn  [get_bd_pins xdma_ep/axi_aresetn] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/ARESETN] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/S00_ARESETN] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M00_ARESETN] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M01_ARESETN] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M02_ARESETN] \
  [get_bd_pins axi_mm_base_reg/s_axi_aresetn] \
  [get_bd_pins host_uart/s_axi_aresetn] \
  [get_bd_pins axi_ic_ddr_mem_pcie/ARESETN] \
  [get_bd_pins axi_ic_ddr_mem_pcie/S00_ARESETN] \
  [get_bd_pins axi_ic_role_io_cross_domain/ARESETN] \
  [get_bd_pins axi_ic_role_io_cross_domain/M00_ARESETN] \
  [get_bd_pins axi_ic_role_io_cross_domain/M01_ARESETN] \
  [get_bd_pins role_uart/s_axi_aresetn] \
  [get_bd_pins bootrom_bram_ctrl/s_axi_aresetn] \
  [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] \
  [get_bd_pins axi_ic_dma/S00_ARESETN]
  connect_bd_net -net xdma_ep_m_axib_araddr  [get_bd_pins xdma_ep/m_axib_araddr] \
  [get_bd_pins slice_xdma_ep_m_axib_araddr/Din]
  connect_bd_net -net xdma_ep_m_axib_awaddr  [get_bd_pins xdma_ep/m_axib_awaddr] \
  [get_bd_pins slice_xdma_ep_m_axib_awaddr/Din]
  connect_bd_net -net xdma_ep_pci_exp_txn  [get_bd_pins xdma_ep/pci_exp_txn] \
  [get_bd_ports pcie_ep_txn]
  connect_bd_net -net xdma_ep_pci_exp_txp  [get_bd_pins xdma_ep/pci_exp_txp] \
  [get_bd_ports pcie_ep_txp]

  # Create address segments
  assign_bd_address -offset 0x10000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces u_role/m_axi_io] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x30000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces u_role/m_axi_io] [get_bd_addr_segs role_uart/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x000400000000 -target_address_space [get_bd_addr_spaces u_role/m_axi_mem] [get_bd_addr_segs m_axi_ddr_mem/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x001000000000 -target_address_space [get_bd_addr_spaces xdma_ep/M_AXI] [get_bd_addr_segs u_role/s_axi_dma/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x000400000000 -target_address_space [get_bd_addr_spaces xdma_ep/M_AXI_BYPASS] [get_bd_addr_segs m_axi_ddr_mem/Reg] -force
  assign_bd_address -offset 0x10010000 -range 0x00001000 -target_address_space [get_bd_addr_spaces xdma_ep/M_AXI_LITE] [get_bd_addr_segs axi_mm_base_reg/S_AXI/Reg] -force
  assign_bd_address -offset 0x10000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces xdma_ep/M_AXI_LITE] [get_bd_addr_segs bootrom_bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x10011000 -range 0x00001000 -target_address_space [get_bd_addr_spaces xdma_ep/M_AXI_LITE] [get_bd_addr_segs host_uart/S_AXI/Reg] -force
  assign_bd_address -offset 0x10100000 -range 0x00100000 -target_address_space [get_bd_addr_spaces xdma_ep/M_AXI_LITE] [get_bd_addr_segs u_role/s_axi_ctrl/reg0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


