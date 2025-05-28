#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build guile3 (options as of version 3.0.10)
#
# --enable-cross-guesses=conservative|risky
#
# --enable-year2038
# --disable-largefile
#
# --with-threads
# --with-modules=FILES
# --without-64-calls
#
# --disable-nls
# --enable-jit=yes/no/auto
#
# --disable-posix
# --disable-networking
# --disable-regex
# --disable-tmpnam
# --disable-deprecated
#
## Dependencies
#
# --enable-mini-gmp
#
# --with-libiconv-prefix[=DIR]
# --with-libintl-prefix[=DIR]
# --with-libgmp-prefix[=DIR]
# --with-libreadline-prefix[=DIR]
# --with-libunistring-prefix[=DIR]
#
# --with-bdw-gc=PKG
#
# --without-included-regex
#
## Build
#
# --enable-ld-version-script
# --enable-lto
#
## Installation
#
# --with-pkgconfigdir
# --with-lispdir
#
## Developer Options
#
# --enable-error-on-warning
#
# --enable-guile-debug
# --enable-debug-malloc
#

guile3_configure() {
	local log_file=${logdir}/configure.log

	local enable_lto=--disable-lto

	if test -n "${dynamic_linker}"; then
		enable_lto=--enable-lto
	fi

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		--disable-dependency-tracking
		--disable-silent-rules

		${with_static_libs}
		${with_shared_libs}
		${with_pic}
		--disable-rpath

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--enable-nls
		${enable_lto}

		--with-threads
	"

	if test -f ${builddir}/Makefile; then
		rm -f ${logdir}/*
		make distclean >/dev/null 2>&1
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/configure \
		CC="${cc}" \
		CPPFLAGS="${cppflags}" \
		CFLAGS="${cflags} -Wno-error=incompatible-pointer-types" \
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
		PKG_CONFIG="${PKG_CONFIG}" \
		EMACS=false \
		${configure_options} \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

guile3_build() {
	_make_build
}

guile3_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

guile3_stage() {
	_make_stage
}

guile3_pack() {
	_make_pack
}

guile3_install() {
	_make_install
}

guile3_main() {
	_make_main guile3 ${GUILE3_SRCDIR}
}
