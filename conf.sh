#!/bin/bash

trap "exit 1" TERM
export TOP_PID=$$

# Set to the current directory when invoking run.sh
export WORK_DIR="$PWD"

# Directory for checking out sources, downloading tarballs, etc.
# It is the parent directory for the CT NG and Kernel sources
# as well as build artifacts.
export EMBED_DEV_DIR="$HOME/embedded-linux-build"

# Misc
export ARTIFACTS_DIR="$EMBED_DEV_DIR/artifacts"

# Crosstool-NG
export CROSSTOOL_DEV_DIR="$EMBED_DEV_DIR/crosstool-ng"
export CROSSTOOL_VERSION="1.25.0"
export CROSSTOOL_CONFIG_NAME="arm-cortex_a8-linux-gnueabi"
export CROSSTOOL_GIT_URL="https://github.com/crosstool-ng/crosstool-ng.git"
export CROSSTOOL_ZLIB_PATCH="true"
export CROSSTOOL_ZLIB_VERSION="1.2.12"
export PATH="$PATH:$CROSSTOOL_DEV_DIR/bin"

# Toolchain
export XTOOLS_DIR="$HOME/x-tools"
export XTOOLS_TARGET_NAME="arm-cortex_a8-linux-gnueabihf"
# Example of path to sysroot under XTOOLS_DIR:
# arm-cortex_a8-linux-gnueabihf/arm-cortex_a8-linux-gnueabihf/sysroot/lib/
export XTOOLS_SYSROOT_DIR="$XTOOLS_DIR/$XTOOLS_TARGET_NAME/$XTOOLS_TARGET_NAME/sysroot"
export XTOOLS_PREFIX="$XTOOLS_TARGET_NAME-"
export XTOOLS_ARCH="arm"
export XTOOLS_DEF_CONFIG="multi_v7_defconfig"
export PATH="$PATH:$XTOOLS_DIR/$XTOOLS_TARGET_NAME/bin"

# Uboot
export UBOOT_DEV_DIR="$EMBED_DEV_DIR/u-boot"
export UBOOT_GIT_URL="https://github.com/u-boot/u-boot.git"
export UBOOT_VERSION="v2023.01"
export UBOOT_DEF_CONFIG="am335x_evm_defconfig"

# Kernel
export KERNEL_DEV_DIR="$EMBED_DEV_DIR/kernel"
export KERNEL_MAJOR_VERSION="6"
export KERNEL_FULL_VERSION="6.1.12"
export KERNEL_DOWNLOAD_URL="https://cdn.kernel.org/pub/linux/kernel/v$KERNEL_MAJOR_VERSION.x/linux-$KERNEL_FULL_VERSION.tar.xz"
export KERNEL_ARCHIVE_NAME="linux-$KERNEL_FULL_VERSION.tar.xz"
export KERNEL_SRC_DIR="$KERNEL_DEV_DIR/linux-$KERNEL_FULL_VERSION"
export KERNEL_DTB_NAME="am335x-boneblack.dtb"

# RootFS
export ROOTFS_DEV_DIR="$EMBED_DEV_DIR/rootfs"

# BusyBox
export BBOX_DEV_DIR="$EMBED_DEV_DIR/busybox"
export BBOX_VERSION="1_36_0"
export BBOX_GIT_URL="git://busybox.net/busybox.git"

# SD Card
export SD_BOOT_PART_LABEL="BOOT"
export SD_ROOT_PART_LABEL="ROOT"
export SD_DRIVE="sdb"

# Yocto
YOCTO_DEV_DIR="$EMBED_DEV_DIR/yocto"
YOCTO_CLONE_DIR="$YOCTO_DEV_DIR/poky"
YOCTO_GIT_URL="git://git.yoctoproject.org/poky"
YOCTO_GIT_BRANCH="langdale"

YOCTO_TARGET_NAME="beaglebone-yocto"
YOCTO_BUILD_NAME="bbb"
YOCTO_BUILD_TYPE="core-image-minimal"
YOCTO_BUILD_DIR="$YOCTO_DEV_DIR/$YOCTO_BUILD_NAME"
YOCTO_IMAGE_DIR="$YOCTO_BUILD_DIR/tmp/deploy/images/$YOCTO_TARGET_NAME"
# e.g.: core-image-minimal-beaglebone-yocto.tar.bz2
YOCTO_ROOTFS_ARCHIVE_NAME="$YOCTO_BUILD_TYPE-$YOCTO_TARGET_NAME.tar.bz2"

YOCTO_OPEN_EMBED_DEV_DIR="$YOCTO_DEV_DIR/meta-openembedded"
YOCTO_OPEN_EMBED_GIT_URL="git://git.openembedded.org/meta-openembedded"
YOCTO_OPEN_EMBED_GIT_BRANCH="$YOCTO_GIT_BRANCH"

YOCTO_BBB_DEV_DIR="$YOCTO_DEV_DIR/meta-beagleboard"
YOCTO_BBB_GIT_URL="git://github.com/beagleboard/meta-beagleboard"
YOCTO_BBB_GIT_BRANCH="$YOCTO_GIT_BRANCH"

YOCTO_CUSTOM_LAYERS_DIR="$YOCTO_DEV_DIR/custom-layers"