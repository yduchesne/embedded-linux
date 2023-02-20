#!/bin/bash

source "$PWD/common.sh" || (echo "Could not load environment variables and common functions. Aborting." && exit 1)

load_module bbox "BusyBox"
load_module ct "Crosstool NG"
load_module kernel "Kernel"
load_module rootfs "RootFS"
load_module sd "SD Card"
load_module uboot "U-Boot"

if [ "$1" == "" ] || [ "$1" == "-h" ] || [ "$1" == "help" ] || [ "$1" == "--help" ]; then
	echo "Synopsis: $0 <command> <args>"
	echo ""
	echo "Commands:"
	echo "========="
	echo ""
	echo "info....: Displays environment info."
	echo "build...: Launches the build for all modules, in the"
	echo "          relevant order. Output will be generated"
	echo "          under $EMBDED_DEV_DIR directory."
	echo "clean...: Deletes the $EMBED_DEV_DIR directory"
	echo "          and sub-directories."
	echo "help....: Displays this help. To obtain the help for"
	echo "          a specific module, type: <module_prefix>-help."
	echo "          Examples:"
	echo "            ct-help"
	echo "            kernel-help"
	echo ""
elif [ "$1" == "info" ] || [ "$1" == "-v" ]; then
        print_info
elif [ "$1" == "build" ]; then
	ct_build
	uboot_build
	kernel_build
	rootfs_build
elif [ "$1" == "clean" ]; then
	clean_all
else
	command=$(echo "$1" | tr '-' '_')
	$command
	assert_ok "Execution failed for command: $1. Is it a valid command? You nay type '$0 -help' for help."
fi