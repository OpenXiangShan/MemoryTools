# setting up the project
create_project ${vivado_prj_name} -force -dir "./${vivado_prj_name}" -part ${device}

if {${bd_part} != ""} {
        set_property board_part ${bd_part} [current_project]
}

