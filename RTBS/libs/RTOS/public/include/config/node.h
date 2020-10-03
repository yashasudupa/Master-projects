#ifndef __NODE_H__
#define __NODE_H__

/* configuration for the unified clock system (UCS) */
#define UCS_DCOCLK  (24000000ul)    ///< the DCO clock frequency in Hz
#define UCS_DIVM    (0)             ///< divider encoding for the main clock MCLK (0..5 maps to 1,2,4,8,16,32)
#define UCS_DIVSM   (0)             ///< divider encoding for the sub main clock SMCLK (0..5 maps to 1,2,4,8,16,32)
#define UCS_DIVA    (0)             ///< divider encoding for auxilliary clock ACLK (0..5 maps to 1,2,4,8,16,32)
#define UCS_DIVAN   (0)             ///< divider encoding for auxilliary clock ACLK/n (0..5 maps to 1,2,4,8,16,32)

/* configuration for the universal serial communication interface (USCI) -- UART Mode */
#define UART_PORT(x)      P4##x     ///< the MCU port to use for the UART
#define UART_TX_PIN       BIT4      ///< the port pin at UART_PORT to use as TX line
#define UART_RX_PIN       BIT5      ///< the port pin at UART_PORT to use as RX line
#define UART_BAUDRATE     115200ul  ///< the desired UART baudrate in bps
#define UART_DATABITS     0         ///< databits select: 0=8DB 1=7DB
#define UART_STOPBITS     0         ///< stopbits select: 0=1SB 1=2SB
#define UART_PARITY       0x00      ///< parity select: 0=none, 1=none, 2=odd, 3=even
#define UART_CLS_CODE     0x01      ///< the clear screen code which will be sent over the UART to trigger a clear screen on the console
#define UART_OVERSAMPLING 1         ///< 0=no oversampling 1=oversampling
#define UART_CLK_SOURCE   2         ///< clock source for the UART module: 0=UCAxCLK, 1=ACLK, 2=SMCLK
#define UCAx(x)           UCA1##x   ///< use UCA1 or UCA0

/* configuration for the XT1 quartz crystal */
#define XT1_PORT(x)       P5##x     ///< XT1 quartz crystal port
#define XT1_IN            BIT4      ///< XT1 in pin
#define XT1_OUT           BIT5      ///< XT1 out pin
#define XT1_FREQ          32768     ///< XT1 quartz crystal frequency in Hz

/* configuration for the XT2 quartz crystal */
#define XT2_PORT(x)       P5##x     ///< XT2 quartz crystal port
#define XT2_IN            BIT2      ///< XT2 in pin
#define XT2_OUT           BIT3      ///< XT2 out pin
#define XT2_FREQ          4000000 	///< XT2 quartz crystal frequency in Hz


/* ======================== PIN HELPER MACROS ======================================================= */
/* init <port>.<pin> as output */
#define Pin_OutputMode(port,pin)	xPin_OutputMode(port,pin)
#define xPin_OutputMode(port,pin)	P##port##DIR |= (BIT##pin)

/* init <port>.<pin> as input */
#define Pin_InputMode(port,pin)		xPin_InputMode(port,pin)
#define xPin_InputMode(port,pin)	P##port##DIR &= ~(BIT##pin)

/* Enable interrupt on  <port>.<pin> (Supported only by ports 1 and 2) */
#define Pin_EnableInt(port,pin)		xPin_EnableInt(port,pin)
#define xPin_EnableInt(port,pin)	P##port##IE |= (BIT##pin)

/* Disable interrupt on  <port>.<pin> (Supported only by ports 1 and 2) */
#define Pin_DisableInt(port,pin)	xPin_DisableInt(port,pin)
#define xPin_DisableInt(port,pin)	P##port##IE &= ~(BIT##pin)

/* Interrupt on rising edge on <port>.<pin> (Supported only by ports 1 and 2) */
#define Pin_RisingEdgeInt(port,pin)		xPin_RisingEdgeInt(port,pin)
#define xPin_RisingEdgeInt(port,pin)	P##port##IES &= ~(BIT##pin)

/* Interrupt on falling edge on  <port>.<pin> (Supported only by ports 1 and 2) */
#define Pin_FallingEdgeInt(port,pin)	xPin_FallingEdgeInt(port,pin)
#define xPin_FallingEdgeInt(port,pin)	P##port##IES |= (BIT##pin)

#define Pin_SelectIO(port,pin)		xPin_SelectIO(port,pin)
#define xPin_SelectIO(port,pin)		P##port##SEL &= ~(BIT##pin)

#define Pin_SelectPeripheral(port,pin)		xPin_SelectPeripheral(port,pin)
#define xPin_SelectPeripheral(port,pin)		P##port##SEL |= (BIT##pin)

/* clear <port>.<pin> */
#define Pin_Low(port,pin)			xPin_Low(port,pin)
#define xPin_Low(port,pin)			P##port##OUT &= ~(BIT##pin)

/* set <port>.<pin> */
#define Pin_High(port,pin)			xPin_High(port,pin)
#define xPin_High(port,pin)			P##port##OUT |= (BIT##pin)

/* toggle <port>.<pin> */
#define Pin_Toggle(port,pin)		xPin_Toggle(port,pin)
#define xPin_Toggle(port,pin)		P##port##OUT ^= (BIT##pin)

/* Enable Resistor <port>.<pin> */
#define Pin_EnableResistor(port,pin)			xPin_EnableResistor(port,pin)
#define xPin_EnableResistor(port,pin)			P##port##REN |= (BIT##pin);Pin_High(port, pin)	// Pin_High necessary after enabling resistor -- see datasheet

/* Enable Resistor <port>.<pin> */
#define Pin_DisableResistor(port,pin)			xPin_DisableResistor(port,pin)
#define xPin_DisableResistor(port,pin)			P##port##REN &= ~(BIT##pin)

/* read port <port>.<pin> */
#define Read_Pin(port, pin)		xRead_Pin(port, pin)
#define xRead_Pin(port, pin)	((P##port##IN & BIT##pin) == BIT##pin)
#endif
