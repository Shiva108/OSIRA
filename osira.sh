#!/usr/bin/env bash
# 2018 by Shiva @ CPH:SEC & Cyberium
# Script requires Sublist3r: https://github.com/aboul3la/Sublist3r

# Script begins
#===============================================================================


VERSION="0.0.1a"
# Where to find sublist3r.py :
VULNERSDIR="/home/e/Sublist3r"

echo ""
echo -e "\e[00;32m#############################################################\e[00m"
echo ""
echo -e "	OSIRA $VERSION by Shiva - An OSINT automater"
echo ""
echo -e "\e[00;32m#############################################################\e[00m"
echo ""

usage ()
{
echo "Usage: ${0##*/} -u {url}"
echo "       ${0##*/} -h"
echo ""
echo "       -h shows this help"
echo "       -u url to test"
echo ""
}

# Check input parameters
if [ $# -eq 0 ]
  then
    usage
    echo "No arguments supplied"
    exit 1
fi

if [ $1 == "-h" ]
  then
    usage
    exit 1
fi

if [[ "$1" != "-u" && "$1" != "-h" ]]; then
   usage
   echo "Invalid parameter: $1"
   exit 1
fi

#Check for sublist3r
locate sublist3r>/dev/null
if [ $? -eq 0 ]
        then
                echo ""
else
                echo ""
       		echo -e "\e[01;31m[!]\e[00m Unable to find the required sublis program, install and try again"
        exit 1
fi

# Check if root
if [[ $EUID -ne 0 ]]; then
        echo ""
        echo -e "\e[01;31m[!]\e[00m This program must be run as root. Run again with 'sudo'"
        echo ""
        exit 1
fi

#
echo -e "Target: is $2 "

# sublist3r
echo -e "[+] Looking up "$2" with sublist3r"
python $VULNERSDIR/sublist3r.py -d $2 -o ./$2.txt

# resolveip
python ./resolveip.py $2.txt
