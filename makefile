
BUILD_DIR                   := $(CURDIR)/.cache/build
BIN_DIR                     := $(CURDIR)/.cache/bin
WORK_DIR                    := $(CURDIR)/.cache/work
RES_DIR                     := $(CURDIR)/res
SRC_DIR                     := $(CURDIR)/src
FIRMWARE_DIR                := $(SRC_DIR)/firmware
SOFTWARE_DIR                ?= $(FIRMWARE_DIR)/software
EMBEDDED_DIR                ?= $(SOFTWARE_DIR)/embedded
MEMORY_DIR                  ?= $(SRC_DIR)/data
RTL_DIRS                    := $(CURDIR)/src/wb $(CURDIR)/src/wb/utils 
RTL_DIRS                    += $(CURDIR)/src/top
MEM_DIR                     := $(CURDIR)/src/data
SCR_SRC_DIR                 := $(CURDIR)/submodules/scr1/src
INCLUDE_DIRS                := $(SCR_SRC_DIR)/includes

TB_FILE                     ?= $(CURDIR)/src/testbench/tb.sv

CSRC                        := $(wildcard $(EMBEDDED_DIR)/*.c)
SSRC                        := $(wildcard $(EMBEDDED_DIR)/*.S)
COBJ                        := $(BUILD_DIR)/$(notdir $(addsuffix .o,$(CSRC)))
SOBJ                        := $(BUILD_DIR)/$(notdir $(addsuffix .o,$(SSRC)))
OBJ                         := $(COBJ) $(SOBJ)
RTL_SCR_LIST_FILES          := $(SCR_SRC_DIR)/core.files
RTL_FILES                   := $(foreach DIR,$(RTL_DIRS), $(wildcard $(DIR)/*.v) $(wildcard $(DIR)/*.sv))
RTL_FILES                   += $(foreach DIR,$(RTL_SCR_LIST_FILES), $(foreach file,$(shell paste -sd ' ' $(DIR)),$(SCR_SRC_DIR)/$(file)))
MEM_FILES                   := $(notdir $(wildcard $(MEM_DIR)/*.mem))
MEM_FILES_TARGET            := $(foreach file,$(MEM_FILES),$(WORK_DIR)/$(file))

CFLAGS                      := -Os -nostdlib -ffreestanding --std=gnu99 -mabi=ilp32e -march=rv32e -c
LDFLAGS                     := -Bstatic -T $(FIRMWARE_DIR)/firmware.lds -Map $(FIRMWARE_DIR)/firmware.map
LDFLAGS                     += --strip-debug -m elf32lriscv
MEMSIZE                     ?= 4096
VSIM_ARGS_FILE              ?= $(CURDIR)/build/args.tcl

.PHONY: all
all: build_firmware run_vsim

.PHONY: clean
clean: clean_firmware clean_simulation
	rm -rf $(CURDIR)/.cache

$(COBJ): $(BUILD_DIR)/%.c.o : $(EMBEDDED_DIR)/%.c
	@mkdir -p $(BUILD_DIR)
	@riscv32-unknown-elf-gcc $(CFLAGS) -o $@ $<

$(SOBJ): $(BUILD_DIR)/%.S.o : $(EMBEDDED_DIR)/%.S
	@mkdir -p $(BUILD_DIR)
	@riscv32-unknown-elf-gcc $(CFLAGS) -o $@ $<

$(BUILD_DIR)/firmware.elf: $(OBJ) $(FIRMWARE_DIR)/firmware.lds
	@riscv32-unknown-elf-ld $(LDFLAGS) -o $@ $(OBJ)

$(BUILD_DIR)/firmware.bin: $(BUILD_DIR)/firmware.elf
	@riscv32-unknown-elf-objcopy -O binary $< $@

$(BUILD_DIR)/firmware.hex: $(BUILD_DIR)/firmware.bin
	@python3 $(SOFTWARE_DIR)/utils/makehex.py $< $(MEMSIZE) > $@

.PHONY: build_firmware
build_firmware: $(BUILD_DIR)/firmware.hex
	@cp $(BUILD_DIR)/firmware.hex $(MEMORY_DIR)/firmware.mem

.PHONY: clean_firmware
clean_firmware:
	rm -rf $(BUILD_DIR)

.PHONY: run_vsim
run_vsim : $(MEM_FILES_TARGET) $(RTL_FILES) $(VSIM_ARGS_FILE) $(TB_FILE)
	@mkdir -p $(WORK_DIR) $(BIN_DIR) $(RES_DIR)
	@vlib $(WORK_DIR)
	@vmap work $(WORK_DIR)
	@vlog -work work +incdir$(foreach directory,$(INCLUDE_DIRS),+$(directory)) -sv $(RTL_FILES) $(TB_FILE)
	@vsim -c -voptargs=+acc -suppress 8386 work.$(notdir $(basename $(TB_FILE))) -do $(VSIM_ARGS_FILE)

$(MEM_FILES_TARGET) : $(foreach file,$(MEM_FILES),$(MEM_DIR)/$(file))
	@mkdir -p $(WORK_DIR)
	@cp -a $(MEM_DIR)/. $(WORK_DIR)

.PHONY: call_gtkwave
call_gtkwave:
	@gtkwave $(CURDIR)/res/system.vcd&

.PHONY: clean_simulation
clean_simulation:
	@rm -rf $(CURDIR)/.cache/work \
		transcript \
		modelsim.ini
