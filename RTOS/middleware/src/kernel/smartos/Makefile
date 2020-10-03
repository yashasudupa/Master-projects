################################################################################
#		Copyright Notice and Disclaimer for the mosartMCU Project.
# Copyright (C) 2016 EAS Group. All rights reserved.
# 
# This file was released for educational use within the 
#             Embedded Automotive Systems Group, 
#             Institute of Technical Informatics,
#           Graz University of Technology, Austria
# This copyright may not be removed, modified or relocated within this file.
################################################################################

################################################################################
## MCSmartOS build environment V0.3
################################################################################

# list of directories to remove [_*/] (_all _common)
DIRS_REM = $(wildcard _*/) 
# list of all directories, except _all and _common
DIRS = $(filter-out $(DIRS_REM),$(wildcard */)) 

.PHONY: all $(DIRS)

all: $(DIRS) Makefile

$(DIRS):
	@echo .
	@echo "!!=== MAKE [$(CURDIR)/$@] ===!!"
	@make --no-print-directory -C $@

define BUILDENV_GENERATE_CLEAN
  clean_all += clean_$(1)
  clean_$(1):
	@echo ""
	@echo "=== CLEAN [$(1)] ==="
	@make --no-print-directory -C $(1) clean

  libclean_all += libclean_$(1)
  libclean_$(1):
	@echo ""
	@echo "=== LIBCLEAN [$(1)] ==="
	@make --no-print-directory -C $(1) libclean
endef

$(foreach dir,$(DIRS),$(eval $(call BUILDENV_GENERATE_CLEAN,$(dir))))

clean: $(clean_all)

libclean: $(libclean_all)
