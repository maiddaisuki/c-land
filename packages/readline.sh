#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf + automake)

##
# Build readline (options as of version 8.2)
#
# --disable-largefile
# --enable-year2038
#
# --enable-multibyte
# --disable-bracketed-paste-default
#
# --with-curses
# --with-shared-termcap-library
#

readline_configure() {
	local log_file=${logdir}/configure.log

	# Dependencies
	local with_termcap=--without-shared-termcap-library

	if test -n "${dynamic_linker}"; then
		with_termcap=--with-shared-termcap-library
	fi

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		${with_static_libs}
		${with_shared_libs}

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--enable-multibyte

		--without-curses
		${with_termcap}
	"

	if test -f ${builddir}/Makefile; then
		make distclean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/configure \
		CC="${CC}" \
		CPPFLAGS="${cppflags}" \
		CFLAGS="${cflags} " \
		CXX="${CXX}" \
		CXXFLAGS="${cxxflags}" \
		AS="${AS}" \
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

readline_build() {
	_make_build
}

readline_check() {
	if ${MAKE_CHECK}; then
		: _make_check
	fi
}

readline_stage() {
	_make_stage install
}

readline_pack() {
	_make_pack
}

readline_install() {
	_make_install
}

readline_main() {
	_make_main readline ${READLINE_SRCDIR}
}
