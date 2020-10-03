################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Each subdirectory must supply rules for building sources it contributes
Base_RTOS_lib/RTOS_Public_Leandro/testbeds/01_codeSize/main.o: C:/Users/Lab/Desktop/Workspace/Base_RTOS_lib/RTOS_Public_Leandro/testbeds/01_codeSize/main.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: GNU Compiler'
	"C:/Tools/TI/ccsv6.2/ccsv6/tools/compiler/msp430-gcc-5.3.0.224_win32/bin/msp430-elf-gcc.exe" -c -mmcu=msp430f5529 -I"C:/Tools/TI/ccsv6.2/ccsv6/ccs_base/msp430/include_gcc" -I"C:/Tools/TI/ccsv6.2/ccsv6/tools/compiler/msp430-gcc-5.3.0.224_win32/msp430-elf/include" -I"C:/Users/Lab/Desktop/Workspace/RTBS_BaseProject/libs/RTOS/public/include" -Os -g -gdwarf-3 -gstrict-dwarf -Wall -msmall -mhwmult=f5series -mcode-region=none -mdata-region=none -mlarge -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o"$@" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '


