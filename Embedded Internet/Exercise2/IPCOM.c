#include <stdio.h>
#include <string.h>
#include "contiki.h"
#include "contiki-net.h"
#include "sys/etimer.h"
#include "net/ip/uip.h"
#include "net/ipv6/uip-icmp6.h"
#define DEBUG DEBUG_PRINT
#include "net/ip/uip-debug.h"
#include "button-sensor.h"
#include "dev/leds.h"
#include "board-peripherals.h"

/*---------------------------------------------------------------------------*/

#define SOUGHT_SINK_ADDRESS 	exercise2_sink.local
#define ETIMER_INTERVAL 		(CLOCK_SECOND * 5)

#define PING6_DATALEN 16
#define UIP_IP_BUF              ((struct uip_ip_hdr *)&uip_buf[UIP_LLH_LEN])
#define UIP_ICMP_BUF            ((struct uip_icmp_hdr *)&uip_buf[uip_l2_l3_hdr_len])
#define UDP_HDR ((struct uip_udpip_hdr *)&uip_buf[UIP_LLH_LEN])
#define MAX_PAYLOAD_LEN		sizeof(struct uni_message)
#define EVENT_POST_1 2
#define EVENT_POST_2 3 
/*---------------------------------------------------------------------------*/


enum{
	TYPE_UNICAST_GET_LOCK,
	TYPE_UNICAST_GET_LOCK_ACK,
	TYPE_UNICAST_GET_LOCK_NACK,
	TYPE_UNICAST_SET_RESOURCE,
	TYPE_UNICAST_SET_RESOURCE_ACK,
	TYPE_UNICAST_SET_RESOURCE_NACK,
 };


static struct uni_message{
 	uint8_t type_unicast;
 	uint8_t reserved;
 	uint8_t white;
 	uint8_t red;
 	uint8_t green;
 	uint8_t blue;
 	uint16_t secret;
 };

// Global variables
static struct etimer et;

// Sink address and discovery
static uip_ipaddr_t ip_sink_addr;
static uint8_t sink_found = 0;

// Each echo request payload will have an increasing counter
static uint32_t icmp_payload_counter = 0;

// Allocate memory for Contiki's ICMPv6 notification for the callback
static struct uip_icmp6_echo_reply_notification server_notification;

static struct uip_udp_conn *client_conn;
static struct uni_message mesg;
static uint16_t secret_code;
static uint16_t echo_request_time;
static uint16_t echo1_request_time;
static uint16_t echo_reply_time;
static uint16_t led_change_request_time;
static uint16_t led_changed_successfully_time;
static uint8_t counter=0;


PROCESS(udp_ping_process, "UDP ping process");
PROCESS(udp_client_process, "UDP client process");
PROCESS(udp_resource, "UDP Get RESOURCE process");
PROCESS(udp_resend_process, "UDP resend process");

AUTOSTART_PROCESSES(&udp_client_process, &udp_ping_process,&udp_resource,&udp_resend_process);
/*---------------------------------------------------------------------------*/

#if DISCOVER_SINK_ADDRESS
static resolv_status_t set_connection_address(uip_ipaddr_t *ipaddr)
{
	#define _QUOTEME(x) #x
	#define QUOTEME(x) _QUOTEME(x)
	#ifndef UDP_CONNECTION_ADDR
	#if RESOLV_CONF_SUPPORTS_MDNS
	#define UDP_CONNECTION_ADDR       SOUGHT_SINK_ADDRESS
	#endif
	#endif /* !UDP_CONNECTION_ADDR */


	resolv_status_t status = RESOLV_STATUS_ERROR;

	if(uiplib_ipaddrconv(QUOTEME(UDP_CONNECTION_ADDR), ipaddr) == 0) {
		uip_ipaddr_t *resolved_addr = NULL;
		status = resolv_lookup(QUOTEME(UDP_CONNECTION_ADDR),&resolved_addr);
		if(status == RESOLV_STATUS_UNCACHED || status == RESOLV_STATUS_EXPIRED) {
			PRINTF("Attempting to look up %s\n",QUOTEME(UDP_CONNECTION_ADDR));
			resolv_query(QUOTEME(UDP_CONNECTION_ADDR));
			status = RESOLV_STATUS_RESOLVING;
		} else if(status == RESOLV_STATUS_CACHED && resolved_addr != NULL) {
			PRINTF("Lookup of \"%s\" succeded!\n",QUOTEME(UDP_CONNECTION_ADDR));
		} else if(status == RESOLV_STATUS_RESOLVING) {
			PRINTF("Still looking up \"%s\"...\n",QUOTEME(UDP_CONNECTION_ADDR));
		} else {
			PRINTF("Lookup of \"%s\" failed. status = %d\n",QUOTEME(UDP_CONNECTION_ADDR),status);
		}
		if(resolved_addr)
			uip_ipaddr_copy(ipaddr, resolved_addr);
	} else {
		status = RESOLV_STATUS_CACHED;
	}

	return status;
}
#endif


