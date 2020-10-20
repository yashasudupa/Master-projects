#!/usr/bin/env sh

#
grep -irn ienna *.bib | grep -i tech | grep school | grep -v "Vienna University of Technology"

case "$?" in
	0)
		exit 255
		;;
	1)
		exit 0
		;;
	*)
		echo unknown code $?
esac
