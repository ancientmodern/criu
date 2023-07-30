#!/bin/bash

printf "${BCyan}running script: build_criu.sh${Color_Off}\n"

. ./config.sh

cd $CRIU_ROOT_DIR

export PATH=$BUILD_ROOT_DIR/x86_64_pb_install/bin:$PATH
export PKG_CONFIG_PATH=$BUILD_ROOT_DIR/riscv64_pb_install/lib/pkgconfig:$PKG_CONFIG_PATH

make mrproper

file="$CRIU_ROOT_DIR/compel/plugins/include/uapi/std/syscall-aux.S"
if [ -f "$file" ] ; then
    rm "$file"
fi

file="$CRIU_ROOT_DIR/compel/plugins/include/uapi/std/syscall-aux.h"
if [ -f "$file" ] ; then
    rm "$file"
fi


# CFLAGS=$(pkg-config --cflags libprotobuf-c)
CFLAGS=" -I$INCLUDE_DIR_CC -L$LIB_DIR_CC -DCONFIG_HAS_NO_LIBC_RSEQ_DEFS"


# LDFLAGS=$(pkg-config --libs libprotobuf-c)
LDFLAGS=" -Wl,-rpath-link,/rivos/riscv-gnu-toolchain/sysroot/lib"
LDFLAGS+=" -Wl,-rpath-link,/scratch/riscv-gnu-toolchain/build-glibc-linux-rv64imafdc-lp64d"


# V=1 \
ARCH=riscv64 \
CROSS_COMPILE=riscv64-unknown-linux-gnu- \
CFLAGS=$CFLAGS \
LDFLAGS=$LDFLAGS \
make DEBUG=1