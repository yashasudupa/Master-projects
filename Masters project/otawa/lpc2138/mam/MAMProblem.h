
#ifndef CACHE_MAMPROBLEM_H_
#define CACHE_MAMPROBLEM_H_

#include <otawa/util/HalfAbsInt.h>
#include <elm/assert.h>
#include <elm/io.h>
#include <elm/util/Pair.h>
#include <otawa/prog/WorkSpace.h>
#include <otawa/cfg/BasicBlock.h>
#include <otawa/dfa/BitSet.h>
#include "MAMBlockSet.h"

using namespace otawa::dfa;

namespace otawa {

class MAM {
	public:
	static address_t const PF_BOTTOM;
	static address_t const PF_TOP;
};



class AMS {
	public:
	BitSet P; /* Prefetch buffer */
	BitSet T; /* Trail buffer */
	BitSet L; /* Latch, trucs en cours de préchargement */
	address_t prefetch_from; 
	inline AMS(int size) : P(size), T(size), L(size), prefetch_from(MAM::PF_BOTTOM) {
	}
};


class MAMProblem {
 
	public:
	typedef AMS Domain;
 
	inline MAMProblem(int size) : bot(size + 1), ent(size + 1),  INVALID_BLOCK(size) { 
		
		/* bottom */
		bot.P.empty();
		bot.T.empty();
		bot.L.empty();
		bot.prefetch_from = MAM::PF_BOTTOM;
		
		/* entry */
		ent.P.empty();
		ent.T.empty();
		ent.L.empty();		
		ent.P.add(INVALID_BLOCK);
		ent.T.add(INVALID_BLOCK);
		ent.L.add(INVALID_BLOCK);
		ent.prefetch_from = MAM::PF_TOP;
	}
	
	inline const Domain& bottom(void) const { return bot; } 
	inline const Domain& entry(void) const { return ent; } 
	inline void lub(Domain &a, const Domain &b) const {
		a.P.add(b.P);
		a.T.add(b.T);
		a.L.add(b.L);
		/*
		if ((a.prefetch_from != MAM::PF_TOP) && (b.prefetch_from != MAM::PF_TOP) &&
			(a.prefetch_from != MAM::PF_BOTTOM) && (b.prefetch_from != MAM::PF_BOTTOM))
			cout << "LUB-addr " << (a.prefetch_from->address()) << " avec " << (b.prefetch_from->address()) ;
		*/
		if (a.prefetch_from == MAM::PF_BOTTOM) {
			a.prefetch_from = b.prefetch_from;
		} else if ((a.prefetch_from != b.prefetch_from) && (b.prefetch_from != MAM::PF_BOTTOM)) {
			a.prefetch_from = MAM::PF_TOP;
		}
		/*
		if ((a.prefetch_from != MAM::PF_TOP) && (b.prefetch_from != MAM::PF_BOTTOM)) {
			cout << " result=" << (a.prefetch_from->address()) << "\n";
		} else cout << "\n";
		*/
	} 
	inline void assign(Domain &a, const Domain &b) const { a = b; }
	inline bool equals(const Domain &a, const Domain &b) const { return ((a.P == b.P) && (a.T == b.T) && (a.L == b.L) && (a.prefetch_from == b.prefetch_from)) ; }
	void update(Domain& out, const Domain& in, BasicBlock* bb);
	inline void enterContext(Domain &dom, BasicBlock *header, otawa::util::hai_context_t&) { }
	inline void leaveContext(Domain &dom, BasicBlock *header, otawa::util::hai_context_t&) { }	
	void updateMBlock(Domain &dom, MAMBlock *lblock, bool seq, bool branch);


	private:
	Domain bot; /* Bottom state */
	Domain ent; /* Entry state */
	const int INVALID_BLOCK;

};

} // otawa

#endif 
