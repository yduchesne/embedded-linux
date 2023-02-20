#!/bin/bash

source "$PWD/conf.sh" || (echo "Could not load environment variables and common functions. Aborting." && exit 1)

# General functions
# =================

function cd_back()
{
	if ! [ "$WORK_DIR" == "" ]; then
		cd "$WORK_DIR" || (echo "Could not switch to $WORK_DIR directory. Aborting." && exit 1)
	else
		cd "$OLD_PWD" || (echo "Could not switch to $OLD_PWD directory. Aborting." && exit 1)
	fi
}

function abort()
{
	if [ -n "$1" ]; then
		echo "$1"
	else
		echo "Aborting execution."
	fi

	if [ -v TOP_PID ]; then
 		kill -s TERM $TOP_PID	
	else
		exit 1
	fi
}

function assert_ok()
{
	if [ $? -ne 0 ]; then
		if [ -n "$1" ]; then
			abort "$1"
		else
		 	abort "Assertion failed. Aborting - see output above for details."
		fi
		cd_back
	fi
}

function assert_set()
{
	if [ -z "$1" ]; then
		if [ -n "$2" ]; then
			abort "$2"
		else
			abort "Expected input not provided. Aborting."
		fi
	fi
}

function assert_file_exists()
{
	if ! [ "$2" == "" ]; then
		ls "$1"> /dev/null
		assert_ok "File or directory does not exist: $1. $2"
	else
		ls "$1"> /dev/null
		assert_ok "File or directory does not exist: $1"
	fi
}

function load_module()
{
	assert_set "$1" "Module prefix not specified"
	assert_set "$2" "Module name not specified"

	source "$WORK_DIR/$1/$1-functions.sh"
	assert_ok "Could not load $2-related functions. Aborting."	
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
		mkdir -p "$1" || (abort "Could not create directory: $1. Aborting.")
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

