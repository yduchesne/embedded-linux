#!/bin/bash


function rootfs_create_initramfs()

{
    assert_file_exists "$ROOTFS_DEV_DIR"
    mk_dir "$ARTIFACTS_DIR"
    
    cd "$ROOTFS_DEV_DIR" && \
    find . | cpio -H newc -ov --owner root:root > "$ARTIFACTS_DIR/initramfs.cpio"
    assert_ok "Could not create initramfs.cpio. Aborting."
    
    cd "$ARTIFACTS_DIR" && \
    gzip initramfs.cpio && \
    mkimage -A arm -O linux -T ramdisk -d initramfs.cpio.gz uRamdisk
    assert_ok "Could not compress initramfs.cpio. Aborting."
    
    cd_back
}

function rootfs_build()
{
    WORK_DIR="$WORK_DIR" "$WORK_DIR/rootfs/rootfs-build.sh"
}

function rootfs_clean()
{
    # Not reusing clean_dir function as sudo is required
    # to clean rootfs dir (whose owner is set as root by
    # the build).
    if [ -d "$ROOTFS_DEV_DIR" ]; then
        sudo rm -Rf "$ROOTFS_DEV_DIR"
        assert_ok "Could not clean directory: $ROOTFS_DEV_DIR"
        echo "Cleaned directory: $ROOTFS_DEV_DIR"
    fi
}


function rootfs_help()
{
    echo "RootFS"
    echo "------"
    echo "rootfs-build...: Builds the root file system under $ROOTFS_DEV_DIR."
    echo "                 Note: this command triggers the BusyBox build, if needed."
    echo "                       BusyBox can also be built separately (see bbox-build command)."
    echo "rootfs-clean...: Deletes the $ROOTFS_DEV_DIR directory"
    echo "                 and sub-directories."
}