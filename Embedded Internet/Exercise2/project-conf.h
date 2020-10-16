/*---------------------------------------------------------------------------*/
#ifndef PROJECT_CONF_H_
#define PROJECT_CONF_H_

/*---------------------------------------------------------------------------*/

// Network stack configurations

#define IEEE802154_CONF_PANID            0xABCD
#define RF_CORE_CONF_CHANNEL                 26
#define RF_BLE_CONF_ENABLED                   0
#define NETSTACK_CONF_RDC   nullrdc_driver
#define NETSTACK_CONF_MAC   nullmac_driver

/*---------------------------------------------------------------------------*/

// Disable button shutdown functionality
#undef BUTTON_SENSOR_CONF_ENABLE_SHUTDOWN
#define BUTTON_SENSOR_CONF_ENABLE_SHUTDOWN		0

/*---------------------------------------------------------------------------*/

#undef STARTUP_CONF_VERBOSE
#define STARTUP_CONF_VERBOSE 0

#undef DISCOVER_SINK_ADDRESS
#define DISCOVER_SINK_ADDRESS 1

#undef PRINT_OWN_IPV6_ADDRESSES
#define PRINT_OWN_IPV6_ADDRESSES 1

#undef SHOW_IP_AND_ICMP_PACKET
#define SHOW_IP_AND_ICMP_PACKET 1


/*---------------------------------------------------------------------------*/

// Do not edit these definitions!

#undef UIP_CONF_ROUTER
#define UIP_CONF_ROUTER 0

#undef UIP_CONF_ND6_SEND_NA
#define UIP_CONF_ND6_SEND_NA 1

#undef UIP_CONF_ND6_DEF_MAXDADNS
#define UIP_CONF_ND6_DEF_MAXDADNS 1

#undef ENERGEST_CONF_ON
#define ENERGEST_CONF_ON 1

/*---------------------------------------------------------------------------*/
#endif /* PROJECT_CONF_H_ */
/*---------------------------------------------------------------------------*/
