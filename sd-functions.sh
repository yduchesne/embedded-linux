#!/bin/bash

sd_copy_fsramdisk()
{
    assert_file_exists "$ARTIFACTS_DIR/uRamdisk" "Make sure you have run the 'rootfs-create-initramfs' command."
    assert_file_exists "/media/$USER/boot" "Is the SD card inserted? Has it been formatted? Check the sd-format command."
    cp "$ARTIFACTS_DIR/uRamdisk" "/media/$USER/boot"
    assert_ok "Could not copy $ARTIFACTS_DIR/uRamdisk to /media/$user/boot. Aborting."
}

sd_copy_uboot()
{
    assert_file_exists "$UBOOT_DEV_DIR/MLO" "Has U-Boot been compiled? Check the uboot-build command."
    assert_file_exists "$UBOOT_DEV_DIR/u-boot.img" "Has U-Boot been compiled? Check the uboot-build command."
    assert_file_exists "/media/$USER/boot" "Is the SD card inserted? Has it been formatted? Check the sd-format command."
    cp "$UBOOT_DEV_DIR/MLO" "$UBOOT_DEV_DIR/u-boot.img" "/media/$USER/boot"
    assert_ok "Could not copy MLO and u-boot.img from directory $UBOOT_DEV_DIR to /media/$user/boot. Aborting."
}

sd_copy_kernel()
{
    assert_file_exists "$KERNEL_SRC_DIR/arch/arm/boot/zImage" "Has the kernel been compiled? Check the kernel-build command."
    assert_file_exists "$KERNEL_SRC_DIR/arch/arm/boot/dts/$KERNEL_DTB_NAME" "Has the kernel been compiled? Check the kernel-build command."
    assert_file_exists "/media/$USER/boot" "Is the SD card inserted? Has it been formatted? Check the sd-format command."

    cp "$KERNEL_SRC_DIR/arch/arm/boot/zImage" "/media/$USER/boot"
    assert_ok "Could not copy $KERNEL_SRC_DIR/arch/arm/boot/zImage to /media/$USER/boot"
    cp "$KERNEL_SRC_DIR/arch/arm/boot/dts/$KERNEL_DTB_NAME" "/media/$USER/boot"
    assert_ok "Could not copy $KERNEL_SRC_DIR/arch/arm/boot/dts/$KERNEL_DTB_NAME to /media/$USER/boot"
}

sd_unmount()
{
    if [ -e "/media/$USER/boot" ]; then
        sudo unmount "/media/$USER/boot"
    fi
    if [ -e "/media/$USER/rootfs" ]; then
        sudo unmount "/media/$USER/rootfs"
    fi    
}