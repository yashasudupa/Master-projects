/* Generated by gep (118/08/28 18:32:29) copyright (c) 2008 IRIT - UPS */

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <ppc/mem.h>
#include <ppc/fetch.h>
#include <ppc/gen_int.h>
#include <ppc/macros.h>
#include "fetch_table.h"

#define ppc_error(e) fprintf(stderr, "%s\n", (e))


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
 *  initialization and destruction of ppc_fetch_t object
 */
static int number_of_fetch_objects = 0;


/**
 * Initialize a fetch handler.
 * @param pf	Current platform.
 * @param state	State to fetch instruction from. */
ppc_fetch_t *ppc_new_fetch(ppc_platform_t *pf, ppc_state_t *state)
{
	ppc_fetch_t *res = malloc(sizeof(ppc_fetch_t));
	if (res == NULL)
		ppc_error("not enough memory to create a ppc_fetch_t object"); /* I assume error handling will remain the same, we use ppc_error istead of iss_error ? */
	res->mem = ppc_get_memory(pf, PPC_MAIN_MEMORY);
	res->state = state;	if (number_of_fetch_objects == 0)
		init_fetch();
	number_of_fetch_objects++;
	return res;
}


/**
 * Delete the given fetch handler.
 * @param fetch		Fetch handler to delete.
 */
void ppc_delete_fetch(ppc_fetch_t *fetch)
{
	if (fetch == NULL)
		/* we shouldn't try to free a void fetch_t object, should this output an error ? */
		ppc_error("cannot delete an NULL ppc_fetch_t object");
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
ppc_ident_t ppc_fetch_32(ppc_fetch_t *fetch, ppc_address_t address, uint32_t *code, Table_Decodage_32 *table) {
	uint32_t valeur;
	Table_Decodage_32 *ptr;
	Table_Decodage_32 *ptr2 = table;
	*code = ppc_mem_read32(fetch->mem, address);
#	ifdef PPC_ORDER_BYTES32 
		{ uint8_t *buff = (uint8_t *)code; PPC_ORDER_BYTES32; }
#	endif
	do {
		valeur = make_opcode32(*code, ptr2->mask);
		ptr  = ptr2;
		ptr2 = ptr->table[valeur].ptr;
	} while(ptr->table[valeur].type == TABLEFETCH);
	return (ppc_ident_t)ptr->table[valeur].ptr;
}


/**
 * Fetch and decode an instruction (for CISC instruction set).
 * @param fetch		Fetch handler.
 * @param address	Address of instruction to fetch.
 * @param code		Bytes to store instruction word in.
 * @param table	Fetch table to use. * @return			Index of the fetched instruction.
 */
ppc_ident_t ppc_fetch_CISC(ppc_fetch_t *fetch, ppc_address_t address, mask_t *code, Table_Decodage_CISC *table) {
	uint32_t value;
	Table_Decodage_CISC *ptr;
	Table_Decodage_CISC *ptr2 = table;

	do {
		
		/* if inst buffer has not enough bits to apply mask, read and add what's needed, read a 32 bit chunk (like in mask_t) at a time */
		while (get_mask_length(code) < get_mask_length(ptr2->mask)) {
			uint8_t buff[4];
			uint32_t word;
			ppc_mem_read(fetch->mem, address + (get_mask_length(code) >> 3), buff, 4);
#			ifdef PPC_ORDER_BYTES_CISC
				PPC_ORDER_BYTES_CISC;
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

	return (ppc_ident_t)ptr->table[value].ptr;
}



/**
 * Fetch the instruction at the given address.
 * @param fetch		Fetch handler.
 * @param address	Address to fetch from.
 * @param code		Bytes to store instruction code in.
 */
ppc_ident_t ppc_fetch(ppc_fetch_t *fetch, ppc_address_t address, code_t *code) {
	ppc_state_t *state = fetch->state;
	assert(state);
		if ((((uint32_t)(PPC_VLE)) == 0)) {
		return ppc_fetch_32(fetch, address, &code->u32, ppc_table_0);
			}
		if ((((uint32_t)(PPC_VLE)) == 1)) {
		return ppc_fetch_CISC(fetch, address, code->mask, ppc_table_1);	}
	
}
