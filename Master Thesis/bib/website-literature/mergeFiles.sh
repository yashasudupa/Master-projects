#!/usr/bin/env sh

# first switch to directory of this script (in case it is started via double click from Explorer)
cd $(dirname $0)

dest=merged.htm
trimTop=23
trimBtm=4

# generate HTML
sh updateHTML.sh

# clean destination
rm -rf $dest

function parseFile {
#	echo "$# params: $*"
	if [ "$#" -eq 2 ]; then
		disp="block"
	else
		disp="none"
	fi
	file="$1"
#	echo $file
	li=$(wc -l < "${file}")
	name="${file##*/}"	# strip path
	year="${name%%.*}"	# strip endings
	echo $year

	# write section header
	echo "" >> $dest
	echo "<h4 id=\"h4_$year\" class=\"bibitems\">$year</h4>" >> $dest
	echo "<script type=\"text/javascript\"><!--" >> $dest
	echo "\$(document).ready(function() {" >> $dest
	echo "	\$(\"#h4_$year\").click(function() {" >> $dest
	echo "		\$(\"#ul_$year\").slideToggle(\"normal\");" >> $dest
	echo "	});" >> $dest
	echo "});" >> $dest
	echo "//--></script>" >> $dest
	echo "<ul style=\"display: $disp;\" id=\"ul_$year\" class=\"bibitems\">" >> $dest
	echo "" >> $dest

	head -n $(expr $li - $trimBtm) $file | tail -n $(expr $li - $trimTop) >> $dest
	# write section footer
	echo "	</ul>" >> $dest
}

# collect and write sections
first=0
for i in $(ls -r *.html); do
	if [ $first -eq 0 ]; then
		parseFile "$i" 1
		first=1
	else
		parseFile "$i"
	fi
done

# write file footer
echo "" >> $dest

# clean temp html files
rm -rf *.html

echo "done."
