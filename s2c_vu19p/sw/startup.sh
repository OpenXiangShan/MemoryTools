./setup_xdma.sh
sudo ./pcie-util /dev/xdma0_user write 0x100000 0
sudo ./xdma_write_image_checkum_4B_per_1KB RV_BOOT_train_4g.bin
sudo ./load_to_blockram_and_run.sh xdma0 ./bootrom.check_cache.bin
