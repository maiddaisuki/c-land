#!/bin/sh

# BUILD_SYSTEM: autosetup (moved from autotools)

##
# Build sqlite3 (options as of version 3.49.2)
#
# Sqlite3 allows to enable or disable large number of features during the
# compilation with preprocessor macros
#
# See https://www.sqlite.org/compile.html for details
#
##
#
# --disable-shared
# --disable-static
#
# --dynlink-tools
#
# --disable-amalgamation
# --linemacros
#
## Features
#
# --disable-largefile
# --disable-threadsafe
# --with-tempstore
# --scanstatus
#
## Extension
#
# --disable-math
# --disable-json
#
# --memsys5
# --memsys3
#
# --fts3
# --fts4
# --fts5
#
# --geopoly
# --rtree
# --session
#
# --all
#
# --disable-load-extension
#
## Dependencies
#
# --disable-tcl
# --with-tcl=DIR
# --with-tclsh=PATH
#
# --disable-readline
# --with-readline-ldflags=
# --with-readline-cflags=
# --with-readline-header=PATH
#
# --editline
#
# --with-linenoise=DIR
#
# --with-icu-ldflags=LDFLAGS
# --with-icu-cflags=CFLAGS
# --with-icu-config=
# --icu-collations
#
# --with-wasi-sdk=
# --with-emsdk=
#
## Build
#
# --soname=none|legacy|VERSION
#
# --dll-basename=libsqlite3|default|BASENAME
# --out-implib[=none]
#
# --test-status
#
## Developer options
#
# --dev
# --debug
# --gcov
# --dump-defines
#

sqlite3_configure() {
	local log_file=${logdir}/configure.log

	# Features
	local dynlink_tools=
	local load_extension=--disable-load-extension

	if test -n "${dynamic_linker}"; then
		dynlink_tools=--dynlink-tools
		load_extension=--enable-load-extension
	fi

	# Optional dependencies
	local readline=--disable-readline

	if ${WITH_READLINE}; then
		readline=--enable-readline
	fi

	local configure_options="
		--host=${target_triplet}
		--build=${target_triplet}

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		${with_static_libs}
		${with_shared_libs}

		${dynlink_tools}
		${load_extension}

		--enable-threadsafe
		--all

		${readline}
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
		NM="${NM}" \
		RANLIB="${RANLIB}" \
		OBJDUMP="${OBJDUMP}" \
		OBJCOPY="${OBJCOPY}" \
		STRIP="${STRIP}" \
		${configure_options} \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

sqlite3_build() {
	_make_build
}

sqlite3_check() {
	if ${MAKE_CHECK}; then
		LD_LIBRARY_PATH=${builddir} _make_check test
	fi
}

sqlite3_stage() {
	_make_stage install
}

sqlite3_pack() {
	_make_pack
}

sqlite3_install() {
	_make_install
}

sqlite3_main() {
	_make_main sqlite3 ${SQLITE3_SRCDIR}
}
