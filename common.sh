WS="`pwd`"
BUILD_DIR="$WS/build_dir"
SRC_DIR="jdk${VERSION}u"

if [ `uname -p` = 'sparc' ] ; then
  JDK_PLATFORM="sparcv9"
else
  JDK_PLATFORM="x86_64"
fi

if [ -z $BOOT_JDK ] ; then
  if [ $VERSION -eq 9 ] ; then
    BOOT_JDK="/usr/jdk/instances/jdk1.8.0"
  elif [ $VERSION -lt 13 ] ; then
    BOOT_JDK="$BUILD_DIR/jdk$(($VERSION-1))u/build/solaris-$JDK_PLATFORM-normal-server-release/jdk"
  else
    BOOT_JDK="$BUILD_DIR/jdk$(($VERSION-1))u/build/solaris-$JDK_PLATFORM-server-release/jdk"
  fi
fi

TOOLS_DIR="${SRC_DIR}_tools"

STUDIO="/opt/solarisstudio12.4/bin"

GCC=/usr/gcc/10/bin/gcc
GXX=/usr/gcc/10/bin/g++

mkdir -p "$BUILD_DIR"
rm -rf "$BUILD_DIR"/$SRC_DIR "$BUILD_DIR"/$TOOLS_DIR
test -z $JDK_GITHUB_REPO && JDK_GITHUB_REPO=https://github.com/openjdk

function apply_patch_series {
  cat "$WS/patches-$VERSION/series" | while read patch args; do
    echo $patch | grep ^\# > /dev/null && continue
    gpatch --batch --forward --strip=1 $args -i "$WS/patches-$VERSION/$patch"
  done
}

# GNU make 4.2.1 is needed for OpenJDK 9, 10, 11 and 12 (version 4.3 doesn't work for them).
function old_gmake_version_needed {
  GMAKE_VERSION=`gmake --version | head -1 | awk '{print $3}'`
  if [ x$GMAKE_VERSION = "x4.2.1" ] ; then
    return 1;
  fi
  GMAKE_OLD="$BUILD_DIR/$TOOLS_DIR/make/bin/make"
  if [ -x "$BUILD_DIR/$TOOLS_DIR/make/bin/make" ] ; then
    return 0
  fi
  mkdir -p "$BUILD_DIR/$TOOLS_DIR" && cd "$BUILD_DIR/$TOOLS_DIR"
  if [ -z $TOOLS_ARCHIVE ] ; then
    curl -s "https://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2" | gtar xj
  else
    gtar xfj "$TOOLS_ARCHIVE/make-4.2.1.tar.bz2"
  fi
  cd "make-4.2.1" && ./configure --prefix="$BUILD_DIR/$TOOLS_DIR/make" CC=$GCC && gmake install
  return 0
}

# autoconf 2.69 is needed for OpenJDK 11 and 12 (version 2.71 doesn't work for them).
function old_autoconf_version_needed {
  AUTOCONF_VERSION=`autoconf --version | head -1 | awk '{print $4}'`
  if [ x$AUTOCONF_VERSION = "x2.69" ] ; then
    return 1;
  fi
  AUTOCONF_OLD_PATH="$BUILD_DIR/$TOOLS_DIR/autoconf/bin"
  if [ -x "$BUILD_DIR/$TOOLS_DIR/autoconf/bin/autoconf" ] ; then
    return 0
  fi
  mkdir -p "$BUILD_DIR/$TOOLS_DIR" && cd "$BUILD_DIR/$TOOLS_DIR"
  if [ -z $TOOLS_ARCHIVE ] ;  then
    curl -s "https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz" | gtar xJ
  else
    gtar xfJ "$TOOLS_ARCHIVE/autoconf-2.69.tar.xz"
  fi
  cd "autoconf-2.69" && ./configure --prefix="$BUILD_DIR/$TOOLS_DIR/autoconf" CC=$GCC && gmake install
  return 0
}
