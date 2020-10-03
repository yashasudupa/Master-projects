
#include <stdio.h>
#include <elm/io.h>
#include "MAMBlockSet.h"
#include "AbsMAMBlockBuilder.h"
#include <otawa/ilp.h>
#include <otawa/ipet.h>
#include <otawa/cfg/Edge.h>
#include <otawa/util/Dominance.h>
#include <otawa/cfg.h>
#include <otawa/util/LoopInfoBuilder.h>
#include <otawa/hard/Platform.h>
#include <elm/assert.h>

#include "MAMProblem.h"


using namespace otawa;
using namespace otawa::ilp;
using namespace otawa::ipet;

/**
 * @class MAMProblem
 * 
 * Problem for computing the Abstract Row Buffer State.
 * This implements Ferdinand's May analysis.
 * 
 */

namespace otawa {

address_t const MAM::PF_TOP = 0;
address_t const MAM::PF_BOTTOM = -1;

void MAMProblem::update(Domain& out, const Domain& in, BasicBlock *bb) {
	
	bool seq = false;
	bool branch = false;
	
	for (BasicBlock::InIterator inedge(bb); inedge; inedge++) {
		if (inedge->kind() == Edge::NOT_TAKEN) {
			seq = true;
		} else {
			branch = true;
		}
	}

	assign(out, in);
	
	if (BB_MAMBLOCKS(bb) == NULL)
		return;


	AllocatedTable<MAMBlock*> &mamblocks = **BB_MAMBLOCKS(bb);

	int j = 1; 
	for (int i = 0; i < mamblocks.count(); i++)	{

		updateMBlock(out, mamblocks[i], seq, branch);

		seq = true;
		branch = false;
	}
}

void MAMProblem::updateMBlock(Domain &dom, MAMBlock *mamblock, bool seq, bool branch) {
	Domain branchdom(bot), seqdom(bot);
	int id = mamblock->mamBlockID();
	
	assign(seqdom, dom);
	assign(branchdom, dom);		
	assign(dom, bot);
	
	 
	if (branch) {
		if (!seqdom.P.contains(id)) {
			seqdom.T.empty();
			seqdom.T.add(id);
		} else if ((seqdom.P.contains(id) && (seqdom.P.count() == 1)) || ( seqdom.T.contains(id) && seqdom.T.count() == 1)) {

		} else {
			seqdom.T.add(id);						
		}	
		lub(dom, seqdom);	
	} 
	if (seq) {
		if (!branchdom.T.contains(id)) {			
			branchdom.P.empty();
			branchdom.P.add(id);
		} else if ((branchdom.P.contains(id) && (branchdom.P.count() == 1)) || ( branchdom.T.contains(id) && branchdom.T.count() == 1)) {
		} else {
			branchdom.P.add(id);						
		}
		lub(dom, branchdom);
	}
	
	if (!dom.L.contains(mamblock->next)) {
		dom.prefetch_from = mamblock->address();		
	} else if (dom.L.contains(mamblock->next) && (dom.L.count() == 1)) {
		/* do not touch the prefetch_from */
	} else {
		dom.prefetch_from = MAM::PF_TOP;
	}
	 
	dom.L.empty();
	dom.L.add(mamblock->next);


}

} // otawa

