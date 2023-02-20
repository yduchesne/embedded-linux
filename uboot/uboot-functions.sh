#!/bin/bash

function uboot_build()
{
	WORK_DIR="$WORK_DIR" "$WORK_DIR/uboot/uboot-build.sh"
}

function uboot_clean()
{
	clean_dir "$UBOOT_DEV_DIR"
}

function uboot_help()
{
	echo "U-Boot Module Help"
	echo "------------------"
	echo "uboot-build....: Builds U-Boot from source (the Git repo is cloned"
	echo "                 under $EMBED_DEV_DIR)."
	echo "uboot-clean....: Deletes the $UBOOT_DEV_DIR directory"
	echo "                 and sub-directories."
}