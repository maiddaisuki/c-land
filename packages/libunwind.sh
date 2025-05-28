#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build libunwind (options as of version 1.6.2)
#
# --enable-cxx-exceptions
#
# --enable-coredump
# --enable-ptrace
# --enable-setjmp
#
# --disable-weak-backtrace
# --disable-unwind-header
#
# --enable-debug-frame
# --enable-per-thread-cache
#
# --enable-block-signals
# --enable-conservative-checks
#
# --enable-minidebuginfo
# --enable-zlibdebuginfo
#
## Build
#
# --disable-tests
# --enable-debug
#
## Installation
#
# --disable-documentation
#

libunwind_configure() {
	local log_file=${logdir}/configure.log

	local with_lzma=--disable-minidebuginfo
	local with_zlib=--disable-zlibdebuginfo

	if test ${stage} -gt 2; then
		if ${WITH_LZMA}; then
			with_lzma=-enable-minidebuginfo
		fi

		if ${WITH_ZLIB}; then
			with_zlib=--enable-zlibdebuginfo
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
		--disable-rpath

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--enable-cxx-exceptions

		--enable-coredump
		--enable-ptrace
		--enable-setjmp

		${with_lzma}
		${with_zlib}
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

libunwind_build() {
	_make_build -C src
}

libunwind_check() {
	if ${MAKE_CHECK}; then
		_make_check check LDFLAGS="${ldflags} -Wl,-rpath-link=\$(top_builddir)/src/.libs"
	fi
}

libunwind_stage() {
	_make_stage install-strip LDFLAGS="${ldflags} -Wl,-rpath-link=\$(top_builddir)/src/.libs"
}

libunwind_pack() {
	_make_pack
}

libunwind_install() {
	_make_install
}

libunwind_main() {
	_make_main libunwind ${LIBUNWIND_SRCDIR}
}
