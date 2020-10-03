/*
 *	$Id$
 *	Test program for LPC2138
 *
 *	This file is part of OTAWA
 *	Copyright (c) 2011, IRIT UPS.
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

//#include <otawa/otawa.h>
#include <otawa/app/Application.h>
#include <elm/options.h>
#include <otawa/cfg/features.h>
#include <otawa/util/FlowFactLoader.h>
#include "mam/AbsMAMBlockBuilder.h"
#include "mam/CATMAMBuilder.h"
#include "exegraph/ARM7ParamExeGraphBBTime.h"

using namespace elm;
using namespace elm::option;
using namespace otawa;

class Test: public Application {
public:
	Test():
		Application("test-arm7-lpc2138", Version(1, 0, 0)),
		virt(*this, cmd, "-V", cmd, "--virtualize", option::help, "Virtualize.", def, false, end),
		perfectmam(*this, cmd, "-m", cmd, "--perfectmam", option::help, "perfect mam", def, false, end),
		ff(*this, cmd, "-f", cmd, "--flowfacts", option::help, "select flowfact file", arg_desc, "flow fact file", end)
		{ }

protected:

	virtual void work(const string &entry, PropList &props) throw (elm::Exception)  {
		PROCESSOR_PATH(props) = Path("lpc2138/pipeline.xml");
		lpc2138::CHART_DIR(props) = "out";

		// load flow facts
		if(ff)
			FLOW_FACTS_PATH(props) = elm::system::Path(ff);

		// virtualize if required
		if(virt)
			require(VIRTUALIZED_CFG_FEATURE);

		// MAM analysis
		AbsMAMBlockBuilder amlb;
		amlb.process(workspace(), props);
		CATMAMBuilder cmb;
		cmb.process(workspace(), props);

		// time computation
		lpc2138::ARM7ParamExeGraphBBTime tbt;
		tbt.process(workspace(), props);

		// perform computation
		require(ipet::WCET_FEATURE);
		cout << "WCET = " << ipet::WCET(workspace());
	}

private:
	SwitchOption virt, perfectmam;
	ValueOption<string> ff;
};

OTAWA_RUN(Test);
