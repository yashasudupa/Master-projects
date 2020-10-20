#!/usr/bin/env sh

tmppath=tmp
mkdir -p $tmppath

jr=lib/JabRef.jar
if [[ ! -e $jr ]]; then
	echo "JabRef not available ($jr)"
	exit -1
fi

echo "Using Java: "
type java
java -version

echo "Using JabRef @ $jr"
java -jar $jr --version

fail=0

for i in $(ls *.bib); do
	exFile=$tmppath/$i.tmp
	rm -rf $exFile
	java -jar $jr -p jabref.prefs.xml -n -i $i,bibtex -o $exFile
	diff -u $i $exFile || fail=1
done

exit $fail
