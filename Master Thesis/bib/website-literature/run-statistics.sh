#!/usr/bin/env sh

py=python3.6
$py --version 2> /dev/null
[[ $? -eq 0 ]] || py=python

export PYTHONIOENCODING=utf-8

cat *.bib > tmp/all.bib

$py statistics.py
