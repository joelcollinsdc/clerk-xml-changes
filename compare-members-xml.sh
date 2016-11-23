#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

URL=http://clerk.house.gov/xml/lists/MemberData.xml
CACHEFLDR=$DIR/cache
TMPFILE=$(mktemp)
curl "$URL" > $TMPFILE
cd $CACHEFLDR
LATEST=$(ls -t MemberData* | head -1)

if [ $(diff $TMPFILE $LATEST | wc -l) -ne 0 ]; then
  echo "Changes found... copying"
  cp $TMPFILE $CACHEFLDR/MemberData.$(date +"%Y%m%d").xml
fi