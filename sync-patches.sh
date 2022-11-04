#!/bin/bash

JDKVER=$1
TMPFILE=`mktemp`

ls -1 | grep -v ^series$ | grep -v ^Solaris-* | while read f; do
 curl -s -o $TMPFILE "https://raw.githubusercontent.com/tribblix/build/master/patches/openjdk${JDKVER}/$f" 
 cmp $TMPFILE $f > /dev/null
 if [ $? -ne 0 ] ; then
   echo "File $f differ. Updating..."
   cp $TMPFILE $f
 fi
 rm $TMPFILE
done
