/*
 *	ARM7ParamExeGraph implementation
 *
 *	This file is part of OTAWA
 *	Copyright (c) 2005, IRIT UPS.
 *
 *	OTAWA is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation; either version 2 of the License, or
 *	(at your option) any later version.
 *
 *	OTAWA is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with OTAWA; if not, write to the Free Software
 *	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
#include "ARM7ParamExeGraph.h"
#include <otawa/loader/arm.h>

#include "../mam/CATMAMBuilder.h"
#include "../mam/MAMProblem.h"

using namespace otawa;

#define FLASH_MISS_LATENCY flash_miss
#define FLASH_HIT_LATENCY flash_hit


namespace otawa { namespace lpc2138 {

/**
 * Build the exegraph.
 * @param fw				Current workspace.
 * @param microprocessor	Used microprocessor.
 * @param sequence			Instruction sequence.
 * @param has_pred
 * @param trace				Log system.
 * @param _flash_hit		Cost of flash hit.
 * @param _flash_miss		Cost of flash miss.
 */
ARM7ParamExeGraph::ARM7ParamExeGraph (
	WorkSpace *fw,
	Microprocessor<ParamExeNode> * microprocessor,
	ExeSequence<ParamExeNode> *sequence,
	bool has_pred,
	otawa::gensim::SimTrace *trace,
	int _flash_hit,
	int _flash_miss)
:  ParamExeGraph(fw, microprocessor, sequence, has_pred, trace),
   flash_hit(_flash_hit),
   flash_miss(_flash_miss)
{
	info = arm::Info::ID(fw->process());
	ASSERT(info);
}


/**
 */
ARM7ParamExeGraph::~ARM7ParamExeGraph(void) {
}


/**
 * Determine the MAM fetch behaviour.
 * @param inst	Concerned instruction.
 * @return		Type of fetch behaviour.
 */
ARM7ParamExeGraph::inst_fetch_case_t ARM7ParamExeGraph::getInstructionFetchCase(Inst *inst){
	switch(MAM_CATEGORY(inst)) {
	case MAM_ALWAYS_HIT:			return(INST_HIT);
	case MAM_ALWAYS_MISS_STRONG:
	case MAM_ALWAYS_MISS_NC:
	case MAM_NOT_CLASSIFIED:		return(INST_MISS);
	case MAM_ALWAYS_MISS_WEAK:		return(INST_PREFETCHED);
	default:						ASSERT(0); return INST_MISS;
	}
}


/**
 * Obtain the address of the instruction causing preferching.
 * @param inst	Examined instruction.
 * @return		Instruction causing prefetch.
 */
address_t ARM7ParamExeGraph::getPrefetchTriggeringAddress(Inst *inst){
	return(MAM_PREFETCH_FROM(inst));
}


/**
 * Get the latency according to prefetch behaviour.
 * @param fetch_case	Prefetch behaviour.
 * @return				Maching latency.
 */
int ARM7ParamExeGraph::getInstructionFetchLatency(inst_fetch_case_t fetch_case) {
	switch(fetch_case) {
	case INST_MISS:			return(FLASH_MISS_LATENCY);
	case INST_HIT:			return(FLASH_HIT_LATENCY);
	case INST_PREFETCHED:	return(FLASH_HIT_LATENCY);
	default:				ASSERT(false); return 0;
	}
}


/**
 * Get the data access behaviour.
 * @param inst		Instruction accessing data.
 * @return			Data access behaviour.
 */
ARM7ParamExeGraph::data_access_case_t ARM7ParamExeGraph::getDataAccessCase(Inst *inst){
	// TODO It is not clear what is: hit/miss in flash?
	ASSERT(inst->isLoad() || inst->isStore());
	//return (arm::IS_SP_RELATIVE(inst) ? DATA_HIT : DATA_MISS);
	return(DATA_HIT);
}


/**
 * Get the latency of data access by the given instruction.
 * @param inst		Current instruction.
 * @return			Data access latency.
 */
int ARM7ParamExeGraph::getDataAccessLatency(Inst *inst) {
	if (getDataAccessCase(inst) == DATA_MISS)
		return(FLASH_MISS_LATENCY);
	else
		return(FLASH_HIT_LATENCY);
}


