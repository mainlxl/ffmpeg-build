#!/bin/bash
 
NDK=$HOME/Library/Android/sdk/ndk/21.1.6352462
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
API=21

OUT_DIR=$(pwd)/out/x264

cd x264

function build_one
{
    ./configure \
        --prefix=$PREFIX \
        --disable-cli \
        --enable-shared \
        --enable-static \
        --enable-pic \
        --host=$my_host \
        --cross-prefix=$CROSS_PREFIX \
        --sysroot=$TOOLCHAIN/sysroot
 
    make clean
    make -j16
    make install
}
 
#arm64-v8a
PREFIX=$OUT_DIR/arm64-v8a
my_host=aarch64-linux-android
export TARGET=aarch64-linux-android
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
build_one
 
#armeabi-v7a
PREFIX=$OUT_DIR/armeabi-v7a
my_host=armv7a-linux-android
export TARGET=armv7a-linux-androideabi
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
build_one