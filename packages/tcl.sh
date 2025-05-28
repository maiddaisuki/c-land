#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf)

##
# Build tcl (options as of versiob 8.6.15)
#
# --enable-shared
#
# --enable-load
# --enable-dll-unloading
#
# --enable-threads
# --enable-langinfo
#
# --enable-64bit
# --enable-64bit-vis
#
# --with-tzdata
#
## Installation
#
# --enable-man-symlinks
# --enable-man-compression=PROG
# --enable-man-suffix=SUFFIX
#
## Developer Options
#
# --enable-symbols
# --enable-dtrace
#

tcl_configure() {
	local log_file=${logdir}/configure.log

	# Features
	local dynamic_loading='--disable-load --disable-dll-unloading'

	if test -n "${dynamic_linker}"; then
		dynamic_loading='--enable-load --enable-dll-unloading'
	fi

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		${with_shared_libs}

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--enable-threads
		--enable-langinfo

		${dynamic_loading}
	"

	if test -f ${builddir}/Makefile; then
		make distclean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/unix/configure \
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

tcl_build() {
	_make_build binaries libraries doc
}

tcl_check() {
	if ${MAKE_CHECK}; then
		_make_check test-tcl
	fi
}

tcl_stage() {
	_make_stage install-binaries install-libraries install-msgs install-doc install-headers
}

tcl_pack() {
	_make_pack
}

tcl_install() {
	_make_install
}

tcl_main() {
	_make_main tcl ${TCL_SRCDIR}
}
