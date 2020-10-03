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

#include <otawa/proc/ProcessorPlugin.h>

namespace otawa { namespace lpc2138 {

class Plugin: public ProcessorPlugin {
public:
	typedef elm::genstruct::Table<AbstractRegistration * > procs_t;

	Plugin(void): ProcessorPlugin("otawa::lpc2138", Version(1, 0, 0), OTAWA_PROC_VERSION) { }
	virtual procs_t& processors (void) const { return procs_t::EMPTY; };
};

} }		// otawa::lpc2138

otawa::lpc2138::Plugin OTAWA_PROC_HOOK;
otawa::lpc2138::Plugin& otawa_leon = OTAWA_PROC_HOOK;
