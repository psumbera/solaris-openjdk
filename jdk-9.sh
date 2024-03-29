set -xe

VERSION=9

. common.sh

# S11.4.21 have updated CUPS version which causes problem to old Studio compiler
function fix_cups_versioning {
  test `uname -v | cut -d . -f 3` -lt 21 && return
  gsed 's;_CUPS_NONNULL(...);_CUPS_NONNULL();' /usr/include/cups/versioning.h > my-cups-versioning.h
  FILE=CUPSfuncs.c
  for f in jdk/src/java.desktop/unix/native/common/awt/$FILE src/java.desktop/unix/native/common/awt/$FILE; do
    [ ! -f "$f" ] || gsed -i "/#include <dlfcn.h>/a#include \"`pwd`/my-cups-versioning.h\"" "$f"
  done
  test `uname -v | cut -d . -f 3` -lt 48 && return
  gsed -i 's;_CUPS_API_AVAILABLE(...);_CUPS_API_AVAILABLE();' my-cups-versioning.h
  gsed -i 's;_CUPS_API_DEPRECATED(...);_CUPS_API_DEPRECATED();' my-cups-versioning.h
}

PATH="$STUDIO:/usr/bin"

CONFIGURE_OPTIONS+=" --with-boot-jdk=$BOOT_JDK"

old_gmake_version_needed && CONFIGURE_OPTIONS+=" MAKE=$GMAKE_OLD"

git clone ${JDK_GITHUB_REPO}/$SRC_DIR "$BUILD_DIR"/$SRC_DIR
cd "$BUILD_DIR"/$SRC_DIR
git checkout jdk-9+181

fix_cups_versioning
apply_patch_series

PATH="$PATH" bash ./configure ${CONFIGURE_OPTIONS} 
gmake bundles 
