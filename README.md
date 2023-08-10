   

FFmpeg6.0 下载：https://ffmpeg.org/releases/ffmpeg-6.0.tar.xz

x264 下载：https://www.videolan.org/developers/x264.html

```
.
├── build_ffmpeg.sh
├── build_x264.sh
├── ffmpeg-6.0
├── x264
└── 下载.md
```

下载后保持如此目录

先使用build_x264.sh编译x264

再使用build_ffmpeg.sh编译ffmpeg

```shell
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
```





```shell
#!/bin/bash
#配置你的NDK路径
NDK=$HOME/Library/Android/sdk/ndk/21.1.6352462
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
X264_OUT_DIR=$(pwd)/out/x264
OUT_DIR=$(pwd)/out/ffmpeg-6.0

function build_android {
	./configure \
		--prefix=$PREFIX \
		--disable-postproc \
		--disable-debug \
		--disable-doc \
		--disable-ffmpeg \
		--disable-ffplay \
		--disable-ffprobe \
		--disable-symver \
		--disable-doc \
		--disable-avdevice \
		--enable-gpl \
		--enable-static \
		--enable-shared \
		--enable-neon \
		--enable-libx264 \
		--enable-encoder=libx264 \
		--enable-hwaccels \
		--enable-jni \
		--enable-small \
		--enable-mediacodec \
		--enable-decoder=h264_mediacodec \
		--enable-decoder=hevc_mediacodec \
		--enable-decoder=mpeg4_mediacodec \
		--enable-hwaccel=h264_mediacodec \
		--cross-prefix=$CROSS_PREFIX \
		--target-os=android \
		--arch=$ARCH \
		--cpu=$CPU \
		--cc=$CC \
		--cxx=$CXX \
		--enable-cross-compile \
		--sysroot=$SYSROOT \
		--extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS -I$X264_INCLUDE " \
		--extra-ldflags="-L$X264_LIB $ADDI_LDFLAGS" \
		--pkg-config="pkg-config --static"

		make clean
		make -j32
		make install
}

cd "$(pwd)/ffmpeg-6.0"

#arm64-v8a 参数配置

# 指定X264的库
export PKG_CONFIG_PATH=$X264_OUT_DIR/arm64-v8a/lib/pkgconfig
echo "PKG_CONFIG_PATH:${PKG_CONFIG_PATH}"
X264_INCLUDE=$X264_OUT_DIR/arm64-v8a/include
X264_LIB=$X264_OUT_DIR/arm64-v8a/lib
ARCH=arm64
CPU=armv8-a
API=21
CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
SYSROOT=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
PREFIX=$OUT_DIR/arm64-v8a
OPTIMIZE_CFLAGS="-march=$CPU"

#清空上次的编译
make clean
# 函数调用
build_android

echo "============================build android ffmpeg arm64 end=========================="

#arm-v7a 参数配置

# 指定X264的库
export PKG_CONFIG_PATH=$X264_OUT_DIR/armeabi-v7a/lib/pkgconfig
echo "PKG_CONFIG_PATH:${PKG_CONFIG_PATH}"
X264_INCLUDE=$X264_OUT_DIR/armeabi-v7a/include
X264_LIB=$X264_OUT_DIR/armeabi-v7a/lib

ARCH=arm
CPU=armv7a
API=21
CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
SYSROOT=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
PREFIX=$OUT_DIR/armeabi-v7a
OPTIMIZE_CFLAGS="-march=$CPU"

#清空上次的编译
make clean
# 函数调用
build_android

echo "============================build android ffmpeg armv7a end=========================="
```



