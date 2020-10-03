/* Generated by gep (118/08/28 18:33:06) copyright (c) 2008 IRIT - UPS */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <arm/fetch.h>
#include <arm/decode.h> /* api.h will be in it, for fetch functions, decode_table.h also */
#include <arm/config.h> /* for memory endiannesses */
#include <arm/gen_int.h>
#include "decode_table.h"

#define arm_error(e) fprintf(stderr, "%s\n", (e))


/* external functions */
			struct Table_Decodage_32;
arm_ident_t arm_fetch_32(arm_fetch_t *fetch, arm_address_t address, uint32_t *code, struct Table_Decodage_32 *table);
					struct Table_Decodage_CISC;
arm_ident_t arm_fetch_CISC(arm_fetch_t *fetch, arm_address_t address, mask_t *code, struct Table_Decodage_CISC *table);
			


/* external tables */
	extern struct Table_Decodage_32 *arm_table_0;
	extern struct Table_Decodage_CISC *arm_table_1;
	

/* decode structure */
struct arm_decoder_t
{
	/* the fetch unit used to retrieve instruction ID */
	arm_fetch_t *fetch;
	/* help determine which decode type if several instr sets defined */
	arm_state_t *state;
	arm_platform_t *pf;};

/* Extern Modules */
/* Constants */
/* Variables & Fonctions */
/* decoding */
arm_inst_t *arm_decode(arm_decoder_t *decoder, arm_address_t address);


/* initialization and destruction of arm_decode_t object */
static int number_of_decoder_objects = 0;

static void init_decoder(arm_decoder_t *d, arm_platform_t *pf)
{
	d->fetch = NULL;
	d->state = NULL;
	d->pf = pf;
	}

static void halt_decoder(arm_decoder_t *d)
{
        arm_delete_fetch(d->fetch);
     
}

arm_decoder_t *arm_new_decoder(arm_platform_t *pf) {
	assert(pf);
    arm_decoder_t *res = malloc(sizeof(arm_decoder_t));
    if (res == NULL)
                arm_error("not enough memory to create a arm_decoder_t object"); /* I assume error handling will remain the same, we use arm_error istead of iss_error ? */
    init_decoder(res, pf);
    number_of_decoder_objects++;
    return res;
}

void arm_delete_decoder(arm_decoder_t *decode)
{
    if (decode == NULL)
        /* we shouldn't try to free a void decoder_t object, should this output an error ? */
                arm_error("cannot delete an NULL arm_decoder_t object");
    number_of_decoder_objects--;
    /*assert(number_of_decode_objects >= 0);*/
    halt_decoder(decode);
    free(decode);
    
}

/** set the state which is used to determine which instruction set we decode for,
 *  selection conditions are expressions using some state registers,
 *  the registers of the given state will be used after a call to this function.
 *  The fetch object will be created here for multi set descriptions.
 *  Does nothing if only one instr set is defined.
*/
void arm_set_cond_state(arm_decoder_t *decoder, arm_state_t *state) {
	assert(decoder);
	
		decoder->state = state;
	decoder->fetch = arm_new_fetch(decoder->pf, state);
	
}



/* Fonctions Principales */
arm_inst_t *arm_decode_32(arm_decoder_t *decoder, arm_address_t address)
{
	arm_inst_t *res = 0;
	arm_ident_t id;
	code_t code;
	
	/* first, fetch the instruction at the given address */
	id = arm_fetch(decoder->fetch, address, &code);
	
	/* then decode it */
	res = arm_decode_table[id](&code);
	res->addr = address;
    
	return res;
}
/* Fonctions Principales */
arm_inst_t *arm_decode_CISC(arm_decoder_t *decoder, arm_address_t address)
{
	arm_inst_t *res = 0;
	arm_ident_t id;
	code_t code;
	/* init a buffer for the read instr, size should be max instr size for the given arch */
	uint32_t i_buff[32 / 32 + (32 % 32? 1: 0)];
	mask_t mask = { i_buff, 0 };
	code.mask = &mask;
	
	/* first, fetch the instruction at the given address */
	id = arm_fetch(decoder->fetch, address, &code);
	
	/* then decode it */
	res = arm_decode_table[id](&code);
	res->addr = address;
    
	return res;
}

/* decoding functions for one specific instr set */

/* access to a specific fetch table */
/* decoding function for instr set 0, named ARM */
arm_inst_t *arm_decode_ARM(arm_decoder_t *decoder, arm_address_t address)
{
	arm_inst_t *res = 0;
	arm_ident_t id;
	code_t code;
	
	/* first, fetch the instruction at the given address, call specialized fetch */
	id = arm_fetch_32(decoder->fetch, address, &code.u32, arm_table_0);
		
	
	/* then decode it */
	res = arm_decode_table[id](&code);
	res->addr = address;
    
	return res;
}
/* decoding function for instr set 1, named THUMB */
arm_inst_t *arm_decode_THUMB(arm_decoder_t *decoder, arm_address_t address)
{
	arm_inst_t *res = 0;
	arm_ident_t id;
	code_t code;
	/* init a buffer for the read instr, size should be max instr size for the given arch */
	uint32_t i_buff[32 / 32 + (32 % 32? 1: 0)];
	mask_t mask = { i_buff, 0 };
	code.mask = &mask;
	
	/* first, fetch the instruction at the given address, call specialized fetch */
	id = arm_fetch_CISC(decoder->fetch, address, code.mask, arm_table_1);	
	
	/* then decode it */
	res = arm_decode_table[id](&code);
	res->addr = address;
    
	return res;
}


arm_inst_t *arm_decode(arm_decoder_t *decoder, arm_address_t address)
{
	arm_state_t *state = decoder->state;
		if ((((uint32_t)(arm_bit32(ARM_APSR, 5))) == 0)) {
		return arm_decode_32(decoder, address);
			}
		if ((((uint32_t)(arm_bit32(ARM_APSR, 5))) == 1)) {
		return arm_decode_CISC(decoder, address);	}
	
}


/* End of file arm_decode.c */
