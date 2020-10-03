/*
 *	ARM7ParamExeGraphBBTime implementation
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

#include <elm/io/OutFileStream.h>
#include <otawa/cfg/features.h>
#include "ARM7ParamExeGraphBBTime.h"

using namespace otawa;
using namespace otawa::hard;
using namespace elm;
using namespace elm::genstruct;
using namespace otawa::graph;
using namespace otawa::ipet;
using namespace otawa::gensim;


namespace otawa { namespace lpc2138 {

/**
 * Configuration property to select directory where chart will be output."""
 */
Identifier<String> CHART_DIR("otawa::lpc2138::CHART_DIR", "");


/**
 * Number of flash hit.
 */
Identifier<int> FLASH_HIT("otawa::lpc2138::FLASH_HIT", 1);


/**
 * Number flash misses.
 */
Identifier<int> FLASH_MISS("otawa::lpc2138::FLASH_MISS", 3);


Registration<ARM7ParamExeGraphBBTime> ARM7ParamExeGraphBBTime::reg(
	"otawa::lpc2138::ARM7ParamExeGraphBBTime", Version(1, 0, 0),
	p::base, &ParamExeGraphBBTime::reg,
	p::require, &otawa::hard::PROCESSOR_FEATURE,
	p::require, &otawa::COLLECTED_CFG_FEATURE,
	p::end
);


ARM7ParamExeGraphBBTime::ARM7ParamExeGraphBBTime(AbstractRegistration& _reg)
: 	ParamExeGraphBBTime(reg),
	flash_hit(0),
	flash_miss(0)
{ }


/**
 */
void ARM7ParamExeGraphBBTime::configure(const PropList &props) {
	ParamExeGraphBBTime::configure(props);
	_chart_dir_name = CHART_DIR(props);
	flash_hit = FLASH_HIT(props);
	flash_miss = FLASH_MISS(props);
}


/**
 */
void ARM7ParamExeGraphBBTime::processBB(WorkSpace *ws, CFG *cfg, BasicBlock *bb) {
	if (bb->countInstructions() == 0)
		return;

	// start log
	if(logFor(LOG_BB)) {
		*_output << "================================================================\n";
		*_output << "Processing block b" << bb->number() << " (starts at " << bb->address() << " - " << bb->countInstructions() << " instructions)\n\n";
	}

	// prepare data
	int context_index = 0;
	int maxExecTime = 0;
	elm::genstruct::DLList<ExeSequence<ExeNode> *> prologue_list;

	// compute capacity
	int capacity;
	for (ParamExeGraph::PipelineIterator stage(microprocessor) ; stage ; stage++)
		capacity = stage->width();

	// build sequence prologue
	ExeSequence<ParamExeNode> * new_prologue = new ExeSequence<ParamExeNode>();
	buildPrologueList(bb, new_prologue, capacity, &prologue_list,0);

	// without prologue
	if (prologue_list.isEmpty()) {

		// build the sequence
		ExeSequence<ExeNode> sequence;
		int index = 0;
		for(BasicBlock::InstIterator inst(bb); inst; inst++) {
			ExeInst<ExeNode> *eg_inst = new ExeInst<ExeNode>(inst, bb, ParamExeGraph::BODY, index++);
			sequence.addLast(eg_inst);
		}

		// build the graph
		bool has_pred = false;
		ARM7ParamExeGraph execution_graph(ws, microprocessor, &sequence, has_pred, _trace, flash_hit, flash_miss);
		execution_graph.newBuild(ws, microprocessor, &sequence);

		// compute time
		int bbExecTime = execution_graph.analyze();
		if(logFor(LOG_BB))
			*_output << "Context " << context_index << " (sequence b" << bb->number() << "): wcc = " << bbExecTime << "\n";
		maxExecTime = bbExecTime;

		// dump the execution graph *with times* in dot format
		if (!_graphs_dir_name.isEmpty()){
			elm::StringBuffer buffer;
			buffer << _graphs_dir_name << "/";
			buffer << bb->number() << "-c" << context_index << ".dot";
			elm::String string = buffer.toString();
			elm::io::OutFileStream dotStream(string);
			elm::io::Output dotFile(dotStream);
			execution_graph.dump(dotFile);
		}

		// dump graph
		if(!_chart_dir_name.isEmpty()){
			elm::StringBuffer buffer;
			buffer << _chart_dir_name << "/";
			buffer << bb->number() << "-c" << context_index << ".txt";
			elm::String string = buffer.toString();
			elm::io::OutFileStream chartStream(string);
			elm::io::Output chartFile(chartStream);
			execution_graph.dumpChart(chartFile);
		}
	}

	// with prologue
	else {
		for (elm::genstruct::DLList<ExeSequence<ExeNode> *>::Iterator sequence(prologue_list) ; sequence ; sequence++) {

			// build the sequence
			int index = 0;
			for (ExeSequence<ExeNode>::InstIterator inst(sequence) ; inst ; inst++) {
				inst->setIndex(index++);
			}
			for(BasicBlock::InstIterator inst(bb); inst; inst++) {
				ExeInst<ExeNode> *eg_inst =
						new ExeInst<ExeNode>(inst, bb, ParamExeGraph::BODY, index++);
				sequence->addLast(eg_inst);
			}

			// test if pred
			BasicBlock * first_bb = sequence->first()->basicBlock();
			bool has_pred = false;
			for(BasicBlock::InIterator edge(first_bb); edge & !has_pred; edge++) {
				BasicBlock * pred = edge->source();
				if (pred->countInstructions() != 0)
					has_pred = true;
			}

			int bbnum = -1;
			address_t bbadd = 0;

			// build the graph
			ARM7ParamExeGraph execution_graph(fw, microprocessor, sequence, has_pred, _trace, flash_hit, flash_miss);
			execution_graph.newBuild(fw, microprocessor, sequence);

			// compute the cost
			int bbExecTime = execution_graph.analyze();

			// dump log
			if(logFor(LOG_BB)) {
				*_output << "Context " << context_index << " (sequence ";
				for (ExeSequence<ExeNode>::InstIterator inst(sequence) ; inst ; inst++) {
					if ((inst->basicBlock()->number() != bbnum) ||(inst->inst()->address() == bbadd)) {
						bbnum = inst->basicBlock()->number();
						bbadd = inst->inst()->address();
						*_output << "b" << bbnum <<  "-";
					}
				}
				*_output << "): wcc = " << bbExecTime << "\n";
			}

			// select max cost
			if (bbExecTime > maxExecTime)
				maxExecTime = bbExecTime;

			// dump exegraph
			if (!_graphs_dir_name.isEmpty()){
				elm::StringBuffer buffer;
				buffer << _graphs_dir_name << "/";
				buffer << bb->number() << "-c" << context_index << ".dot";
				elm::String string = buffer.toString();
				elm::io::OutFileStream dotStream(string);
				elm::io::Output dotFile(dotStream);
				execution_graph.dump(dotFile);
			}
			if (!_chart_dir_name.isEmpty()){
				elm::StringBuffer buffer;
				buffer << _chart_dir_name << "/";
				buffer << bb->number() << "-c" << context_index << ".txt";
				elm::String string = buffer.toString();
				elm::io::OutFileStream chartStream(string);
				elm::io::Output chartFile(chartStream);
				execution_graph.dumpChart(chartFile);
			}

			context_index++;

		}
	}

	// record max cost
	if(logFor(LOG_BB))
		*_output << "WCC of block " << bb->number() << " is " << maxExecTime << "\n";
	TIME(bb) = maxExecTime;
}



} } // otawa::lpc2138
