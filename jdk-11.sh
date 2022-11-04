set -xe

VERSION=11

. common.sh

BOOT_JDK="$BUILD_DIR/jdk10u/build/solaris-$JDK_PLATFORM-normal-server-release/jdk"
PATH="$STUDIO:/usr/bin"

CONFIGURE_OPTIONS+=" --with-boot-jdk=$BOOT_JDK"

old_autoconf_version_needed && PATH="$AUTOCONF_OLD_PATH:$PATH"

git clone ${JDK_GITHUB_REPO}/$SRC_DIR "$BUILD_DIR"/$SRC_DIR
cd "$BUILD_DIR"/$SRC_DIR

# There are some troubles with latest OpenJDK 11 update commits. For now
# let's build old sources.
git checkout 224e1a3fcb2c9c43e97e7b0e69d7aad66560f6fc

apply_patch_series

PATH="$PATH" bash ./configure ${CONFIGURE_OPTIONS} 
gmake bundles 
