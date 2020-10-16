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
/**
 * \addtogroup cc26xx-platforms
 * @{
 *
 * \defgroup cc26xx-examples CC26xx Example Projects
 *
 * Example projects for CC26xx-based platforms.
 * @{
 *
 * \defgroup cc26xx-demo CC26xx Demo Project
 *
 *   Example project demonstrating the CC26xx platforms
 *
 *   This example will work for the following boards:
 *   - srf06-cc26xx: SmartRF06EB + CC26XX EM
 *   - sensortag-cc26xx: CC26XX sensortag
 *
 *   By default, the example will build for the srf06-cc26xx board. To switch
 *   between platforms:
 *   - make clean
 *   - make BOARD=sensortag-cc26xx savetarget
 *
 *     or
 *
 *     make BOARD=srf06-cc26xx savetarget
 *
 *   This is an IPv6/RPL-enabled example. Thus, if you have a border router in
 *   your installation (same RDC layer, same PAN ID and RF channel), you should
 *   be able to ping6 this demo node.
 *
 *   This example also demonstrates CC26xx BLE operation. The process starts
 *   the BLE beacon daemon (implemented in the RF driver). The daemon will
 *   send out a BLE beacon periodically. Use any BLE-enabled application (e.g.
 *   LightBlue on OS X or the TI BLE Multitool smartphone app) and after a few
 *   seconds the cc26xx device will be discovered.
 *
 * - etimer/clock : Every CC26XX_DEMO_LOOP_INTERVAL clock ticks the LED defined
 *                  as CC26XX_DEMO_LEDS_PERIODIC will toggle and the device
 *                  will print out readings from some supported sensors
 * - sensors      : Some sensortag sensors are read asynchronously (see sensor
 *                  documentation). For those, this example will print out
 *                  readings in a staggered fashion at a random interval
 * - Buttons      : CC26XX_DEMO_SENSOR_1 button will toggle CC26XX_DEMO_LEDS_BUTTON
 *                - CC26XX_DEMO_SENSOR_2 turns on LEDS_REBOOT and causes a
 *                  watchdog reboot
 *                - The remaining buttons will just print something
 *                - The example also shows how to retrieve the duration of a
 *                  button press (in ticks). The driver will generate a
 *                  sensors_changed event upon button release
 * - Reed Relay   : Will toggle the sensortag buzzer on/off
 *
 * @{
 *
 * \file
 *     Example demonstrating the cc26xx platforms
 */

#include "contiki.h"  // Contiki core
#include <stdio.h> 	  // Necessary for the printf
#include "button-sensor.h"
#include "dev/leds.h"
#include "board-peripherals.h"
#include "contiki-conf.h"
#include "lib/sensors.h"
#include <stdio.h>
#include "contiki.h"
#include "net/rime/rime.h"
#include "net/rime/unicast.h"
#include "batmon-sensor.h"
#include "radio.h"
#include "contiki-net.h"
//#define ARRAY_SIZE	100

/*---------------------------------------------------------------------------*/

// Global variables
// Application specific event value user for inter-process communication

static struct etimer et;
static process_event_t event_data_ready;
static process_event_t event_data_ready1;

//static int counter = 0;

PROCESS(batmon_process, "Batmon Process");
PROCESS(measure_process, "Measure Process");
PROCESS(Unicast_process, "Example unicast");
PROCESS(Unicast_resource_process, "Resource Process");
PROCESS(Broadcast_process, "Broadcast example");
PROCESS(Unicast_resend_process, "Unicast Resend Process");
AUTOSTART_PROCESSES(&Unicast_process,&Unicast_resource_process,&Broadcast_process,&measure_process,&batmon_process, &Unicast_resend_process);
/*---------------------------------------------------------------------------*/

