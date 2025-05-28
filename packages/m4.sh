#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build m4 (options as of version 1.4.20)
#
# --with-packager=TEXT
# --with-packager-version=VERSIONS
# --with-packager-bug-reports=URL
#
# --enable-cross-guesses={conservative|risky}
# --disable-largefile
# --enable-year2038
# --enable-threads={isoc|posix|iosc+posix|windows}
#
# --enable-c++
#
# --enable-nsl
# --enable-changeword
#
# --with-syscmd-shell=FILENAME
#
# --with-dmalloc
#
## Dependencies
#
# --without-included-regex
#
# --with-libiconv-prefix[=DIR]
# --with-libintl-prefix[=DIR]
#
# --with-libsigsegv
# --with-libsigsegv-prefix[=DIR]
#
# --with-gnulib-prefix=DIR
#
## Developer Options
#
# --enable-gcc-warnings
# --disable-assert
#

m4_configure() {
	local log_file=${logdir}/configure.log

	local cppflags=$(strip_args "${cppflags}" '-D_FORTIFY_SOURCE*')
	local cflags=$(strip_args "${cflags}" '-D_FORTIFY_SOURCE*')
	local cxxflags=$(strip_args "${cxxflags}" '-D_FORTIFY_SOURCE*')

	# Dependencies
	local with_libsigsegv=--without-libsigsegv

	if ${WITH_LIBSIGSEGV}; then
		with_libsigsegv="--with-libsigsegv --with-libsigsegv-prefix=${prefix}"
	fi

	# Features
	local shell=/bin/sh

	if ${WITH_BASH}; then
		shell=${PREFIX}/bin/bash
	fi

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		--disable-dependency-tracking
		--disable-silent-rules

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}
		--disable-rpath

		--enable-nls
		--enable-c++
		--enable-threads=posix

		--disable-changeword
		--disable-assert

		${with_libsigsegv}
		--with-syscmd-shell=${shell}
	"

	if test -f ${builddir}/Makefile; then
		make distclean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/configure \
		CC="${cc}" \
		CPPFLAGS="${cppflags}" \
		CFLAGS="${cflags}" \
		CXX="${cxx}" \
		CXXFLAGS="${cxxflags}" \
		AS="${as}" \
		ASFLAGS="${ASFLAGS}" \
		LD="${LD}" \
		LDFLAGS="${ldflags}" \
		AR="${AR}" \
		RANLIB="${RANLIB}" \
		NM="${NM}" \
		OBJDUMP="${OBJDUMP}" \
		OBJCOPY="${OBJCOPY}" \
		STRIP="${STRIP}" \
		${configure_options} \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

m4_build() {
	_make_build
}

m4_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

m4_stage() {
	_make_stage
}

m4_pack() {
	_make_pack
}

m4_install() {
	_make_install
}

m4_main() {
	_make_main m4 ${M4_SRCDIR}
}
