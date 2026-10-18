# Vivado IDE version and installed location
VIVADO_VERSION ?= 2024.2
VIVADO_TOOL_BASE ?= /nfs/tools/xilinx

# Vivado and SDK tool executable binary location
VIVADO_TOOL_PATH := $(VIVADO_TOOL_BASE)/Vivado/$(VIVADO_VERSION)/bin

EXPORT_VIVADO_PATH := export PATH=$(VIVADO_TOOL_PATH):$$PATH

LINUX_GCC_PREFIX ?= riscv64-linux-gnu-

# Leveraged Vivado tools
VIVADO_BIN := vivado
