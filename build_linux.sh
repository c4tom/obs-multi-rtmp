#!/usr/bin/bash

set -eux

: "${INSTALL:=0}"
: "${DESTDIR:=/usr}"
: "${QTDIR:=}"
: "${OBS_SRC_DIR:=/usr/include/obs}"

ver=$(grep 'obs-multi-rtmp VERSION' CMakeLists.txt)
ver=${ver:30:-1}

rm -fr build dist *.tar.xz

# have cmake?
apt install cmake

# have qt5 lib?
sudo apt-get install qtcreator qt5-default

cmake  -DCMAKE_INSTALL_PREFIX="$DESTDIR" -DQTDIR="$QTDIR" -DOBS_SRC_DIR="$OBS_SRC_DIR" -B build .
cmake --build build --config Release

cmake --install build --config Release --prefix "dist/$DESTDIR"
cd dist
cmake -E tar cfJ "../obs-multi-rtmp_Linux_$ver.tar.xz" --format=gnutar .
cd ..

[ $INSTALL -gt 0 ] && sudo cmake --install build --config Release || :
