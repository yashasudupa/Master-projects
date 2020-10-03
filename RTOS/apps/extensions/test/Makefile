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


## Supported build targets:
##       all: build the binary and support files
##     clean: remove all build results
##  download: build binary and download it to the target device


## Specific build variables:
##    BOARDS: List of target BOARDs (CPU[.PCB]) for which to build the project
##	    LIBS: The list of libraries to be linked (TYPE.NAME)
##PUBLICLIBS: The list of public libraries to be linked (TYPE.NAME)
##   SOURCES: List of sources to be compiled and linked (will only consider *.c *.S)
##   CODE_GC: Perform (1) or omit (0) linker garbage collection.
##   DEFINES: List of arbitrary defines. These will simply be passed to the compiler/assembler
##              Example: "DEFINES += XXX" or "DEFINES += XXX=1"
##      NAME: (auto) Name of the project. Target filename: $(NAME).$(BOARD).$(GROUP).elf/hex
BOARDS  = msp430f5529.LaunchPad

LIBS	= kernel.smartos
PUBLICLIBS = kernel.interrupts kernel.crt0 kernel.sysinfo arch.sysclk arch.uart drv.uart libs.printfx
 
SOURCES	= $(wildcard *.c) $(wildcard *.S)
CODE_GC = 0
DEFINES +=
NAME	= $(notdir $(abspath $(CURDIR)))

## Environment build variables:
##	 GROUP: (auto) The group name where the libs will be taken from
##	PUBLIC: The directory name of the public repository (where public libs are)
GROUP  = $(notdir $(abspath $(CURDIR)/../../..))
PUBLIC = RTOS_Public_SS17

## Generic build variables:
##      ROOT: Relative path to the SmartOS root directory
##   MAKELIB: The make library to be used
ROOT	= ../../../..
MAKELIB	= $(ROOT)/$(PUBLIC)/buildenv/makelib/app.make

include $(MAKELIB)
