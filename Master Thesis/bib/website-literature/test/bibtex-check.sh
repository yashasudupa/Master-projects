#!/usr/bin/env sh

tmppath=tmp

mkdir -p $tmppath

fail=0
py=python3.6
$py --version 2> /dev/null
[[ $? -eq 0 ]] || py=python

for i in $(ls *.bib); do
	echo $i:
	$py bibtex-check/bibtex_check.py -r -b $i || fail=1
	printf "\n"
done;

exit $fail
