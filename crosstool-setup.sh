#!/bin/bash

source $PWD/common.sh
if [ $? -ne 0 ]; then
        echo "Crosstool-NG installation failed. Could not load environment variables."
fi

echo "Setting development directory to: $EMBED_DEV_DIR (Crosstool-NG will be cloned under that directory)."
if [ ! -f "$EMBED_DEV_DIR" ]; then
	echo "Creating $EMBED_DEV_DIR directory (it does not currently exist)."
	mkdir -p "$EMBED_DEV_DIR"
	assert_ok "Could not make directory: $EMBED_DEV_DIR. Aborting."
fi

cd "$EMBED_DEV_DIR" || (echo "Could not switch to directory $EMBED_DEV_DIR. Aborting." && exit 1)

echo "Installing required packages..."
sudo apt update && \
sudo apt install -y git autoconf gperf bison flex texinfo help2man gawk libtool-bin ncurses-dev && i\
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

echo "Crosstool-NG installation completed under directory: $EMBED_DEV_DIR/crosstool-ng"
echo "Path to executable: $EMBED_DEV_DIR/crosstool-ng/bin/ct-ng"

cd "$OLDPWD" || echo "Could not switch back to $OLDPWD directory. Current directory is: $EMBED_DEV_DIR."