/*---------------------------------------------------------------------------*/

#if PRINT_OWN_IPV6_ADDRESSES
static void print_local_addresses(void)
{
  int i;
  uint8_t state;

  PRINTF("This node's IPv6 addresses: ");
  for(i = 0; i < UIP_DS6_ADDR_NB; i++) {
    state = uip_ds6_if.addr_list[i].state;
    if(uip_ds6_if.addr_list[i].isused &&
       (state == ADDR_TENTATIVE || state == ADDR_PREFERRED)) {
      PRINT6ADDR(&uip_ds6_if.addr_list[i].ipaddr);
	  clock_delay_usec(60000);
	  printf("\n");
    }
  }
}
#endif


/*---------------------------------------------------------------------------*/

// Callback function for the echo reply
void echo_reply_handler(uip_ipaddr_t *source, uint8_t ttl, uint8_t *data, uint16_t datalen) {
//	printf("ECHO REPLY HANDLER HERE\n");
  if (uip_ipaddr_cmp(source, &ip_sink_addr)) {

	  echo_reply_time=RTIMER_NOW();  										//timer
	  leds_on(LEDS_GREEN);
	  leds_off(LEDS_RED);
	  // Displaying the echo reply
	  PRINTF("Receiving ICMPv6 echo reply (type %d) from ", UIP_ICMP_BUF->type);
	  PRINT6ADDR(&UIP_IP_BUF->srcipaddr);
	  PRINTF(" to ");
	  PRINT6ADDR(&UIP_IP_BUF->destipaddr);
	  leds_on(LEDS_RED);
	  leds_off(LEDS_GREEN);
	  printf("\n time between 1st echo request and positive echo reply %ld ms  \n",(echo_reply_time-echo1_request_time));
	  printf("time between each echo request and echo reply %ld ms  \n",(echo_reply_time-echo_request_time));
	  clock_delay_usec(60000);
	  printf("\n");
//#if SHOW_IP_AND_ICMP_PACKET
	  printf("Echo reply -- IPv6 packet: ");
	  for(int i=0; i<uip_len-UIP_LLH_LEN;i++){
		  printf("%02x ", uip_buf[i+UIP_LLH_LEN]);
	  }
	  printf("\n");
	  printf("Echo reply -- ICMPv6 packet: ");
	  for(int i=0; i<uip_len-uip_l2_l3_hdr_len;i++){
		  printf("%02x ", uip_buf[i+uip_l2_l3_hdr_len]);
	  }
	  leds_on(LEDS_GREEN);
	  leds_off(LEDS_RED);
	  printf("\n");

//#endif

	  process_post(&udp_client_process, 1, NULL);
  }
  else {
    printf("Unexpected Echo reply received!\n");
  }
}


/*---------------------------------------------------------------------------*/

void echo_request(uip_ipaddr_t* dest_addr) {

  // Prepare IPv6 header
  UIP_IP_BUF->vtc = 0x60;
  UIP_IP_BUF->tcflow = 1;
  UIP_IP_BUF->flow = 0;
  UIP_IP_BUF->proto = UIP_PROTO_ICMP6;
  UIP_IP_BUF->ttl = uip_ds6_if.cur_hop_limit;

  // Adding IPv6 addresses in the IPv6 header
  uip_ipaddr_copy(&UIP_IP_BUF->destipaddr, dest_addr);
  uip_ds6_select_src(&UIP_IP_BUF->srcipaddr, &UIP_IP_BUF->destipaddr);

  // Prepare ICMPv6 header and payload
  UIP_ICMP_BUF->type = ICMP6_ECHO_REQUEST;
  UIP_ICMP_BUF->icode = 0;
  memset((uint8_t *)UIP_ICMP_BUF + UIP_ICMPH_LEN, 0, 4); // Empty identifier and sequence number, see https://en.wikipedia.org/wiki/Ping_(networking_utility)
  memset((uint8_t *)UIP_ICMP_BUF + UIP_ICMPH_LEN + UIP_ICMP6_ECHO_REQUEST_LEN, icmp_payload_counter++, PING6_DATALEN); // Payload of ICMP packet

  uip_len = UIP_ICMPH_LEN + UIP_ICMP6_ECHO_REQUEST_LEN + UIP_IPH_LEN + PING6_DATALEN;
  UIP_IP_BUF->len[0] = (uint8_t)((uip_len - 40) >> 8);
  UIP_IP_BUF->len[1] = (uint8_t)((uip_len - 40) & 0x00FF);

  UIP_ICMP_BUF->icmpchksum = 0;
  UIP_ICMP_BUF->icmpchksum = ~uip_icmp6chksum();

  // Displaying the echo request
  PRINTF("Sending ICMPv6 echo request (type %d) from ", UIP_ICMP_BUF->type);
  PRINT6ADDR(&UIP_IP_BUF->srcipaddr);
  PRINTF(" to ");
  PRINT6ADDR(&UIP_IP_BUF->destipaddr);
  clock_delay_usec(60000);
  printf("\n");

  echo_request_time=RTIMER_NOW();											// timer
  // Sending the IPv6 packet
  tcpip_ipv6_output();
}


