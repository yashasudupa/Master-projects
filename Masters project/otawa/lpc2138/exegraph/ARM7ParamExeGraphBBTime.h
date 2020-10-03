/*
 *	ARM7ParamExeGraphBBTime interface
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
#ifndef OTAWA_LPC2138_ARM7PARAMGRAPHBBTIME_H
#define OTAWA_LPC2138_ARM7PARAMGRAPHBBTIME_H

#include "ParamExeGraphBBTime.h"
#include "ARM7ParamExeGraph.h"

namespace otawa { namespace lpc2138 {

extern Identifier<String> CHART_DIR;
extern Identifier<int> FLASH_HIT;
extern Identifier<int> FLASH_MISS;


class ARM7ParamExeGraphBBTime : public ParamExeGraphBBTime {
public:
	ARM7ParamExeGraphBBTime(AbstractRegistration& _reg = reg);
	static Registration<ARM7ParamExeGraphBBTime> reg;

protected:
	void processBB(WorkSpace *ws, CFG *cfg, BasicBlock *bb);
	virtual void configure(const PropList &props);

private:
	String _chart_dir_name;
	int flash_miss;
	int flash_hit;
};

} } //otawa::lpc2138

#endif 	// OTAWA_LPC2138_ARM7PARAMGRAPHBBTIME_H
