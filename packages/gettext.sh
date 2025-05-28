#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build gettext (options os of version 0.24.1)
#
# --enable-cross-guesses={conservative|risky}
# --enable-relocatable
#
# --disable-largefile
# --enable-year2038
#
# --enable-threads=posix|isoc|posix+isoc|windows
#
# --disable-java
# --disable-csharp
# --disable-c++
#
# --enable-nls
#
# --disable-curses
# --disable-openmp
# --disable-acl
# --disable-xattr
#
## Dependencies
#
# --with-included-gettext
# --with-included-libunistring
# --with-included-libxml
# --without-included-regex
#
# --with-installed-libtextstyle
#
# --with-libiconv-prefix[=DIR]
# --with-libintl-prefix[=DIR]
# --with-libunistring-prefix[=DIR]
# --with-libtermcap-prefix[=DIR]
# --with-libncurses-prefix[=DIR]
# --with-libxcurses-prefix[=DIR]
# --with-libcurses-prefix[=DIR]
# --with-libtextstyle-prefix[=DIR]
# --with-libxml2-prefix[=DIR]
#
# --without-libsmack (TODO?)
#
# --with-installed-csharp-dll
#
# --with-bison-prefix=DIR
# --with-gnulib-prefix=DIR
#
# --without-emacs
# --with-lispdir=DIR
#
# --without-git
# --with-cvs
#
# --without-bzip2
# --without-xz
#
## Developer Options
#
# --enable-more-warnings
#

gettext_configure() {
	local log_file=${logdir}/configure.log

	local with_compress=

	if ${WITH_LZMA}; then
		with_compress=--with-xz
	elif ${WITH_BZIP2}; then
		with_compress=--with-bzip2
	fi

	# Dependencies
	local enable_curses=--disable-curses
	local enable_libasprintf=--disable-libasprintf
	local with_libunistring=--with-included-libunistring
	local with_libxml2=--with-included-libxml

	if ${WITH_NCURSES}; then
		enable_curses=--enable-curses
	fi

	if ${WITH_LIBASPRINTF}; then
		enable_libasprintf=--enable-libasprintf
	fi

	if ${WITH_LIBXML2}; then
		with_libxml2=--without-included-libxml
	fi

	if ${WITH_LIBUNISTRING}; then
		with_libunistring=--without-included-libunistring
	fi

	# TODO
	local with_emacs=--without-emacs

	# if ${WITH_EMACS-false}; then
	# 	with_emacs=--with-emacs
	# fi

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

		--enable-c++
		--disable-csharp
		--disable-java

		${enable_libasprintf}
		${enable_curses}

		--enable-nls
		--enable-threads=posix

		--with-installed-libtextstyle
		${with_emacs}
		${with_libunistring}
		${with_libxml2}

		${with_compress}
	"

	if test -f ${builddir}/Makefile; then
		make distclean >/dev/null 2>&1
		rm -f ${logdir}/*
	fi

	log "%s: configuring\n" ${package}

	${srcdir}/gettext-tools/configure \
		-C \
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

gettext_build() {
	_make_build
}

gettext_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

gettext_stage() {
	_make_stage
}

gettext_pack() {
	_make_pack
}

gettext_install() {
	_make_install
}

gettext_main() {
	_make_main gettext ${GETTEXT_SRCDIR} gettext/gettext-tools
}
