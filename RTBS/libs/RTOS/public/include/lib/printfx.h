#ifndef __PRINTFX__H__
#define __PRINTFX__H__

#include <kernel/kernel.h>
#include <lib/uart_tx.h>
#include <string.h>
#include <stdarg.h>


/** Sets the default streamwriter function which will be called for generating the output.
 * 	Passing NULL to deactivate the output is allowed.
 *
 * 	- The streamwriter will receive any single character (in machine word width) and is responsible
 * 		for generating the output to an arbitrary destination (e.g. RS232, SPI, a buffer, ...)
 * 	- The streamwriter must return any value <= 0 to indicate an error, and a value >0 to indicate success
 * 	- The streamwriter must *not* call printf or any other function which used the streamwriter
 * 		itself since this would cause an infinite recursion.
 */
extern void     printfSetStreamwriter(int (*func)(int));

/** Sets the group separator for number formatting.
 * 	e.g. printf("%.2x", 0x1234567) will produce the output "1.23.45.67" with an "." separator between
 * 	each group of 2 digits.
 */
extern void     printfSetGroupseparator(char sep );

/** Sets the verbosity level for printfx */
extern void     printfSetVerbosity(uint16_t level );

/** @return the currently set verbosity level for printfx */
extern uint16_t printfGetVerbosity(void );

/** A simple print function for zero terminated strings.
 * 	Supports conditional newline ('\v').
 * 	Simply prints the specified string to the currently defined default streamwriter.
 * 	@returns 1 on success, 0 on failure
 */
extern uint16_t printfzString(char* zString);


/** An alternative for the classic printf function with special adaptations for embedded systems.
 * 	Though the general usage through an arbitrary length parameter list is the same, the format specifiers
 * 	are slightly different regarding some details.
 *
 * 	Format:
 * 		%[flags][minWidth][.precision or maxWidth][sourceLength]type
 *
 * 	supported flags:
 * 		+		force the display of a number's sign
 * 		-		left align numbers
 * 		0		left pad with zeroes
 * 		space	left pad with spaces (default)
 * 	supported sourceLength:
 * 		ll			64bit
 * 		l 			32bit
 * 		nothing 	machine word width
 * 		h 			16bit
 * 		hh			8bit
 * 	supported types:
 *		u,d,i,x,o,b		support minWidth and alignment (maxWidth will be interpreted as grouping)
 *		s				supports minWidth and maxWidth, but will always be left aligned (right padded with ' ')
 *		B				bitfield with '1' for high, '_' for low. will always print the correct number of digits depending on the source bitwidth
 *		p				pointer
 *		c   char
 *		w	wide char		currently not supported
 *		f	(IEEE float)	currently not supported
 *		a	(fixed point)	currently not supported
 *		v	verbosity level
 *		q	temporarily set output function pointer
 *
 *	Examples:
 *		printfx("%012.3lx", 0x12345678);	--> "000:012:345:678"
 *		printfx("%.7s", "Hallo Welt");		--> "Hallo W"
 *		printfx("abc%vtest", 3);		   	--> will always print abc, but "test" only if the current verbosity level is at least 3
 *		printfx("%.4B", 0x55);		   		--> "____.____._1_1._1_1"
 *		printfx("%d%q%d", 10, &putch2, 11);	--> will print "10" through the default output function, and "11" through putch2
 *		printfx("\vLINE");					--> a newline will only preceed "LINE" if there was no other newline before
 *
 *	@attention Note that smartprintf (just like the ordinary printf) will consume a significant amount of stack
 *				(about 100 bytes, depending on the target architecture!)
 *	@return 0 on failure, 1 on success
 *
 *	TODO: currently %q changes the global streamwriter. using a local streamwriter that defaults to the global one would be much better.
 *			However, due to some compiler problems, this was not possible to implement for the MSP430.
 */
extern uint16_t printfx(const char * format, ...);

/** A wrapper for calling the smartprintf(...) function.
 * 	@see printfx */
extern uint16_t printf(const char * format, ...);


#endif
