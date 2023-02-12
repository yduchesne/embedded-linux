#!/bin/bash

source $PWD/common.sh || (echo "Kernel build  failed. Could not load environment variables and common functions." && exit 1)

echo "Work directory set to: $EMBED_DEV_DIR (Kernel sources and artifacts will be downloaded/built under $KERNEL_DEV_DIR)."
mk_dev_dir
if ! [ -d "$KERNEL_DEV_DIR" ]; then
	mkdir "$KERNEL_DEV_DIR" || (echo "Could create directory: $KERNEL_DEV_DIR. Aborting." && exit 1)
fi

if ! [ -d "$KERNEL_SRC_DIR" ]; then

	echo "Downloading Kernel sources from: $KERNEL_DOWNLOAD_URL"
	wget "$KERNEL_DOWNLOAD_URL" -O "$KERNEL_DEV_DIR/$KERNEL_ARCHIVE_NAME" 
	assert_ok "Kernel build failed (error downloading kernel source archive). Check the output above for the details."
	echo "Finished downloading kernel source archive to $KERNEL_DEV_DIR/$KERNEL_ARCHIVE_NAME. Extracting sources (this may take a while)..." 

	tar --directory="$KERNEL_DEV_DIR" -xf "$KERNEL_DEV_DIR/$KERNEL_ARCHIVE_NAME"
	assert_ok "Could not extract kernel sources under: $KERNEL_SRC_DIR"
	assert_file_exists "$KERNEL_SRC_DIR"
else
	echo "Kernel sources already present under $KERNEL_SRC_DIR. Skipping download."
	echo "  -> If you want to download from scratch, invoke the kernel-clean command prior to kernel-build."
	echo "  -> * Beware *: kernel-clean will also destroy all binaries and config files  generated under $KERNEL_DEV_DIR".   
fi

echo "Building kernel (this will take some time)..."

cd "$KERNEL_SRC_DIR" || (echo "Could not switch to directory $KERNEL_SRC_DIR. Aborting." && exit 1)

echo "  1) make mrpoper"
make ARCH=$XTOOLS_ARCH CROSS_COMPILE="$XTOOLS_PREFIX" mrproper && \
echo "  2) make $XTOOLS_DEF_CONFIG" && \
make ARCH=$XTOOLS_ARCH $XTOOLS_DEF_CONFIG && \
echo "  3) make zImage" && \
make -j4 ARCH=$XTOOLS_ARCH CROSS_COMPILE="$XTOOLS_PREFIX" zImage && \
echo "  4) make modules" && \
make -j4 ARCH=$XTOOLS_ARCH CROSS_COMPILE="$XTOOLS_PREFIX" modules && \
echo "  5) make dtbs" && \
make ARCH=$XTOOLS_ARCH CROSS_COMPILE="$XTOOLS_PREFIX" dtbs

assert_ok "Error buiding kernel. Check the output above for the details."

echo "Finished building kernel under $KERNEL_SRC_DIR"

cd "$OLDPWD" || echo "Could not switch back to $OLDPWD directory. Current directory is: $EMBED_DEV_DIR."

