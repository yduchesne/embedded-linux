#!/bin/bash

# Directory for checking out sources, downloading tarballs, etc.
# It is the parent directory for the CT NG and Kernel sources
# as well as build artifacts.
export EMBED_DEV_DIR=~/embedded-linux-tools

# Crosstool-NG
export CROSSTOOL_VERSION="1.25.0"
export CROSSTOOL_GIT_URL="https://github.com/crosstool-ng/crosstool-ng.git"

# Kernel
export KERNEL_MAJOR_VERSION="5"
export KERNEL_FULL_VERSION="5.15.93"
export KERNEL_DOWNLOAD_URL="https://cdn.kernel.org/pub/linux/kernel/v$KERNEL_MAJOR_VERSION.x/linux-$KERNEL_FULL_VERSION.tar.xz"
export KERNEL_SRC_DIR=$EMBED_DEV_DIR/kernel

function assert_ok()
{
  if [ $? -ne 0 ]; then
        echo "$1"
  fi
  exit $?
}

function assert_not_empty()
{
	if [ "$1" == "" ]; then
		echo "$2"
	fi
}

function clean_dir()
{
	assert_not_empty $1 "Directory to clean must be specified."
	if [ -f "$1" ]; then
		rm -Rf "$1"
	fi
	assert_ok "Could not clean directory: $1"
	echo "Cleaned directory: $1"
}

function clean_all()
{
	clean_dir "$EMBED_DEV_DIR"
}

function clean_ct_ng()
{
	clean_dir "$EMBED_DEV_DIR/crosstool-ng"
}

function clean_kernel()
{
	clean_dir  "$EMBED_DEV_DIR/kernel"
}

function print_info()
{
	echo ""
	echo "General"
	echo "======="
	echo "Development directory (EMBED_DEV_DIR)...: $EMBED_DEV_DIR"
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

if [ "$1" == "info" ]; then
	print_info
fi
