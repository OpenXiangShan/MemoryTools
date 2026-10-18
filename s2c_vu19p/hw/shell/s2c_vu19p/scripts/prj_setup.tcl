# 设置路径
set FPGA_SRC_DIR ${design_dir}/../fpga
set BDTCL_DIR    ${FPGA_SRC_DIR}/tcl/bd
set IPTCL_DIR    ${FPGA_SRC_DIR}/tcl/ip
set HDL_DIR      ${FPGA_SRC_DIR}/hdl
set XDC_DIR      ${FPGA_SRC_DIR}/constraints
set ELF_DIR      ${FPGA_SRC_DIR}/elf

# 获取物理核心数
set run_list {}
set lscpu [exec lscpu]
regexp {Core\(s\) per socket:\s+(\d+)} $lscpu -> cores_per_socket
regexp {Socket\(s\):\s+(\d+)}          $lscpu -> sockets
set phys_cores [expr {$cores_per_socket * $sockets}]
set jobs [expr {$phys_cores > 16 ? 16 : $phys_cores}]

# 加载hdl文件
add_files -fileset sources_1 ${HDL_DIR}
set_property top xiangshan_wrapper [current_fileset]
set_property include_dirs ${HDL_DIR}/defines [current_fileset]

# 加载xdc文件
add_files -fileset constrs_1 ${XDC_DIR}

# 加载ip文件
foreach iptcl_file [glob -nocomplain ${IPTCL_DIR}/*.tcl] {
    set ip_name [file rootname [file tail $iptcl_file]]

    source $iptcl_file
    generate_target all [get_ips ${ip_name}]
    lappend run_list [create_ip_run [get_ips ${ip_name}]]
}
if {[llength $run_list] > 0} {
    launch_runs $run_list -jobs ${jobs}
    wait_on_run $run_list
}

# 加载bd文件
foreach bdtcl_file [glob -nocomplain ${BDTCL_DIR}/*.tcl] {
    set bd_name [file rootname [file tail $bdtcl_file]]
    set bd_file ./${vivado_prj_name}/${vivado_prj_name}.srcs/sources_1/bd/${bd_name}/${bd_name}.bd

    source $bdtcl_file
    set_property synth_checkpoint_mode None [get_files $bd_file]
    generate_target all [get_files $bd_file]
    close_bd_design $bd_name
}

# 加载elf文件
add_files -fileset sources_1 -norecurse ${ELF_DIR}/DDR4-2400-config.elf
set_property SCOPED_TO_REF ddr [get_files -all -of_objects [get_fileset sources_1] ${ELF_DIR}/DDR4-2400-config.elf]
set_property SCOPED_TO_CELLS { microblaze_0 } [get_files -all -of_objects [get_fileset sources_1] ${ELF_DIR}/DDR4-2400-config.elf]
