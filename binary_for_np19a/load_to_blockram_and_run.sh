#!/bin/bash

if [ $# -ge 1 ]; then

    xdma_user=/dev/${1}_user
    xdma_bypass=/dev/${1}_bypass
    xdma_h2c_0=/dev/${1}_h2c_0

    if [ ! -c $xdma_user ]; then
        echo "ERROR: not a character device: $xdma_user"
        exit 1
    fi

    if [ ! -c $xdma_bypass ]; then
        echo "ERROR: not a character device: $xdma_bypass"
        exit 1
    fi

fi

fw_payload=$2

if [ ! -f $bootrom ]; then
    echo "ERROR: file not found: $bootrom"
    exit 1
fi

if [ ! -f $fw_payload ]; then
    echo "ERROR: file not found: $fw_payload"
    exit 1
fi

echo "Assert reset $xdma_user"
./pcie-util $xdma_user write 0x100000 1

echo "Load $fw_payload"
filesize=$(stat -c%s "$fw_payload")
echo "filesize is $filesize"
./pcie-util $xdma_user load 0x0 $filesize $fw_payload

#    BASE_ADDR=0x80000000   
#    CHUNK_SIZE=$((256*1024*1024))  # 256MB = 0x10000000
#    REPEAT=$filesize/$CHUNK_SIZE   # for cycle repeat times
#    echo "write $REPEAT times, start ..."
#
#for (( i=0; i<REPEAT; i++ )); do
#    ADDR=$((BASE_ADDR + i*CHUNK_SIZE))
#    ./difffpga_dma_to_device -d $xdma_h2c_0 -f $fw_payload -s $CHUNK_SIZE -c 1 -a $ADDR
#    echo "write the $i block"
#done


if [ $? -eq 0 ]; then
    echo "✓ Checkpoint loaded successfully"
    echo ""
    echo "Next steps:"
    echo "3. Release CPU reset"
    echo "4. Monitor UART console for execution"
    echo ""
    echo "Expected UART output:"
    echo "  - gcpt restore started"
    echo "  - Register restoration..."
    echo "  - CPU resumed from checkpoint"
else
    echo "✗ Failed to load checkpoint"
    exit 1
fi


    echo "Deassert reset"
    ./pcie-util $xdma_user write 0x100000 0

    echo "Start serial connection"
    ./pcie-util $xdma_user uart 0x11000

exit 1

