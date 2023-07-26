#!/bin/sh

echo "running script: build_libgnutls.sh"

. ./config.sh
. ./util.sh

GMP_DOWNLOAD_URL="https://gmplib.org/download/gmp/gmp-6.2.1.tar.lz"

# download source code and extract it, including both libnet and libnet-c
download_extract () {
    wget -P $BUILD_ROOT_DIR $GMP_DOWNLOAD_URL --quiet

    tarball="$(basename -- $GMP_DOWNLOAD_URL)"
    tar --lzip -xvf $BUILD_ROOT_DIR/$tarball --directory $BUILD_ROOT_DIR    
}

build_gmp_riscv64 () {
    # go to the folder where the extracted files are
    cd "$BUILD_ROOT_DIR/gmp-6.2.1" 

    mkdir -p riscv64_build
    cd riscv64_build
    
    CC=riscv64-unknown-linux-gnu-gcc \
    CXX=riscv64-unknown-linux-gnu-g++ \
    ../configure --prefix=$BUILD_ROOT_DIR/riscv64_pb_install \
    --enable-static --host=riscv64-unknown-linux-gnu

    make && make install
}

main () {
    download_extract

    case $TARGET_ARCH in
        "riscv64")
            printf "${BCyan}building gmp for $TARGET_ARCH${Color_Off}\n"
            measure_func_time build_gmp_riscv64
            ;;

        *)
            echo "the target architecture $TARGET_ARCH is not supported, exit the program..."
            exit
            ;;
    esac
}

main