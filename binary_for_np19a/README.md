This directory contains binaries and scripts for testing the Yuquan memory controller, which is integrated with the Xianshan Nanhu core.
After programming the bitstream onto the FPGA, users can restart host machine and follow startup.sh to start the Linux kernel, 
then execute user programs such as SPEC CPU2006 or simple test programs.

The startup.sh script contains several steps to start the Linux kernel:
1. ./setup_xdma.sh   
This step installs the XDMA driver on the host machine after the bitstream has been programmed.
2. sudo ./pcie-util /dev/xdma0_user write 0x100000 0
This step releases the CPU reset, taking the CPU out of reset and starting execution.
3. sudo ./xdma_write_image_checkum_4B_per_1KB RV_BOOT_train_4g.bin
This copies the OpenSBI image using the XDMA operation.
4. sudo ./load_to_blockram_and_run.sh xdma0 ./bootrom.check_cache.bin
This starts OpenSBI and the Linux kernel, and then enters the Linux shell. 
After Linux has booted successfully, users can cd to /my-dir to find the SPEC CPU2006 executable binary files.
If you replace RV_BOOT_train_4g.bin with RV_BOOT_Hello.bin in step 3, then after Linux starts up, execute the following commands:
cd /my-dir
./hello
The output should be:
Hello, welcome to use the Baiyang memory controller.
