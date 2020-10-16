/*
 * Copyright (c) 2014, Texas Instruments Incorporated - http://www.ti.com/
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the copyright holder nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */
/*---------------------------------------------------------------------------*/
#ifndef PROJECT_CONF_H_
#define PROJECT_CONF_H_
/*---------------------------------------------------------------------------*/
/* Disable button shutdown functionality */
#define BUTTON_SENSOR_CONF_ENABLE_SHUTDOWN    0
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/**
 * \name Network Stack Configuration
 *
 * @{
 */
#ifndef NETSTACK_CONF_NETWORK
#if NETSTACK_CONF_WITH_IPV6
#define NETSTACK_CONF_NETWORK sicslowpan_driver
#else
#define NETSTACK_CONF_NETWORK rime_driver
#endif /* NETSTACK_CONF_WITH_IPV6 */
#endif /* NETSTACK_CONF_NETWORK */

#ifndef NETSTACK_CONF_MAC
#define NETSTACK_CONF_MAC    nullmac_driver// csma_driver
#endif

#ifndef NETSTACK_CONF_RDC
#define NETSTACK_CONF_RDC     nullrdc_driver //contikimac_driver
#endif

 /*---------------------------------------------------------------------------*/
 /**
  * \name IEEE address configuration
  *
  * Used to generate our RIME & IPv6 address
  * @{
  */
 /**
  * \brief Location of the IEEE address
  * 0 => Read from InfoPage,
  * 1 => Use a hardcoded address, configured by IEEE_ADDR_CONF_ADDRESS
  */
 #ifndef IEEE_ADDR_CONF_HARDCODED
 #define IEEE_ADDR_CONF_HARDCODED             1
 #endif

 /**
  * \brief The hardcoded IEEE address to be used when IEEE_ADDR_CONF_HARDCODED
  * is defined as 1
  */
 #ifndef IEEE_ADDR_CONF_ADDRESS
 #define IEEE_ADDR_CONF_ADDRESS { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x19, 0x00 }
 #endif
 /** @} */

 //Enable BLE support
#define RF_BLE_CONF_ENABLED                  1 /**< 0 to disable BLE support */

 //verbose output fter reset
#define IEEE802154_CONF_PANID           0xABCD /**< Default PAN ID */

 //IEEE 802.15.4 channel
#define RF_CORE_CONF_CHANNEL                     26
#define STARTUP_CONF_VERBOSE 1 // defined by me



/*---------------------------------------------------------------------------*/
#endif /* PROJECT_CONF_H_ */
/*---------------------------------------------------------------------------*/