/*Collecting sensor data*/
PROCESS_THREAD(batmon_process, ev, data){
	PROCESS_EXITHANDLER()  // Cleanup code (if any)
	PROCESS_BEGIN();


	static int enabled_volt;
	static int disabled_volt;
	static int voltage_Readings;
	static int enable_volt = 1;

	while(1) {
		etimer_set(&et, CLOCK_SECOND*20);
		enabled_volt = batmon_sensor.configure(SENSORS_ACTIVE, enable_volt);
		PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
		//PROCESS_YIELD();
		voltage_Readings = batmon_sensor.value(BATMON_SENSOR_TYPE_VOLT);
		printf("The Batmon voltage is equal to %d.%02d V \n", ((voltage_Readings * 125) >> 5)/1000 ,((voltage_Readings * 125) >> 5)%1000 );			
	}
	PROCESS_END();
}


PROCESS_THREAD(measure_process, ev, data){
		PROCESS_EXITHANDLER()  // Cleanup code (if any)
		PROCESS_BEGIN();

		static int enabled_temp;
		static int disable_temp;
		static int temp_Readings;
		static int enable_temp = 1;
		static int value;

		SENSORS_ACTIVATE(button_sensor);
		while(1){
			PROCESS_WAIT_EVENT();
			if(ev == sensors_event){
				if(data == &button_right_sensor){
					//Measure Temperature
					enabled_temp = batmon_sensor.configure(SENSORS_ACTIVE, enable_temp);
					//PROCESS_YIELD();
					value = batmon_sensor.value(BATMON_SENSOR_TYPE_TEMP);
					printf("Temperature : Temperature=%d degree centrigrade\n", value);

					//Measure Barometric Pressure

					SENSORS_ACTIVATE(bmp_280_sensor);
					PROCESS_YIELD();
					value = bmp_280_sensor.value(BMP_280_SENSOR_TYPE_PRESS);
					if(value != CC26XX_SENSOR_READING_ERROR){
						//bmp_pressure_buffer[counter] = value;
						printf("BAR : Pressure=%d.%02d hPa\n", value / 100, value % 100);
					}
					else{
						printf("BAR: Pressure Read Error\n");
						//bmp_pressure_buffer[counter] = 0;
					}

					// Measure Humidity Sensor HDC1000

					SENSORS_ACTIVATE(hdc_1000_sensor);
					PROCESS_YIELD();
					value = hdc_1000_sensor.value(HDC_1000_SENSOR_TYPE_HUMIDITY);
					if(value != CC26XX_SENSOR_READING_ERROR){
						//hdc_humidity_buffer[counter] = value;
						printf("HDC : Humidity=%d.%02d humidity\n", value / 100, value % 100);
					}
					else{
						printf("HDC: Humidity Read Error\n");
						//hdc_humidity_buffer[counter] = 0;
					}
				}
			}
		}
	PROCESS_END();
}

//Global declaration

enum {
	TYPE_UNICAST_GET_LOCK,
	TYPE_UNICAST_GET_LOCK_ACK,
	TYPE_UNICAST_GET_LOCK_NACK,
	TYPE_UNICAST_SET_RESOURCE,
	TYPE_UNICAST_SET_RESOURCE_ACK,
	TYPE_UNICAST_SET_RESOURCE_NACK,
};

uint16_t secret_code;
static struct uni_message{
	uint8_t type_unicast;
	uint8_t reserved;
	uint8_t white;
	uint8_t red;
	uint8_t green;
	uint8_t blue;
	uint16_t secret;
};
static struct broad_message{
	uint8_t type_broadcast;
	uint8_t addr_high;
	uint8_t low;
};
//static process_event_t event_data_ready;
static uint8_t SINK_AVAILABLE;


