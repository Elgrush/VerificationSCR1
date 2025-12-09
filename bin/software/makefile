MEMSIZE          ?= 2048
SRC_PATH		 := $(CURDIR)/src
FIRMWARE_PATH	 := $(SRC_PATH)/firmware
SOFTWARE_PATH	 := $(FIRMWARE_PATH)/software
EMBEDDED_PATH	 := $(SOFTWARE_PATH)/embedded
BUILD_PATH		 := $(CURDIR)/.cache/build
BIN_PATH		 := $(CURDIR)/.cache/bin
MEMORY_PATH		 := $(SRC_PATH)/data
CSRC             := $(wildcard $(EMBEDDED_PATH)/*.c)
SSRC             := $(wildcard $(EMBEDDED_PATH)/*.S)
COBJ             := $(BUILD_PATH)/$(notdir $(addsuffix .o,$(CSRC)))
SOBJ             := $(BUILD_PATH)/$(notdir $(addsuffix .o,$(SSRC)))
OBJ              := $(COBJ) $(SOBJ)
CFLAGS           := -Os -nostdlib -ffreestanding --std=gnu99 -mabi=ilp32e -march=rv32e -c
LDFLAGS          := -Bstatic -T $(FIRMWARE_PATH)/firmware.lds -Map $(FIRMWARE_PATH)/firmware.map
LDFLAGS          += --strip-debug -m elf32lriscv



.PHONY: all
all: build

$(COBJ): $(BUILD_PATH)/%.c.o : $(EMBEDDED_PATH)/%.c
	mkdir -p $(BUILD_PATH)
	riscv32-unknown-elf-gcc $(CFLAGS) -o $@ $<

$(SOBJ): $(BUILD_PATH)/%.S.o : $(EMBEDDED_PATH)/%.S
	mkdir -p $(BUILD_PATH)
	riscv32-unknown-elf-gcc $(CFLAGS) -o $@ $<

$(BUILD_PATH)/firmware.elf: $(OBJ)
	riscv32-unknown-elf-ld $(LDFLAGS) -o $@ $<

$(BUILD_PATH)/firmware.bin: $(BUILD_PATH)/firmware.elf
	riscv32-unknown-elf-objcopy -O binary $< $@

$(BUILD_PATH)/firmware.hex: $(BUILD_PATH)/firmware.bin
	python3 $(SOFTWARE_PATH)/utils/makehex.py $< $(MEMSIZE) > $@

.PHONY: build
build: $(BUILD_PATH)/firmware.hex
	@cp $(BUILD_PATH)/firmware.hex $(MEMORY_PATH)/firmware.mem

.PHONY: clean
clean:
	rm -rf $(OBJ) $(BUILD_PATH)/firmware.elf $(BUILD_PATH)/firmware.bin
