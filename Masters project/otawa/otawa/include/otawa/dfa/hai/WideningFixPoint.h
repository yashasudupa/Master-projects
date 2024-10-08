/*
 *	$Id$
 *	Widening FixPoint implementation (no loop unrolling)
 *
 *	This file is part of OTAWA
 *	Copyright (c) 2007, IRIT UPS.
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
 *	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 *	02110-1301  USA
 */

#ifndef OTAWA_DFA_HAI_WIDENINGFIXPOINT_H_
#define OTAWA_DFA_HAI_WIDENINGFIXPOINT_H_


#include "HalfAbsInt.h"
#include <otawa/cfg/CFG.h>
#include <otawa/cfg/BasicBlock.h>
#include <otawa/cfg/Edge.h>
#include <otawa/prop/PropList.h>
#include <elm/genstruct/Vector.h>

#ifdef HAI_DEBUG
#	define HAIW_TRACE(t)	cerr << t;
#else
#	define HAIW_TRACE(t)
#endif

namespace otawa { namespace dfa { namespace hai {

template <class Listener>
class WideningFixPoint {
	
	// Types
	public:
	typedef typename Listener::Problem Problem;
	typedef typename Problem::Domain Domain;
		
	private:	
	

	 
	// Fields
	static Identifier<Domain*> STATE;	
	Problem& prob;
	Listener  &list;
	HalfAbsInt<WideningFixPoint> *ai;
	
	public:
	// FixPointState class
	class FixPointState {
		public:
		Domain headerState;
		inline FixPointState(const Domain &bottom): headerState(bottom){
		}
	};
	
	inline FixPointState *newState(void) {
		return(new FixPointState(bottom()));
	}

	
	inline WideningFixPoint(Listener & _list)
	:prob(_list.getProb()),list(_list),ai(0)
	{
	}	
	// Destructor
	inline ~WideningFixPoint() {
	}
	
	// Accessors
	
	// Mutators 
	inline void init(HalfAbsInt<WideningFixPoint> *_ai);
	
	// FixPoint function
	void fixPoint(BasicBlock *bb, bool &fixpoint, Domain &in, bool firstTime) const;
	
	// Edge marking functions
	inline void markEdge(PropList *e, const Domain &s);
	inline void unmarkEdge(PropList *e);
	inline Domain *getMark(PropList *e);
	inline void updateEdge(Edge *edge, Domain &dom);
	