/**
 * Compute time to end the instruction.
 * @param inst	Instruction to compute for.
 * @return		Time to completion.
 */
int ARM7ParamExeGraph::getCompletionLatency(Inst *inst) {

	// non-ALU, non-load branch
	if(inst->isControl()
	&& !(inst->kind() & otawa::Inst::IS_ALU)
	&& !(inst->kind() & otawa::Inst::IS_LOAD))
		return (0);

	// multiplication
	if (inst->kind() & otawa::Inst::IS_MUL) {
		if(inst->kind() & 0x00200000) // 64 bits multiplication, hence extra cycle
			return (5);
		else
			return (4);
	}
	
	if (inst->kind() & 0x00100000) { // MLA
		if(inst->kind() & 0x00200000) // 64 bits multiplication, hence extra cycle
			return (7);
		else
			return (6);
	}
	

	// ALU
	if (inst->kind() & otawa::Inst::IS_ALU) {

		// with shifted register
		if (inst->kind() & otawa::Inst::IS_SHIFT) {
			return (1);
		}

		// without shifted register
		else {
			return (0);
		}
	}

	// load
	if(inst->isLoad()) {
		int num_regs = 1;
		if(inst->isMulti())
			num_regs = elm::ones(info->multiMask(inst));
		return (num_regs * getDataAccessLatency(inst) + 1);
	}

	// store
	if(inst->isStore()) {
		int num_regs = 1;
		if(inst->isMulti())
			num_regs = elm::ones(info->multiMask(inst));
		return (num_regs * getDataAccessLatency(inst));
	}

	return 0;
}


/**
 * Compute the fetch delay for an instruction.
 * @param inst		Current instruction.
 * @return			Matching fetch delay.
 */
int ARM7ParamExeGraph::getFetchDelay(Inst *inst) {

	// B, BX
	if(	inst->isControl()
	&&	!(inst->kind() & otawa::Inst::IS_ALU)
	&&	!(inst->kind() & otawa::Inst::IS_LOAD))
		return(0);

	// ALU
	if(inst->kind() & otawa::Inst::IS_ALU) {
		if (inst->kind() & otawa::Inst::IS_SHIFT) {
			if (inst->kind() & otawa::Inst::IS_CONTROL) // ALU shifted toPC
				return(1);
			else 	// ALU shifted
				return(0);
		}
		else // ALU
			return(0);
	}

	// multiplication
	if (inst->kind() & otawa::Inst::IS_MUL){
		if (otawa::arm::IS_MLA(inst)) 	// MLA
			return(1);
		else 							// MUL
			return(0);
	}

	// load
	if (inst->isLoad()) {
		int num_regs = 1;
		if(inst->isMulti())
			num_regs = elm::ones(info->multiMask(inst));
		if (num_regs == 1) {
			if (inst->kind() & otawa::Inst::IS_CONTROL)		// LOAD 1 toPC
				return(getDataAccessLatency(inst) + 1);
			else											// LOAD 1
				return(getDataAccessLatency(inst));
		}
		else {
			if (inst->kind() & otawa::Inst::IS_CONTROL) 	// LOAD MULTIPLE toPC
				return(num_regs * getDataAccessLatency(inst) + 1);
			else 											// LOAD MULTIPLE
				return(num_regs * getDataAccessLatency(inst));
		}
	}

	// store
	if (inst->isStore()) {
		int num_regs = 1;
		if(inst->isMulti())
			num_regs = elm::ones(info->multiMask(inst));
		if (num_regs==1)
			return(getDataAccessLatency(inst));
		else
			return(num_regs * getDataAccessLatency(inst));
	}

	// else 0
	return 0;
}


/**
 * Build the graph itself.
 * @param fw				Current workspace.
 * @param microprocessor	Current microprocessor.
 * @param sequence			Instruction sequence.
 */
