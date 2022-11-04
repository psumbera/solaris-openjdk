set -xe

VERSION=19

. common.sh

BOOT_JDK="$BUILD_DIR/jdk18u/build/solaris-$JDK_PLATFORM-server-release/jdk"
PATH="/usr/bin:/usr/gnu/bin"

CONFIGURE_OPTIONS+=" --enable-unlimited-crypto"
CONFIGURE_OPTIONS+=" --enable-deprecated-ports=yes"
CONFIGURE_OPTIONS+=" --with-boot-jdk=$BOOT_JDK"
CONFIGURE_OPTIONS+=" --with-native-debug-symbols=none"
CONFIGURE_OPTIONS+=" --with-toolchain-type=gcc"
CONFIGURE_OPTIONS+=" --disable-dtrace"
CONFIGURE_OPTIONS+=" --disable-warnings-as-errors"
CONFIGURE_OPTIONS+=" AS=/usr/gnu/bin/as"
CONFIGURE_OPTIONS+=" CC=$GCC"
CONFIGURE_OPTIONS+=" CXX=$GXX"

git clone ${JDK_GITHUB_REPO}/$SRC_DIR "$BUILD_DIR"/$SRC_DIR
cd "$BUILD_DIR"/$SRC_DIR
git checkout jdk-19.0.1-ga

apply_patch_series

PATH="$PATH" bash ./configure ${CONFIGURE_OPTIONS} 
gmake bundles 
