#!/bin/sh

echo "running script: build_libgnutls.sh"

. ./config.sh
. ./util.sh

NETTLE_DOWNLOAD_URL="https://ftp.gnu.org/gnu/nettle/nettle-3.9.1.tar.gz"

# download source code and extract it, including both libnet and libnet-c
download_extract () {
    wget -P $BUILD_ROOT_DIR $NETTLE_DOWNLOAD_URL --quiet

    tarball="$(basename -- $NETTLE_DOWNLOAD_URL)"
    tar -zxf $BUILD_ROOT_DIR/$tarball --directory $BUILD_ROOT_DIR    
}

build_nettle_riscv64 () {
    # go to the folder where the extracted files are
    cd "$BUILD_ROOT_DIR/nettle-3.9.1" 

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
            printf "${BCyan}building nettle for $TARGET_ARCH${Color_Off}\n"
            measure_func_time build_nettle_riscv64
            ;;

        *)
            echo "the target architecture $TARGET_ARCH is not supported, exit the program..."
            exit
            ;;
    esac
}

main