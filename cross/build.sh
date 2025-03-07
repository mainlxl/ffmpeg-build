cross_tool=/home/Mainli/ipc/gcc-11.1.0
cross_install_x264=/home/Mainli/ipc/cross_install/x264
cross_install_ffmpeg=/home/Mainli/ipc/cross_install/ffmpeg
mkdir -p $cross_install_x264
mkdir -p $cross_install_ffmpeg


export PATH="$cross_tool/bin:$PATH"
export CC=$cross_tool/bin/arm-linux-gnueabihf-gcc
export CXX=$cross_tool/bin/arm-linux-gnueabihf-g++
export AR=$cross_tool/bin/arm-linux-gnueabihf-ar
export STRIP=$cross_tool/bin/arm-linux-gnueabihf-strip
export SYSROOT="$cross_tool/arm-linux-gnueabihf/libc"


cd x264
./configure \
  --host=arm-linux-gnueabihf \
  --prefix=$cross_install_x264 \
  --enable-static \
  --libdir=$cross_install_x264/lib \
  --includedir=$cross_install_x264/include \
  --cross-prefix=$cross_tool/bin/arm-linux-gnueabihf- \
  --sysroot=$SYSROOT
make distclean
make -j$(nproc)
make install

# 需要安装pkg-config   sudo apt install pkg-config


cd ../ffmpeg-6.0
export PKG_CONFIG_PATH="$cross_install_x264/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="$SYSROOT"
export PKG_CONFIG_LIBDIR="$SYSROOT/usr/lib/pkgconfig:$SYSROOT/usr/share/pkgconfig"
make distclean
./configure \
  --cc=$CC \
  --cxx=$CXX \
  --enable-cross-compile \
  --target-os=linux \
  --arch=arm \
  --sysroot=$SYSROOT \
  --cross-prefix=$cross_tool/bin/arm-linux-gnueabihf- \
  --prefix=$cross_install_ffmpeg \
  --extra-cflags="-I$cross_install_x264/include" \
  --extra-ldflags="-L$cross_install_x264/lib -Wl,-rpath-link,$SYSROOT/lib" \
  --enable-libx264 \
  --enable-gpl \
  --pkg-config=$(which pkg-config) \
  --enable-static \
  --enable-encoder=libx264,aac \
  --enable-decoder=h264,aac \
  --enable-muxer=mp4,mpegps \
  --enable-demuxer=mp4,mpegps \
  --enable-encoder=mpeg2video \
  --enable-decoder=mpeg2video \
  --enable-parser=mpeg2video


make distclean
make -j$(nproc)
make install