#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf)

##
# Build glibc (options are as of version 2.41)
#
# --disable-sanity-checks
#
# --with-pkgversion=PKG
# --with-bugurl=URL
#
## Features
#
# --enable-shared
# --enable-static-nss
#
# --enable-mathvec
# --enable-profile
#
# --disable-hidden-plt
#
# --disable-build-nscd
# --disable-nscd
#
# --disable-timezone-tools
#
## Build Options
#
# --disable-werror
#
# --disable-default-pie
# --enable-bind-now
#
# --enable-stack-protector=[yes|no|all|strong]
# --enable-fortify-source[=1|2|3]
#
# --with-nonshared-cflags=CFLAGS
# --with-rtld-early-cflags=CFLAGS
#
# --with-binutils=PATH
# --with-headers=PATH
#
# --without-selinux
#
## System-specific
#
# --with-cpu=CPU
#
# --enable-memory-tagging
# --enable-multi-arch
#
# [Linux]
#
# --enable-kernel=VERSION
#
# [x86]
#
# --enable-cet[=permissive]
#
# [powerpc]
#
# --disable-scv
#
# [Hurd]
#
# --enable-pt_chown
#
## Installation
#
# --disable-force-install
#
# --with-man-pages=VERSION
#
## Tests
#
# --enable-hardcoded-path-in-tests
#
# --disable-static-c++-tests
# --disable-static-c++-link-check
#
# --with-timeoutfactor=NUM
#
## Other
#
# --enable-systemtap
#
# --with-gd=DIR
# --with-gd-include=DIR
# --with-gd-lib=DIR
#

glibc_configure() {
	local log_file=${logdir}/configure.log

	# local overrides

	local CPPFLAGS=$(strip_args "${CPPFLAGS}" '-D_FORTIFY_SOURCE*')
	local CFLAGS=$(strip_args "${CFLAGS}" '-f*lto' '-f*fat-lto-objects' '-f*stack-protector*' '-f*cf-protection' '-D_FORTIFY_SOURCE*')
	local CXXFLAGS=$(strip_args "${CXXFLAGS}" '-f*lto' '-f*fat-lto-objects' '-f*stack-protector*' '-f*cf-protection' '-D_FORTIFY_SOURCE*')

	# build options
	local enable_bind_now=
	local enable_cet=
	local enable_pie=--disable-default-pie
	local enable_werror=

	if ${ENABLE_BIND_NOW}; then
		enable_bind_now=--enable-bind-now
	fi

	if ${ENABLE_CET}; then
		enable_cet=--enable-cet
	fi

	if ${ENABLE_PIC}; then
		enable_pie=--enable-default-pie
	fi

	if ${MAKE_CHECK_LIBC}; then
		enable_werror=--disable-werror
	fi

	# features
	local enable_kernel=
	local enable_profile=--disable-profile

	if test -n "${glibc_kernel-}"; then
		enable_kernel="--enable-kernel=${glibc_kernel}"
	fi

	if test ${stage} -gt 1 && ${glibc_profile-false}; then
		enable_profile=--enable-profile
	fi

	local configure_options="
		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--enable-shared
		${enable_kernel}

		${enable_werror}
		${enable_profile}

		--with-headers=${prefix}/include
		--without-selinux

		--disable-timezone-tools
	"

	if test ${stage} -gt 1; then
		local fortify=

		if ${glibc_fortify-false}; then
			fortify='--enable-fortify-source --enable-stack-protector'
		fi

		configure_options="
			${configure_options}

			${enable_bind_now}
			${enable_pie}

			${enable_cet}
			${fortify}
		"
	fi

	if test -f ${builddir}/Makefile; then
		rm -f ${logdir}/*
		make distclean >/dev/null 2>&1
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/configure \
		CC="${cc}" \
		CPPFLAGS="${CPPFLAGS}" \
		CFLAGS="${CFLAGS}" \
		CXX="${cxx}" \
		CXXFLAGS="${CXXFLAGS}" \
		AS="${as}" \
		ASFLAGS="${ASFLAGS}" \
		LD="${LD}" \
		LDFLAGS= \
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

glibc_build() {
	_make_build
}

glibc_check() {
	if test ${stage} -gt 1 && ${MAKE_CHECK_LIBC}; then
		_make_check check
	fi
}

glibc_stage() {
	if test ${stage} -eq 1; then
		_make_stage install
	else
		# _make_stage install localedata/install-locales
		_make_stage install localedata/install-locale-files
	fi
}

glibc_pack_hook() {
	test -d etc || install -d etc || exit

	# link dynamic linker into expected directory
	# this is required for `ldd` to function properly

	if ${is_64bit}; then
		test -d lib64 || install -d lib64 || exit
		if test -f lib/${dynamic_linker}; then
			(cd lib64 && ln -s ../lib/${dynamic_linker} .) || exit
		fi
	elif ${is_x32bit}; then
		test -d libx32 || install -d libx32 || exit
		if test -f lib/${dynamic_linker}; then
			(cd libx32 && ln -s ../lib/${dynamic_linker} .) || exit
		fi
	else
		test -d lib32 || install -d lib32 || exit
	fi

	# strip PREFIX from library names in libc.so, libm.so and libm.a
	# they are linker scripts containing absolute filenames of real libraries

	local libdir lib

	for libdir in lib ${arch_libdir}; do
		if test -d ${libdir}; then
			for lib in libc.so libm.so libm.a; do
				if test -f ${libdir}/${lib}; then
					sed -i "s|${prefix}||g" ${libdir}/${lib}
				fi
			done
		fi
	done
}

glibc_pack() {
	_make_pack glibc_pack_hook
}

glibc_install() {
	_make_install
}

glibc_main() {
	_make_main libc ${GLIBC_SRCDIR}
}
