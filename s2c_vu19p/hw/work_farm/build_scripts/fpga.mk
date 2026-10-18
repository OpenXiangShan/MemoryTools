# FPGA_ACT list
#==========================================
# prj_gen: Creating Vivado project and generating hardware 
#          definition file (HDF)
# run_syn: Synthesizing design
# bit_gen: Generating bitstream file (.bit) via automatically 
#          launching placement and routing
# dcp_gen: Generate a checkpoint (.dcp) for a specified part in a design
#          and later integrate the .dcp file into the design project via
#          the command read_checkpoint
# dcp_chk: Opening a checkpoint (.dcp) file generated in a certain step 
#          of synthesis, placement and routing. 
#          You can optionally setup hardware debug cores when opening 
#          the synth.dcp
#==========================================
# Default Vivado GUI launching flags if not specified in command line
FPGA_ACT ?= 
FPGA_VAL ?= 

# launch Vivado Toolset
vivado_prj: FORCE
	@mkdir -p $(HW_PLATFORM)
	$(EXPORT_VIVADO_PATH) && \
		$(MAKE) -C ./fpga VIVADO=$(VIVADO_BIN) FPGA_BD=$(FPGA_BD) FPGA_PRJ=$(PRJ) \
		FPGA_ACT=$(FPGA_ACT) FPGA_VAL="$(FPGA_VAL)" O=$(HW_PLATFORM) $@