void ARM7ParamExeGraph::newBuild(WorkSpace *fw,  Microprocessor<ParamExeNode> * microprocessor, ExeSequence<ParamExeNode> *sequence) {
	_sequence = sequence;
	_microprocessor = microprocessor;

	// init rename tables
	otawa::hard::Platform *pf = fw->platform();
	AllocatedTable<rename_table_t> rename_tables(pf->banks().count());
	int reg_bank_count = pf->banks().count();
	for(int i = 0; i <reg_bank_count ; i++) {
		rename_tables[i].reg_bank = (otawa::hard::RegBank *) pf->banks()[i];
		rename_tables[i].table = new AllocatedTable<ParamExeNode *>(rename_tables[i].reg_bank->count());
		for (int j=0 ; j<rename_tables[i].reg_bank->count() ; j++)
			rename_tables[i].table->set(j, 0);
	}

	// clear node queues for instructions and for pipeline stages
	for (PipelineIterator stage(microprocessor) ; stage ; stage++) {
		stage->deleteNodes();
		if (stage->usesFunctionalUnits())
			for(FunctionalUnitIterator fu(stage); fu; fu++)
				for (FunctionalUnitPipelineIterator fu_stage(fu); fu_stage; fu_stage++)
					fu_stage->deleteNodes();
	}
	int bb_num = -1;
	int nb_inst = 0;
	for (InstIterator inst(sequence) ; inst ; inst++) {
		inst->deleteNodes();
		nb_inst++;
	}

	// build nodes
	// consider every pipeline stage
	for (PipelineIterator stage(microprocessor) ; stage ; stage++) {
		code_part_t current_code_part = BEFORE_PROLOGUE;

		// consider every instruction
		for (InstIterator inst(sequence) ; inst ; inst++)  {

			// the instruction before the prologue (if any) is unknown
			// => it deserves a specific treatment
			if (inst->codePart() == BEFORE_PROLOGUE) {
				ParamExeNode * node = new ParamExeNode(this, stage, inst);
				node->setLatency(MIN,0);
				node->setLatency(MAX,0);
				inst->addNode(node);
				stage->addNode(node);
				if (microprocessor->operandProducingStage() == stage)
					for (int b=0 ; b<reg_bank_count ; b++)
						for (int r=0 ; r < rename_tables[b].reg_bank ->count() ; r++)
							rename_tables[b].table->set(r,node);
				setFirstNode(BEFORE_PROLOGUE,inst->firstNode());
				setLastNode(BEFORE_PROLOGUE,inst->lastNode());
			}

			// other instructions
			else {

				// FE or DE
				if (!stage->usesFunctionalUnits()) {
					ParamExeNode * node = new ParamExeNode(this, stage, inst);
					inst->addNode(node);
					stage->addNode(node);
					if (microprocessor->operandReadingStage() == stage)
						node->setNeedsOperands(true);
					if (microprocessor->operandProducingStage() == stage)
						node->setProducesOperands(true);
				}

				// EX
				else {

					// find FU
					PipelineStage<ParamExeNode>::FunctionalUnit *fu = stage->findFU(inst->inst()->kind());
					bool first_fu_node = true;
					ParamExeNode * node;

					// create FU nodes
					for(FunctionalUnitPipelineIterator fu_stage(fu); fu_stage; fu_stage++) {
						node = new ParamExeNode(this, fu_stage, inst);
						inst->addNode(node);
						fu_stage->addNode(node);
						if (first_fu_node) {
							stage->addNode(node);
							if (microprocessor->operandReadingStage() == stage)
								node->setNeedsOperands(true);
							first_fu_node = false;
						}
					}
					if (microprocessor->operandProducingStage() == stage)
						node->setProducesOperands(true);
				}

				// record start of code part
				if (inst->codePart() != current_code_part) {
					current_code_part = inst->codePart();
					setFirstNode(current_code_part,inst->firstNode());
				}
				setLastNode(current_code_part,inst->lastNode());
			}
		}
	}

	// record information
	setEntryNode(sequence->first()->firstNode());
	bool trace = false;

	// build edges for pipeline order and data dependencies
	for (InstIterator inst(sequence) ; inst ; inst++)  {
		ParamExeNode * previous = 0;
		for (InstNodeIterator node (inst) ; node ; node++) {

			// fist node
			if (previous != 0) {
				// edge between consecutive pipeline stages
				ExeEdge *edge = new ExeEdge(previous, node, ExeEdge::SOLID);
				if (trace)
					elm::cout << "SOLID edge between " << previous->name() << " and " << node->name() << " (pipeline order)\n";
				if (previous->needsOperands()) {
					// set edge latency
					edge->setLatency(getCompletionLatency(previous->inst()->inst()));
				}
			}
			previous = node;

			// note that this instruction produces some registers
			if  (node->producesOperands()) {
				const elm::genstruct::Table<otawa::hard::Register *>& writes =
						node->inst()->inst()->writtenRegs();
				for(int i = 0; i < writes.count(); i++) {
					for (int b=0 ; b<reg_bank_count ; b++) {
						if (rename_tables[b].reg_bank == writes[i]->bank()) {
							rename_tables[b].table->set(writes[i]->number(),node);
						}
					}
				}
			}
		}
	}

	// build edges for program order
	bool in_order = false;
	for (PipelineIterator stage(microprocessor) ; stage ; stage++) {
		if (stage->orderPolicy() == PipelineStage<ParamExeNode>::IN_ORDER) {

			ParamExeNode * previous = 0;
			for (StageNodeIterator node(stage) ; node ; node++) {
				if (previous != 0) {
					// scalar stage => draw a solid edge
					ExeEdge * edge = new ExeEdge(previous, node, ExeEdge::SOLID);
					if (trace)
						elm::cout << "SOLID edge between " << previous->name() << " and " << node->name() << " (program order)\n";
					if (previous->needsOperands())	// set edge latency		TODO	check this?
						edge->setLatency(getCompletionLatency(previous->inst()->inst()));
				}
				previous = node;
			}
		}

		// in EX
		if (stage == microprocessor->operandProducingStage()) {
			PipelineStage<ParamExeNode> * prod_stage;
			for (PipelineIterator st(microprocessor) ; st ; st++)
				if (st->category() == PipelineStage<ParamExeNode>::FETCH) {
					prod_stage = st;
					break;
				}
			for (StageNodeIterator node(stage) ; node ; node++) {
				// compute the index of the instruction that cannot be admitted
				// into the queue until the current instruction leaves it
				int index = node->inst()->index() + 3;
				for (StageNodeIterator waiting_node(prod_stage) ; waiting_node ; waiting_node++)
					if (waiting_node->inst()->index() == index) {
						ExeEdge *edge = new ExeEdge(node, waiting_node, ExeEdge::SOLID);
						edge->setLatency(getFetchDelay(node->inst()->inst()));
						break;
					}
			}
		}
	}

	//build edges for branches
	bool follows_a_branch = false;
	ParamExeNode *branch_execution_node  = 0;
	Inst *branch_inst;
	for (InstIterator inst(sequence) ; inst ; inst++)  {

		// control found
		if(inst->inst()->isControl()) {
			follows_a_branch = true;
			// look for EX stage node
			for (InstNodeIterator node (inst) ; node ; node++)
				if(node->producesOperands()) {
					branch_execution_node = node;
					branch_inst = inst->inst();
					break;
				}
		}

		// other instruction
		else {
			if(follows_a_branch) {
				ASSERT(branch_execution_node != 0);
				// not in sequence
				if(inst->inst()->address() != branch_inst->topAddress()) {
					ParamExeNode *target_fetch_node = inst->firstNode();
					ExeEdge *edge = new ExeEdge(branch_execution_node, target_fetch_node, ExeEdge::SOLID);
					edge->setLatency(getCompletionLatency(branch_inst));
				}
			}
			follows_a_branch = false;
			branch_execution_node  = 0;
		}
	}

	// set latencies and build edges for instruction fetch with the Memory Acceleration Module
	for(InstIterator inst(sequence); inst; inst++)  {

		// compute fetch latency
		ARM7ParamExeGraph::inst_fetch_case_t fetch_case = getInstructionFetchCase(inst->inst());
		int latency = getInstructionFetchLatency(fetch_case);
		ParamExeNode *fetch_node = inst->firstNode();
		fetch_node->setLatency(latency);

		// special case of prefetched instruction
		if (fetch_case == INST_PREFETCHED) {
			address_t triggering_address = getPrefetchTriggeringAddress(inst->inst());
			bool found = false;

			// find the prefetching instruction (if any in the sequence)
			for(InstIterator prev_inst(sequence); prev_inst; prev_inst++)  {
				if(prev_inst->index() >= inst->index())
					break;

				// found: edge and prefetch latency
				if (prev_inst->inst()->address().offset() == triggering_address) {
					ExeEdge *edge = new ExeEdge(prev_inst->firstNode(), fetch_node, ExeEdge::SOLID);
					edge->setLatency(FLASH_MISS_LATENCY - FLASH_HIT_LATENCY);
					found = true;
				}

				 // only data accesses after the triggering instruction may reinitiate the prefetch
				if(found) {
					if(FLASH_MISS_LATENCY > FLASH_HIT_LATENCY)
						if (prev_inst->inst()->isLoad() || prev_inst->inst()->isStore()) {
							if (getDataAccessCase(prev_inst->inst()) == DATA_MISS) {
								ExeEdge *edge = new ExeEdge(prev_inst->lastNode(), fetch_node, ExeEdge::SOLID);
								edge->setLatency(FLASH_MISS_LATENCY - FLASH_HIT_LATENCY);
							}
						}
				}

				// not found => consider the inst. fetch is a miss
				else
					fetch_node->setLatency(getInstructionFetchLatency(INST_MISS));
			}
		}
	}


	// clean up
	for(int i = 0; i <reg_bank_count ; i++)
		delete rename_tables[i].table;
}


