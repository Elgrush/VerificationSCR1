SOFTWARE_PATH := $(CURDIR)/bin/software
VERIFICATION_PATH := $(CURDIR)/bin/software

.PHONY: all
all: 
	make -f $(SOFTWARE_PATH)/makefile
	make -f $(VERIFICATION_PATH)/makefile
