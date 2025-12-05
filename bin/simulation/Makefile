RTL_PATHS 		= $(CURDIR)/src/wb $(CURDIR)/src/wb/utils $(CURDIR)/src/top
INCLUDE_PATHS 	= $(CURDIR)/submodules/scr1/src/includes
RTL_LIST_FILES	= $(CURDIR)/submodules/scr1/src/core.files
TB_PATH 		= $(CURDIR)/src/testbench
TB_NAME			= tb.v

IVERILOG_COMPILATION_FLAGS = -g2012

TB_CALL = $(TB_PATH)/$(TB_NAME)

RTL_FILES = $(INCLUDE_PATHS)/*.vh $(INCLUDE_PATHS)/*.svh \
	$(RTL_PATHS)/*.v $(RTL_PATHS)/*.sv \
	$(cat $(RTL_LIST_FILES)) \
	$(TB_CALL)

.PHONY: all\
	clear_cache\
	rebuild\
	visualize_simulation

all:
	#rebuild
	visualize_simulation

$(CURDIR)/.cache/system.vcd: $(RTL_FILES)
	iverilog -o $(CURDIR)/.cache/system.vcd \
	$(IVERILOG_COMPILATION_FLAGS) \
 	$(RTL_FILES) \
	-s $(TB_CALL)

visualize_simulation: $(CURDIR)/.cache/system.vcd
	gtkwave $(CURDIR)/.cache/system.vcd

rebuild: $(CURDIR)/.cache/system.vcd

clear_cache:
	rm -rf $(CURDIR)/.cache
