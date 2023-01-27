#!/bin/bash

EMBED_DEV_DIR=~/embedded-linux-tools
CROSS_TOOL_VERSION="1.25.0"

if [ $1 != "" ]; then
	EMBED_DEV_DIR="$1"
fi
echo "Setting development directory to: $EMBED_DEV_DIR (Crosstool-NG will be cloned under that directory)."
if [ ! -f $EMBED_DEV_DIR ]; then
	echo "Creating $EMBED_DEV_DIR directory (it does not currently exist)."
	mkdir -p $EMBED_DEV_DIR
	if [ $? -ne 0 ]; then
		echo "Could not make directory: $EMBED_DEV_DIR. Aborting."
		exit 1
	fi
fi

cd $EMBED_DEV_DIR

function install_crosstool()
{
	echo "Installing required packages..."
	sudo apt update && \
	sudo apt install -y git autoconf gperf bison flex texinfo help2man gawk libtool-bin ncurses-dev && \
	echo "Cloning Crosstool-NG Git repo..." && \
	git clone https://github.com/crosstool-ng/crosstool-ng.git && \
	cd crosstool-ng/ && \
	echo "Checking out version $CROSS_TOOL_VERSON..." && \
	git checkout crosstool-ng-$CROSS_TOOL_VERSION && \
	echo "Running bootstrap => configure => make..." && \
	./bootstrap && \
	./configure --prefix=${PWD} && \
	make && \
	make install
	return $?
}

install_crosstool
if [ $? -eq 0 ]; then
	echo "Crosstool-NG installation completed under directory: $EMBED_DEV_DIR."
	echo "Path to executable: $EMBED_DEV_DIR/bin/ct-ng"
else
	echo "Crosstool-NG installation failed. Check the output above for the details."
fi
cd $OLDPWD

