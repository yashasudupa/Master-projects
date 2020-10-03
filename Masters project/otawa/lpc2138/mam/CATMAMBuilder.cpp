#include <elm/assert.h>
#include <elm/io.h>
#include <otawa/util/DefaultListener.h>
#include <otawa/util/HalfAbsInt.h>
#include <otawa/util/LBlockBuilder.h>
#include <otawa/cache/cat2/CAT2Builder.h>

#include "MAMBlock.h"
#include "MAMBlockSet.h"
#include "AbsMAMBlockBuilder.h"

#include "CATMAMBuilder.h"
#include "MAMProblem.h"

using namespace elm;
using namespace otawa;
using namespace otawa::util;

namespace otawa {

Registration<CATMAMBuilder> CATMAMBuilder::reg(
	"otawa::lpc2138::CATMAMBuilder", Version(1, 0, 0),
	p::require, &DOMINANCE_FEATURE,
	p::require, &LOOP_HEADERS_FEATURE,
	p::require, &LOOP_INFO_FEATURE,
	p::require, &COLLECTED_MAMBLOCKS_FEATURE,
	p::provide, &MAM_CAT_FEATURE,
	p::end
);

CATMAMBuilder::CATMAMBuilder(void): CFGProcessor(reg) {
}

void CATMAMBuilder::configure (const PropList &props) {
	CFGProcessor::configure(props);
	perfect_mam = PERFECT_MAM(props);
	ASSERT(perfect_mam == false);
}


void CATMAMBuilder::processCFG(WorkSpace *ws, CFG *cfg) {

	// get rowbuf lines
	MAMBlockSet *mlset = MAMBLOCKS(ws);
	
	
	MAMProblem prob(mlset->mamBlockIDCount());
	DefaultListener<MAMProblem> list(ws, prob);
	DefaultFixPoint<DefaultListener<MAMProblem> > fp(list);
	HalfAbsInt<DefaultFixPoint<DefaultListener<MAMProblem> > > hai(fp, *ws);
	hai.solve();
	
	
	// display the result
	for(CFG::BBIterator bb(cfg); bb; bb++) {
		
		if (bb->isEntry() || bb->isExit())
			continue;
		
		bool seq = false;
		bool branch = false;
		
		for (BasicBlock::InIterator inedge(bb); inedge; inedge++) {
			if (inedge->kind() == Edge::NOT_TAKEN) {
				seq = true;
			} else {
				branch = true;
			}
		}		
		/* MAMProblem::Domain &dom = *list.results[cfg->number()][bb->number()]; */

		ASSERT(BB_MAMBLOCKS(bb) != NULL);

		AllocatedTable<MAMBlock*> &mamblocks = **BB_MAMBLOCKS(bb);

		int j = 1; 
		MAMProblem::Domain dom(*list.results[cfg->number()][bb->number()]);
		
		for (int i = 0; i < mamblocks.count(); i++) {
			Inst *first = ws->findInstAt(mamblocks[i]->address());
			ASSERT(first);
			int id = mamblocks[i]->mamBlockID();
			
			if (perfect_mam) {
				MAM_CATEGORY(mamblocks[i]) = MAM_ALWAYS_HIT;
				MAM_CATEGORY(first) = MAM_ALWAYS_HIT;
				continue;
			}
			if ((dom.P.contains(id) && (dom.P.count() == 1)) || ( dom.T.contains(id) && dom.T.count() == 1)) {
				MAM_CATEGORY(first) = MAM_ALWAYS_HIT;
				MAM_CATEGORY(mamblocks[i]) = MAM_ALWAYS_HIT;
			} else if (!dom.P.contains(id) && !dom.T.contains(id)) {
				if (dom.L.contains(id) && (dom.L.count() == 1)) {
				
					MAM_CATEGORY(first) = MAM_ALWAYS_MISS_WEAK;
					MAM_CATEGORY(mamblocks[i]) = MAM_ALWAYS_MISS_WEAK;
					MAM_PREFETCH_FROM(first) = dom.prefetch_from;
					MAM_PREFETCH_FROM(mamblocks[i]) = dom.prefetch_from;
				} else if (!dom.L.contains(id)) {
					MAM_CATEGORY(first) = MAM_ALWAYS_MISS_STRONG;
					MAM_CATEGORY(mamblocks[i]) = MAM_ALWAYS_MISS_STRONG;
				} else {
					MAM_CATEGORY(first) = MAM_ALWAYS_MISS_NC;
					MAM_CATEGORY(mamblocks[i]) = MAM_ALWAYS_MISS_NC;
				}
				
			} else {
				MAM_CATEGORY(first) = MAM_NOT_CLASSIFIED;
				MAM_CATEGORY(mamblocks[i]) = MAM_NOT_CLASSIFIED;

			}
			prob.updateMBlock(dom, mamblocks[i], seq, branch);
			seq = true;
			branch = false;
		}
	}
}

Identifier<mam_category_t> MAM_CATEGORY("otawa::mam_category", MAM_ALWAYS_HIT);
Identifier<address_t> MAM_PREFETCH_FROM("otawa::mam_prefetch_from", 0);
Identifier<bool> PERFECT_MAM("otawa::PERFECT_MAM", false);
Feature<CATMAMBuilder> MAM_CAT_FEATURE("otawa::mam_cat_feature");

} // otawa
