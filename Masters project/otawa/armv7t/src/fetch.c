/* Generated by gep (118/08/28 18:33:04) copyright (c) 2008 IRIT - UPS */

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <arm/mem.h>
#include <arm/fetch.h>
#include <arm/gen_int.h>
#include <arm/macros.h>
#include "fetch_table.h"

#define arm_error(e) fprintf(stderr, "%s\n", (e))


/**
 * Halt the fetch module.
 */
static void halt_fetch(void) {
}

/**
 * Initialize the fetch module.
 */
static void init_fetch(void) {
}



/**
 *  initialization and destruction of arm_fetch_t object
 */
static int number_of_fetch_objects = 0;


/**
 * Initialize a fetch handler.
 * @param pf	Current platform.
 * @param state	State to fetch instruction from. */
arm_fetch_t *arm_new_fetch(arm_platform_t *pf, arm_state_t *state)
{
	arm_fetch_t *res = malloc(sizeof(arm_fetch_t));
	if (res == NULL)
		arm_error("not enough memory to create a arm_fetch_t object"); /* I assume error handling will remain the same, we use arm_error istead of iss_error ? */
	res->mem = arm_get_memory(pf, ARM_MAIN_MEMORY);
	res->state = state;	if (number_of_fetch_objects == 0)
		init_fetch();
	number_of_fetch_objects++;
	return res;
}


/**
 * Delete the given fetch handler.
 * @param fetch		Fetch handler to delete.
 */
void arm_delete_fetch(arm_fetch_t *fetch)
{
	if (fetch == NULL)
		/* we shouldn't try to free a void fetch_t object, should this output an error ? */
		arm_error("cannot delete an NULL arm_fetch_t object");
	free(fetch);
	number_of_fetch_objects--;
	/*assert(number_of_fetch_objects >= 0);*/
	if (number_of_fetch_objects == 0)
		halt_fetch();
}

			
/**
 * Assemble bits representing the opcode.
 * @param	instr	Instruction work.
 * @param	mask	Mask of bits to group.
 * @return			Opcode.
 */
static uint32_t make_opcode32(uint32_t instr, uint32_t mask) {
	int i;
	uint32_t tmp_mask;
	uint32_t res = 0;

	tmp_mask = mask;
	for (i = 32 - 1; i >= 0; i--) {
		if (tmp_mask & 0x80000000) {
			res <<= 1;
			res |= ((instr >> i) & 0x01);
		}
		tmp_mask <<= 1;
	}
	return res;
}


/**
 * Fetch the instruction at the given address.
 * @param fetch		Fetch handler.
 * @param address	Address to fetch from.
 * @param code		Bytes to store instruction code in.
 * @param table	Table to get decoding tree from. */
arm_ident_t arm_fetch_32(arm_fetch_t *fetch, arm_address_t address, uint32_t *code, Table_Decodage_32 *table) {
	uint32_t valeur;
	Table_Decodage_32 *ptr;
	Table_Decodage_32 *ptr2 = table;
	*code = arm_mem_read32(fetch->mem, address);
#	ifdef ARM_ORDER_BYTES32 
		{ uint8_t *buff = (uint8_t *)code; ARM_ORDER_BYTES32; }
#	endif
	do {
		valeur = make_opcode32(*code, ptr2->mask);
		ptr  = ptr2;
		ptr2 = ptr->table[valeur].ptr;
	} while(ptr->table[valeur].type == TABLEFETCH);
	return (arm_ident_t)ptr->table[valeur].ptr;
}


/**
 * Fetch and decode an instruction (for CISC instruction set).
 * @param fetch		Fetch handler.
 * @param address	Address of instruction to fetch.
 * @param code		Bytes to store instruction word in.
 * @param table	Fetch table to use. * @return			Index of the fetched instruction.
 */
arm_ident_t arm_fetch_CISC(arm_fetch_t *fetch, arm_address_t address, mask_t *code, Table_Decodage_CISC *table) {
	uint32_t value;
	Table_Decodage_CISC *ptr;
	Table_Decodage_CISC *ptr2 = table;

	do {
		
		/* if inst buffer has not enough bits to apply mask, read and add what's needed, read a 32 bit chunk (like in mask_t) at a time */
		while (get_mask_length(code) < get_mask_length(ptr2->mask)) {
			uint8_t buff[4];
			uint32_t word;
			arm_mem_read(fetch->mem, address + (get_mask_length(code) >> 3), buff, 4);
#			ifdef ARM_ORDER_BYTES_CISC
				ARM_ORDER_BYTES_CISC;
#			elif HOST_ENDIANNESS == TARGET_ENDIANNESS
				word = (buff[0] << 24) | (buff[1] << 16) | (buff[2] << 8) | buff[3];
#			endif
			set_mask_chunk(code, get_mask_length(code) >> 5, word);
			set_mask_length(code, get_mask_length(code) + 32);
		}

		/* compute value on mask */
		value = value_on_mask(code, ptr2->mask);
                ptr  = ptr2;
		ptr2 = ptr->table[value].ptr;

	} while (ptr->table[value].type == TABLEFETCH);

	return (arm_ident_t)ptr->table[value].ptr;
}



/**
 * Fetch the instruction at the given address.
 * @param fetch		Fetch handler.
 * @param address	Address to fetch from.
 * @param code		Bytes to store instruction code in.
 */
arm_ident_t arm_fetch(arm_fetch_t *fetch, arm_address_t address, code_t *code) {
	arm_state_t *state = fetch->state;
	assert(state);
		if ((((uint32_t)(arm_bit32(ARM_APSR, 5))) == 0)) {
		return arm_fetch_32(fetch, address, &code->u32, arm_table_0);
			}
		if ((((uint32_t)(arm_bit32(ARM_APSR, 5))) == 1)) {
		return arm_fetch_CISC(fetch, address, code->mask, arm_table_1);	}
	
}
