#!/bin/bash
set -e

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
	which gsha256sum
	alias sha256sum=gsha256sum
	alias md5sum=gmd5sum
	which sha256sum
	gsha256sum --version
	sha256sum --version
fi

# update qmake conf
echo "CONFIG += libpng_static" >> .qmake.conf

cd $(dirname $0)

# get zlib
curl -Lo zlib.tar.xz "https://www.zlib.net/zlib-${ZLIB_VERSION}.tar.xz"
echo "$ZLIB_CHECKSUM zlib.tar.xz" | sha256sum --check -
tar -xf zlib.tar.xz
rm zlib.tar.xz
mv zlib-${ZLIB_VERSION} zlib

# get libpng
curl -Lo libpng.tar.xz "https://prdownloads.sourceforge.net/libpng/libpng-${LIBPNG_VERSION}.tar.xz?download"
echo "$LIBPNG_CHECKSUM libpng.tar.xz" | md5sum --check -
tar xf libpng.tar.xz
rm libpng.tar.xz
mv libpng-${LIBPNG_VERSION} libpng

# get apng patch
curl -Lo libpng-apng.patch.gz "https://downloads.sourceforge.net/sourceforge/libpng-apng/libpng-${LIBPNG_VERSION}-apng.patch.gz"
gunzip libpng-apng.patch.gz
pushd libpng
patch -Np1 -i "../libpng-apng.patch"
ln -s scripts/pnglibconf.h.prebuilt pnglibconf.h
popd

# link pro files
ln -s ../zlib.pro zlib/zlib.pro
ln -s ../libpng.pro libpng/libpng.pro
