#define TARGET_ENDIANNESS little
#define HOST_ENDIANNESS little

/* TODO: update reg names */

/* generic macro */
#define MSP_GET_GPR(s, i)		((s)->GPR[i])

/* compatibility */
#define print(t)				printf("%s\n", t)

#define MSP430
