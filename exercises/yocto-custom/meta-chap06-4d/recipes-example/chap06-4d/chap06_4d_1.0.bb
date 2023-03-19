
#
# This file was derived from the 'Hello World!' example recipe in the
# Yocto Project Development Manual.
#

DESCRIPTION = "Chap 06, 4d"
SECTION = "examples"
DEPENDS = ""
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9907583fc01fd91571cecf0cdeaca89e"

FILESEXTRAPATHS_prepend := “${THISDIR}/src:”

SRC_URI = "file://ex1.c"

S = "${WORKDIR}"

do_compile() {
    ${CC} ${CFLAGS} ${LDFLAGS} ${WORKDIR}/ex1.c -o chap06_4d_ex1
}

do_install() {
    # create the /usr/bin folder in the rootfs with default permissions
    install -d ${D}${bindir}

    # install the application into the /usr/bin folder with default permissions
    install -m 0755 ${WORKDIR}/chap06_4d_ex1 ${D}${bindir}
}