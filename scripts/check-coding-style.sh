#!/bin/bash

# ---HELP---
# to check kernel coding style of file(s):
# a) either pass a filename as cmdline parameter
# b) create file 'scripts/check-coding-files.txt' with filenames
# c) to find and check all .c and .h files, run in repo root:
#  	find rtrlib tests tools \( -name "*.h" -o -name "*.c" \) \
#	-not -name "*tommy*" -exec ./scripts/check-coding-style.sh {} \;
# ---HELP---

READLINK=$(which greadlink)
[ -z "$READLINK" ] && {
	READLINK=$(which readlink)
}
SCRIPT_DIR=$(dirname "$($READLINK -f "$0")")
SCRIPT_FILE="$SCRIPT_DIR/check-coding-files.txt"
if [ -z "$1" ] ; then
	if [ -f "$SCRIPT_FILE" ]; then
		CHECKSOURCE=$(cat "$SCRIPT_FILE")
	else
		echo "USAGE: $0 SOURCEFILE"
		exit 1
	fi
else
	CHECKSOURCE=$($READLINK -f "$1")
fi
cd $SCRIPT_DIR/..
for i in $CHECKSOURCE; do
	echo "> check coding style of $i ..."
	$SCRIPT_DIR/checkpatch.pl -f --strict --no-tree --terse --show-types \
		--ignore PREFER_KERNEL_TYPES $i
done
