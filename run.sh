#!/bin/bash

source "$PWD/common.sh" || (echo "Could not load environment variables and common functions. Aborting." && exit 1)

if [ "$1" == "" ] || [ "$1" == "-h" ] || [ "$1" == "help" ] || [ "$1" == "--help" ]; then
	echo "Synopsis: $0 <command> <args>"
	echo ""
	echo "Commands:"
	echo "========="
	echo ""
	echo "  General"
	echo "  -------"
	echo "  info...........: Displays environment info."
	echo "  clean..........: Deletes the $EMBED_DEV_DIR directory"
	echo "                   and sub-directories."
	echo ""
	echo "  Crosstool-NG"
	echo "  ------------"
    echo "  ct-build.......: Builds Crosstool-NG from source (the Git repo is cloned"
	echo "                   under $EMBED_DEV_DIR)."
	echo "  ct-clean.......: Deletes the $CROSSTOOL_DEV_DIR directory"
	echo "                   and sub-directories."	echo ""
	echo "  U-Boot"
	echo "  ------"
	echo "  uboot-build....: Builds U-Boot from source (the Git repo is cloned"
	echo "                   under $EMBED_DEV_DIR)."
	echo "  uboot-clean....: Deletes the $UBOOT_DEV_DIR directory"
	echo "                   and sub-directories."
	echo ""
	echo "  Kernel"
	echo "  ------"
	echo "  kernel-build...: Builds the kernel from source (the sources are downloaded"
	echo "                   and untarred under $KERNEL_DEV_DIR)."
	echo "  kernel-clean...: Deletes the $KERNEL_DEV_DIR directory"
	echo "                   and sub-directories."
	echo ""
	echo "  RootFS"
	echo "  ------"
	echo "  rootfs-build...: Builds the root file system under $ROOTFS_DEV_DIR."
	echo "                   Note: this command triggers the BusyBox build, if needed."
	echo "                         BusyBox can also be built separately (see bbox-build command)."
	echo "  rootfs-clean...: Deletes the $ROOTFS_DEV_DIR directory"
	echo "                   and sub-directories."
	echo ""
	echo "  BusyBox"
	echo "  -------"
	echo "  bbox-build.....: Builds BusyBox from source ( the Git repo is cloned"
	echo "                   under $EMBED_DEV_DIR)."
	echo "                   Note: the BusyBox build is automatically triggered by the"
	echo "                         rootfs-build command, if needed. Calling this command"
	echo "                         separately is necessary only if one desires to build"
	echo "                         BusyBox independently."
	echo "  bbox-clean.....: Deletes the $BBOX_DEV_DIR directory"
	echo "                   and sub-directories."
	echo ""
elif [ "$1" == "info" ] || [ "$1" == "-v" ]; then
        print_info
elif [ "$1" == "build" ]; then
	ct_build
	uboot_build
	kernel_build
	rootfs_build
elif [ "$1" == "clean" ]; then
	clean_all

# Crosstool-NG
elif [ "$1" == "ct-build" ]; then
	ct_build
elif [ "$1" == "ct-clean" ]; then
	ct_clean

# Uboot
elif [ "$1" == "uboot-build" ]; then
	uboot_build
elif [ "$1" == "uboot-clean" ]; then
	uboot_clean

# Kernel
elif [ "$1" == "kernel-build" ]; then
	kernel_build
elif [ "$1" == "kernel-clean" ]; then
	kernel_clean

# RootFS
elif [ "$1" == "rootfs-build" ]; then
	rootfs_build
elif [ "$1" == "rootfs-clean" ]; then
	rootfs_clean

# BusyBox
elif [ "$1" == "bbox-build" ]; then
	bbox_build
elif [ "$1" == "bbox-clean" ]; then
	bbox_clean
else
	echo "Unknown command: $1"
	exit 1
fi

