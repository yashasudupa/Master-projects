/*
 *	$Id: ExeGraphBBTime.h,v 1.12 2006/11/02 08:02:49 rochange Exp $
 *	Copyright (c) 2005, IRIT UPS.
 *
 *	ExeGraphBBTime.h -- ExeGraphBBTime class interface.
 */
#ifndef OTAWA_LPC2138_PARAM_EXECUTIONGRAPH_BBTIME_H
#define OTAWA_LPC2138_PARAM_EXECUTIONGRAPH_BBTIME_H

#include "ExeGraphBBTime.h"
#include "ParamExeGraph.h"
#include <otawa/ipet.h>
#include <otawa/prop/Identifier.h>



namespace otawa { namespace lpc2138 {

extern Identifier<String> OUTPUT_FILE;
extern Identifier<int> OUTPUT_LEVEL;
extern Identifier<String> GRAPHS_DIR;
extern Identifier<int> PROLOGUE_DEPTH;


using namespace elm::genstruct; 

class ParamExeGraphBBTime: public ExeGraphBBTime<ParamExeGraph> {
protected:
	int _prologue_depth;
	OutStream *_output_stream;
	elm::io::Output *_output;
	String _graphs_dir_name;
	otawa::gensim::SimTrace *_trace;
public:
	ParamExeGraphBBTime(AbstractRegistration& _reg = reg);
	static Registration<ParamExeGraphBBTime> reg;

	void processBB(WorkSpace *ws, CFG *cfg, BasicBlock *bb);
	void processSequence(WorkSpace *ws, CFG *cfg, int nop1, BasicBlock *bb1, int nop2, BasicBlock *bb2);
	void buildPrologueList(BasicBlock * bb,
			ExeSequence<ExeNode> * prologue,
			int capacity,
			elm::genstruct::DLList<ExeSequence<ExeNode> *> * prologue_list,
			int depth);
	class InstIterator : public ParamExeGraph::InstIterator {
	public:
		inline InstIterator(const ExeSequence<ExeNode> * sequence)
		: ParamExeGraph::InstIterator(sequence) {}
	};

protected:
	virtual void configure(const PropList& props);
};



} }	//otawa::lpc2138

#endif // OTAWA_LPC2138_ParamExeGraphBBTime_H
