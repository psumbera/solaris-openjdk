# Oracle Solaris OpenJDK Builder

This project builds all OpenJDK versions from 9 till latest 17 for Solaris 11.4.

Note that this was done based on great job of Peter Tribble:
https://ptribble.blogspot.com/2021/12/keeping-java-alive-on-illumos.html

At this time only amd64 platform is expected to work (not SPARC).

You just need to have:
- Oracle Solaris 11.4 (at least S11.4.24) with installed system header files
- Git
- JDK 8
- GCC 10
- Internet access for OpenJDK repositories

Alternatively you can use your OpenJDK repository mirror and set it via
environment variables JDK_GITHUB_REPO (for JDK_GITHUB_REPO=https://github.com/openjdk).

Depending on your system version of GNU make and autoconf, build might need to
download specific version of these build tools. You can also set TOOLS_ARCHIVE
environment variable to directory with following archives to avoid repeating
external downloads.

To create these mirrors in your directory you can use mirror.sh script:
  bash mirror.sh

sync-partches.sh files helps to synchronize patch files with Tribblix.

Example:

```
git clone https://github.com/psumbera/solaris-openjdk.git
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
```

--

After the build you should inspect build_dir/ for your OpenJDK binaries.

Your build log files will be available in logs/ directory.
