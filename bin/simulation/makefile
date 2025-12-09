RTL_PATHS 			:= $(CURDIR)/src/wb $(CURDIR)/src/wb/utils 
RTL_PATHS 			+= $(CURDIR)/src/top
MEM_PATH 			:= $(CURDIR)/src/data
SCR_SRC_PATH 		:= $(CURDIR)/submodules/scr1/src
INCLUDE_PATHS 		:= $(SCR_SRC_PATH)/includes
RTL_SCR_LIST_FILES	:= $(SCR_SRC_PATH)/core.files
TB_PATH 			:= $(CURDIR)/src/testbench
TB_NAME				:= tb
TB_EXTENSION		:= sv

IVERILOG_COMPILATION_FLAGS := -g2012

TB_CALL := $(TB_PATH)/$(TB_NAME).$(TB_EXTENSION)

RTL_FILES := $(foreach path,$(RTL_PATHS), $(wildcard $(path)/*.v) $(wildcard $(path)/*.sv))
RTL_FILES += $(foreach path,$(RTL_SCR_LIST_FILES), $(foreach file,$(shell paste -sd ' ' $(path)),$(SCR_SRC_PATH)/$(file)))
RTL_FILES += $(TB_CALL)

.PHONY: all
all: run_vsim

$(CURDIR)/.cache/systemIV.vcd : $(INCLUDE_FILES) $(RTL_FILES)
	@iverilog -o $(CURDIR)/.cache/systemIV.vcd \
	$(IVERILOG_COMPILATION_FLAGS) \
	$(foreach path,$(INCLUDE_PATHS), -I $(path)) \
 	$(RTL_FILES) \
	-s $(TB_NAME)

VSIM_FILES := 
VSIM_FILES += $(RTL_FILES)
VSIM_FILES += $(TB_CALL)

BIN_DIR  := $(CURDIR)/.cache/bin
WORK_DIR  := $(CURDIR)/.cache/work
MEM_FILES := $(notdir $(wildcard $(MEM_PATH)/*.mem))
MEM_FILES_TARGET := $(foreach file,$(MEM_FILES),$(WORK_DIR)/$(file))

.PHONY: run_vsim
run_vsim : $(MEM_FILES_TARGET) $(VSIM_FILES)
	@mkdir -p $(WORK_DIR) $(BIN_DIR)
	@vlib $(WORK_DIR)
	@vmap work $(WORK_DIR)
	@vlog -work work +incdir$(foreach directory,$(INCLUDE_PATHS),+$(directory)) -sv $(VSIM_FILES)
	@vsim -c -voptargs=+acc-do -suppress 8386 work.$(TB_NAME) -do $(CURDIR)/bin/simulation/args.tcl

$(MEM_FILES_TARGET) : $(foreach file,$(MEM_FILES),$(MEM_PATH)/$(file))
	@mkdir -p $(WORK_DIR)
	@cp -a $(MEM_PATH)/. $(WORK_DIR)

.PHONY: visualize_simulation
visualize_simulation:
	@gtkwave $(CURDIR)/.cache/bin/system.vcd

.PHONY: clear_cache
clear_cache:
	@rm -rf $(CURDIR)/.cache \
		transcript \
		modelsim.ini
