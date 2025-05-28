#!/bin/sh

# BUILD_SYSTEM: make

##
# Build zlib (options as of version 1.3.1)
#
# --static
#
# --const
# --64
#
# --archs
#
## Installation
#
# --prefix=PREFIX
# --eprefix=EXPREFIX
# --libdir=LIBDIR
# --sharedlibdir=LIBDIR
# --includedir=INCLUDEDIR
#
# --zprefix
#

zlib_configure() {
	local log_file=${logdir}/configure.log

	local static=

	if test -z "${dynamic_linker}"; then
		static=--static
	fi

	local configure_options="
		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		${static}
	"

	if test -f ${builddir}/Makefile; then
		make clean distclean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/configure \
		${configure_options} \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

zlib_build() {
	_make_build
}

zlib_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

zlib_stage() {
	_make_stage install
}

zlib_pack() {
	_make_pack
}

zlib_install() {
	_make_install
}

zlib_main() {
	CC="${cc}" CFLAGS="${cppflags} ${cflags}" LDFLAGS="${ldflags}" \
		_make_main zlib ${ZLIB_SRCDIR}
}
