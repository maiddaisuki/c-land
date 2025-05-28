#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build libtextstyle (options as of gettext 0.24.1)
#
# --enable-cross-guesses={conservative|risky}
# --disable-namespacing
#
# --disable-largefile
# --enable-year2038
#
# --enable-threads=posix|isoc|posix+isoc|windows
# --disable-curses
#
## Dependencies
#
# --with-included-gettext
# --without-included-regex
#
# --with-libiconv-prefix[=DIR]
# --with-libtermcap-prefix[=DIR]
# --with-libncurses-prefix[=DIR]
# --with-libxcurses-prefix[=DIR]
# --with-libcurses-prefix[=DIR]
#
# --with-gnulib-prefix=DIR
#
## Developer Options
#
# --enable-more-warnings
#

libtextstyle_configure() {
	local log_file=${logdir}/configure.log

	local enable_curses=--disable-curses

	if ${WITH_NCURSES}; then
		enable_curses=--enable-curses
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

		--enable-threads=posix
		${enable_curses}
	"

	if test -f ${builddir}/Makefile; then
		make distclean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/libtextstyle/configure \
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

libtextstyle_build() {
	_make_build
}

libtextstyle_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

libtextstyle_stage() {
	_make_stage
}

libtextstyle_pack() {
	_make_pack
}

libtextstyle_install() {
	_make_install
}

libtextstyle_main() {
	_make_main libtextstyle ${GETTEXT_SRCDIR} gettext/libtextstyle
}
