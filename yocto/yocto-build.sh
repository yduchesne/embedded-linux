#!/bin/bash

source $WORK_DIR/common.sh || (echo "Yocto build  failed. Could not load environment variables and common functions." && exit 1)

# Installing required packages

sudo apt install gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm python3-subunit mesa-common-dev zstd liblz4-tool
assert_ok "Could not installed required Yocto packages. Aborting."

if ! [ -d "$YOCTO_CLONE_DIR" ]; then 
    echo "Cloning Yockto Repo to $YOCTO_DEV_DIR" && \
    cd "$YOCTO_DEV_DIR" && \
    git clone "$YOCTO_GIT_URL" && \
    cd "$YOCTO_CLONE_DIR" && \
    git switch "$YOCTO_GIT_BRANCH"
    assert_ok "Could not clone Yocto repository."
else
    echo "Yocto repository already cloned: bypassing this step (if want to clone from scratch, run '$0 yocto-clean' first)."
fi

if ! [ -d "$YOCTO_OPEN_EMBED_DEV_DIR" ]; then 
    echo "Cloning OpenEmbedded meta repo to $YOCTO_OPEN_EMBED_DEV_DIR" && \
    cd "$YOCTO_OPEN_EMBED_DEV_DIR" && \
    git clone "$YOCTO_OPEN_EMBED_GIT_URL" && \
    cd "$YOCTO_OPEN_EMBED_DEV_DIR" && \
    git switch "$YOCTO_GIT_BRANCH"
    assert_ok "Could not clone Yocto repository."
else
    echo "Yocto repository already cloned: bypassing this step (if want to clone from scratch, run '$0 yocto-clean' first)."
fi


cd "$YOCTO_CLONE_DIR"

if ! [ -d "$YOKTO_BUILD_DIR" ]; then
	source oe-init-build-env
	assert_file_exists "$YOCTO_BUILD_DIR" "Directory not created as expected: $YOCTO_BUILD_DIR. Aborting."
fi



cd_back


