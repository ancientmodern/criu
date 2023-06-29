#!/bin/bash

# Running script notification
echo "Running script: build_criu.sh"

# Define toolchain directories
TOOLCHAIN_ROOT="/rivos/riscv-gnu-toolchain"
TOOLCHAIN_BIN_DIR="${TOOLCHAIN_ROOT}/bin"

# Define target architecture
TARGET_ARCH="riscv64"

# Define build root directory
BUILD_DIR_ROOT="/scratch/cross-compile-riscv64-artifacts"

# Define include and library directories for cross-compile
INCLUDE_DIR_CC="${BUILD_DIR_ROOT}/riscv64_pb_install/include"
LIB_DIR_CC="${BUILD_DIR_ROOT}/riscv64_pb_install/lib"

# Define include and library directories for toolchain
TOOLCHAIN_INCLUDE_DIR="${TOOLCHAIN_ROOT}/sysroot/usr/include"
TOOLCHAIN_LIB_DIR="${TOOLCHAIN_ROOT}/sysroot/lib"

# Update PATH and PKG_CONFIG_PATH environment variables
export PATH="${TOOLCHAIN_BIN_DIR}:${BUILD_DIR_ROOT}/x86_64_pb_install/bin:${PATH}"
export PKG_CONFIG_PATH="${BUILD_DIR_ROOT}/riscv64_pb_install/lib/pkgconfig:${PKG_CONFIG_PATH}"

# Clean the build environment
make mrproper || exit 1
find . -type f -name "*.d" -exec rm -f {} +
find . -type f -name "*.o" -exec rm -f {} +

# Remove stale files
FILES_TO_REMOVE=(
    "compel/plugins/include/uapi/std/syscall-aux.S"
    "compel/plugins/include/uapi/std/syscall-aux.h"
)

for file in "${FILES_TO_REMOVE[@]}"; do
    if [ -f "$file" ] ; then
        rm "$file" || { echo "Error removing $file"; exit 1; }
    fi
done

# Define compilation flags
CFLAGS=" -I${INCLUDE_DIR_CC} -L${LIB_DIR_CC} -DCONFIG_HAS_NO_LIBC_RSEQ_DEFS"
LDFLAGS=" -Wl,-rpath-link,${TOOLCHAIN_LIB_DIR}"
LDFLAGS+=" -Wl,-rpath-link,/scratch/riscv-gnu-toolchain/build-glibc-linux-rv64imafdc-lp64d"
# CFLAGS=$(pkg-config --cflags libprotobuf-c)
# LDFLAGS=$(pkg-config --libs libprotobuf-c)

# Make with debug enabled
ARCH=${TARGET_ARCH} \
CROSS_COMPILE=riscv64-unknown-linux-gnu- \
CFLAGS="${CFLAGS}" \
LDFLAGS="${LDFLAGS}" \
make DEBUG=1 || exit 1
