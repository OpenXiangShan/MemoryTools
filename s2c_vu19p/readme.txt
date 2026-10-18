The Baiyang IP FPGA SoC environment is built on the Nexst framework, integrating the FATE DDR IP (1356809263), the XiangShan Nanhu core (git commit: 824cfcf7b50ab627d1605d8e70582362dc9c887d), and the Baiyang IP (git commit: 1d758b7d985d7348d406c29077ff6445cc6540d6). This project only provides the compiled RTL source code of the above submodules, along with the scripts necessary for generating the bitstream and building the on-board test binaries. For the detailed source repositories, please refer to https://github.com/NEXST-TOOL/nexst.

The board configured by the currently open-sourced scripts is the S2C Prodigy S7-19PS/D/Q Logic System, with the FPGA model Xilinx Virtex UltraScale+ XCVU19P. The project is also developing a FATE-DDR version adapted for the VCU128 development board. If you are interested in co-developing, please feel free to contact us.

The hw directory is used to generate the bitstream for the FPGA board running on the VU19P, which integrates the XiangShan Nanhu core and the Baiyang memory controller. nanhu-g contains the source files and scripts required for building the XiangShan Nanhu core project, shell contains the source files and scripts required for building the Baiyang memory controller system, and work_farm is the unified build entry point for the FPGA project. It contains the project build scripts, and the FPGA project and related output files are also generated under this path.

You can build the bitstream by following these steps:

1. Environment setup

mkdir -p work_farm/target/
cd work_farm/target && ln -s ../../nanhu-g nanhu-g
cd ../ && ln -s ../shell shell

These commands create symbolic links to the nanhu-g and shell folders inside the work_farm folder.

export VIVADO_VERSION=2024.2
export VIVADO_TOOL_BASE=/path/to/your/vivado  # e.g., /opt/Vivado_2024.2
export FPGA_BD=s2c_vu19p
export NUM_CORES=1

After running the above commands, make sure the current directory is work_farm/.

2. Project creation, synthesis, placement/routing, and bitstream generation

make PRJ="shell:${FPGA_BD}" FPGA_BD=${FPGA_BD} FPGA_ACT=prj_gen vivado_prj

This command is used to create the synthesizable shell project. After it finishes, the corresponding Vivado project is created under work_farm\fpga\vivado_prj\shell_s2c_vu19p_s2c_vu19p, and related files are output under work_farm\fpga\vivado_out.

make PRJ="shell:${FPGA_BD}" FPGA_BD=${FPGA_BD} FPGA_ACT=run_syn vivado_prj

This command is used to synthesize the shell project. After it finishes, related files are output under work_farm\fpga\vivado_out.

make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} FPGA_ACT=prj_gen vivado_prj

This command is used to create the nanhu-g project. After it finishes, the Vivado project is created under work_farm\fpga\vivado_prj\target_nanhu-g_proto_s2c_vu19p, and related files are output under work_farm\fpga\vivado_out.

make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} FPGA_ACT=run_syn vivado_prj

This command is used to synthesize the nanhu-g project. After it finishes, related files are output under work_farm\fpga\vivado_out.

make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} FPGA_ACT=bit_gen vivado_prj

This command is used to generate the final bitstream. After it finishes, the bitstream will be located at work_farm/hw_plat/target_nanhu-g_proto_${FPGA_BD}/system.bit.

The sw directory contains the binaries and scripts used to test the Baiyang memory controller, which is integrated with the XiangShan Nanhu core. After the bitstream has been programmed onto the FPGA, the user can reboot the host machine, start the Linux kernel by following startup.sh, and then execute user programs, such as SPEC CPU2006 or simple test programs.

The startup.sh script includes several steps for starting the Linux kernel:

./setup_xdma.sh

This step installs the XDMA driver on the host machine after the bitstream has been programmed.

sudo ./pcie-util /dev/xdma0_user write 0x100000 0

This step releases the CPU reset, bringing the CPU out of the reset state and starting execution.

sudo ./xdma_write_image_checkum_4B_per_1KB RV_BOOT_train_4g.bin

This step uses XDMA operations to copy the OpenSBI image.

sudo ./load_to_blockram_and_run.sh xdma0 ./bootrom.check_cache.bin

This step boots OpenSBI and the Linux kernel, then enters the Linux shell. After Linux has successfully booted, the user can cd to the /my-dir directory to find the executable binaries of SPEC CPU2006. If you replace RV_BOOT_train_4g.bin with RV_BOOT_Hello.bin in step 3, then after Linux boots, run the following commands:

cd /my-dir
./hello

The output should be:

Hello, welcome to use the Baiyang memory controller
