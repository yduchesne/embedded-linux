#!/bin/bash

source $WORK_DIR/common.sh || (echo "U-Boot build  failed. Could not load environment variables and common functions." && exit 1)

if [ -f "$UBOOT_DEV_DIR/u-boot" ]; then
	echo "U-Boot binaries already present under $UBOOT_DEV_DIR. Skipping build."
    echo "  -> If you want to build from scratch, invoke the uboot-clean command prior to uboot-build."
else
	echo "Development directory set to: $EMBED_DEV_DIR (U-Boot will be cloned under that directory)."
	mk_dev_dir

	cd "$EMBED_DEV_DIR" || (echo "Could not switch to directory $EMBED_DEV_DIR. Aborting." && exit 1)

	echo "Cloning U-Boot Git repo..." && \
	git clone "$UBOOT_GIT_URL" && \
	cd "$UBOOT_DEV_DIR" && \
	echo "Checking out version $UBOOT_VERSION..." && \
	git checkout "$UBOOT_VERSION" && \
	echo "Running make..." && \
	make ARCH="$XTOOLS_ARCH" CROSS_COMPILE="$XTOOLS_PREFIX" "$UBOOT_DEF_CONFIG" && \
	make ARCH="$XTOOLS_ARCH" CROSS_COMPILE="$XTOOLS_PREFIX"

	assert_ok "U-Boot build failed. Check the output above for the details."
	echo "U-Boot build completed."

	cd_back
fi
