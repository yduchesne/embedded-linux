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

function yocto_custom_layers()
{
    if ! [ -e "$YOCTO_CUSTOM_LAYERS_DIR" ]; then
        mkdir -p "$YOCTO_CUSTOM_LAYERS_DIR"
        assert_ok "Could not create custom layers directory: $YOCTO_CUSTOM_LAYERS_DIR"
    fi

    if [ "$CHAP06" == "" ]; then
        abort "CHAP06 environment variable not defined. Aborting."
    fi

    META_CHAP04_4D="meta-chap06-4d"
    META_CHAP04_4F="meta-chap06-4f"

    cp -R "$WORK_DIR/exercises/yocto-custom/$CHAP04_4D" "$YOCTO_CUSTOM_LAYERS_DIR" && \
    cp -R "$WORK_DIR/exercises/yocto-custom/$CHAP04_4F" "$YOCTO_CUSTOM_LAYERS_DIR"
    assert_ok "Could not copy source directories to Yocto layer directories"

    YOCTO_CHAP06_4D_SRC="$YOCTO_CUSTOM_LAYERS_DIR/$META_CHAP04_4D/recipes-example/chap06-4d/src"
    YOCTO_CHAP06_4F_SRC="$YOCTO_CUSTOM_LAYERS_DIR/$META_CHAP04_4F/recipes-example/chap06-4f/src"

    mkdir -p "$YOCTO_CHAP06_4D_SRC" && \
    mkdir -p "$YOCTO_CHAP06_4F_SRC"
    assert_ok "Error occured trying to create src directories $YOCTO_CHAP06_4D_SRC and/or $YOCTO_CHAP06_4F_SRC"


    cp "$CHAP06/4d/ex1.c" "$YOCTO_CHAP06_4D_SRC" &&
    cp "$CHAP06/4f/ex1.c" "$YOCTO_CHAP06_4D_SRC"
    assert_ok "Error occured trying to copy C source files from $CHAP06"

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