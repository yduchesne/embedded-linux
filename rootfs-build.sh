#!/bin/bash

source "$PWD/common.sh" || (echo "RootFS build failed. Could not load environment variables and common functions." && exit 1)

echo "Work directory set to: $EMBED_DEV_DIR."
mk_dir "$ROOTFS_DEV_DIR"

echo "Creating RootFS directory hierarchy"
subdirs=("bin" "dev" "etc" "home" "lib" "proc" "sbin" "sys" "tmp" "usr" "usr/bin" "usr/lib" "usr/sbin" "var" "var/log" )
for subdir in "${subdirs[@]}"
do
   mk_dir "$ROOTFS_DEV_DIR/$subdir"
done

echo "Triggering BusyBox build"
"$PWD/bbox-build.sh"

echo "Copying libraries from $XTOOLS_SYSROOT_DIR/lib to $ROOTFS_DEV_DIR/lib"
cp $XTOOLS_SYSROOT_DIR/lib/*.so* "$ROOTFS_DEV_DIR/lib"

echo "Creating dev/null and dev/console under $ROOTFS_DEV_DIR"
cd "$ROOTFS_DEV_DIR" || (echo "Could not switch to directory $ROOTFS_DEV_DIR. Aborting." && exit 1)

if ! [ -e dev/null ]; then
	sudo mknod -m 666 dev/null c 1 3
	assert_ok "Could not create dev/null under $ROOT_FS_DEV_DIR. Aborting."
else
	echo "  dev/null already exists under $ROOTFS_DEV_DIR. Skipping"
fi

if ! [ -e dev/console ]; then
        sudo mknod -m 600 dev/console c 5 1
        assert_ok "Could not create dev/console under $ROOT_FS_DEV_DIR. Aborting."
else
        echo "  dev/console already exists under $ROOTFS_DEV_DIR. Skipping."
fi

echo "Mounting proc and sysfs under $ROOTFS_DEV_DIR"
if ! [ -e "$ROOTFS_DEV_DIR/proc" ]; then
        sudo mount -t proc proc /proc
	assert_ok "Could not mount proc under $ROOT_FS_DEV_DIR. Aborting."
else 
        echo "  proc already exists under $ROOTFS_DEV_DIR. Skipping."
fi

if ! [ -e "$ROOTFS_DEV_DIR/sys" ]; then
        sudo mount -t sysfs sysfs /sys
	assert_ok "Could not mount sys under $ROOT_FS_DEV_DIR. Aborting."
else 
        echo "  sys already exists under $ROOTFS_DEV_DIR. Skipping."
fi

echo "Finished creating RootFS under $ROOTFS_DEV_DIR"

cd "$OLDPWD" || echo "Could not switch back to $OLDPWD directory. Current directory is: $EMBED_DEV_DIR."