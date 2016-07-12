FROM ubuntu:15.10

# Inject the remote file fetcher and checksum verifier
ADD fetch.sh /fetch.sh
ENV FETCH /fetch.sh
RUN chmod +x $FETCH


# Make sure apt-get is up to date and dependent packages are installed
RUN \
  apt-get update && \
  apt-get install -y automake autogen build-essential ca-certificates            \
    gcc-5-arm-linux-gnueabi g++-5-arm-linux-gnueabi libc6-dev-armel-cross        \
    gcc-5-arm-linux-gnueabihf g++-5-arm-linux-gnueabihf libc6-dev-armhf-cross    \
    gcc-5-aarch64-linux-gnu g++-5-aarch64-linux-gnu libc6-dev-arm64-cross        \
    gcc-5-multilib g++-5-multilib gcc-mingw-w64 g++-mingw-w64 clang-3.7 llvm-dev \
    libtool libxml2-dev uuid-dev libssl-dev swig openjdk-7-jdk pkg-config patch  \
    make xz-utils cpio wget zip unzip p7zip git mercurial bzr --no-install-recommends

# Fix any stock package issues
RUN \
  ln -s /usr/include/asm-generic /usr/include/asm && \
  ln -s /usr/bin/clang-3.7 /usr/bin/clang         && \
  ln -s /usr/bin/clang++-3.7 /usr/bin/clang++

# Configure the container for OSX cross compilation
ENV OSX_SDK     MacOSX10.9.sdk
ENV OSX_NDK_X86 /usr/local/osx-ndk-x86

RUN \
  OSX_SDK_PATH=https://s3.amazonaws.com/andrew-osx-sdks/MacOSX10.9.sdk.tar.xz && \
  $FETCH $OSX_SDK_PATH e2f01f6dc7611df4783d2adc279d15132f4e9851               && \
  \
  git clone https://github.com/tpoechtrager/osxcross.git && \
  mv `basename $OSX_SDK_PATH` /osxcross/tarballs/        && \
  \
  sed -i -e 's|-march=native||g' /osxcross/build_clang.sh /osxcross/wrapper/build.sh && \
  UNATTENDED=yes OSX_VERSION_MIN=10.6 /osxcross/build.sh                             && \
  mv /osxcross/target $OSX_NDK_X86                                                   && \
  \
  rm -rf /osxcross

ENV PATH $OSX_NDK_X86/bin:$PATH

# Configure the container for iOS cross compilation
ENV IOS_NDK_ARM_7     /usr/local/ios-ndk-arm-7
ENV IOS_NDK_ARM64     /usr/local/ios-ndk-arm64
ENV IOS_SIM_NDK_AMD64 /usr/local/ios-sim-ndk-amd64

ADD update_ios.sh /update_ios.sh
ENV UPDATE_IOS /update_ios.sh
RUN chmod +x $UPDATE_IOS

RUN \
  IOS_SDK_PATH=http://iphone.howett.net/sdks/dl/iPhoneOS8.1.sdk.tbz2 && \
  $FETCH $IOS_SDK_PATH 41203ed17a29743323cce0dd10b238efcea406e1      && \
  mv `basename $IOS_SDK_PATH` iPhoneOS8.1.sdk.tar.bz2                && \
  $UPDATE_IOS /iPhoneOS8.1.sdk.tar.bz2                               && \
  rm -rf /iPhoneOS8.1.sdk.tar.bz2

ENV PATH $IOS_NDK_ARM_7/bin:$PATH

ENTRYPOINT ["/bin/bash"]
