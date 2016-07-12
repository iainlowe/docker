# OSX tools base image
#
# Originally extracted from https://github.com/karalabe/xgo
# Copyright (c) 2014 Péter Szilágyi. All rights reserved.
#
# Android parts have been removed. Everything else left the same to reuse xgo layers.
# Copyright (c) 2016 Iain Lowe. All rights reserved. Mistakes are mine, not Péter's
#
# Released under the MIT license.

FROM karalabe/xgo-base

MAINTAINER Iain Lowe <iain.lowe@gmail.com>

# # Mark the image as xgo enabled to support xgo-in-xgo
# ENV XGO_IN_XGO 1


# # Configure the Go environment, since it's not going to change
# ENV PATH   /usr/local/go/bin:$PATH
# ENV GOPATH /go


# # Inject the remote file fetcher and checksum verifier
# ADD fetch.sh /fetch.sh
# ENV FETCH /fetch.sh
# RUN chmod +x $FETCH


# # Make sure apt-get is up to date and dependent packages are installed
# RUN \
#   apt-get update && \
#   apt-get install -y automake autogen build-essential ca-certificates                    \
#     gcc-5-arm-linux-gnueabi g++-5-arm-linux-gnueabi libc6-dev-armel-cross                \
#     gcc-5-arm-linux-gnueabihf g++-5-arm-linux-gnueabihf libc6-dev-armhf-cross            \
#     gcc-5-aarch64-linux-gnu g++-5-aarch64-linux-gnu libc6-dev-arm64-cross                \
#     gcc-5-mips64-linux-gnuabi64 g++-5-mips64-linux-gnuabi64 libc6-dev-mips64-cross       \
#     gcc-5-mips64el-linux-gnuabi64 g++-5-mips64el-linux-gnuabi64 libc6-dev-mips64el-cross \
#     gcc-5-multilib g++-5-multilib gcc-mingw-w64 g++-mingw-w64 clang llvm-dev             \
#     libtool libxml2-dev uuid-dev libssl-dev swig openjdk-8-jdk pkg-config patch          \
#     make xz-utils cpio wget zip unzip p7zip git mercurial bzr texinfo help2man           \
#     --no-install-recommends

# # Fix any stock package issues
# RUN ln -s /usr/include/asm-generic /usr/include/asm

# # Configure the container for OSX cross compilation
# ENV OSX_SDK     MacOSX10.11.sdk
# ENV OSX_NDK_X86 /usr/local/osx-ndk-x86

# RUN \
#   OSX_SDK_PATH=https://s3.dockerproject.org/darwin/v2/$OSX_SDK.tar.xz && \
#   $FETCH $OSX_SDK_PATH dd228a335194e3392f1904ce49aff1b1da26ca62       && \
#   \
#   git clone https://github.com/tpoechtrager/osxcross.git && \
#   mv `basename $OSX_SDK_PATH` /osxcross/tarballs/        && \
#   \
#   sed -i -e 's|-march=native||g' /osxcross/build_clang.sh /osxcross/wrapper/build.sh && \
#   UNATTENDED=yes OSX_VERSION_MIN=10.6 /osxcross/build.sh                             && \
#   mv /osxcross/target $OSX_NDK_X86                                                   && \
#   \
#   rm -rf /osxcross

# ADD patch.tar.xz $OSX_NDK_X86/SDK/$OSX_SDK/usr/include/c++
# ENV PATH $OSX_NDK_X86/bin:$PATH

# # Configure the container for iOS cross compilation
# ENV IOS_NDK_ARM_7     /usr/local/ios-ndk-arm-7
# ENV IOS_NDK_ARM64     /usr/local/ios-ndk-arm64
# ENV IOS_SIM_NDK_AMD64 /usr/local/ios-sim-ndk-amd64

# ADD update_ios.sh /update_ios.sh
# ENV UPDATE_IOS /update_ios.sh
# RUN chmod +x $UPDATE_IOS

# RUN \
#   IOS_SDK_PATH=https://jbdevs.org/sdks/dl/iPhoneOS9.3.sdk.tbz2  && \
#   $FETCH $IOS_SDK_PATH db5ecf91617abf26d3db99e769bd655b943905e5 && \
#   mv `basename $IOS_SDK_PATH` iPhoneOS9.3.sdk.tar.bz2           && \
#   $UPDATE_IOS /iPhoneOS9.3.sdk.tar.bz2                          && \
#   rm -rf /iPhoneOS9.3.sdk.tar.bz2

ENTRYPOINT ["/bin/bash"]
