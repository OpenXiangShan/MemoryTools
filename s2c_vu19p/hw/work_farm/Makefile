# Xilinx Vivado toolset and open-source device tree compiler
include build_scripts/toolset.mk

# Specified FPGA board, chipset and project
include build_scripts/fpga_config.mk

# Temporal directory to hold hardware design output files 
# (i.e., bitstream, hardware definition file (HDF))
HW_PLATFORM := $(shell pwd)/hw_plat/$(FPGA_PRJ_NAME)
BITSTREAM := $(HW_PLATFORM)/system.bit
SYS_HDF := $(HW_PLATFORM)/system.hdf

# Software configs：Please refer to the open-source link https://github.com/NEXST-TOOL/nexst
# Temporal directory to save all image files for porting
# ifneq ($(TARGET_DESIGN),)
# INSTALL_LOC := $(TARGET_LOC)/$(TARGET_PRJ)/sw_plat/$(TARGET_DESIGN)_$(FPGA_BD)
# else
# INSTALL_LOC := $(TARGET_LOC)/$(TARGET_PRJ)/sw_plat/$(FPGA_BD)
# endif

.PHONY: FORCE

# software compilation
# ifneq ($(TARGET_SW_MK),)
# include $(TARGET_LOC)/$(TARGET_PRJ)/$(TARGET_SW_MK)
# endif

# fpga design flow
ifneq ($(TARGET_FPGA_MK),)
include $(TARGET_LOC)/$(TARGET_PRJ)/$(TARGET_FPGA_MK)
endif
include build_scripts/fpga.mk

# FPGA project-specific hardware design compilation/generation
ifneq ($(TARGET_HW_MK),)
include $(TARGET_LOC)/$(TARGET_PRJ)/$(TARGET_HW_MK)
endif
