/*
 *	ARM7ParamExeGraph interface
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
#ifndef OTAWA_LPC2138_ARM7PARAMEXEGRAPH_G
#define OTAWA_LPC2138_ARM7PARAMEXEGRAPH_G

#include <otawa/loader/arm.h>
#include "ParamExeGraph.h"

namespace otawa { namespace lpc2138  {

class ARM7ParamExeGraph: public ParamExeGraph {
public:
	typedef enum{INST_HIT=0, INST_MISS=1, INST_PREFETCHED=2} inst_fetch_case_t;
	typedef enum{DATA_HIT=0, DATA_MISS=1} data_access_case_t;
	ARM7ParamExeGraph (
			WorkSpace *fw,
			Microprocessor<ParamExeNode> * microprocessor,
			ExeSequence<ParamExeNode> *sequence,
			bool has_pred,
			otawa::gensim::SimTrace *trace,
			int _flash_hit,
			int _flash_miss);
	virtual ~ARM7ParamExeGraph(void);
	void newBuild(WorkSpace *fw,  Microprocessor<ParamExeNode> * microprocessor, ExeSequence<ParamExeNode> *sequence);
	int getCompletionLatency(Inst *inst);
	int getFetchDelay(Inst *inst);
	inst_fetch_case_t getInstructionFetchCase(Inst *inst);
	address_t getPrefetchTriggeringAddress(Inst *inst);
	int getInstructionFetchLatency(inst_fetch_case_t fetch_case);
	data_access_case_t getDataAccessCase(Inst *inst);
	int getDataAccessLatency(Inst *inst);
	void dump(elm::io::Output& dotFile);
	void dumpChart(elm::io::Output& chartFile);

private:
	int flash_hit;
	int flash_miss;
	arm::Info *info;
};

} } // otawa::lpc2138

#endif // OTAWA_LPC2138_ARM7PARAMEXEGRAPH_G
