#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build gdb (options as of version 16.3)
#

## Options used by multiple subdirectories
#
# --enable-ld
# --enable-gold
# --enable-gprofng
# --enable-libctf
#
# --enable-nls
# --enable-plugins
#
# --enable-compressed-debug-sections={all,gas,ld,none}
# --enable-default-compressed-debug-sections={zlib,zstd}
#
## Build
#
# --enable-host-pie
# --enable-host-shared
#
## Installation
#
# --enable-install-libbfd
#
## Dependencies
#
# --with-static-standard-libraries
#
# --with-libiconv-prefix=DIR
# --with-libiconv-type=auto|static|shared
#
# --with-libintl-prefix=DIR
# --with-libintl-type=auto|static|shared
#
# --with-system-zlib
# --with-zstd
#
## Developer Options
#
# --enable-werror
# --enable-werror-always
# --enable-build-warnings
#
# --enable-checking
#

## gdb
#
# --with-pkgversion=VERSION
# --with-bugurl=URL
#
# --enable-targets=TARGETS
#
# --enable-threading
# --enable-source-highlight
#
# --enable-tui
# --enable-gdbtk
#
# --enable-libbacktrace
# --enable-sim
#
# --with-jit-reader-dir=PATH
#
## Dependencies
#
# --with-curses
# --with-tcl
# --with-tk
#
# --with-system-readline
#
# --with-amd-dbgapi
# --with-libunwind-ia64
#
# --with-babeltrace
# --with-libbabeltrace-prefix[=DIR]
# --with-libbabeltrace-type=static|shared|auto
#
# --with-expat
# --with-libexpat-prefix[=DIR]
# --with-libexpat-type=static|shared|auto
#
# --with-intel-pt
# --with-libipt-prefix[=DIR]
# --with-libipt-type=static|shared|auto
#
# --with-lzma
# --with-liblzma-prefix[=DIR]
# --with-liblzma-type=static|shared|auto
#
# --with-x
# --x-includes=DIR
# --x-libraries=DIR
#
# --with-xxhash
# --with-libxxhash-prefix[=DIR]
# --with-libxxhash-type=static|shared|auto
#
# --with-guile[=VERSION|PKG_CONFIG]
#
# --with-python[=FILENAME]
# --with-python-libdir=DIR
#
# --with-iconv-bin=FILENAME
#
## Installation
#
# --with-gdb-datadir=DIR
#
# --with-gdb-system-gdbinit=FILENAME
# --with-gdb-system-gdbinit-dir=DIRNAME
#
# --with-auto-load-dir=DIR
# --with-auto-load-safe-path=LIST
#
# --with-additional-debug-dirs=LIST
#
## Developer Options
#
# --enable-codesign=CERR
#
# --enable-gdb-build-warnings
#
# --enable-profiling
# --enable-ubsan
#
# --enable-unit-tests
#

## gdbserver
#
# --enable-inprocess-agent
#
# --with-libthread_db=FILENAME
#
# --with-ust=DIR
# --with-ust-include=DIR
# --with-ust-lib=DIR
#

## libbacktrace
#
# --with-system-libunwind
#

## libdecnumber
#
# --enable-decimal-float=no|yes|bid|dpd
#

# Also see sim/configure --help

# NOTE: see binutils.sh for options specific to libbfd

