#!/bin/bash

set -e

# Ensure argument is given
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <VERSION>" >&2
    exit 1
fi

VERSION=$1
BOOTSTRAP_VERSION=$((VERSION - 1))
GITHUB_URL="https://github.com/psumbera/solaris-openjdk/releases/download"
arch=$(uname -m)

if [[ "$VERSION" -eq 17 ]]; then
    BOOTSRAP_OPENJDK_URL=${GITHUB_URL}/openjdk${BOOTSTRAP_VERSION}-bootstrap/openjdk-${BOOTSTRAP_VERSION}.0.2-bootstrap_SunOS-`mach`_bin.tar.xz
    total_lines=73880
elif [[ "$VERSION" -eq 21 && "$arch" == "i86pc" ]]; then
    BOOTSRAP_OPENJDK_URL=${GITHUB_URL}/openjdk${BOOTSTRAP_VERSION}-i386-bootstrap/openjdk-${BOOTSTRAP_VERSION}-bootstrap_SunOS-i386_bin.tar.xz
    total_lines=101875
else
    echo "Only OpenJDK 17 and 21 (i386) versions build is supported." >&2
    exit 1
fi

# Check for required executables for the build.

required_bins=(
  /usr/bin/ar
  /usr/bin/arch
  /usr/bin/autoconf
  /usr/bin/autom4te
  /usr/bin/awk
  /usr/bin/basename
  /usr/bin/curl
  /usr/bin/date
  /usr/bin/df
  /usr/bin/diff
  /usr/bin/dirname
  /usr/bin/find
  /usr/bin/gawk
  /usr/bin/gcc
  /usr/bin/g++
  /usr/bin/ggrep
  /usr/bin/git
  /usr/bin/gmake
  /usr/bin/gmkdir
  /usr/bin/gpatch
  /usr/bin/grep
  /usr/bin/gsed
  /usr/bin/gtar
  /usr/bin/pigz
  /usr/bin/pkg-config
  /usr/bin/pv
  /usr/bin/readlink
  /usr/bin/sed
  /usr/bin/strip
  /usr/bin/tail
  /usr/bin/tee
  /usr/bin/time
  /usr/bin/touch
  /usr/bin/tr
  /usr/bin/xargs
  /usr/bin/xz
  /usr/bin/zip
  /usr/gnu/bin/as
  /usr/gnu/bin/date
  /usr/gnu/bin/m4
)

missing=()

for bin in "${required_bins[@]}"; do
    if ! command -v "$bin" >/dev/null 2>&1; then
        missing+=("$bin")
    fi
done

if [ ${#missing[@]} -ne 0 ]; then
    echo
    echo "Some required tools are missing: ${missing[*]}"
    exit 1
fi

# OpenJDK bootstrap version

echo "Downloading OpenJDK $BOOTSTRAP_VERSION boostrap version..."
TMPFILE="$(mktemp)"
curl -L "$BOOTSRAP_OPENJDK_URL" -o $TMPFILE --progress-bar

echo "Extraxcting it..."
gtar xf $TMPFILE
rm -f $TMPFILE

echo "Clonning OpenJDK source repo..."
tmpdir=$(mktemp -d ./jdk${VERSION}u-XXXXXX)
git clone https://github.com/openjdk/jdk${VERSION}u $tmpdir/jdk${VERSION}u

# Building

echo "Building OpenJDK ${VERSION} ($(pwd)/build.log)..."
JDK_GITHUB_REPO=$(pwd)/$tmpdir  BOOT_JDK=$(pwd)/jdk-${BOOTSTRAP_VERSION}-bootstrap bash jdk-${VERSION}.sh 2>&1 | tee build.log | pv -l -s $total_lines -p -t -e > /dev/null

# Create archive

./archives.sh
