#!/bin/bash
echo "Loading xdma driver..."
sudo modprobe xdma
# 检查驱动是否加载成功
if lsmod | grep -q xdma; then
    echo "xdma driver loaded successfully."
else
    echo "Failed to load xdma driver."
    exit 1
fi
# 进入测试文件夹
#cd tests/ || exit
# 执行测试脚本
echo "Executing load_driver.sh..."
sudo ./load_driver.sh
# 检查是否执行成功
if [ $? -eq 0 ]; then
    echo "Device successfully recognized and configured."
else
    echo "Error: Failed to load xdma module. Try regenerating xdma.ko if you see 'Invalid module format'."
fi
