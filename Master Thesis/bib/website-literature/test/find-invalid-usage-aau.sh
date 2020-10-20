#!/usr/bin/env sh

grep -irn adria *.bib | grep -v "Alpen-Adria-Universität Klagenfurt"

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
