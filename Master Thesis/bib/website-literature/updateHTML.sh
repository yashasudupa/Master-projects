#!/usr/bin/env sh

# first switch to directory of this script (in case it is started via double click from Explorer)
cd $(dirname $0)

# clean html files
rm -rf *.html

# move into bib2xhtml directory
cd bib2xhtml

perl gen-bst.pl

# for each bib-file, run bib2xhtml script
find .. -maxdepth 1 -name "2*.bib" -exec perl bib2xhtml.pl -u -U "{}" "{}.html" \;

# return to original directory
cd ..