/*---------------------------------------------------------------------------*/
static void
tcpip_handler(void)
{
  char *str;

  static struct uni_message mesg;

  if(uip_newdata()) {
    str = uip_appdata;
    str[uip_datalen()] = '\0';
    printf("Response from the server: '%s'\n", str);
    memcpy(&mesg,str,sizeof(mesg));
    printf("secret code %d",mesg.secret);
    secret_code=mesg.secret;
    if(mesg.type_unicast==TYPE_UNICAST_SET_RESOURCE_ACK){
    	led_changed_successfully_time=RTIMER_NOW();
    	printf("time difference between request change of the sink's led and reception: %ldms \n",
		(led_changed_successfully_time-led_change_request_time));
    }
    if(mesg.type_unicast==TYPE_UNICAST_GET_LOCK_ACK){
    	 process_post(&udp_resource, EVENT_POST_1, NULL);
    	 counter--;
    	// leds_on(LEDS_GREEN);
    	// leds_off(LEDS_RED);
    }else if((mesg.type_unicast == TYPE_UNICAST_GET_LOCK_NACK))
	{
		printf("resending request\n");
		leds_on(LEDS_RED);
		leds_off(LEDS_GREEN);
		process_post(&udp_resend_process, EVENT_POST_2, NULL);
	}
    if(mesg.type_unicast==TYPE_UNICAST_SET_RESOURCE_ACK){
			leds_on(LEDS_GREEN);
			leds_off(LEDS_RED);
	}

  }
}
/*---------------------------------------------------------------------------*/

static void
timeout_handler(void)
{
  printf("Client sending to: ");
  PRINT6ADDR(&client_conn->ripaddr);
  uip_udp_packet_send(client_conn, &mesg, sizeof(struct uni_message));
}

/*---------------------------------------------------------------------------*/

PROCESS_THREAD(udp_ping_process, ev, data) {

	PROCESS_BEGIN();

	// Waiting ETIMER_INTERVAL seconds
	// Do NOT remove this: it is necessary for Contiki to properly initialize the network stack and allow receiving autoconfiguration packets
	etimer_set(&et, ETIMER_INTERVAL);
	PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
	rtimer_init();

#if PRINT_OWN_IPV6_ADDRESSES
	print_local_addresses();
#endif

#if DISCOVER_SINK_ADDRESS
	// Address auto-discovery using mDNS
	static resolv_status_t status = RESOLV_STATUS_UNCACHED;
	while(status != RESOLV_STATUS_CACHED) {
		status = set_connection_address(&ip_sink_addr);

		if(status == RESOLV_STATUS_RESOLVING) {
			PROCESS_WAIT_EVENT_UNTIL(ev == resolv_event_found);
		} else if(status != RESOLV_STATUS_CACHED) {
			PRINTF("Can't get connection address.\n");
			PROCESS_YIELD();
		}
	}
	printf("exercise2_sink.local address: ");
	PRINT6ADDR(&ip_sink_addr);
	clock_delay_usec(60000);
	printf("\n");
	sink_found = 1;
#endif

	// Specifies a callback for the echo replies:
	// server_notification is a structure internally used by Contiki
	// echo_reply_handler is the callback function called upon reception of an echo reply
	uip_icmp6_echo_reply_callback_add(&server_notification, echo_reply_handler);
	echo1_request_time=RTIMER_NOW();
	while (1) {
		// Waiting ETIMER_INTERVAL seconds
		etimer_set(&et, ETIMER_INTERVAL);
		PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));

		// Print hello world
		printf("Hello world2!\n");

		// Sends an echo request to a specified address
		if(sink_found){
			echo_request(&ip_sink_addr);
			leds_on(LEDS_GREEN);
			leds_off(LEDS_RED);
		}
	}
	PROCESS_END();
}


