
# Target platform
ifndef TARGET
	TARGET=srf06-cc26xx
	BOARD=sensortag/cc2650
endif

# Name of the .c file containing the main application
CONTIKI_PROJECT = IPCOM

# What to compile
all: $(CONTIKI_PROJECT)

# Upload
upload: $(CONTIKI_PROJECT).upload

# Path to custom configuration file
CFLAGS += -DPROJECT_CONF_H=\"project-conf.h\"

# Additional source files to be compiled (if any)
#CONTIKI_TARGET_SOURCEFILES += library.c

# Networking stack
CONTIKI_WITH_IPV6 = 1
#CONTIKI_WITH_RIME = 1
CONTIKI_WITH_RPL = 0

#undef UIP_CONF_IPV6_RPL
#define UIP_CONF_IPV6_RPL 0


# Path to main Contiki folder
CONTIKI = ../../contiki
# Include Contiki makefile
include $(CONTIKI)/Makefile.include
