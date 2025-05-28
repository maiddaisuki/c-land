#!/bin/sh

# BUILD_SYSTEM: autotools (autoconf + optional libtool)

##
# Build ncurses (options as of version 6.5)
#

## Libraries
#
# --with-normal
# --with-shared
#
# --with-form-libname=NAME
# --with-panel-libname=NAME
# --with-menu-libname=NAME
#
# --enable-widec
# --disable-lib-suffix
# --with-lib-prefix=XXX
#
# --disable-overwrite
# --without-curses-h
# --with-extra-suffix[=XXX]
#
## Tic and Terminfo
#
# --with-termlib[=XXX]
# --with-ticlib[=XXX]
#
# --disable-tic-depends
#
## Mouse Support
#
# [Linux]
# --with-gpm[=PATH]
#
# [FreeBSD]
# --with-sysmouse
#

## Interface, Compatibility and ABI
#
# --enable-interop
# --enable-opaque-{curses,form,menu,panel}
#
# --enable-reentrant
# --with-pthread
# --enable-weak-symbols
# --with-wrap-prefix=XXX
#
# --enable-const
# --enable-stdnoreturn
#
# --with-versioned-syms[=XXX]
# --enable-fvisibility
#
# --with-abi-altered=NUM
# --with-abi-version=NUM
#
# --with-rel-version=NUM
# --with-shlib-version=XXX
#
## Types
#
# --enable-wattr-macros
#
# --disable-lp64
# --enable-signed-char
#
# --with-bool=TYPE
# --with-ccharw-max=XXX
# --with-chtype=TYPE
# --with-mmask-t=TYPE
# --with-ospeed=TYPE
#
## Extensions
#
# --disable-ext-funcs
# --enable-ext-colors
# --enable-ext-mouse
# --enable-ext-putwin
#
# --enable-sp-funcs
# --disable-tparm-varargs
# --with-tparm-arg[=XXX]
#
# --with-trace
#
## BSD Compatibility
#
# --enable-bsdpad
#

## c++
#
# --without-cxx
# --without-cxx-binding
#
# --with-cxx-shared
# --with-cxx-libname=NAME
#

## Ada
#
# --without-ada
# --disable-gnat-projects
#
# --with-ada-compiler=CMD
# --with-ada-include=DIR
# --with-ada-libname=NAME
# --with-ada-objects=DIR
# --with-ada-sharedlib
#

## pkg-config
#
# --with-pkg-config[=CMD]
# --with-pkg-config-libdir[=DIR]
#
# --enable-pc-files
# --disable-pkg-ldflags
#

## Features
#
# --disable-home-terminfo
# --enable-tcap-names
#
# --disable-root-access
# --disable-root-environ
# --disable-setuid-environ
#
# --disable-hashmap
# --disable-scroll-hints
#
# --enable-colorfgbg
# --enable-no-padding
#
# --disable-assumed-color
# --enable-check-size
# --enable-hard-tabs
# --enable-wgetch-events
#

## Runtime
#
# --without-dlsym
#
# --enable-sigwinch
# --enable-pthreads-eintr
#
# --enable-string-hacks
# --enable-safe-sprintf
#

## termcap and terminfo databases
#
# --enable-mixed-case
# --enable-symlinks
#
# --with-default-terminfo-dir=XXX
# --with-terminfo-dirs=XXX
#
# --disable-database
# --disable-db-install
#
# --with-database=XXX
# --with-caps=XXX
#
# --enable-termcap
# --with-termpath=XXX
#
## Fallback
#
# --with-fallbacks=XXX
#
# --with-infocmp-path[=XXX]
# --with-tic-path[=XXX]
#
## BSD
#
# --enable-getcap
# --enable-getcap-cahce
#
# --with-hashed-db[=XXX]
#

## Build
#
# --without-progs
#
# --disable-echo
# --enable-warnings
#
# --with-libtool[=PATH]
# --with-libtool-opts=XXX
# --disable-libtool-version
# --with-export-syms[=XXX]
#
# --enable-broken_linker
#
# --enable-rpath
# --disable-rpath-hack
# --disable-relink
#
# --with-install-prefix=XXX
#
# --with-strip-program=XXX
# --disable-stripping
#
# --disable-big-core
# --disable-big-strings
#

## Build Tools
#
# --with-build-cc=XXX
# --with-build-cflags=XXX
# --with-build-cpp=XXX
# --with-build-cppflags=XXX
# --with-build-ldflags=XXX
# --with-build-libs=XXX
#

## Manual Pages
#
# --without-manpages
#
# --with-manpage-aliases
# --with-manpage-format=XXX
# --with-manpage-renames=XXX
# --with-manpage-symlinks
# --with-manpage-tbl
#

## ???
#
# --enable-xmc-glitch
# --with-config-suffix=XXX
# --with-rcs-ids
# --with-pcre2
# --with-x11-rgb=FILE
# --with-xterm-kbs=XXX
# --without-xterm-new
#

## Debug/Tests
#
# --with-debug
# --with-profile
#
# --enable-expanded
# --disable-macros
# --enable-assertions
#
# --with-dbmalloc
# --with-dmalloc
#
# --disable-leaks
# --with-valgrind
#
# --without-tests
#

ncurses_configure() {
	local log_file=${logdir}/configure.log

	# Library type
	local with_normal=
	local with_shared=

	# Features
	local with_cxx_shared=--without-cxx-shared
	local with_dlsym=--without-dlsym

	if test -n "${dynamic_linker}"; then
		with_cxx_shared=-with-cxx-shared
		with_dlsym=--with-dlsym
	fi

	case ${with_static_libs} in
	*enable*)
		with_normal=--with-normal
		;;
	*)
		with_normal=--without-normal
		;;
	esac

	case ${with_shared_libs} in
	*enable*)
		with_shared=--with-shared
		;;
	*)
		with_shared=--without-shared
		;;
	esac

	# Optional dependencies
	local with_gpm=--without-gpm

	if ${WITH_GPM}; then
		with_gpm=--with-gpm
	fi

	local configure_options="
		--build=${target_triplet}
		--host=${target_triplet}

		${with_normal}
		${with_shared}

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		--without-debug
		--without-profile

		--enable-overwrite

		--enable-widec
		--disable-lib-suffixes

		--with-termlib
		--with-ticlib

		--enable-interop
		--enable-opaque-curses
		--enable-opaque-form
		--enable-opaque-menu
		--enable-opaque-panel

		--enable-ext-colors
		--enable-ext-mouse

		--enable-wattr-macros
		--enable-sp-funcs

		--enable-check-size
		--enable-sigwinch

		--enable-colorfgbg
		--enable-no-padding

		--disable-root-access
		--disable-root-environ
		--disable-setuid-environ

		--with-terminfo-dirs=${prefix}/share/terminfo:/usr/local/share/terminfo:/usr/share/terminfo

		--with-pkg-config=${PKG_CONFIG}
		--with-pkg-config-libdir=libdir
		--enable-pc-files

		--with-cxx
		${with_cxx_shared}

		--without-ada

		${with_dlsym}
		${with_gpm}
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

ncurses_build() {
	_make_build
}

ncurses_check() {
	if ${MAKE_CHECK}; then
		: _make_check
	fi
}

ncurses_stage() {
	_make_stage install
}

ncurses_pack() {
	_make_pack
}

ncurses_install() {
	_make_install
}

ncurses_main() {
	_make_main ncurses ${NCURSES_SRCDIR}
}
