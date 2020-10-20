#!/usr/bin/env sh

tmppath=tmp
logFile=$tmppath/log.txt
mkdir -p $tmppath
rm -rf $logFile

./mergeFiles.sh &> $logFile

grep -irn "Too many commas" $logFile

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
