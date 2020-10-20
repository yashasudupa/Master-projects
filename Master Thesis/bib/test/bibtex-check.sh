#!/usr/bin/env sh

tmppath=tmp

mkdir -p $tmppath

fail=0
py=python3.6
$py --version 2> /dev/null
[[ $? -eq 0 ]] || py=python

for i in $(ls *.bib); do
	echo $i:
	$py bibtex-check/bibtex_check.py -b $i || fail=1
done;

exit $fail
