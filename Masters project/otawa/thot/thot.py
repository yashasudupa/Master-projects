#!/usr/bin/python
# -*- coding: utf-8 -*-

# thot -- Thot command
# Copyright (C) 2009  <hugues.casse@laposte.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import doc
import os
import tparser
import locale
import sys
import optparse
import datetime
import os.path
import common
import re
import glob

arg_re = re.compile("\(\?P<([a-zA-Z0-9]+)(_[a-zA-Z0-9_]*)?>(%s|%s)*\)" %
	("[^)[]", "\[[^\]]*\]"))
REPS = [
	(" ", 		u"␣"	),
	("\t", 		u"⭾"	),	
	("\\s+",	" "		),
	("\\s*", 	" "		),
	("\\s", 	" "		),
	("\(", 		"("		),
	("\)", 		")"		),
	("^", 		""		),
	("$", 		""		)
]
def prepare_syntax(t):
	"""Prepare a regular expression to be displayed to human user."""
	t = arg_re.sub('/\\1/', t)
	for (p, r) in REPS:
		t = t.replace(p, r)
	return t

# Prepare environment
env = { } # os.environ.copy()
env["THOT_VERSION"] = "0.8"
env["ENCODING"] = locale.getpreferredencoding()
base = os.path.realpath(os.path.abspath(__file__))
env["THOT_BASE"] = os.path.dirname(base) + '/'
env["THOT_USE_PATH"] = env["THOT_BASE"] + "mods/"
env["THOT_DATE"] = str(datetime.datetime.today())

# Prepare arguments
oparser = optparse.OptionParser()
oparser.add_option("-t", "--type", action="store", dest="out_type",
	default="html", help="output type (xml, html, latex, ...)")
oparser.add_option("-o", "--out", action="store", dest="out_path",
	help="output path")
oparser.add_option("-D", "--define", action="append", dest="defines",
	help="add the given definition to the document environment.")
oparser.add_option("--dump", dest = "dump", action="store_true", default=False,
	help="only for debugging purpose, dump the database of Thot")
oparser.add_option("-u", "--use", action="append", dest="uses",
	help="given module is loaded before the generation.")
oparser.add_option("--verbose", "-v", dest = "verbose", action="store_true", default=False,
	help="display verbose messages about the processing")
oparser.add_option("--encoding", "-e", dest="encoding", action="store",
	type="string", help="select the encoding of the input files (default UTF-8)")
oparser.add_option("--list-mods", dest = "list_mods", action="store_true", default=False,
	help="list used modules")
oparser.add_option("--list-syntax", dest = "list_syntax", action="store_true", default=False,
	help="list available syntax in the document")
oparser.add_option("--list-output", action="store", dest="list_output",
	help="list all generation output for the current modules")
oparser.add_option("--list-mod", action="store", dest="list_mod",
	help="list the content of a module")
oparser.add_option("--list-avail", dest = "list_avail", action="store_true", default=False,
	help="list available modules")


# Parse arguments
(options, args) = oparser.parse_args()
common.IS_VERBOSE = options.verbose
if options.encoding:
	common.ENCODING = options.encoding
env["THOT_OUT_TYPE"] = options.out_type
if not options.out_path:
	env["THOT_OUT_PATH"] = ""
else:
	env["THOT_OUT_PATH"] = options.out_path
if args == []:
	input = sys.__stdin__
	env["THOT_FILE"] = "<stdin>"
	env["THOT_DOC_DIR"] = "."
else:
	input = file(args[0])
	env["THOT_FILE"] = args[0]
	env["THOT_DOC_DIR"] = os.path.dirname(args[0])
	if not env["THOT_DOC_DIR"]:
		env["THOT_DOC_DIR"] = "."
if options.defines:
	for d in options.defines:
		p = d.find('=')
		if p == -1:
			common.onError('-D' + d + ' must follow syntax -Didentifier=value')
		else:
			env[d[:p]] = d[p+1:]

# open the output
document = doc.Document(env)
out_name = env["THOT_OUT_TYPE"]
out_path = os.path.join(document.env["THOT_BASE"], "backs")
out_driver = common.loadModule(out_name,  out_path)
if not out_driver:
	common.onError('cannot find %s back-end' % out_name)

# Parse the file
man = tparser.Manager(document)
if out_driver.__dict__.has_key("init"):
	out_driver.init(man)
if options.uses:
	for u in options.uses:
		man.use(u)
man.parse(input, env['THOT_FILE'])

# dump the parsed document
if options.dump:
	document.dump("")
	sys.exit(0)

# list the involved modules
elif options.list_mods:
	print "Used modules:"
	for mod in man.used_mods:
		desc = ""
		if mod.__dict__.has_key("__short__"):
			desc = " (%s)" % mod.__short__
		print "- %s%s" % (mod.__name__, desc)
	sys.exit(0)

# list available modules
elif options.list_avail:
	print "Available modules:"
	paths = document.getVar("THOT_USE_PATH")
	names = set([os.path.splitext(file)[0] for path in paths.split(":") for file in os.listdir(path) if os.path.splitext(file)[1] in { ".py", ".pyc" }])
	for name in names:
		mod = common.loadModule(name, paths)
		desc = ""
		if mod.__dict__.has_key("__short__"):
			desc = " (%s)" % mod.__short__
		print "- %s%s" % (name, desc)
	sys.exit(0)

# list the syntax
elif options.list_syntax:
	print "Available syntax:"
	for mod in man.used_mods:
		print "- %s" % mod.__name__
		if mod.__dict__.has_key("__words__"):
			for (_, word, desc) in mod.__words__:
				print "\t%s: %s" % (prepare_syntax(word), desc)
		if mod.__dict__.has_key("__lines__"):
			for (_, line, desc) in mod.__lines__:
				print "\t%s:\n\t\t%s" % (prepare_syntax(line), desc)	
	sys.exit(0)

# list outputs
elif options.list_output:
	print "Available outputs:"
	for mod in man.used_mods:
		print "- %s" % mod.__name__
		name = "__%s__" % options.list_output
		if mod.__dict__.has_key(name):
			for (form, desc) in mod.__dict__[name]:
				print "\t%s\n\t\t%s" % (form, desc)
	sys.exit(0)

# list a module
elif options.list_mod:
	paths = document.getVar("THOT_USE_PATH")
	mod = common.loadModule(options.list_mod, paths)
	if not mod:
		common.onError("no module named %s" % options.list_mod)
		sys.exit(1)
	short = ""
	if mod.__dict__.has_key("__short__"):
		short = " (%s)" % mod.__short__
	print "Module: %s%s" % (options.list_mod, short)
	if mod.__dict__.has_key("__description__"):
		print "\n%s\n" % mod.__description__
	if mod.__dict__.has_key("__words__") or mod.__dict__.has_key("__lines__"):
		print "\nSyntax:"
		if mod.__dict__.has_key("__words__"):
			for (_, word, desc) in mod.__words__:
				print "\t%s: %s" % (prepare_syntax(word), desc)
		if mod.__dict__.has_key("__lines__"):
			for (_, line, desc) in mod.__lines__:
				print "\t%s:\n\t\t%s" % (prepare_syntax(line), desc)	
		has_output = False
		for out in ["html", "latex", "docbook"]:
			name = "__%s__" % out
			if mod.__dict__.has_key(name):
				if not has_output:
					has_output = True
					print "\nOutput:"
				print "\t%s:" % out
				for (form, desc) in mod.__dict__[name]:
					print "\t%s\n\t\t%s" % (form, desc)
	sys.exit(0)

# Output the result
else:
	out_driver.output(document)