	// Problem wrapper functions
	inline const Domain& bottom(void) const;
	inline const Domain& entry(void) const;
	inline void lub(Domain &a, const Domain &b) const;
	inline void assign(Domain &a, const Domain &b) const;
	inline bool equals(const Domain &a, const Domain &b) const;
	inline void update(Domain &out, const Domain &in, BasicBlock* bb);
	inline void blockInterpreted(BasicBlock* bb, const Domain& in, const Domain& out, CFG *cur_cfg, elm::genstruct::Vector<Edge*> *callStack) const;
	inline void fixPointReached(BasicBlock* bb) const;
	inline void enterContext(Domain &dom, BasicBlock* bb, hai_context_t ctx) const;
	inline void leaveContext(Domain &dom, BasicBlock* bb, hai_context_t ctx) const;
	
};
	
template < class Listener > Identifier<typename Listener::Problem::Domain*> WideningFixPoint<Listener >::STATE("", 0);

template < class Listener >	
inline void WideningFixPoint<Listener >::init(HalfAbsInt<WideningFixPoint> *_ai) {
		ai = _ai;
}

	
template < class Listener >	
void WideningFixPoint<Listener >::fixPoint(BasicBlock *bb, bool &fixpoint, Domain &in, bool firstTime) const {
		
		FixPointState *fpstate = ai->getFixPointState(bb);
		Domain newHeaderState(bottom());
		fixpoint = false;
		
		
		if (firstTime)
			assign(newHeaderState, ai->entryEdgeUnion(bb));
		else {
			assign(newHeaderState, fpstate->headerState);
			HAIW_TRACE("before widening, state + 1: " << newHeaderState << io::endl);
			// TODO Uncomment and fix!
			prob.widening(bb, newHeaderState, ai->backEdgeUnion(bb));

			
			if (prob.equals(newHeaderState, fpstate->headerState))
				fixpoint = true;
		}
		
		assign(fpstate->headerState, newHeaderState);
		assign(in, newHeaderState);
		HAIW_TRACE("after widening " << in << io::endl);
	}
	
template < class Listener >	
inline void WideningFixPoint<Listener>::markEdge(PropList *e, const Domain &s) {
	
		Domain tmp(bottom());
		/*
		 * Because this FixPoint unrolls the first iteration of each loop, 
		 * the loop-exit-edges will be marked at least 2 times 
		 * (one time for 1st iteration, and one time for others iterations),
		 * so when we mark the edges for the 2nd time we need to merge (lub)
		 * with the existing value from the 1st iteration, instead of overwriting it.
		 */
		if (STATE(e) == 0)
			STATE(e) = new Domain(bottom());
		
/*		prob.lub(tmp, *STATE(e)); 
		prob.lub(*STATE(e), s);
		prob.lub(tmp, s);
		ASSERT(prob.equals(tmp,s)); */ 
		prob.assign(**STATE(e), s);
		
	}
	
template < class Listener >	
inline void WideningFixPoint<Listener >::unmarkEdge(PropList *e) {
		delete STATE(e);
		STATE(e) = 0;
}

template < class Listener >		
inline typename WideningFixPoint<Listener>::Domain *WideningFixPoint<Listener >::getMark(PropList *e) {
		return(STATE(e));
}
	
	
	/*
	 * Wrappers for the Problem methods and types
	 */
	 
template < class Listener >	
inline const typename WideningFixPoint<Listener>::Domain& WideningFixPoint<Listener >::bottom(void) const {
		return(prob.bottom());
}

template < class Listener >		
inline const typename WideningFixPoint<Listener>::Domain& WideningFixPoint<Listener >::entry(void) const {
		return(prob.entry());
}

template < class Listener >	
inline void WideningFixPoint<Listener >::lub(typename Problem::Domain &a, const typename Problem::Domain &b) const {
		prob.lub(a,b);
}

template < class Listener >		
inline void WideningFixPoint<Listener >::assign(typename Problem::Domain &a, const typename Problem::Domain &b) const {
		prob.assign(a,b);
}

template < class Listener >		
inline bool WideningFixPoint<Listener >::equals(const typename Problem::Domain &a, const typename Problem::Domain &b) const {
		return (prob.equals(a,b));
}

template < class Listener >	
inline void WideningFixPoint<Listener>::update(Domain &out, const typename Problem::Domain &in, BasicBlock* bb)  {
		prob.update(out,in,bb);
}
	
template < class Listener >	
inline void WideningFixPoint<Listener>::blockInterpreted(BasicBlock* bb, const typename Problem::Domain& in, const typename Problem::Domain& out, CFG *cur_cfg, elm::genstruct::Vector<Edge*> *callStack) const {
		list.blockInterpreted(this, bb, in, out, cur_cfg, callStack);
}

template < class Listener >	
inline void WideningFixPoint<Listener >::fixPointReached(BasicBlock* bb) const {
		list.fixPointReached(this, bb);
}
	
template < class Listener >	
inline void WideningFixPoint<Listener >::enterContext(Domain &dom, BasicBlock* bb, hai_context_t ctx) const {
		prob.enterContext(dom, bb, ctx);
}
	
template < class Listener >	
inline void WideningFixPoint<Listener>::leaveContext(Domain &dom, BasicBlock* bb, hai_context_t ctx) const {
		prob.leaveContext(dom, bb, ctx);
}

template < class Listener >
inline void WideningFixPoint<Listener>::updateEdge(Edge *edge, Domain &dom) {
		prob.updateEdge(edge, dom);
}
	
	
} } } // otawa::dfa::hai

#endif /*OTAWA_DFA_HAI_WIDENINGFIXPOINT_H_*/
