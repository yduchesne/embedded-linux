#!/bin/bash

source "$PWD/common.sh" || (echo "BusyBox build failed. Could not load environment variables and common scripts." && exit 1)

if [ -f "$ROOTFS_DEV_DIR/bin/busybox" ]; then
	echo "BusyBox binary already present under $ROOTFS_DEV_DIR. Skipping build."
        echo "  -> If you want to build from scratch, invoke the bbox-clean command prior to bbox-build."
        echo "  -> * Beware *: bbox-clean will also destroy all binaries and config files generated under $BBOX_DEV_DIR".
else
	echo "Development directory set to: $EMBED_DEV_DIR (BusyBox will be cloned under that directory)."
	mk_dev_dir

	cd "$EMBED_DEV_DIR" || (echo "Could not switch to directory $EMBED_DEV_DIR. Aborting." && exit 1)

	echo "Cloning BusyBox Git repo..." && \
	git clone $BBOX_GIT_URL && \
	cd "$BBOX_DEV_DIR" && \
	echo "Checking out version $BBOX_VERSION..." && \
	git checkout "$BBOX_VERSION" && \
	echo "Running make..." && \
	make distclean && \
	make defconfig && \
	make menuconfig && \
	make ARCH="$XTOOLS_ARCH" CROSS_COMPILE="$XTOOLS_PREFIX" && \
	make ARCH="$XTOOLS_ARCH" CROSS_COMPILE="$XTOOLS_PREFIX" install

	assert_ok "BusyBox build failed. Check the output above for the details."
	echo "BusyBox build completed."

	cd_back
fi
