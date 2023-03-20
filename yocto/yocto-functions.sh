#!/bin/bash

function yocto_build()
{
    WORK_DIR="$WORK_DIR" "$WORK_DIR/yocto/yocto-build.sh"
}

function yocto_image_cp()
{
    assert_file_exists "$YOCTO_IMAGE_DIR/$YOCTO_WIC_IMAGE_NAME" "WIC image does not found: $YOCTO_IMAGE_DIR/$YOCTO_WIC_IMAGE_NAME"
    assert_file_exists "/dev/$SD_DRIVE" "Error accessing '/dev/$SD_DRIVE' directory. Is the SD card inserted? Has it been formatted? Check the sd-format command."
    sudo dd if="$YOCTO_IMAGE_DIR/$YOCTO_WIC_IMAGE_NAME" of="/dev/$SD_DRIVE" bs="4M"
}

function yocto_layers_cp()
{
    if ! [ -e "$YOCTO_CUSTOM_LAYERS_DIR" ]; then
        mkdir -p "$YOCTO_CUSTOM_LAYERS_DIR"
        assert_ok "Could not create custom layers directory: $YOCTO_CUSTOM_LAYERS_DIR"
    fi

    if [ "$CHAP06" == "" ]; then
        abort "CHAP06 environment variable not defined. Aborting."
    fi


    META_CHAP06="meta-chap06"
  
    cp -R "$WORK_DIR/exercises/yocto-custom/$META_CHAP06" "$YOCTO_CUSTOM_LAYERS_DIR"
    assert_ok "Could not copy source directory to Yocto layer directories"

    YOCTO_CHAP06_RECIPE_DIR="$YOCTO_CUSTOM_LAYERS_DIR/$META_CHAP06/recipes-chap06/chap06"

    if ! [ -e "$YOCTO_CHAP06_RECIPE_DIR/files" ]; then
        mkdir -p "$YOCTO_CHAP06_RECIPE_DIR/files"
        assert_ok "Error occured trying to create src directories $YOCTO_CHAP06_RECIPE_DIR"
    fi

    cp "$CHAP06/4d/ex1.c" "$YOCTO_CHAP06_RECIPE_DIR/files/chap06_4d_ex1.c" && \
    cp "$CHAP06/4f/ex1.c" "$YOCTO_CHAP06_RECIPE_DIR/files/chap06_4f_ex1.c"

    assert_ok "Error occured trying to copy C source files from $CHAP06"
}

function yocto_layers_rm()
{
    if [ -e "$YOCTO_CUSTOM_LAYERS_DIR" ]; then
        rm -Rf "$YOCTO_CUSTOM_LAYERS_DIR"
        assert_ok "Could not delete custom layers directory: $YOCTO_CUSTOM_LAYERS_DIR"
    fi
}


function yocto_clean()
{
    clean_dir "$YOCTO_DEV_DIR"
}

function yocto_help()
{
    echo "Yocto"
    echo "-----"
    echo "yocto-build.......: Clones the Yocto repo under $YOCTO_DEV_DIR."
    echo "yocto-clean.......: Deletes the $YOCTO_DEV_DIR directory"
    echo "                    and sub-directories."
    echo "yocto-image-cp....: Copies the Yocto-built image to the SD card."
    echo "yocto-layers-cp...: Copies the custom layers to the $YOCTO_DEV_DIR" 
    echo "                    directory."
    echo "yocto-layers-rm...: Deletes the custom layers fromthe $YOCTO_DEV_DIR" 
    echo "                    directory."
}