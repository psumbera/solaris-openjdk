set -xe

VERSION=12

. common.sh

BOOT_JDK="$BUILD_DIR/jdk11u/build/solaris-$JDK_PLATFORM-normal-server-release/jdk"
PATH="$STUDIO:/usr/bin"

CONFIGURE_OPTIONS+=" --with-boot-jdk=$BOOT_JDK"

# OpenJDK 12 has some issues:
# - https://bugs.openjdk.java.net/browse/JDK-8211081
# - shenandoahgc doesn't build on Solaris i386 (and is not supported on sparc)
CONFIGURE_OPTIONS+=" --with-jvm-features=-shenandoahgc"
CONFIGURE_OPTIONS+=" --disable-warnings-as-errors"

old_gmake_version_needed && CONFIGURE_OPTIONS+=" MAKE=$GMAKE_OLD"
old_autoconf_version_needed && PATH="$AUTOCONF_OLD_PATH:$PATH"

git clone ${JDK_GITHUB_REPO}/$SRC_DIR "$BUILD_DIR"/$SRC_DIR
cd "$BUILD_DIR"/$SRC_DIR
git checkout 89c4c727007ec579d4183221954ed33f23b46bd5
#git checkout jdk-12.0.2+10

apply_patch_series

PATH="$PATH" bash ./configure ${CONFIGURE_OPTIONS} 
gmake bundles 
