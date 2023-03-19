
#
# This file was derived from the 'Hello World!' example recipe in the
# Yocto Project Development Manual.
#

DESCRIPTION = "Chap 06"
SECTION = "examples"
DEPENDS = ""
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:" 

SRC_URI += "file://chap06_4d_ex1.c \
           file://chap06_4f_ex1.c"

S = "${WORKDIR}"

do_compile() {
    ${CC} ${CFLAGS} ${LDFLAGS} ${WORKDIR}/chap06_4d_ex1.c -o chap06_4d_ex1
    ${CC} ${CFLAGS} ${LDFLAGS} ${WORKDIR}/chap06_4f_ex1.c -o chap06_4f_ex1
}

do_install() {
    # create the /usr/bin folder in the rootfs with default permissions
    install -d ${D}${bindir}

    # install the application into the /usr/bin folder with default permissions
    install -m 0755 ${WORKDIR}/chap06_4d_ex1 ${D}${bindir}
    install -m 0755 ${WORKDIR}/chap06_4f_ex1 ${D}${bindir}

}