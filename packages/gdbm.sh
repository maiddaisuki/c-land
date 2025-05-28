#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build gdbm (options as of version 1.25)
#
# --disable-largefile
#
# --disable-nls
# --enable-memory-mapped-io
#
# --enable-crash-tolerance
#
# --enable-libgdbm-compat
#
## Dependencies
#
# --with-libiconv-prefix[=DIR]
# --with-libintl-prefix[=DIR]
# --without-readline
#
## Developer Options
#
# --enable-debug
# --enable-gdbmtool-debug
#

gdbm_configure() {
	local log_file=${logdir}/configure.log

	local with_readline=--without-readline

	if ${WITH_READLINE}; then
		with_readline=--with-readline
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

		--enable-libgdbm-compat

		--enable-nls
		--enable-memory-mapped-io

		${with_readline}
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

gdbm_build() {
	_make_build
}

gdbm_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

gdbm_stage() {
	_make_stage
}

gdbm_pack() {
	_make_pack
}

gdbm_install() {
	_make_install
}

gdbm_main() {
	_make_main gdbm ${GDBM_SRCDIR}
}
