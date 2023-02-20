#!/bin/bash

function bbox_build()
{
	WORK_DIR="$WORK_DIR" "$WORK_DIR/bbox/bbox-build.sh"
}

function bbox_clean()
{
	clean_dir "$BBOX_DEV_DIR"
}


function bbox_help()
{
	echo "BusyBox"
	echo "-------"
	echo "bbox-build.....: Builds BusyBox from source ( the Git repo is cloned"
	echo "                 under $EMBED_DEV_DIR)."
	echo "                 Note: the BusyBox build is automatically triggered by the"
	echo "                       rootfs-build command, if needed. Calling this command"
	echo "                       separately is necessary only if one desires to build"
	echo "                       BusyBox independently."
	echo "bbox-clean.....: Deletes the $BBOX_DEV_DIR directory"
	echo "                 and sub-directories."	
}