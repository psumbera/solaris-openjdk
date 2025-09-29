set -xe

VERSION=22

. common.sh

PATH="/usr/bin:/usr/gnu/bin"

CONFIGURE_OPTIONS+=" --enable-unlimited-crypto"
CONFIGURE_OPTIONS+=" --with-boot-jdk=$BOOT_JDK"
CONFIGURE_OPTIONS+=" --with-native-debug-symbols=none"
CONFIGURE_OPTIONS+=" --with-toolchain-type=gcc"
CONFIGURE_OPTIONS+=" --disable-dtrace"
CONFIGURE_OPTIONS+=" --disable-warnings-as-errors"
CONFIGURE_OPTIONS+=" --with-source-date=current"
CONFIGURE_OPTIONS+=" AS=/usr/gnu/bin/as"
CONFIGURE_OPTIONS+=" AR=/usr/gnu/bin/ar"
CONFIGURE_OPTIONS+=" CC=$GCC"
CONFIGURE_OPTIONS+=" CXX=$GXX"
CONFIGURE_OPTIONS+=" DATE=/usr/gnu/bin/date"

git clone ${JDK_GITHUB_REPO}/$SRC_DIR "$BUILD_DIR"/$SRC_DIR
cd "$BUILD_DIR"/$SRC_DIR
git checkout jdk-22.0.2-ga

apply_patch_series

PATH="$PATH" bash ./configure ${CONFIGURE_OPTIONS} 
gmake LOG=${LOG} bundles
