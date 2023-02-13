#!/bin/bash

source $PWD/common.sh || (echo "Crosstool-NG installation failed. Could not load environment variables." && exit 1)

echo "Development directory set to: $EMBED_DEV_DIR (Crosstool-NG will be cloned under that directory)."
mk_dev_dir

cd "$EMBED_DEV_DIR" || (echo "Could not switch to directory $EMBED_DEV_DIR. Aborting." && exit 1)

echo "Installing required packages..."
sudo apt update && \
sudo apt install -y git autoconf gperf bison flex texinfo help2man gawk libtool-bin ncurses-dev libssl-dev u-boot-tools && \
echo "Cloning Crosstool-NG Git repo..." && \
git clone $CROSSTOOL_GIT_URL && \
cd "$CROSSTOOL_DEV_DIR"/ && \
echo "Checking out version $CROSSTOOL_VERSION..." && \
git checkout crosstool-ng-$CROSSTOOL_VERSION && \
echo "Running bootstrap => configure => make..." && \
./bootstrap && \
./configure --prefix="${PWD}" && \
make && \
make install

assert_ok "Error calling Crosstool-NG's make. Check the output above for the details."

echo "Running Crosstool-NG's menuconfig"
ct-ng "$CROSSTOOL_CONFIG_NAME" && \
ct-ng menuconfig
assert_ok "Error running Crosstool-NG's menuconfig. Check the output above for the details."

if [ "$CROSSTOOL_ZLIB_PATCH" == "true" ]; then
echo "Patching Crosstool-NG: downloading zlib to $CROSSTOOL_DEV_DIR/.build/tarballs"
if ! [ -d "$CROSSTOOL_DEV_DIR/.build/tarballs" ]; then
    mkdir "$CROSSTOOL_DEV_DIR/.build/tarballs"
    assert_ok "Could not create directory: $CROSSTOOL_DEV_DIR/.build/tarballs"
fi
wget -O "$CROSSTOOL_DEV_DIR/.build/tarballs/zlib-$CROSSTOOLS_ZLIB_VERSION.tar.gz"  "https://zlib.net/fossils/zlib-$CROSSTOOL_ZLIB_VERSION.tar.gz"
assert_ok "Could not download zlib $CROSSTOOL_ZLIB_VERSION. Check the output above for the details."

echo "Running ct-ng build"
ct-ng build
assert_ok "Crosstool-NG installation failed. Check the output above for the details."

assert_file_exists "$CROSSTOOL_DEV_DIR"
echo "Crosstool-NG installation completed under directory: $CROSSTOOL_DEV_DIR"
echo "Path to executable: $CROSSTOOL_DEV_DIR/bin/ct-ng"

cd_back
