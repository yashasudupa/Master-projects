/*
 *	$Id: ExecutionGraphBBTime.cpp,v 1.19 2006/11/02 08:03:15 rochange Exp $
 *	Copyright (c) 2005, IRIT UPS.
 *
 *	src/prog/ipet_TrivialBBTime.cpp --TrivialBBTime class implementation.
 */

#include <elm/io/OutFileStream.h>
#include "ParamExeGraphBBTime.h"

using namespace otawa;
using namespace otawa::hard;
using namespace elm;
using namespace elm::genstruct;
using namespace otawa::graph;
using namespace otawa::ipet;
using namespace otawa::gensim;


//#define ACCURATE_STATS
#if defined(NDEBUG) || !defined(ACCURATE_STATS)
#	define STAT(c)
#else
#	define STAT(c) c
#endif

namespace otawa { namespace lpc2138 {

/**
 * Configuration property selecting the file to output log to.
 */
Identifier<String> OUTPUT_FILE("otawa::lpc2138::OUTPUT_FILE", "");


/**
 * Configuration property defining the log output level.
 */
Identifier<int> OUTPUT_LEVEL("otawa::lpc2138::OUTPUT_LEVEL", 0);


/**
 * Configuration property selecting directory to dump exegraph to.
 */
Identifier<String> GRAPHS_DIR("otawa::lpc2138::GRAPHS_DIR","");


/**
 * Configuration property selecting the prolog length to use.
 */
Identifier<int> PROLOGUE_DEPTH("otawa::lpc2138::PROLOGUE_DEPTH", 1);



/**
 * Block time computation analysis for LPC2138 microprocessor.
 */
Registration<ParamExeGraphBBTime> ParamExeGraphBBTime::reg(
	"otawa::lpc2138::ParamExeGraphBBTime", Version(1, 0, 0),
	p::end
);


/**
 */
ParamExeGraphBBTime::ParamExeGraphBBTime(AbstractRegistration& reg)
:	ExeGraphBBTime<ParamExeGraph>(reg),
 	_output_stream(0),
 	_output(0),
 	_trace(0),
 	_prologue_depth(0)
{ }


/**
 */
void ParamExeGraphBBTime::configure(const PropList& props) {
	ExeGraphBBTime<ParamExeGraph>::configure(props);

	// get required depth
	_prologue_depth = PROLOGUE_DEPTH(props);

	// get log file
	if(!OUTPUT_FILE(props).isEmpty()) {
		String file_name = OUTPUT_FILE(props);
		_output_stream = new io::OutFileStream(file_name);
	}
	else
		_output_stream = &(elm::cout.stream());
	_output = new Output(*_output_stream);

	// get output level
	int level = OUTPUT_LEVEL(props);
	_trace = new otawa::gensim::SimTrace(*_output_stream, level,  "ExeGraph");

	// get graph directory
	_graphs_dir_name = GRAPHS_DIR(props);
}


/**
 * Build the list of possible prologs.
 * @param bb				Current BB.
 * @param prologue			Current prologue.
 * @param capacity
 * @param prologue_list		Current list of prologues.
 * @param depth
 */
void ParamExeGraphBBTime::buildPrologueList(
	BasicBlock * bb,
	ExeSequence<ExeNode> * prologue,
	int capacity,
	elm::genstruct::DLList<ExeSequence<ExeNode> *> * prologue_list,
	int depth)
{

	// prologues are recursively built by considering preceeding nodes in the CFG
	for(BasicBlock::InIterator edge(bb); edge; edge++) {

		// get new prolog
		BasicBlock * pred = edge->source();
		ExeSequence<ExeNode> * new_prologue = new ExeSequence<ExeNode>();

		// copy previous instructions
		for (InstIterator inst(prologue) ; inst ; inst++) {
			ExeInst<ExeNode> * eg_inst = new ExeInst<ExeNode>(inst->inst(), inst->basicBlock(), inst->codePart(), inst->index());
			new_prologue->addLast(eg_inst);
		}

		// no need to enlarge prolog
		if(pred->countInstructions() == 0) {
			if (!new_prologue->isEmpty()) {
				// current sequence is terminated (not more instructions to add)
				// (end of recursive building)
				prologue_list->addLast(new_prologue);
			}
		}

		// else look in CFG predecessors
		else {

			// build new sequence from pred
			elm::genstruct::DLList<Inst *> inst_list;
			for(BasicBlock::InstIterator inst(pred); inst; inst++)
				inst_list.addLast(inst);

			while ( !inst_list.isEmpty() ) {
				ExeInst<ExeNode> * eg_inst =
						new ExeInst<ExeNode>(inst_list.last(), pred, ParamExeGraph::PROLOGUE, 0);
				new_prologue->addFirst(eg_inst);
				inst_list.removeLast();
			}

			if((new_prologue->count() < capacity)  // capacity = width of the last pipeline stage
			|| (depth < _prologue_depth) )
				buildPrologueList(pred, new_prologue, capacity, prologue_list,depth+1);
			else
				prologue_list->addLast(new_prologue);
		}
	}
	delete prologue;
}


/**
 */
void ParamExeGraphBBTime::processBB(WorkSpace *ws, CFG *cfg, BasicBlock *bb) {

	// not for entry or exit
	if (bb->countInstructions() == 0)
		return;

	// log
	*_output << "================================================================\n";
	*_output << "Processing block b" << bb->number() << " (starts at " << bb->address() << " - " << bb->countInstructions() << " instructions)\n\n";

	// initialization
	int context_index = 0;
	int maxExecTime = 0;
	elm::genstruct::DLList<ExeSequence<ExeNode> *> prologue_list;

	// compute capacity
	int capacity;
	for (ParamExeGraph::PipelineIterator stage(microprocessor) ; stage ; stage++)
		capacity = stage->width();

	// compute prolog
	ExeSequence<ParamExeNode> * new_prologue = new ExeSequence<ParamExeNode>();
	buildPrologueList(bb, new_prologue, capacity, &prologue_list,0);

	// no prolog case
	if(prologue_list.isEmpty()) {

		// fill sequence
		ExeSequence<ExeNode> sequence;
		int index = 0;
		for(BasicBlock::InstIterator inst(bb); inst; inst++) {
			ExeInst<ExeNode> *eg_inst = new ExeInst<ExeNode>(inst, bb, ParamExeGraph::BODY, index++);
			sequence.addLast(eg_inst);
		}

		// build exegraph
		bool has_pred = false;
		ParamExeGraph execution_graph(ws, microprocessor, &sequence, has_pred, _trace);
		execution_graph.build(ws, microprocessor, &sequence);

		// compute cost
		int bbExecTime = execution_graph.analyze();
		*_output << "Context " << context_index << " (sequence b" << bb->number() << "): wcc = " << bbExecTime << "\n";
		maxExecTime = bbExecTime;

		// dump the execution graph *with times* in dot format
		if(!_graphs_dir_name.isEmpty()) {
			elm::StringBuffer buffer;
			buffer << _graphs_dir_name << "/";
			buffer << bb->number() << "-c" << context_index << ".dot";
			elm::String string = buffer.toString();
			elm::io::OutFileStream dotStream(string);
			elm::io::Output dotFile(dotStream);
			execution_graph.dump(dotFile);
		}
	}

	// prolog case
	else {

		// for each possible prolog
		for (elm::genstruct::DLList<ExeSequence<ExeNode> *>::Iterator sequence(prologue_list) ; sequence ; sequence++) {

			// fill the sequence
			int index = 0;
			for (ExeSequence<ExeNode>::InstIterator inst(sequence) ; inst ; inst++)
					inst->setIndex(index++);
			for(BasicBlock::InstIterator inst(bb); inst; inst++) {
				ExeInst<ExeNode> *eg_inst = new ExeInst<ExeNode>(inst, bb, ParamExeGraph::BODY, index++);
				sequence->addLast(eg_inst);
			}

			// test if there is always a predecessor
			BasicBlock * first_bb = sequence->first()->basicBlock();
			bool has_pred = false;
			for(BasicBlock::InIterator edge(first_bb); edge & !has_pred; edge++) {
				BasicBlock *pred = edge->source();
				if (pred->countInstructions() != 0)
					has_pred = true;
			}
			int bbnum = -1;
			address_t bbadd = 0;

			// build the graph
			ParamExeGraph execution_graph(fw, microprocessor, sequence, has_pred, _trace);
			execution_graph.build(fw, microprocessor, sequence);

			// compute the cost
			int bbExecTime = execution_graph.analyze();

			// output log
			*_output << "Context " << context_index << " (sequence ";
			for (ExeSequence<ExeNode>::InstIterator inst(sequence) ; inst ; inst++) {
				if ((inst->basicBlock()->number() != bbnum) ||(inst->inst()->address() == bbadd)) {
					bbnum = inst->basicBlock()->number();
					bbadd = inst->inst()->address();
					*_output << "b" << bbnum <<  "-";
				}
			}
			*_output << "): wcc = " << bbExecTime << "\n";

			// compute the max cost
			if (bbExecTime > maxExecTime)
					maxExecTime = bbExecTime;

			// dump graph
			if (!_graphs_dir_name.isEmpty()) {
				elm::StringBuffer buffer;
				buffer << _graphs_dir_name << "/";
				buffer << bb->number() << "-c" << context_index << ".dot";
				elm::String string = buffer.toString();
				elm::io::OutFileStream dotStream(string);
				elm::io::Output dotFile(dotStream);
				execution_graph.dump(dotFile);
			}
			context_index++;

		}
	}

	// record BB cost
	*_output << "WCC of block " << bb->number() << " is " << maxExecTime << "\n";
	TIME(bb) = maxExecTime;
}


/**
 * Build a sequence.
 * @param ws	Current workspace.
 * @param cfg	Current CFG.
 * @param nop1	Number of nop to insert before BB1.
 * @param b1	First block.
 * @param nop2	Number of nop to insert before BB2
 * @param bb2	Second block.
 */
void ParamExeGraphBBTime::processSequence(WorkSpace *ws, CFG *cfg, int nop1, BasicBlock *bb1, int nop2, BasicBlock *bb2) {
	ExeSequence<ExeNode> sequence;
	int index = 0;

	// insert NOP prefixing BB1
	for (int i=0 ; i < nop1 ; i++) {
		ExeInst<ExeNode> *eg_inst = new ExeInst<ExeNode>(0, bb1, ParamExeGraph::PROLOGUE, index++);
		sequence.addLast(eg_inst);
	}

	// insert BB1 instructions
	for(BasicBlock::InstIterator inst(bb1); inst; inst++) {
		ExeInst<ExeNode> *eg_inst = new ExeInst<ExeNode>(inst, bb1, ParamExeGraph::PROLOGUE, index++);
		sequence.addLast(eg_inst);
	}

	// insert NOP prefixing BB2
	for (int i=0 ; i<nop2 ; i++) {
		ExeInst<ExeNode> *eg_inst = new ExeInst<ExeNode>(0, bb2, ParamExeGraph::BODY, index++);
		sequence.addLast(eg_inst);
	}

	// insert BB2 instructions
	for(BasicBlock::InstIterator inst(bb2); inst; inst++) {
		ExeInst<ExeNode> *eg_inst = new ExeInst<ExeNode>(inst, bb2, ParamExeGraph::BODY, index++);
		sequence.addLast(eg_inst);
	}

	// log
	for (ExeSequence<ExeNode>::InstIterator inst(&sequence) ; inst ; inst++) {
		elm::cout << inst->index() << ": ";
		if (inst->inst() == 0)
			elm::cout << "NOP";
		else
			inst->inst()->dump(elm::cout);
		elm::cout << "\n";
	}

	//build and compute the exegraph
	ParamExeGraph execution_graph(ws, microprocessor, &sequence, true, _trace);
	execution_graph.build(ws, microprocessor, &sequence);
	int bbExecTime = execution_graph.analyze();
	elm::cout << "wcc = " << bbExecTime << "\n";
}


/**
 * @class ExecutionGraphBBTime
 * This basic block processor computes the basic block execution time using
 * the execution graph method described in the following papers:
 * @li X. Param, A. Roychoudhury, A., T. Mitra, "Modeling Out-of-Order Processors
 * for Software Timing Analysis", Proceedings of the 25th IEEE International
 * Real-Time Systems Symposium (RTSS'04), 2004.
 * @li
 */


/**
 * This property is used to pass the microprocessor description to the
 * code processor. As default, it is extracted from the system description.
 */


/**
 * This property gives an output stream used to output log messages about
 * the execution of the algorithm.
 */
//GenericIdentifier<elm::io::Output *>  ExecutionGraphBBTime::LOG_OUTPUT("otawa.ExecutionGraphBBTime.log", &cerr);


/**
 * Build the ExecutionGraphBBTime processor.
 * @param props	Configuration properties possibly including @ref PROC and
 * @ref LOG.
 */



/**
 * Initialize statistics collection for the given basic block.
 * @param bb	Basic block to use.
 */


/**
 * Record statistics for the given sequence.
 * @param sequence	Sequence to use.
 * @param cost		Cost of the sequence.
 */


/**
 * Record the given node in the prefix tree.
 * @param parent	Parent node.
 * @param bb		Current BB.
 * @param cost		Cost of the current prefix.
 * @return			Node matching the given BB.
 */


/**
 * Record statistics for the given node.
 * @param node	Node to record stats for.
 * @param cost	Cost of the current prefix.
 */




/**
 * Call to end the statistics of the current basic block.
 */


/**
 * Record the time delta on the input edges of the current block.
 * @param insts	Prologue.
 * @param cost	Cost of the block with the current prologue.
 * @param bb	Current basic block.
 */



/**
 * If the statistics are activated, this property is returned in statistics
 * property list to store @ref ExecutionGraphBBTime statistics.
 */
//GenericIdentifier<Vector <stat_t> *>
//	EXEGRAPH_PREFIX_STATS("exegraph_prefix_stats", 0, OTAWA_NS);
//
//
///**
// * If set to the true, ExeGraph will also put @ref TIME_DELTA properties on
// * edges. Using the @ref TimeDetaObjectFunctionModifier, it allow to improve
// * the accuracy of the computed WCET.
// */
//GenericIdentifier<bool> EXEGRAPH_DELTA("exegraph_delta", false, OTAWA_NS);
//
//
///**
// * Set to true in the configuration @ref ExecutionGraphBBTime configure, this
// * processor will generate extra contraints and objects functions factor
// * taking in account the difference of execution time according prologues
// * of evaluated blocks.
// */
//GenericIdentifier<bool> EXEGRAPH_CONTEXT("exegraph_context", false, OTAWA_NS);
//

/**
 * Compute extra context to handle context.
 * @param cost	Cost of the BB.
 * @param stat	Statistics node.
 * @param ctx	Context previous node.
 */


//template ExecutionGraphBBTime<ParamExeGraph>;

} } // otawa::lpc2138
