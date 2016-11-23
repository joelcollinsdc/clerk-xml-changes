#!/bin/bash
set -e

CURL=/usr/bin/curl
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TODAY=$(date +"%Y%m%d")
URL=http://clerk.house.gov/xml/lists/MemberData.xml
CACHEFLDR=$DIR/cache
TMPFILE=$(mktemp)
$CURL -s "$URL" > $TMPFILE
cd $CACHEFLDR
LATEST=$(ls -t MemberData* | head -1)

if [ $(diff $TMPFILE $LATEST | wc -l) -ne 0 ]; then
  echo "Changes found... copying"
  cp $TMPFILE $CACHEFLDR/MemberData.$TODAY.xml
else
  echo "No changes found on $TODAY, latest is still $LATEST"
fi
