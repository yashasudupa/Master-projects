/* Generated by gep ($(date)) copyright (c) 2008 IRIT - UPS */

#include <stdlib.h>
#include <stdio.h>
/* #include <math.h>  needed for affiche_valeur_binaire (which is not well coded) */

#include "inst_size.h"

#include "inst_size_table.h"

#define gliss_error(e) fprintf(stderr, (e))


/* Fonctions Principales */

int gliss_inst_size(gliss_inst_t *inst)
{
	return gliss_inst_size_table[inst->ident];
}


/* End of file inst_size.c */
