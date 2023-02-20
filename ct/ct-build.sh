#!/bin/bash

source $WORK_DIR/common.sh || (echo "Crosstool-NG build  failed. Could not load environment variables and common functions." && exit 1)

echo "Development directory set to: $EMBED_DEV_DIR (Crosstool-NG will be cloned under that directory)."
mk_dev_dir

cd "$EMBED_DEV_DIR" || (echo "Could not switch to directory $EMBED_DEV_DIR. Aborting." && exit 1)

if ! [ -f "$CROSSTOOL_DEV_DIR/bin/ct-ng" ]; then
    echo "Installing required packages..."
    sudo apt update && \
    sudo apt install -y git autoconf gperf bison flex texinfo help2man gawk libtool-bin ncurses-dev libssl-dev u-boot-tools libgmp3-dev libmpc-dev && \
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
else
    echo "Crosstool-NG already installed. Type '$0 ct-clean' to force reinstalling."
fi


if ! [ -f "$CROSSTOOL_DEV_DIR/.config" ]; then
    echo "Running Crosstool-NG's menuconfig"
    ct-ng "$CROSSTOOL_CONFIG_NAME" && \
    ct-ng menuconfig
    assert_ok "Error running Crosstool-NG's menuconfig. Check the output above for the details."
else 
    echo "menuconfig has already been run. Bypassing this step."
fi

# Fix for https://github.com/crosstool-ng/crosstool-ng/issues/1337
if [ "$CROSSTOOL_ZLIB_PATCH" == "true" ]; then
    echo "Patching Crosstool-NG: downloading zlib to $HOME/src (where Crosstool-NG downloads source tarballs)."
    if ! [ -d "$HOME/src" ]; then
        mkdir -p "$HOME/src"
        assert_ok "Could not create directory: $HOME/src."
    fi 
    wget -O "$HOME/src/zlib-$CROSSTOOL_ZLIB_VERSION.tar.gz"  "https://zlib.net/fossils/zlib-$CROSSTOOL_ZLIB_VERSION.tar.gz"
    assert_ok "Could not download zlib $CROSSTOOL_ZLIB_VERSION. Check the output above for the details."
fi

echo "Running ct-ng build"
ct-ng build
assert_ok "Crosstool-NG installation failed. Check the output above for the details."

assert_file_exists "$CROSSTOOL_DEV_DIR"
assert_file_exists "$XTOOLS_DIR/$XTOOLS_TARGET_NAME/$XTOOLS_TARGET_NAME/bin" "Crosstool-NG seems to not have cross-compiled the expected binaries under $XTOOLS_DIR/$XTOOLS_TARGET_NAME/$XTOOLS_TARGET_NAME/bin"
echo "Crosstool-NG installation completed under directory: $CROSSTOOL_DEV_DIR"
echo "Path to executable: $CROSSTOOL_DEV_DIR/bin/ct-ng"

cd_back
