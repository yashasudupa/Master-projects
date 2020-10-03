#define TARGET_ENDIANNESS little
#define HOST_ENDIANNESS little

/* TODO: update reg names */

/* generic macro */
#define MSP_GET_R(s, i)		((s)->GPR[i])

/* compatibility */
#define sc_impl(_1, _2, _3)		arm_syscall(inst, state)
#define print(t)				printf("%s\n", t)

#define MSP430
