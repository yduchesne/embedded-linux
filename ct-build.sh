#!/bin/bash

source $PWD/common.sh || (echo "Crosstool-NG installation failed. Could not load environment variables." && exit 1)

echo "Development directory set to: $EMBED_DEV_DIR (Crosstool-NG will be cloned under that directory)."
mk_dev_dir

cd "$EMBED_DEV_DIR" || (echo "Could not switch to directory $EMBED_DEV_DIR. Aborting." && exit 1)

echo "Installing required packages..."
sudo apt update && \
sudo apt install -y git autoconf gperf bison flex texinfo help2man gawk libtool-bin ncurses-dev libssl-dev && i\
echo "Cloning Crosstool-NG Git repo..." && \
git clone $CROSSTOOL_GIT_URL && \
cd crosstool-ng/ && \
echo "Checking out version $CROSSTOOL_VERSION..." && \
git checkout crosstool-ng-$CROSSTOOL_VERSION && \
echo "Running bootstrap => configure => make..." && \
./bootstrap && \
./configure --prefix="${PWD}" && \
make && \
make install

assert_ok "Crosstool-NG installation failed. Check the output above for the details."
assert_file_exists "$CROSSTOOL_DEV_DIR"
echo "Crosstool-NG installation completed under directory: $CROSSTOOL_DEV_DIR"
echo "Path to executable: $CROSSTOOL_DEV_DIR/bin/ct-ng"

cd "$OLDPWD" || echo "Could not switch back to $OLDPWD directory. Current directory is: $EMBED_DEV_DIR."

