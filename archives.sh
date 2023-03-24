#!/bin/bash

WS="`pwd`"
ARCHIVE_DIR="$WS/archives"
mkdir -p $ARCHIVE_DIR

. common.sh

for VERSION in {9..19}; do
  if [ $VERSION -lt 12 ] ; then
    JAVADIR="./build_dir/jdk${VERSION}u/build/solaris-$JDK_PLATFORM-normal-server-release/images/jdk"
  else
    JAVADIR="./build_dir/jdk${VERSION}u/build/solaris-$JDK_PLATFORM-server-release/images/jdk"
  fi
  test -x "$JAVADIR/bin/java" || continue
  VERS=`"$JAVADIR/bin/java" --version | head -1 | gsed 's;-internal;;' | awk '{ print $1 "-" $2 }'`
  VERS="${VERS}_`uname -s`-`uname -p`_bin"
  echo "Creating archive $ARCHIVE_DIR/$VERS.tar.xz"
  gtar cfJ "$ARCHIVE_DIR/$VERS.tar.xz" "$JAVADIR" --transform "s;$JAVADIR;jdk-$VERSION;"
done
