#!/bin/bash
echo "Cloning dependencies"

  sudo apt-get update -y 

        sudo apt install gcc-aarch64-linux-gnu -y

        sudo apt install gcc-arm-linux-gnueabi -y

        sudo apt install binutils make python3 libssl-dev build-essential bc  bison flex unzip libssl-dev ca-certificates xz-utils mkbootimg cpio device-tree-compiler git git-lfs -y

        git clone https://github.com/kdrag0n/proton-clang --dept=1 -b master

        make clean
        make mrproper


if [ -d include/config ]; then
    echo "Find config,will remove it"
    rm -rf include/config
else
    echo "No Config,good."
fi

# I use Proton-Clang
export PATH=$PATH:$(pwd)/proton-clang/bin/
export CC=clang
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-

export ARCH=arm64
export SUBARCH=arm64
export ANDROID_MAJOR_VERSION=r

export KCFLAGS=-w
# export CONFIG_SECTION_MISMATCH_WARN_ONLY=y

date="$(date +%Y.%m.%d-%I:%M)"

export TARGET=out

make O=out KCFLAGS=-w ARCH=arm64 CC=clang a03s_cis_open_defconfig
make O=out KCFLAGS=-w ARCH=arm64 CC=clang -j24 2>&1 | tee kernel_log-${date}.txt

          git clone --depth=1 https://github.com/osm0sis/AnyKernel3 -b master AnyKernel3 && rm -rf AnyKernel3/.git AnyKernel3/.github AnyKernel3/LICENSE AnyKernel3/README.md
          if [[ -f out/arch/arm64/boot/Image.gz-dtb ]]; then
            cp out/arch/arm64/boot/Image.gz-dtb AnyKernel3/Image.gz-dtb
          elif [[ -f out/arch/arm64/boot/Image-dtb ]]; then
            cp out/arch/arm64/boot/Image-dtb AnyKernel3/Image-dtb
          elif [[ -f out/arch/arm64/boot/Image.gz ]]; then
            cp out/arch/arm64/boot/Image.gz AnyKernel3/Image.gz
          elif [[ -f out/arch/arm64/boot/Image ]]; then
            cp out/arch/arm64/boot/Image AnyKernel3/Image
          fi
          if [ -f out/arch/arm64/boot/dtbo.img ]; then
            cp out/arch/arm64/boot/dtbo.img AnyKernel3/dtbo.img
          fi

