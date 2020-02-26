#!/bin/bash

# This script ensures all headers have #pragma once
# Requirements:
#  - clang-format

EXCLUDE=*lib/*
BUILD=*out/*
PATTERN0="*.h*"
[ "$1" == "-r" ] && RUN=TRUE

THISDIR=$(pwd)
cd "$(dirname "${BASH_SOURCE[0]}")"
. ./os.sh
cd "$THISDIR"

FILES=$(find . -not -path "$EXCLUDE" -not -path "$BUILD" \( -name $PATTERN0 \))
COUNT=$(echo -e "$FILES" | wc -l)
echo -e "== Checking $COUNT headers for:\n\t[#pragma once]\n"

IDX=0
for FILE in ${FILES}; do
	let IDX=$IDX+1
	while read -r LINE; do
		[[ "$LINE" == *"*/" ]] && COMMENTED=FALSE
		[[ "$LINE" == "/*"* ]] && COMMENTED=TRUE
		if [[ "$COMMENTED" != "TRUE" ]]; then
			[[ -z "${LINE// }" || "$LINE" == *"*/" || "$LINE" == "//"* ]] && continue
			if [[ "$LINE" != "#pragma once" ]]; then
				echo -e "  $IDX. ERROR! $FILE missing '#pragma once'! [ERR]"
				break
			fi
			echo "  $IDX. $FILE [OK]"
			break
		fi
	done < $FILE
done
exit
