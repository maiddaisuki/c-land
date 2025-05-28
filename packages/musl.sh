#!/bin/sh

# BUILD_SYSTEM: make (custom configure script)

##
# Build musl (options as of version 1.2.5)
#
# --disable-shared
# --disable-static
#
# --with-malloc=mallocng|???
#
## Build
#
# --enable-optimize=LIST
#
# --enable-debug
# --disable-warnings
#
## Installation
#
# --enable-wrapper
#

musl_configure() {
	local log_file=${logdir}/configure.log

	local configure_options="
		--prefix=${prefix}
		--libdir=${prefix}/${libdir}
		--syslibdir=${prefix}/${libdir}

		--disable-wrapper
		--disable-debug
	"

	if test -f ${builddir}/Makefile; then
		make distclean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/configure \
		CC="${cc}" \
		CFLAGS="${CPPFLAGS} ${CFLAGS}" \
		${configure_options} \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

musl_build() {
	_make_build
}

musl_check() {
	if test ${stage} -gt 1 && ${MAKE_CHECK_LIBC}; then
		: _make_check
	fi
}

musl_stage() {
	_make_stage install
}

musl_pack_hook() {
	test -d etc || install -d etc || exit
	test -d lib || install -d lib || exit
	test -d ${arch_libdir} || install -d ${arch_libdir} || exit
}

musl_pack() {
	_make_pack musl_pack_hook
}

musl_install() {
	_make_install
}

musl_main() {
	_make_main libc ${MUSL_SRCDIR}
}
