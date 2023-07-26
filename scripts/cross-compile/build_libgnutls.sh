#!/bin/sh

echo "running script: build_libgnutls.sh"

. ./config.sh
. ./util.sh

GNUTLS_DOWNLOAD_URL="https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.9.tar.xz"

# download source code and extract it, including both libnet and libnet-c
download_extract () {
    wget -P $BUILD_ROOT_DIR $GNUTLS_DOWNLOAD_URL --quiet

    tarball="$(basename -- $GNUTLS_DOWNLOAD_URL)"
    tar -Jxf $BUILD_ROOT_DIR/$tarball --directory $BUILD_ROOT_DIR    
}


# build the arm64 version 
build_gnutls_arm64 () {
    # go to the folder where the extracted files are
    cd "$BUILD_ROOT_DIR/gnutls-3.7.9" 

    mkdir -p arm64_build
    cd arm64_build
    
    CC=aarch64-linux-gnu-gcc \
    CXX=aarch64-linux-gnu-g++ \
    ../configure --prefix=$BUILD_ROOT_DIR/arm64_pb_install \
    --enable-static --host=aarch64-unknown-linux-gnu

    make && make install
}


build_gnutls_riscv64 () {
    # go to the folder where the extracted files are
    cd "$BUILD_ROOT_DIR/gnutls-3.7.9" 

    mkdir -p riscv64_build
    cd riscv64_build
    
    CC=riscv64-unknown-linux-gnu-gcc \
    CXX=riscv64-unknown-linux-gnu-g++ \
    LDFLAGS="-L$BUILD_ROOT_DIR/riscv64_pb_install/lib" \
    CFLAGS="-I$BUILD_ROOT_DIR/riscv64_pb_install/include" \
    ../configure --prefix=$BUILD_ROOT_DIR/riscv64_pb_install \
    --enable-static --host=riscv64-unknown-linux-gnu --with-included-unistring \
    --with-nettle-prefix=$BUILD_ROOT_DIR/riscv64_pb_install/lib/libnettle.so

    make && make install
}

main () {
    # download_extract

    case $TARGET_ARCH in
        "aarch64" | "arm64")
            printf "${BCyan}building gnutls for $TARGET_ARCH${Color_Off}\n"
            measure_func_time build_gnutls_arm64
            ;;
        
        "riscv64")
            printf "${BCyan}building gnutls for $TARGET_ARCH${Color_Off}\n"
            measure_func_time build_gnutls_riscv64
            ;;

        *)
            echo "the target architecture $TARGET_ARCH is not supported, exit the program..."
            exit
            ;;
    esac
}

main