SOFTWARE_PATH := $(CURDIR)/bin/software
SIMULATION_PATH := $(CURDIR)/bin/simulation

.PHONY: all
all: 
	make -f $(SOFTWARE_PATH)/makefile
	make -f $(SIMULATION_PATH)/makefile
