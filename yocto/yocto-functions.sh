#!/bin/bash

function yocto_build()
{
    WORK_DIR="$WORK_DIR" "$WORK_DIR/yocto/yocto-build.sh"
}

function yocto_copy_to_sd()
{
    assert_file_exists "$YOCTO_IMAGE_DIR"
    assert_file_exists "/media/$USER/boot" "Error accessing '/media/$USER/boot' directory. Is the SD card inserted? Has it been formatted? Check the sd-format command."
    sudo ls "/media/$USER/rootfs" &2>/dev/null || echo "Error accessing '/media/$USER/root' directory. Is the SD card inserted? Has it been formatted? Check the sd-format command." && abort
    rm -f "/media/$USER/boot/*" && \
    cp "$YOCTO_IMAGE_DIR/MLO" "$YOCTO_IMAGE_DIR/u-boot.img" "/media/$USER/boot" && \
    sudo rm -Rf "/media/$USER/rootfs/*" && \
    sudo tar -xvf "$YOCTO_IMAGE_DIR/$YOCTO_ROOTFS_ARCHIVE_NAME"  "/media/$user/rootfs/"
    assert_ok "Could not copy Yocto artifacts to SD card."
}

function yocto_clean()
{
    clean_dir "$YOCTO_DEV_DIR"
}



function rootfs_help()
{
    echo "Yocto"
    echo "-----"
    echo "yocto-build...: Clones the Yocto repo under $YOCTO_DEV_DIR."
    echo "yocto-clean...: Deletes the $YOCTO_DEV_DIR directory"
    echo "                and sub-directories."
}