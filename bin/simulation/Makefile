RTL_PATHS 			:= $(CURDIR)/src/wb $(CURDIR)/src/wb/utils 
RTL_PATHS 			+= $(CURDIR)/src/top
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
	iverilog -o $(CURDIR)/.cache/systemIV.vcd \
	$(IVERILOG_COMPILATION_FLAGS) \
	$(foreach path,$(INCLUDE_PATHS), -I $(path)) \
 	$(RTL_FILES) \
	-s $(TB_NAME)

.PHONY: run_vsim
run_vsim : $(INCLUDE_FILES) $(RTL_FILES)
	mkdir -p $(CURDIR)/.cache/work
	vlib $(CURDIR)/.cache/work
	vmap work $(CURDIR)/.cache/work
	$(foreach file,$(INCLUDE_FILES), $(bash vlog -sv $(file) -work $(CURDIR)/.cache/work))
	$(foreach file,$(RTL_FILES), $(bash vlog -sv $(file) -work $(CURDIR)/.cache/work))
	vlog -sv $(TB_CALL) -work $(CURDIR)/.cache/work
	vsim -voptargs=+acc do "work.$(TB_NAME) log -r /* vcd file $(CURDIR)/.cache/systemQ.vcd vcd add -r /* run -all"

.PHONY: visualize_simulation
visualize_simulation:
	gtkwave $(CURDIR)/.cache/systemIV.vcd

.PHONY: clear_cache
clear_cache:
	rm -rf $(CURDIR)/.cache \
		transcript \
		modelsim.ini
