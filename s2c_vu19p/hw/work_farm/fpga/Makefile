FPGA_ROOT := $(shell pwd)

# Hardware install file
O ?= $(FPGA_ROOT)
HDF_INSTALL := $(O)/system.hdf
BIT_INSTALL := $(O)/system.bit

# Vivado Auto-run tcl scripts
VIVADO_PRJ_TCL := $(FPGA_ROOT)/scripts/mk.tcl
VIVADO_FILE_TCL := $(FPGA_ROOT)/scripts/file_cp.tcl

ifneq ($(findstring $(FPGA_ACT), "dcp_chk sch_gen"),)
VIVADO_MODE := gui
else
VIVADO_MODE := batch
endif

# Locations of Vivado project and generated files
TARGET_LOC := $(shell echo $(FPGA_PRJ) | awk -F ":" '{print $$1}')
TARGET_PRJ := $(shell echo $(FPGA_PRJ) | awk -F ":" '{print $$2}')
TARGET_DESIGN := $(shell echo $(FPGA_PRJ) | awk -F ":" '{print $$3}')

ifneq ($(TARGET_DESIGN),)
TARGET_DIR := $(TARGET_LOC)_$(TARGET_PRJ)_$(TARGET_DESIGN)_$(FPGA_BD)
else
TARGET_DIR := $(TARGET_LOC)_$(TARGET_PRJ)_$(FPGA_BD)
endif

VIVADO_PRJ_LOC := $(FPGA_ROOT)/vivado_prj
VIVADO_OUT := $(FPGA_ROOT)/vivado_out
VIVADO_LOG_LOC := $(VIVADO_OUT)/$(TARGET_DIR)/run_log

DIR_GEN_OBJ := $(VIVADO_PRJ_LOC) $(VIVADO_LOG_LOC)

VIVADO_PRJ_FLAGS := -nojournal -nolog -mode $(VIVADO_MODE) \
	-source $(VIVADO_PRJ_TCL) -notrace \
	-tclargs $(FPGA_ACT) "$(FPGA_VAL)" $(O) $(FPGA_BD) "$(TARGET_LOC) $(TARGET_PRJ) $(TARGET_DESIGN)"

.PHONY: FORCE

ifeq ($(FPGA_ACT),)
vivado_prj: FORCE
	$(error Please specify the action to be lanuched for Vivado hardware design)
else
vivado_prj: FORCE
	@mkdir -p $(DIR_GEN_OBJ)
ifeq ($(VIVADO_MODE),batch)
	@cd $(VIVADO_PRJ_LOC) && $(VIVADO) $(VIVADO_PRJ_FLAGS) 2>&1 | tee $(VIVADO_LOG_LOC)/$(FPGA_ACT).log
else
	@cd $(VIVADO_PRJ_LOC) && $(VIVADO) $(VIVADO_PRJ_FLAGS)
endif
endif

