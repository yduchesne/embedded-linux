#!/bin/bash

function kernel_build()
{
	WORK_DIR="$WORK_DIR" "$WORK_DIR/kernel/kernel-build.sh"
}

function kernel_clean()
{
	clean_dir "$KERNEL_DEV_DIR"
}

function kernel_help()
{
	echo "Kernel"
	echo "------"
	echo "kernel-build...: Builds the kernel from source (the sources are downloaded"
	echo "                 and untarred under $KERNEL_DEV_DIR)."
	echo "kernel-clean...: Deletes the $KERNEL_DEV_DIR directory"
	echo "                 and sub-directories."
}