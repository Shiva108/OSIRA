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

#Check for sublist3r - use command -v instead of locate
if command -v sublist3r &>/dev/null; then
    SUBLIST3R_CMD="sublist3r"
elif command -v sublist3r.py &>/dev/null; then
    SUBLIST3R_CMD="sublist3r.py"
elif [[ -x "$VULNERSDIR/sublist3r.py" ]]; then
    SUBLIST3R_CMD="python3 $VULNERSDIR/sublist3r.py"
elif [[ -x "/usr/share/sublist3r/sublist3r.py" ]]; then
    SUBLIST3R_CMD="python3 /usr/share/sublist3r/sublist3r.py"
else
    echo ""
    echo -e "\e[01;31m[!]\e[00m Unable to find sublist3r - install with: sudo apt install sublist3r"
    echo "[~] OSIRA skipped (missing dependencies: sublist3r)"
    exit 0  # Exit gracefully instead of error
fi

# Check if root
if [[ $EUID -ne 0 ]]; then
        echo ""
        echo -e "\e[01;31m[!]\e[00m This program must be run as root. Run again with 'sudo'"
        echo ""
        exit 1
fi

# Get target domain
TARGET_DOMAIN="$2"
OUTPUT_DIR="${REPORT_DIR:-$(pwd)}"
echo -e "Target: $TARGET_DOMAIN"

# sublist3r
echo -e "[+] Looking up $TARGET_DOMAIN with sublist3r"
if [[ -n "$SUBLIST3R_CMD" ]]; then
    timeout 120 $SUBLIST3R_CMD -d "$TARGET_DOMAIN" -o "$OUTPUT_DIR/${TARGET_DOMAIN}_subdomains.txt" 2>&1 || \
        echo "[~] Sublist3r completed with timeout or warnings"
else
    echo "[~] Sublist3r command not available"
fi

# resolveip (optional, skip if not available)
if [[ -x "./resolveip.py" ]] && [[ -f "$OUTPUT_DIR/${TARGET_DOMAIN}_subdomains.txt" ]]; then
    python3 ./resolveip.py "$OUTPUT_DIR/${TARGET_DOMAIN}_subdomains.txt"
fi
