RTL_PATHS 			:= $(CURDIR)/src/wb $(CURDIR)/src/wb/utils 
RTL_PATHS 			+= $(CURDIR)/src/top
MEM_PATH 			:= $(CURDIR)/src/data
SCR_SRC_PATH 		:= $(CURDIR)/submodules/scr1/src
INCLUDE_PATHS 		:= $(SCR_SRC_PATH)/includes
RTL_SCR_LIST_FILES	:= $(SCR_SRC_PATH)/core.files
TB_PATH 			:= $(CURDIR)/src/testbench
TB_NAME				:= tb
TB_EXTENSION		:= v

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

VSIM_ARGS :=
VSIM_ARGS += vlog -work work +incdir$(foreach directory,$(INCLUDE_PATHS),+$(directory)) -sv $(VSIM_FILES) \n
VSIM_ARGS += vsim work.$(TB_NAME) \n
VSIM_ARGS += set WildcardFilter [lsearch -not -all -inline \$$WildcardFilter Memory] \n
VSIM_ARGS += log /* \n
VSIM_ARGS += run \n

WORK_DIR  := $(CURDIR)/.cache/work
MEM_FILES := $(wildcard $(MEM_PATH)/*.mem)

.PHONY: run_vsim
run_vsim : $(INCLUDE_FILES) $(RTL_FILES) $(WORK_DIR)/%.mem
	@mkdir -p $(WORK_DIR)
	@vlib $(WORK_DIR)
	@vmap work $(WORK_DIR)
	@vsim -do "$(VSIM_ARGS)"

$(WORK_DIR)/%.mem : $(MEM_FILES)
	@cp $< $@

#log -r /* vcd file $(CURDIR)/.cache/systemQ.vcd vcd add -r /* run -all

.PHONY: visualize_simulation
visualize_simulation:
	@gtkwave $(CURDIR)/.cache/systemIV.vcd

.PHONY: clear_cache
clear_cache:
	@rm -rf $(CURDIR)/.cache \
		transcript \
		modelsim.ini
