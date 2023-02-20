#!/bin/bash

function ct_build()
{
	WORK_DIR="$WORK_DIR" "$WORK_DIR/ct/ct-build.sh"
}

function ct_clean()
{
	clean_dir "$CROSSTOOL_DEV_DIR"
}

function ct_help()
{
	echo "Crosstool-NG"
	echo "------------"
    echo "ct-build.......: Builds Crosstool-NG from source (the Git repo is cloned"
	echo "                 under $EMBED_DEV_DIR)."
	echo "ct-clean.......: Deletes the $CROSSTOOL_DEV_DIR directory"
	echo "                 and sub-directories."	echo ""
}