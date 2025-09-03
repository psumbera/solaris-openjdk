# Oracle Solaris OpenJDK Builder

This project builds all OpenJDK versions from 9 till latest 21 for Solaris 11.4.

Note that this was done based on great job of Peter Tribble:
https://ptribble.blogspot.com/2021/12/keeping-java-alive-on-illumos.html
https://github.com/ptribble/jdk-sunos-patches
https://pkgs.tribblix.org/openjdk/sparc-solaris/

At this time only amd64 platform is expected to work (for SPARC it can build
up to version 17 only).


You just need to have:
- Oracle Solaris 11.4 (at least S11.4.24) with installed system header files
- Git
- JDK 8 [1]
- GCC 10
- Solaris Studio 12.4 (latest supported version! Release version isn't enough) [1]
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

## Creating archives

You can use then archives.sh script which will create tar archives.

Note also archives-bootstrap.sh which currently creates minimal archive
with OpenJDK 13 for bootstraping (can be used for version 13 and 14).
This might be needed if you don't have required version of Studio
compiler).

openjdk-13.0.11-bootstrap_SunOS-i386_bin.tar.xz should be available for
download. The minimal OS version is Solaris 11.4 CBE release [2].

## Using --build-from

You can also build only newer OpenJDK versions. E.g. when you previously
built older version and have them ready in your `build_dir` for
bootstaping (at least when you have previous version).


```
./build-all.sh --build-from=17
```

Alternately you can use your own bootstrap version.

```
./build-all.sh --build-from=17 --boot-jdk=/export/home/build/jdk-16-bootstrap
```

## bootstrap-lts-jdk.sh

Or you can build OpenJDK LTS version 21 (i386 only) or 17 using
bootstrap archives with `bootstrap-lts-jdk.sh`:

```
git clone https://github.com/psumbera/solaris-openjdk.git
cd solaris-openjdk/
./bootstrap-lts-jdk.sh 21
Downloading OpenJDK 20 boostrap version...                                                                           
############################################################################################################################################################################################################ 100.0%
Extraxcting it...                                                                                                    
Clonning OpenJDK source repo...
Cloning into './jdk21u-5SImGb/jdk21u'...                                                                             
remote: Enumerating objects: 1386884, done.
remote: Counting objects: 100% (13559/13559), done.                                                                  
remote: Compressing objects: 100% (4210/4210), done.
remote: Total 1386884 (delta 10025), reused 9381 (delta 9343), pack-reused 1373325 (from 4)                          
Receiving objects: 100% (1386884/1386884), 1.10 GiB | 9.33 MiB/s, done.
Resolving deltas: 100% (1029432/1029432), done.                                                                      
Updating files: 100% (68594/68594), done.
Building OpenJDK 21 (/home/test/solaris-openjdk/build.log)...                                                   
0:05:09 [=======================================================================================================================================================================================>] 100%            
Creating archive /home/test/solaris-openjdk/archives/openjdk-21.0.8_SunOS-i386_bin.tar.xz

```

## Notes

[1] JDK 8 is needed only for OpenJDK 9. Solaris Studio is needed only for
    OpenJDK 9, 10, 11 and 12. See example with `--build-from=[NUM]`.

[2] https://blogs.oracle.com/solaris/post/building-open-source-software-on-oracle-solaris-114-cbe-release
