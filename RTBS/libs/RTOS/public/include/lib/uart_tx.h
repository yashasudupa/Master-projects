#ifndef __UART_TX__H__
#define __UART_TX__H__

#include <kernel/kernel.h> 
#include <config/node.h>

typedef enum {
	UART_DATABITS_8, UART_DATABITS_7
} UART_databits_t;

typedef enum {
	UART_STOPBITS_1, UART_STOPBITS_2
} UART_stopbits_t;

typedef enum {
	UART_PARITY_NONE,		// 0=none, 1=none
	UART_PARITY_ODD = 2u,	// 2=odd
	UART_PARITY_EVEN = 3u,	// 3=even
} UART_parity_t;

/** Initializes and starts the UART according to the specified parameters and the
 * 	configuration in node.h.
 *
 * 	In case of configuration ambiguities the parameters take precedence over the node.h settings.
 *
 */
extern Result_t UART_setConfig(uint32_t baudrate, UART_databits_t dataBits, UART_stopbits_t stopBits,
		UART_parity_t parity);

/** Puts the single specified character to the serial console.
 * 	No character conversion of any kind will be done.
 *  No attempt to generate any output will be made in case the
 *  console has been disabled or the uart has been stopped.
 *  @return 1 in any case
 */
extern int putchar(int);

/** Prints the specified buffer with the given length.
 * 	@return 1 on success
 * 			0 on failure (null pointer)
 */
extern Result_t UART_write(char *buf, uint16_t length);

/** Sends a clear screen command to the console.
 *  The command is a single character defined through UART_CLS_CODE. */
extern void UART_clearScreen(void);

#endif
