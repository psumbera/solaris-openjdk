# solaris-openjdk

This project builds all OpenJDK versions from 9 till latest 17 for Solaris 11.4.

Now only amd64 platform is supported (not SPARC).

You just need to have:
- Oracle Solaris 11.4 (at least S11.4.24) with installed system header files
- Mercurial
- Git
- JDK 8
- GCC 10
- Internet access for OpenJDK repositories

Alternatively you can use your OpenJDK repository mirrors and set them via
environment variables JDK_REPO (for http://hg.openjdk.java.net/jdk-updates)
and JDK_GITHUB_REPO (for JDK_GITHUB_REPO=https://github.com/openjdk).
You will need both.


Example:

cd solaris-openjdk/
./build-all.sh
Building Openjdk 9...
Building Openjdk 10...
Building Openjdk 11...
Building Openjdk 12...
Building Openjdk 13...
Building Openjdk 14...
Building Openjdk 16...
Building Openjdk 17...
Building Openjdk 18...

--

After the build you should inspect build_dir/ for your OpenJDK binaries.

Your build log files will be available in logs/ directory.
