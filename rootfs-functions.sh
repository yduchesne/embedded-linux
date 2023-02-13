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