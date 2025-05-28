#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build libxcrypt (options as of version 4.4.38)
#
# --disable-largefile
#
# --disable-symvers
#
# --enable-hashes=all|{list}
#
#	list may contain any of:
#	 - string
#	 - alt
#
#	 - glibc
#	 - fedora
#	 - suse
#
#	 - freebsd
#	 - netbsd
#	 - openbsd
#
#	 - osx
#	 - owl
#	 - solaris
#
# --disable-failure-tokens
#
# --enable-obsolute-api=all|alt|glibc|owl|suse|no
# --enable-obsolete-api-enosys=yes|no
#
## Build
#
# --disable-werror
#
## Installation
#
# --disable-xcrypt-compat-files
#
## Vargrind
#
# --enable-valgrind
# --disable-valgrind-memcheck
# --enable-valgrind-helgrind
# --enable-valgrind-drd
# --enable-valgrind-sgcheck
#

libxcrypt_configure() {
	local log_file=${logdir}/configure.log

	local obsolete_api=--disable-obsolete-api
	local obsolete_api_enosys=--disable-obsolete-api-enosys

	if test -n "${libxcrypt_obsolete_api-}"; then
		obsolete_api="--enable-obsolete-api=${libxcrypt_obsolete_api}"

		if ${libxcrypt_obsolete_api_enosys-false}; then
			obsolete_api_enosys=--enable-obsolete-api-enosys
		fi
	fi

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		--disable-dependency-tracking
		--disable-silent-rules

		${with_static_libs}
		${with_shared_libs}
		${with_pic}

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		${obsolete_api}
		${obsolete_api_enosys}

		--disable-werror
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
		PKG_CONFIG="${PKG_CONFIG}" \
		${configure_options} \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

libxcrypt_build() {
	_make_build
}

libxcrypt_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

libxcrypt_stage() {
	_make_stage
}

libxcrypt_pack() {
	_make_pack
}

libxcrypt_install() {
	_make_install
}

libxcrypt_main() {
	_make_main libxcrypt ${LIBXCRYPT_SRCDIR}
}
