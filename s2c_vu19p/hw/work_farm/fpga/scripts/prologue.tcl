# parsing target and component
if {${prj_design} != ""} {
	set target_path ${prj_loc}_${prj_name}_${prj_design}
} else {
	set target_path ${prj_loc}_${prj_name}
}

# project name
set vivado_prj_name ${target_path}_${board}
set prj_file ${vivado_prj_name}/${vivado_prj_name}.xpr

# output directories
set vivado_out ${script_dir}/../vivado_out
set vivado_out_prj ${vivado_out}/${vivado_prj_name}

exec mkdir -p ${vivado_out_prj}

set synth_rpt_dir ${vivado_out_prj}/synth_rpt
set impl_rpt_dir ${vivado_out_prj}/impl_rpt
set dcp_dir ${vivado_out_prj}/dcp

exec mkdir -p ${synth_rpt_dir} ${impl_rpt_dir} ${dcp_dir}
