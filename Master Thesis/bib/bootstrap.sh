#!/usr/bin/env sh

echo "Executing bootstrap ..."

# downloads a specific version of lvlibp's from artifactory
# first switch to directory of this script (in case it is started via double click from Explorer)
cd $(dirname "$0")

config=bootstrap-config.txt
if [[ ! -e $config ]]; then
	echo "Bootstrap config file $config not found."
	exit 1
fi
readarray artifacts < $config

year=$1
if [ -z $year ]; then
	year=2018
fi
arch=$2
if [ -z $arch ]; then
	arch=win32
fi
arch=lv${year}-${arch}

srv=https://artifactory.intra.infineon.com/artifactory
repo=gen-kai-labview-release-local
dest=lib

curlopts=(
	--connect-timeout 3
	--max-time 30
	--retry 3
	--retry-delay 0
	--retry-max-time 30
	--fail
	--globoff
	--silent
	--show-error
)
#	--max-time		(how long each retry will wait)
#	--retry			(it will retry 5 times)
#	--retry-delay	(an exponential backoff algorithm)
#	--retry-max-time (total time before it's considered failed)
#	-f,--fail		fail on HTTP error responses (instead of downloading the HTML error page)
#	-g,--globoff	switches off the "URL globbing parser"
#	--silent		not output on stdout/stderr
#	--show-error	do show error on fail

mkdir -p $dest
#	init with empty string
for item in "${artifacts[@]}"; do
	#	strip white space, bot not space
	item=${item//[$'\t\r\n']}
	#	skip items starting with '#' or empty lines
	if [[ "${item}" == "" ]]; then
		continue
	fi
	if [[ "${item::1}" == "#" ]]; then
		continue
	fi

	orgivy=$(cut -d: -f1 <<< "${item}")
	artifact=$(cut -d: -f2 <<< "${item}")
	reqversion=$(cut -d: -f3 <<< "${item}")
	ext="${artifact##*.}"
	artifact="${artifact%.*}"
	package=$dest/$artifact.$ext
	echo "org: $orgivy"
	echo "art: $artifact"
	echo "req: $reqversion"
	echo "pkg: $package"

	if [ "$ext" == "lvlibp" ]; then
		uri="$srv/$repo/$orgivy/$artifact/$artifact-$arch-%5BRELEASE%5D.$ext"
	else
		uri="$srv/$repo/$orgivy/$artifact/$artifact-%5BRELEASE%5D.$ext"
	fi
	uri="${uri// /%20}"
	echo "Reading headers ..."
	dlfile=$(curl --silent --cacert "${cert}" -I "${uri}" | grep "X-Artifactory-Filename" | sed 's/X-Artifactory-Filename: //')
	echo "File to be downloaded: ${dlfile}"
	echo "Downloading remote version: ${uri}"

	curl "${curlopts[@]}" --output "${package}" "${uri}" || { rm -rf "${package}"; exit 1; }

	echo ""
done

echo "Bootstrap successful."