/**
 * Output exegraph as a chart.
 * @param charFile	File to output to.
 */
void  ARM7ParamExeGraph::dumpChart(elm::io::Output& chartFile) {

	ParamExeNode * chart[100][4];
	for (int t=0 ; t<100 ; t++) {
		for (int s=0; s<4 ; s++)
			chart[t][s] = 0;
	}
	for (InstIterator inst(_sequence) ; inst ; inst++){
		int stage_index = 0;
		for (InstNodeIterator node(inst) ; node ; node++){
			int time = node->d(0);
			if (time < 100)
				chart[time][stage_index] = node;
			stage_index++;
		}
	}
	for (int t=0 ; t<100 ; t++) {
		chartFile << "\t" << t;
	}
	chartFile << "\n";
	for (int s=0 ; s<4 ; s++) {
		switch(s){
		case 0:
			chartFile << "F";
			break;
		case 1:
			chartFile << "D";
			break;
		case 2:
			chartFile << "E";
			break;
		case 3:
			chartFile << "C";
			break;
		}
		for (int t=0 ; t<100 ; t++) {
			chartFile << "\t";
			if (chart[t][s])
				chartFile << chart[t][s]->pipelineStage()->shortName() << "(i" <<  chart[t][s]->inst()->index() << ")";
		}
		chartFile << "\n";
	}
}


