#!/usr/bin/env sh

# first check for colors
# check if stdout is a terminal...
if test -t 1; then

    # see if it supports colors...
    ncolors=$(tput colors)

    if test -n "$ncolors" && test $ncolors -ge 8; then
        bold="$(tput bold)"
        underline="$(tput smul)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"
        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi

[ -e "./bootstrap.sh" ] && ./bootstrap.sh || exit

status=0
for i in $(find test/ -type f -iname "*.sh" ); do
	echo -----
	echo Running: $i
	sh $i
	if [ $? -ne 0 ]; then
		status=1
		echo -e "${red}$i failed.${normal}\n"
	else
		echo -e "${green}$i OK.${normal}\n"
	fi
done

exit $status
