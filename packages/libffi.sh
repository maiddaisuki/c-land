#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build libffi (options as of version 3.4.8)
#
# --enable-portable-binary
#
# --enable-symvers=STYLE
#
# --disable-structs
# --disable-raw-api
# --disable-exec-static-tramp
#
# --with-gcc-arch=CPU
#
## Installation
#
# --disable-multi-os-directory
# --disable-docs
#
## Experemental
#
# --enable-pax_emutramp
#
## Developer Options
#
# --enablt-purify-safity
# --enable-debug
#

libffi_configure() {
	local log_file=${logdir}/configure.log

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
		--disable-multi-os-directory
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

libffi_build() {
	_make_build
}

libffi_check() {
	if ${MAKE_CHECK}; then
		LD_LIBRARY_PATH=${builddir}/.libs _make_check check
	fi
}

libffi_stage() {
	_make_stage
}

libffi_pack() {
	_make_pack
}

libffi_install() {
	_make_install
}

libffi_main() {
	_make_main libffi ${LIBFFI_SRCDIR}
}
