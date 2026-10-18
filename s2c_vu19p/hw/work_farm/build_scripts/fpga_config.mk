# Specification of Board, Chipset and Project
FPGA_BD ?= nf
PRJ ?= shell:mpsoc

# parsing target design
TARGET_LOC := $(shell echo $(PRJ) | awk -F ":" '{print $$1}')
TARGET_PRJ := $(shell echo $(PRJ) | awk -F ":" '{print $$2}')
TARGET_DESIGN := $(shell echo $(PRJ) | awk -F ":" '{print $$3}')

ifneq ($(TARGET_DESIGN),)
FPGA_PRJ_NAME := $(TARGET_LOC)_$(TARGET_PRJ)_$(TARGET_DESIGN)_$(FPGA_BD)
else
FPGA_PRJ_NAME := $(TARGET_LOC)_$(TARGET_PRJ)_$(FPGA_BD)
endif

ifneq ($(wildcard $(abspath $(TARGET_LOC)/$(TARGET_PRJ)/$(TARGET_PRJ).mk)),)
include $(abspath $(TARGET_LOC)/$(TARGET_PRJ)/$(TARGET_PRJ).mk)
endif
