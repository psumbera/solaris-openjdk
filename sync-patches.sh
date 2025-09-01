#!/bin/bash

# Usage: cd patches-17; bash ../sync-patches.sh 17 jdk-17.0.8-ga

JDKVER=$1
JDKTAG=$2
TMPFILE=`mktemp`

ls -1 | grep -v ^series | grep -v ^Solaris-* | while read f; do
 curl -s -o $TMPFILE "https://raw.githubusercontent.com/ptribble/jdk-sunos-patches/refs/heads/master/jdk${JDKVER}/${JDKTAG}/$f"
 cmp $TMPFILE $f > /dev/null
 if [ $? -ne 0 ] ; then
   echo "File $f differ. Updating..."
   cp $TMPFILE $f
 fi
 rm $TMPFILE
done
