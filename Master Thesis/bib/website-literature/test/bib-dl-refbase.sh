#!/usr/bin/env sh

mkdir -p tmp

tmpfile=tmp/refbase-dump.html
echo "downloading to ${tmpfile}"
# download refbase HTML
curl --cacert "IFX-rootca2.cer" "https://kai.intra.infineon.com/refbase/kai_mod2.php?kai_action=list&kai_publications=on" --output "${tmpfile}"
# filter and format to get ids
grep record_table_checkbox "$tmpfile" | grep value | cut -d' ' -f 6 | cut -d'"' -f 2 | sort -n > tmp/refbase.txt
# read ids into array
readarray -t refbaseids < tmp/refbase.txt

echo "found $(wc -l tmp/refbase.txt) entries on Refbase"

cat *.bib > tmp/all.bib
grep -E "refbase\s+=" tmp/all.bib | cut -d'{' -f 2 | cut -d'}' -f 1 | sort -n > tmp/website-literature-ids.txt
echo "found $(wc -l tmp/website-literature-ids.txt) entries in website-literature"

# loop
fail=0
nmbrfail=0
nmbrdup=0

# check if each refbase entry is included in website-literature
# get IDs that are only present in refbase.txt
nrefbaseonly=$(comm -23 tmp/refbase.txt tmp/website-literature-ids.txt)
if (( nrefbaseonly > 0 )); then
	nmbrfail=$((nmbrfail + nrefbaseonly))
	echo "The following IDs are missing in website-literature:"
	comm -23 tmp/refbase.txt tmp/website-literature-ids.txt
fi
#for id in "${refbaseids[@]}"; do
#	# try to find id
#	cnt=$(grep -c -E "\s*refbase\s+= \{$id\}" tmp/all.bib)
#
#	case "$cnt" in
#		0)
#			fail=1
#			((nmbrfail++))
#			echo "Refbase ID $id not found. https://kai.intra.infineon.com/refbase/kai_mod2.php?kai_action=edit&id=$id"
#			;;
#		1)
#			# ok
#			;;
#		*)
#			fail=1
#			((nmbrdup++))
#			echo "Refbase ID $id found $cnt times:"
#			grep -E "\s*refbase\s+= \{$id\}" *.bib
#	esac
#done

# check if all website-literature refbase-entries are set to 'KAI Publication'
# get IDs that are only in website-literature
nwebsitelitonly=$(comm -13 tmp/refbase.txt tmp/website-literature-ids.txt)
if (( nwebsitelitonly > 0 )); then
	nmbrfail=$((nmbrfail + nwebsitelitonly))
	echo "The following IDs are either missing in Refbase or have not been set to 'KAI Publication':"
	comm -13 tmp/refbase.txt tmp/website-literature-ids.txt
fi

if [[ $nmbrfail -ne 0 ]]; then
	echo "$nmbrfail missing items"
	fail=1
fi
if [[ $nmbrdup -ne 0 ]]; then
	echo "$nmbrdup duplicate IDs"
fi

exit $fail