static void recv_uc(struct unicast_conn *c, const linkaddr_t *from){
	struct uni_message mesg;
	static radio_value_t radio_RSSI;
	if((from->u8[0] == 50) && (from->u8[1] == 0)){
		memcpy(&mesg, packetbuf_dataptr(), sizeof(mesg));
		printf("unicast message received from %d.%d\n",from->u8[0], from->u8[1]);
		if(mesg.type_unicast == TYPE_UNICAST_GET_LOCK_ACK){
			printf("Acknowledged \n");
		}

		if(mesg.type_unicast == TYPE_UNICAST_GET_LOCK_NACK){
			printf("Not Acknowledged \n");
		}

		if(mesg.type_unicast == TYPE_UNICAST_SET_RESOURCE_ACK){
			printf("Resource allocated \n");
			leds_on(LEDS_GREEN);
			leds_off(LEDS_RED);
		}
		if(mesg.type_unicast == TYPE_UNICAST_SET_RESOURCE_NACK){
			printf("Resource not allocated \n");
			leds_on(LEDS_RED);
			leds_off(LEDS_GREEN);
		}
		printf("Secret code is %d \n", mesg.secret);
		secret_code = mesg.secret;
		NETSTACK_RADIO.get_value(RADIO_PARAM_RSSI, &radio_RSSI);
		printf("RSSI in dBm is %d \n", radio_RSSI);
	}

}
/*---------------------------------------------------------------------------*/
static void sent_uc(struct unicast_conn *c, int status, int num_tx){
	uint8_t TxPow = 5;
	const linkaddr_t *dest = packetbuf_addr(PACKETBUF_ADDR_RECEIVER);
	NETSTACK_RADIO.set_value(RADIO_PARAM_TXPOWER, TxPow);
	if(linkaddr_cmp(dest, &linkaddr_null)){
		printf("Unsuccessful");
		return;
	}
	printf("unicast message sent to %d.%d: status %d num_tx %d\n",
	dest->u8[0], dest->u8[1], status, num_tx);
}

/* Unicast communication */

static const struct unicast_callbacks unicast_messages = {recv_uc, sent_uc};
static struct unicast_conn SINK_RIME_UNICAST_CHANNEL;
/*---------------------------------------------------------------------------*/

PROCESS_THREAD(Unicast_process, ev, data){
	PROCESS_EXITHANDLER(unicast_close(&SINK_RIME_UNICAST_CHANNEL));
	PROCESS_BEGIN();

	unicast_open(&SINK_RIME_UNICAST_CHANNEL, 130, &unicast_messages);
	//static struct etimer et;
	event_data_ready = process_alloc_event();
	event_data_ready1 = process_alloc_event();
	while(1){
		leds_on(LEDS_GREEN);
		leds_off(LEDS_RED);
		PROCESS_WAIT_EVENT();
		if(ev == sensors_event){
			if(data == &button_left_sensor){
				printf("Checking if sink is already  taken \n");
				if(SINK_AVAILABLE == 1){  //Sink is taken
					printf("YES \n");
					printf("Waiting for sink to become free \n");
					PROCESS_WAIT_WHILE(SINK_AVAILABLE != 1);    //Wait till Sink is released and become available
					process_post(&Unicast_resend_process, event_data_ready1, NULL);
				}
				else{
					printf("NO \n");
					struct uni_message mesg;
					leds_on(LEDS_RED);
					leds_off(LEDS_GREEN);
					etimer_set(&et, CLOCK_SECOND);
					PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
					mesg.type_unicast = TYPE_UNICAST_GET_LOCK;
					mesg.white = 0;
					mesg.red = 0;
					mesg.green = 0;
					mesg.blue = 0;
					mesg.secret = 0;
					linkaddr_t addr;
					addr.u8[0] = 50;
					addr.u8[1] = 0;
					packetbuf_copyfrom(&mesg, sizeof(struct uni_message));
					//printf("Hello");
					//PROCESS_WAIT_UNTIL(access != 1);
					if(!linkaddr_cmp(&addr, &linkaddr_node_addr)){
						unicast_send(&SINK_RIME_UNICAST_CHANNEL, &addr);
					}
					if(mesg.type_unicast == TYPE_UNICAST_GET_LOCK){
					process_post(&Unicast_resource_process, event_data_ready, NULL);
					}
				}
			}				
		}
	}
	PROCESS_END();
}

/* Resource Process */

