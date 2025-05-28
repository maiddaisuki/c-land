#!/bin/sh

##
# Redirect to ${libc}.sh
#

. ${packages_dir}/${libc}.sh

libc_configure() {
	${libc}_configure
}

libc_build() {
	${libc}_build
}

libc_check() {
	${libc}_check
}

libc_stage() {
	${libc}_stage
}

libc_pack() {
	${libc}_pack
}

libc_install() {
	${libc}_install
}

libc_main() {
	${libc}_main
}
