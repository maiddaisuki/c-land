#!/bin/sh

##
# Install Linux header files
#

linux_headers_configure() {
	cd ${srcdir} || exit
}

linux_headers_build() {
	:
}

linux_headers_check() {
	:
}

linux_headers_stage() {
	local destdir_var=INSTALL_HDR_PATH
	_make_stage headers_install
}

linux_headers_pack() {
	local old_pwd=$(pwd)
	cd ${destdir} || exit

	log "%s: creating %s\n" ${package} ${package_tarx}

	tar -c -f ${package_tar} include &&
		xz -9 ${package_tar} &&
		mv ${package_tarx} -t ${pkgdir}

	test $? -eq 0 || exit
	cd ${old_pwd} || exit

	rm -rf "${destdir}"
}

linux_headers_install() {
	_make_install
}

linux_headers_main() {
	_make_main linux_headers ${LINUX_SRCDIR}
}
