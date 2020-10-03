################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Each subdirectory must supply rules for building sources it contributes
RTOS/RTOS_Public_Leandro/kernel/sysinfo.o: C:/Users/Name/workspace_v6_2/Base_RTOS_lib/RTOS_Public_Leandro/kernel/sysinfo.c $(GEN_OPTS) | $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: GNU Compiler'
	"C:/ti/ccsv6/tools/compiler/msp430-gcc-6.4.0.32_win32/bin/msp430-elf-gcc.exe" -c -mmcu=msp430f5529 -I"C:/ti/ccsv6/ccs_base/msp430/include_gcc" -I"C:/ti/ccsv6/tools/compiler/msp430-gcc-6.4.0.32_win32/msp430-elf/include" -I"C:/Users/Name/workspace_v6_2/RTBS_BaseProject/libs/RTOS/public/include" -Os -g -gdwarf-3 -gstrict-dwarf -Wall -msmall -mhwmult=f5series -mcode-region=none -mdata-region=none -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o"$@" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '


