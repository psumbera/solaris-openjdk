#!/bin/bash

WS="`pwd`"
LOG_DIR="$WS/logs"
rm -rf $LOG_DIR
mkdir -p $LOG_DIR

BUILD_FROM_VER=0

for i in "$@"; do
  case "$i" in
    --build-from=*)
      BUILD_FROM_VER=$((0+"${i#*=}"))
      ;;
    --boot-jdk=*)
      BOOT_JDK="${i#*=}"
      ;;
  esac
done

for VERSION in {9..20}; do

  if [ $VERSION -lt $BUILD_FROM_VER ] ; then
    echo "Skipping Openjdk $VERSION build."
    continue
  fi

  echo "Building Openjdk $VERSION..."
  BOOT_JDK="$BOOT_JDK" bash $WS/jdk-$VERSION.sh > $LOG_DIR/jdk-$VERSION.log 2>&1

  # BOOT_JDK can be valid only for first version
  BOOT_JDK=

  # Check for expected sucesful build output.
  tail -1 $LOG_DIR/jdk-$VERSION.log \
    | grep "Finished building target \'bundles\' in configuration " > /dev/null
  if [ $? -ne 0 ] ; then
    echo "Build error. See: $LOG_DIR/jdk-$VERSION.log"
    exit 1
  fi
done
