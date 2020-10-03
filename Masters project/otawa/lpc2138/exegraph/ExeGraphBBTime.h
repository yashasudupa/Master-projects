/*
 *	$Id: ExeGraphBBTime.h,v 1.17 2007/06/27 20:21:49 casse Exp $
 *	ExeGraphBBTime class interface
 *
 *	This file is part of OTAWA
 *	Copyright (c) 2007-11, IRIT UPS.
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

#ifndef OTAWA_LPC2138_EXECUTIONGRAPH_BBTIME_H
#define OTAWA_LPC2138_EXECUTIONGRAPH_BBTIME_H

#include <otawa/proc/BBProcessor.h>
#include "ExeGraph.h"
#include <elm/genstruct/DLList.h>
#include <otawa/cfg/BasicBlock.h>
#include <otawa/ipet.h>

namespace otawa { namespace lpc2138 {

using namespace elm::genstruct;

template <class G>
class ExeGraphBBTime: public BBProcessor {
protected:
	typedef typename G::Node ExeNode;
	WorkSpace *fw;
	PropList *properties;
	Microprocessor<ExeNode> *microprocessor;

public:
	ExeGraphBBTime(AbstractRegistration& reg);

	// BBProcessor overload
	void processWorkSpace(WorkSpace *fw);
	void processBB(WorkSpace *fw, CFG *cfg, BasicBlock *bb) {}

	// Configuration Properties
	static Identifier<Microprocessor<ExeNode> *> PROCESSOR;
	static Identifier<elm::io::Output *>  LOG_OUTPUT;

protected:
	virtual void configure(const PropList& props);
};

template <class G>
Identifier<Microprocessor<typename G::Node> *>
ExeGraphBBTime<G>::PROCESSOR("otawa.ExeGraphBBTime.proc.", NULL);


template <class G>
ExeGraphBBTime<G>::ExeGraphBBTime(AbstractRegistration& reg): BBProcessor(reg), fw(0) {
	provide(ipet::BB_TIME_FEATURE);
}

template <class G>
void ExeGraphBBTime<G>::configure(const PropList& props) {
	BBProcessor::configure(props);
	microprocessor = PROCESSOR(props);
}

template <class G>
void ExeGraphBBTime<G>::processWorkSpace(WorkSpace *fw) {
	bool built = false, reset = false;
	this->fw = fw;

	// If required, find the microprocessor
	if(!microprocessor) {
		microprocessor = PROCESSOR(fw);
		if(microprocessor)
			reset = true;
		else {
			const otawa::hard::Processor *proc = otawa::hard::PROCESSOR(fw);
			if(!proc)
				throw ProcessorException(*this, "no processor to work with");
			else {
				reset = true;
				built = true;
				microprocessor = new Microprocessor<ExeNode>(proc);
			}
		}
	}

	// Perform the actual process
	BBProcessor::processWorkSpace(fw);

	// Cleanup if required
	if(built)
		delete microprocessor;
	if(reset)
		microprocessor = 0;
}


} } // otawa::lpc2138

#endif // OTAWA_LPC2138_OTAWA_ExeGraphBBTime_H
