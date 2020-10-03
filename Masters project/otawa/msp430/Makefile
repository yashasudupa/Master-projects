#
#MSP430 -- GLISS2 implementation of MSP430

-include config.mk

#definitions 
ARCH=msp
ifdef WITH_DYNLIB
REC_FLAGS = WITH_DYNLIB=1
endif

GFLAGS= \
	-m loader:old_elf \
	-m code:code \
	-m env:void_env \
	-m sys_call:extern/sys_call \
	-m shift:extern/shift \
	-v \
	-a disasm.c \
	-S \
	-switch \
	-D

ifdef WITH_IO
GFLAGS += -m mem:io_mem
else
GFLAGS += -m mem:vfast_mem
endif

MAIN_NMP	=	msp.nmp
NMP = \
	nmp/$(MAIN_NMP) \
	nmp/condition.nmp \
	nmp/dataProcessingMacro.nmp \
	nmp/dataProcessing.nmp \
	nmp/modes.nmp \
	nmp/simpleType.nmp \
	nmp/state.nmp \
	nmp/tempVar.nmp


# goals definition
GOALS		=
SUBDIRS		=	src
CLEAN		=	msp.nml msp.irg nmp/state.nmp
DISTCLEAN	=	include src $(CLEAN) config.mk
LIB_DEPS	=	include/msp/config.h

ifdef WITH_FAST_STATE
GFLAGS		+=	-a used_regs.c
LIB_DEPS	+=	src/used_regs.c
endif

ifdef WITH_DISASM
GOALS		+=	msp-disasm
SUBDIRS		+=	disasm
DISTCLEAN	+= 	disasm
GFLAGS		+= -a disasm.c
LIB_DEPS	+= src/disasm.c 
endif

ifdef WITH_SIM
GOALS		+=	msp-sim
SUBDIRS		+=	sim
DISTCLEAN	+=	sim
endif

# rules
all: lib $(GOALS)

$(ARCH).irg: $(NMP)
	cd nmp &&  ../$(GLISS_PREFIX)/irg/mkirg $(MAIN_NMP) ../$@  && cd ..

STATE_NMP=state-normal.nmp
nmp/state.nmp: nmp/$(STATE_NMP) config.mk
	cp nmp/$(STATE_NMP) nmp/state.nmp  

src include: arm.irg
	$(GLISS_PREFIX)/gep/gep $(GFLAGS) $<

lib: src $(LIB_DEPS)
	(cd src; make $(REC_FLAGS))

arm-disasm:
	cd disasm; make

include/arm/config.h: config.tpl
	test -d src || mkdir src
	cp config.tpl $@

src/disasm.c: arm.irg
	$(GLISS_PREFIX)/gep/gliss-disasm $(ARCH).irg -o $@ -c

src/used_regs.c: $(ARCH).irg nmp/used_regs.nmp
	$(GLISS_PREFIX)/gep/gliss-used-regs $< -e nmp/used_regs.nmp

arm-sim:
	cd sim; make

clean:
	rm -rf $(CLEAN)

distclean:
	rm -Rf $(DISTCLEAN) msp.irg msp.out

config: config.mk

config.mk:
	cp config.mk.in config.mk
	echo "Created config.mk. Edit it for configuration."