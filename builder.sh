#!/bin/bash
BASEDIR=$(pwd)

# build the stupid thing
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_TOOLCHAIN_FILE=../toolchain/Linux-mingw64.cmake ..
cmake --build . --target bofs_x64
cmake --build . --target bofs_x86
cd bofs
make install
cd ..
cmake --build . --target bofnet_managed
cmake --install .

mkdir -p ${BASEDIR}/dist
cp -R ${BASEDIR}/build/dist/net40/* ${BASEDIR}/dist/
