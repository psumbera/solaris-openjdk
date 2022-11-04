# Creates/updates local mirrors from Github OpenJDK update repos.
git -C jdk9u  pull 2>/dev/null || git clone https://github.com/openjdk/jdk9u
git -C jdk10u pull 2>/dev/null || git clone https://github.com/openjdk/jdk10u
git -C jdk11u pull 2>/dev/null || git clone https://github.com/openjdk/jdk11u
git -C jdk12u pull 2>/dev/null || git clone https://github.com/openjdk/jdk12u
git -C jdk13u pull 2>/dev/null || git clone https://github.com/openjdk/jdk13u
git -C jdk14u pull 2>/dev/null || git clone https://github.com/openjdk/jdk14u
git -C jdk15u pull 2>/dev/null || git clone https://github.com/openjdk/jdk15u
git -C jdk16u pull 2>/dev/null || git clone https://github.com/openjdk/jdk16u
git -C jdk17u pull 2>/dev/null || git clone https://github.com/openjdk/jdk17u
git -C jdk18u pull 2>/dev/null || git clone https://github.com/openjdk/jdk18u
# Downloads build tools.
test -f make-4.2.1.tar.bz2 || wget https://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2
test -f autoconf-2.69.tar.xz || wget https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz
