#!/usr/bin/env sh

grep -irn Technische *.bib | grep -v "Technische Universität Darmstadt" | grep -v "Ostbayerische Technische Hochschule Regensburg"

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
