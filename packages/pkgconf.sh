#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build pkgconf (options as of version 2.3.10)
#
# --with-personality-dir=PATH
# --with-pkg-config-dir=PATH
#
# --with-system-libdir=PATH
# --with-system-includedir=PATH
#

pkgconf_configure() {
	local log_file=${logdir}/configure.log

	# Default search path
	local with_libdir=${prefix}/${arch_libdir}:${prefix}/lib:${prefix}/share

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

		--with-system-libdir=${with_libdir}
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

pkgconf_build() {
	_make_build
}

pkgconf_check() {
	if ${MAKE_CHECK}; then
		if type kyua >/dev/null 2>&1; then
			_make_check
		else
			note "${package}: testsuite: cannot run - kyua is not installed"
			touch ${check_stamp}
		fi
	fi
}

pkgconf_stage() {
	_make_stage
}

pkgconf_pack() {
	_make_pack
}

pkgconf_install() {
	_make_install
}

pkgconf_main() {
	_make_main pkgconf ${PKGCONF_SRCDIR}
}