gdb_configure() {
	local log_file=${logdir}/configure.log

	# local overrides

	if test -n "${dynamic_linker}" && test ${stage} -gt 1 && ${ENABLE_PIC}; then
		local with_pic="${with_pic} --enable-host-pie"
	fi

	# Options specific to target C Library
	local enable_plugins=--disable-plugins
	local with_static_stdlibs=--with-static-standard-libraries
	local with_newlib=

	if test -n "${dynamic_linker}"; then
		with_static_stdlibs=--without-static-standard-libraries
		enable_plugins=--enable-plugins
	fi

	if test ${libc} = newlib; then
		with_newlib=--with-newlib
	fi

	# Optional Dependencies
	local with_curses='--without-curses --disable-tui'
	local with_debuginfod=--without-debuginfod
	local with_expat=--without-expat
	local with_guile=--without-guile
	local with_libunwind=--without-system-libunwind
	local with_lzma=--without-lzma
	local with_python=--without-python
	local with_readline=--without-system-readline
	local with_tcl=--without-tcl
	local with_tk='--without-tk --disable-gdbtk'
	local with_x=--without-x
	local with_xxhash=--without-xxhash
	local with_zlib=--without-system-zlib
	local with_zstd=--without-zstd

	if ${WITH_NCURSES}; then
		with_curses=--enable-tui
	fi

	if ${WITH_ELFUTILS-false}; then
		with_debuginfod=--with-debuginfod
	fi

	if ${WITH_EXPAT}; then
		with_expat=--with-expat
	fi

	if ${WITH_GUILE2} || ${WITH_GUILE3}; then
		with_guile=--with-guile
	fi

	if ${WITH_LIBUNWIND}; then
		with_libunwind=--with-system-libunwind
	fi

	if ${WITH_LZMA}; then
		with_lzma=--with-lzma
	fi

	if ${WITH_PYTHON}; then
		with_python="--with-python --with-python-libdir=${prefix}/${libdir}"
	fi

	#if ${WITH_READLINE}; then
	with_readline=--with-system-readline
	#fi

	if ${WITH_TCL}; then
		with_tcl=--with-tcl
	fi

	if ${WITH_TK-false}; then
		with_tk='--with-tk --enable-gdbtk'
	fi

	if ${WITH_X11-false}; then
		with_x=--with-x
	fi

	if ${WITH_XXHASH}; then
		with_xxhash=--with-xxhash
	fi

	#if ${WITH_ZLIB}; then
	with_zlib=--with-system-zlib
	#fi

	if ${WITH_ZSTD}; then
		with_zstd=--with-zstd
	fi

	# Options for libctf, bfd, opcodes and libiberty subdirectories
	local bfd_flags="
		--disable-install-libbfd
		--disable-install-libiberty

		--with-mmap
		${with_newlib}
	"

	# This will disable building of Binutils for builds from git
	local disable_binutils="
		--disable-binutils
		--disable-gas
		--disable-gold
		--disable-gprof
		--disable-gprofng
		--disable-ld
	"

	# --build, --host and --target
	local build_host_target=

	if test ${target_triplet} != ${build_triplet}; then
		if test ${stage} -eq 1; then
			build_host_target="
				--build=${build_triplet}
				--host=${build_triplet}
				--target=${target_triplet}
			"
		else
			build_host_target="
				--build=${target_triplet}
				--host=${target_triplet}
				--target=${target_triplet}
			"
		fi
	fi

	local configure_options="
		${build_host_target}
		${disable_binutils}

		--disable-dependency-tracking
		--disable-silent-rules

		--enable-static
		--disable-shared
		${with_pic}
		--disable-rpath

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		${bfd_flags}

		--enable-nls
		${enable_plugins}
		--enable-threading

		--with-iconv-bin=${PREFIX}/bin/iconv

		${with_curses}
		${with_debuginfod}
		${with_expat}
		${with_guile}
		${with_libunwind}
		${with_lzma}
		${with_newlib}
		${with_python}
		${with_readline}
		${with_tcl}
		${with_tk}
		${with_x}
		${with_xxhash}
		${with_zstd}
		${with_zstd}
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
		PKG_CONFIG="${PKG_CONFIG}" \
		${configure_options} \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

gdb_build() {
	_make_build
}

gdb_check() {
	if ${MAKE_CHECK}; then
		if test -d ${srcdir}/.git; then
			_make_check -C gdb check
		else
			_make_check
		fi
	fi
}

gdb_stage() {
	_make_stage
}

gdb_pack_hook() {
	local file

	for file in bfd.info ctf-spec.info sframe-spec.info; do
		rm -f share/info/${file}
	done

	for file in opcodes.mo bfd.mo; do
		find share/locale -name ${file} -exec rm -f \{\} +
	done

	find share/locale -depth -type d -exec rmdir \{\} + >/dev/null 2>&1
}

gdb_pack() {
	_make_pack gdb_pack_hook
}

gdb_install() {
	_make_install
}

gdb_main() {
	_make_main gdb ${GDB_SRCDIR}
}
