#!/bin/bash

function yocto_build()
{
    WORK_DIR="$WORK_DIR" "$WORK_DIR/yocto/yocto-build.sh"
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