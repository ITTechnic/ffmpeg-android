#!/bin/bash

. abi_settings.sh $1 $2 $3

url="https://downloads.sf.net/project/libpng/libpng16/1.6.13/libpng-1.6.13.tar.xz"
tarcommand="xJ"
dirname="libpng-1.6.13"
delete_regex="libpng-*"

./download_from_repo.sh "$url" "$tarcommand" "$dirname" "$delete_regex"

pushd "$dirname"

make clean

case $1 in
  armeabi-v7a-neon)
    ARM_NEON="yes"
    ;;
  armeabi-v7a)
    ARM_NEON="no"
    ;;
esac

./configure \
  --with-pic \
  --with-sysroot="$NDK_SYSROOT" \
  --host="$NDK_TOOLCHAIN_ABI" \
  --enable-static \
  --disable-shared \
  --prefix="${TOOLCHAIN_PREFIX}" \
  --enable-arm-neon="$ARM_NEON" \
  --disable-shared || exit 1

make -j${NUMBER_OF_CORES} install || exit 1

popd
  