/*---------------------------------------------------------------------------*/
PROCESS_THREAD(udp_client_process, ev, data)
{

  PROCESS_BEGIN();
  PRINTF(" process started\n");

 // print_local_addresses();

  PROCESS_WAIT_EVENT_UNTIL(ev==1);

  client_conn = udp_new(&ip_sink_addr, UIP_HTONS(7777), NULL);
  udp_bind(client_conn, UIP_HTONS(8888));

  PRINTF(" local/remote port %u/%u\n", UIP_HTONS(client_conn->lport), UIP_HTONS(client_conn->rport));
  static char buf[sizeof(struct uni_message)];
  while(1) {
	SENSORS_ACTIVATE(button_sensor);
	leds_on(LEDS_GREEN);
	leds_off(LEDS_RED);
	PROCESS_WAIT_EVENT();
	if(ev == sensors_event) {
		if(data == &button_left_sensor) {
			counter++;
			mesg.type_unicast= TYPE_UNICAST_GET_LOCK;
			mesg.white=0;
			mesg.red=0;
			mesg.green=0;
			mesg.blue=0;
			leds_off(LEDS_GREEN);
			leds_on(LEDS_RED);
			led_change_request_time=RTIMER_NOW();
			//memcpy(buf, &payload, sizeof(payload));
			//uip_udp_packet_send(client_conn, buf, UIP_APPDATA_SIZE);
			timeout_handler();
		}
	}
	else if(ev == tcpip_event) {
	tcpip_handler();
	}
  }
  PROCESS_END();
}



PROCESS_THREAD(udp_resource, ev, data)
{
  static struct etimer et;
  uip_ipaddr_t ipaddr;

  PROCESS_BEGIN();

  /* new connection with remote host */
  client_conn = udp_new(&ip_sink_addr, UIP_HTONS(7777), NULL);
  udp_bind(client_conn, UIP_HTONS(8888));
  printf("entered into udp_resource process");
  PRINTF(" local/remote port %u/%u\n", UIP_HTONS(client_conn->lport), UIP_HTONS(client_conn->rport));
  static char buf[sizeof(struct uni_message)];
  while(1) {
	PROCESS_WAIT_EVENT();
	if(ev==EVENT_POST_1){
		mesg.secret=secret_code;
		mesg.type_unicast= TYPE_UNICAST_SET_RESOURCE;
		mesg.white=50;
		mesg.red=0;
		mesg.green=50;
		mesg.blue=0;
		leds_off(LEDS_GREEN);
		leds_on(LEDS_RED);
		printf("responding with secret key");
		//memcpy(buf, &payload, sizeof(payload));
		timeout_handler();
	}
	else if(ev == tcpip_event) {
		tcpip_handler();
	}
  }
  PROCESS_END();
}


PROCESS_THREAD(udp_resend_process, ev, data)
{

  PROCESS_BEGIN();
  PRINTF(" resend process started\n");
  static struct etimer et;
  client_conn = udp_new(&ip_sink_addr, UIP_HTONS(7777), NULL);
  udp_bind(client_conn, UIP_HTONS(8888));
  PRINTF(" local/remote port %u/%u\n", UIP_HTONS(client_conn->lport), UIP_HTONS(client_conn->rport));
  static char buf[sizeof(struct uni_message)];
  while(1) {
		//PROCESS_WAIT_EVENT_UNTIL(ev==3);
		PROCESS_WAIT_EVENT();
		if(ev==EVENT_POST_2){
			while(counter!=0){
				etimer_set(&et, CLOCK_SECOND);
				PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
				mesg.type_unicast= TYPE_UNICAST_GET_LOCK;
				mesg.white=0;
				mesg.red=0;
				mesg.green=0;
				mesg.blue=0;
				leds_off(LEDS_GREEN);
				leds_on(LEDS_RED);
				//memcpy(buf, &payload, sizeof(payload));
				timeout_handler();
			}
		}
		else if(ev == tcpip_event) {
			tcpip_handler();
		}
  }
  PROCESS_END();
}