/**
 * Dump exegraph to a dot file.
 * @param dotFile	Stream to dump to.
 */
void ARM7ParamExeGraph::dump(elm::io::Output& dotFile) {

	dotFile << "digraph G {\n";
	dotFile << "\"legend\" [shape=record, label= \"{ ";
	int i=0;
	bool first_line = true;
	int width = 5;
	for (elm::genstruct::Vector<Resource *>::Iterator res(_resources) ; res ; res++) {
		if (i == 0) {
			if (!first_line)
				dotFile << " | ";
			first_line = false;
			dotFile << "{ ";
		}
		dotFile << res->name();
		if (i < width-1){
			dotFile << " | ";
			i++;
		}
		else {
			dotFile << "} ";
			i = 0;
		}
	}
	if (i!= 0)
		dotFile << "} ";
	dotFile << "} ";
	dotFile << "\"] ; \n";

	dotFile << "\"code\" [shape=record, label= \"";
	for (InstIterator inst(_sequence) ; inst ; inst++) {
		dotFile << "0x" << inst->inst()->address() << ":  ";
		inst->inst()->dump(dotFile);
		dotFile << "\\" << "n" ;
	}
	dotFile << "\"] ; \n";


	for (InstIterator inst(_sequence) ; inst ; inst++) {
		// dump nodes
		dotFile << "{ rank = same ; ";
		for (InstNodeIterator node(inst) ; node ; node++) {
			dotFile << "\"" << node->pipelineStage()->shortName();
			dotFile << "I" << node->inst()->index() << "\" ; ";
		}
		dotFile << "}\n";
		// again to specify labels
		for (InstNodeIterator node(inst) ; node ; node++) {
			dotFile << "\"" << node->pipelineStage()->shortName();
			dotFile << "I" << node->inst()->index() << "\"";
			dotFile << " [shape=record, ";
			if (node->inst()->codePart() == BODY)
				dotFile << "color=blue, ";
			dotFile << "label=\"" << node->pipelineStage()->shortName();
			dotFile << "(I" << node->inst()->index() << ") ";
			dotFile << "\\nlat=" << node->latency();
			if (node->pipelineStage()->category() == PipelineStage<ParamExeNode>::FETCH) {
				switch(MAM_CATEGORY(node->inst()->inst())){
				case MAM_ALWAYS_HIT:
					dotFile << "\\nMAH";
					break;
				case MAM_ALWAYS_MISS_STRONG:
					dotFile << "\\nMAMs";
					break;
				case MAM_ALWAYS_MISS_NC:
					dotFile << "\\nMNC";
					break;
				case MAM_ALWAYS_MISS_WEAK:
					dotFile << "\\nMAMw";
					address_t address = MAM_PREFETCH_FROM(node->inst()->inst());
					if ((address!= MAM::PF_TOP) && (address!= MAM::PF_BOTTOM))
						dotFile << "\\n(from " << "0x" << Address(address) << ")";
					break;
				}
			}
			dotFile << " | { ";
			int i=0;
			int num = _resources.length();
			while (i < num) {
				int j=0;
				dotFile << "{ ";
				while ( j<width ) {
					if ( (i<num) && (j<num) ) {
						if (node->e(i))
							dotFile << node->d(i, ExeGraph<ParamExeNode>::MIN);
					}
					if (j<width-1)
						dotFile << " | ";
					i++;
					j++;
				}
				dotFile << "} ";
				if (i<num)
					dotFile << " | ";
			}
			dotFile << "} ";
			dotFile << "\"] ; \n";
		}
		dotFile << "\n";
	}


	int group_number = 0;
	for (InstIterator inst(_sequence) ; inst ; inst++) {
		// dump edges
		for (InstNodeIterator node(inst) ; node ; node++) {
			for (Successor next(node) ; next ; next++) {
				if ( node != inst->firstNode()
						||
						(!node->producesOperands())
						|| (node->inst()->index() == next->target()->inst()->index()) ) {
					dotFile << "\"" << node->pipelineStage()->shortName();
					dotFile << "I" << node->inst()->index() << "\"";
					dotFile << " -> ";
					dotFile << "\"" << next->target()->pipelineStage()->shortName();
					dotFile << "I" << next->target()->inst()->index() << "\"";
					switch( next->type()) {
					case ExeEdge::SOLID:
						//if (node->inst()->index() == next->inst()->index())
						dotFile << "[minlen=2, label=\"lat=" << next->latency() << "\"]";
						dotFile << " ;\n";
						break;
					case ExeEdge::SLASHED:
						dotFile << " [style=dotted";
						//if (node->inst()->index() == next->inst()->index())
						dotFile << ", minlen=2";
						dotFile << "] ;\n";
						break;
					default:
						break;
					}
					if ((node->inst()->index() == next->target()->inst()->index())
					|| ((node->pipelineStage()->index() == next->target()->pipelineStage()->index())
					   && (node->inst()->index() == next->target()->inst()->index()-1)) ) {
						dotFile << "\"" << node->pipelineStage()->shortName();
						dotFile << "I" << node->inst()->index() << "\"  [group=" << group_number << "] ;\n";
						dotFile << "\"" << next->target()->pipelineStage()->shortName();
						dotFile << "I" << next->target()->inst()->index() << "\" [group=" << group_number << "] ;\n";
						group_number++;
					}
				}
			}
		}
		dotFile << "\n";
	}
	dotFile << "}\n";
}

} }		// otawa::lpc2138
