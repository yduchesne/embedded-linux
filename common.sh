#!/bin/bash

source "$PWD/conf.sh" || (echo "Could not load environment variables and common functions. Aborting." && exit 1)

# General functions
# =================

function assert_ok()
{
  if [ $? -ne 0 ]; then
        echo "$1"
	cd "$OLD_PWD" || (echo "Could not switch to $OLD_PWD directory. Aborting." && exit 1)
	exit $?
  fi
}

function assert_file_exists()
{
	ls "$1"> /dev/null
	assert_ok "Directory does not exist: $1"
}

function clean_dir()
{
	if [ -d "$1" ]; then
		rm -Rf "$1"
	        assert_ok "Could not clean directory: $1"
        	echo "Cleaned directory: $1"
	fi
}

function clean_all()
{
	clean_dir "$EMBED_DEV_DIR"
}

function mk_dir()
{
	if ! [ -d "$1" ]; then
		mkdir -p "$1" || (echo "Could not create directory: $1. Aborting." && exit 1)
		echo "Created directory: $1"
	fi
}

function mk_dev_dir()
{
	mk_dir "$EMBED_DEV_DIR"
}

function print_info()
{
        echo ""
        echo "General"
        echo "======="
        echo "Development directory (EMBED_DEV_DIR)...: $EMBED_DEV_DIR"
        echo "(Where Git repos are cloned, tarballs"
        echo "downloaded, etc.)"
        echo ""
        echo "Crosstool-NG"
        echo "============"
        echo "Version (CROSSTOOL_VERSION).............: $CROSSTOOL_VERSION"
        echo "Git URL (CROSSTOOL_GIT_URL).............: $CROSSTOOL_GIT_URL"
        echo ""
        echo "Kernel"
        echo "======"
        echo "Major version (KERNEL_MAJOR_VERSION)....: $KERNEL_MAJOR_VERSION"
        echo "Full version (KERNEL_FULL_VERSION)......: $KERNEL_FULL_VERSION"
        echo ""
}

# Crosstool-NG functions
# ======================

function ct_clean()
{
	clean_dir "$CROSSTOOL_DEV_DIR"
}

# Kernel functions
# ================

function kernel_clean()
{
	clean_dir  "$KERNEL_DEV_DIR"
}

# RootFS functions
# ================

function rootfs_clean()
{
        # Not reusing clean_dir function as sudo is required
        # to clean rootfs dir (whose owner is set as root by
        # the build).
	if [ -d "$1" ]; then
		sudo rm -Rf "$1"
	        assert_ok "Could not clean directory: $1"
        	echo "Cleaned directory: $1"
	fi
}

# BusyBox functions
# =================
function bbox_clean()
{
	clean_dir "$BBOX_DEV_DIR"
}