PROCESS_THREAD(Unicast_resource_process, ev, data)
{
	PROCESS_EXITHANDLER(unicast_close(&SINK_RIME_UNICAST_CHANNEL));
	PROCESS_BEGIN();
	unicast_open(&SINK_RIME_UNICAST_CHANNEL, 130, &unicast_messages);
	static struct etimer et;
	while(1){
		PROCESS_WAIT_EVENT_UNTIL(ev == event_data_ready);
		etimer_set(&et, CLOCK_SECOND);
		PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
		struct uni_message mesg;
		mesg.type_unicast = TYPE_UNICAST_SET_RESOURCE;
		mesg.white = 50;
		mesg.red = 0;
		mesg.green = 50;
		mesg.blue = 0;
		mesg.secret = secret_code;
		linkaddr_t addr;
		addr.u8[0] = 50;
		addr.u8[1] = 0;
		packetbuf_copyfrom(&mesg, sizeof(struct uni_message));
		if(!linkaddr_cmp(&addr, &linkaddr_node_addr)){
			unicast_send(&SINK_RIME_UNICAST_CHANNEL, &addr);
		}
		//unicast_close(&SINK_RIME_UNICAST_CHANNEL);
	}
	PROCESS_END();
}

enum{
	TYPE_BROADCAST_FREE,
	TYPE_BROADCAST_TAKEN,
};

static void
broadcast_recv(struct broadcast_conn *c, const linkaddr_t *from){
	struct broad_message mesg;
	memcpy(&mesg, packetbuf_dataptr(), sizeof(mesg));
	printf("broadcast message received from %d.%d: '%s'\n",
	     from->u8[0], from->u8[1], (char *)packetbuf_dataptr());
	if(mesg.type_broadcast == TYPE_BROADCAST_FREE){
		printf("Sink is available \n ");
		SINK_AVAILABLE = 0;   //Global variable to check if the Sink is available
	}
	if(mesg.type_broadcast == TYPE_BROADCAST_TAKEN){
		printf("Sink is taken \n");
		SINK_AVAILABLE = 1;
	}
}

static const struct broadcast_callbacks broadcast = {broadcast_recv};
static struct broadcast_conn SINK_RIME_BROADCAST_CHANNEL;

/* Broadcast communication process */

PROCESS_THREAD(Broadcast_process, ev, data){
	static struct etimer et;
	PROCESS_EXITHANDLER(broadcast_close(&SINK_RIME_BROADCAST_CHANNEL));
	PROCESS_BEGIN();
	broadcast_open(&SINK_RIME_BROADCAST_CHANNEL, 129, &broadcast);
	while(1) {
		/* Delay 2-4 seconds */
		etimer_set(&et, CLOCK_SECOND * 4 + random_rand() % (CLOCK_SECOND * 4));
		PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
		//packetbuf_clear();
		//packetbuf_copyfrom("Hello", 6);
		//broadcast_send(&broadcast);
		//printf("broadcast message sent\n");
	}
	PROCESS_END();
}

/* Process to resend the unicast message if the sink is occupied */

PROCESS_THREAD(Unicast_resend_process, ev, data){
	PROCESS_EXITHANDLER(unicast_close(&SINK_RIME_UNICAST_CHANNEL));
	PROCESS_BEGIN();
	PROCESS_WAIT_EVENT_UNTIL(ev == event_data_ready1);
	unicast_open(&SINK_RIME_UNICAST_CHANNEL, 130, &unicast_messages);
	//static struct etimer et;
	while(1){
		//leds_on(LEDS_GREEN);
		//leds_off(LEDS_RED);
		//printf("Hello");
		//printf("ACCESS is %d \n", access);
		struct uni_message mesg;
		leds_on(LEDS_RED);
		leds_off(LEDS_GREEN);
		etimer_set(&et, CLOCK_SECOND);
		PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&et));
		mesg.type_unicast = TYPE_UNICAST_GET_LOCK;
		mesg.white = 0;
		mesg.red = 0;
		mesg.green = 0;
		mesg.blue = 0;
		mesg.secret = 0;
		linkaddr_t addr;
		addr.u8[0] = 50;
		addr.u8[1] = 0;
		packetbuf_copyfrom(&mesg, sizeof(struct uni_message));
		//printf("Hello1");
		//PROCESS_WAIT_UNTIL(access != 1);
		if(!linkaddr_cmp(&addr, &linkaddr_node_addr)){
				unicast_send(&SINK_RIME_UNICAST_CHANNEL, &addr);
		}
		if(mesg.type_unicast == TYPE_UNICAST_GET_LOCK){
				process_post(&Unicast_resource_process, event_data_ready, NULL);
		}
	}
	PROCESS_END();
}
