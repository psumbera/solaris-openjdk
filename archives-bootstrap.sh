#!/bin/bash

WS="`pwd`"
ARCHIVE_DIR="$WS/archives"
mkdir -p $ARCHIVE_DIR

if [ `uname -p` = 'sparc' ] ; then
  JDK_PLATFORM="sparcv9"
else
  JDK_PLATFORM="x86_64"
fi

for VERSION in 13; do
  if [ $VERSION -lt 12 ] ; then
    JAVADIR="./build_dir/jdk${VERSION}u/build/solaris-$JDK_PLATFORM-normal-server-release/jdk"
  else
    JAVADIR="./build_dir/jdk${VERSION}u/build/solaris-$JDK_PLATFORM-server-release/jdk"
  fi
  test -x "$JAVADIR/bin/java" || continue
  VERS=`"$JAVADIR/bin/java" --version | head -1 | gsed 's;-internal;-bootstrap;' | awk '{ print $1 "-" $2 }'`
  VERS="${VERS}_`uname -s`-`uname -p`_bin"
  echo "Creating archive $ARCHIVE_DIR/$VERS.tar.xz"
  gtar cfhJ "$ARCHIVE_DIR/$VERS.tar.xz" "$JAVADIR" --transform "s;$JAVADIR;jdk-$VERSION-bootstrap;"
done
