#!/usr/bin/env sh

grep -irn "TU " *.bib | grep school

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
