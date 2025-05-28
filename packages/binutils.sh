#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build binutils (options are as of version 2.44)
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
# --enable-compressed-debug-sections=all|gas|ld|none
# --enable-default-compressed-debug-sections=zlib|zstd
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

## binutils
#
# --disable-default-strings-all
#
# --enable-colored-disassembly
# --enable-deterministic-archives
# --enable-f-for-ifunc-symbols
# --enable-follow-debug-links
#
# --with-debuginfod
# --with-msgpack (TODO?)
#

## gas
#
# --enable-elf-stt-common
# --enable-generate-build-notes
#
# --enable-x86-relax-relocations
# --enable-x86-used-note
#
# --enable-mips-fix-loongson3-llsc
# --enable-default-riscv-attribute
#

## ld
#
# --enable-error-handling-script
#
# --enable-default-hash-style={sysv,gnu,both}
# --disable-initfini-array
#
# --enable-got=target|single|negative|multigot
#
# --enable-new-dtags
# --enable-relro
# --enable-textrel-check=yes|no|warning|error
# --enable-separate-code
# --enable-rosegment
# --enable-mark-plt
# --enable-memory-seal
#
# --enable-{error|warn}-exexstack
# --enable-{error|warn}-rwx-segments
#
# --enable-default-execstack
#
## Sysroot
#
# --with-sysroot=DIR
# --with-lib-path=PATH
#
## Dependencies
#
# --enable-jansson
# --with-xxhash
#

## gold
#
# --enable-targets
# --enable-threads=auto|yes|no
#
## Build
#
# --with-gold-ldflags=FLAGS
# --with-gold-ldadd=LIBS
#

## libctf
#
# --enable-libctf-hash-debugging
#

## bfd
#
# --with-separate-debug-dir=DIR
#
# --enable-secureplt
# --enable-separate-code
#
# --enable-64-bit-bfd
# --enable-64-bit-archives
#
# --with-mmap
#

## opcodes
#
# --enable-cgen-maint=dir
#

## libiberty
#
# --with-newlib
#
# --enable-install-libiberty
#

## gprofng
#
# --disable-gprofng-tools
#
## Dependencies
#
# --with-jdk=PATH
#
## Developer Options
#
# --enable-gprofng-debug
#

binutils_configure() {
	local log_file=${logdir}/configure.log

	if test -n "${dynamic_linker}" && test ${stage} -gt 1 && ${ENABLE_PIC}; then
		local with_pic="${with_pic} --enable-host-pie"
	fi

	# Options specific to target C Library
	local enable_nls=--disable-nls
	local enable_plugins=--disable-plugins
	local with_newlib=

	if test ${stage} -gt 1; then
		enable_nls=--enable-nls

		if test -n "${dynamic_linker}"; then
			enable_plugins=--enable-plugins
		fi

		if test ${libc} = newlib; then
			with_newlib=--with-newlib
		fi
	fi

	# features
	local enable_compressed_debug_sections=--disable-compressed-debug-sections
	local enable_default_compressed_debug_sections=

	# optional libraries to install
	local enable_install_libbfd=--disable-install-libbfd

	# optional dependencies
	local enable_jansson=--disable-jansson
	local with_debuginfod=--without-debuginfod
	local with_xxhash=--without-xxhash
	local with_zlib=--without-system-zlib
	local with_zstd=--without-zstd

	if test ${stage} -gt 1; then
		enable_install_libbfd=--enable-install-libbfd

		if test ${binutils_compressed_debug_sections-none} != none; then
			enable_compressed_debug_sections=${binutils_compressed_debug_sections}

			if test -n ${binutils_default_compressed_debug_sections}; then
				enable_default_compressed_debug_sections=${binutils_default_compressed_debug_sections}
			# prefer zstd if not specified explicitly
			elif ${WITH_ZSTD}; then
				--enable-default-compressed-debug-sections=zstd
			# elif ${WITH_ZLIB}; then
			else
				--enable-default-compressed-debug-sections=zlib
			fi
		fi

		if ${WITH_ELFUTILS-false}; then
			with_debuginfod=--with-debuginfod
		fi

		if ${WITH_JANSSON}; then
			enable_jansson=--enable-jansson
		fi

		if ${WITH_XXHASH}; then
			with_xxhash=--with-xxhash
		fi

		#if ${WITH_ZLIB}; then
		with_zlib='--with-system-zlib --disable-zlib'
		#fi

		if ${WITH_ZSTD}; then
			with_zstd=--with-zstd
		fi
	fi

	# Options for libctf, bfd, opcodes and libiberty subdirectories
	local bfd_flags="
		${enable_install_libbfd}
		--disable-install-libiberty

		--with-mmap
		${with_newlib}
	"

	# Options for binutils subdirectory or common for multiple subdirs
	local binutils_flags="
		${enable_compressed_debug_sections}
		${enable_default_compressed_debug_sections}

		--enable-follow-debug-links
	"

	# Options for gas subdirectory
	local gas_flags="
	"

	# Options for ld subdirectory
	local ld_flags="
		--disable-default-execstack
		--enable-new-dtags
		--enable-relro
		--enable-separate-code
		--enable-textrel-check

		--with-sysroot=${PREFIX}
		--with-lib-path==/${arch_libdir}:=/lib

		${enable_jansson}
	"

	# Options for gold subdirectory
	local gold_flags=--disable-gold

	if test ${stage} -gt 1 && ${WITH_GOLD}; then
		gold_flags="
			--enable-gold
			--enable-threads
		"
	fi

	# Options for gprofng subdirectory
	local gprofng_flags=--disable-gprofng

	if test ${stage} -gt 1 && ${WITH_GPROFNG}; then
		gprofng_flags="
			--enable-gprofng
		"
	fi

	# This will disable building of GDB for builds from git
	local configure_disable_gdb="
		--disable-gdb
		--disable-gdbserver
		--disable-gdbsupport
		--disable-gnulib
		--disable-libdecnumber
		--disable-libbacktrace
		--disable-readline
		--disable-sim
	"

	# Pass --build, --host and --target
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
		${configure_disable_gdb}
		${build_host_target}

		--disable-dependency-tracking
		--disable-silent-rules

		${with_static_libs}
		${with_shared_libs}
		${with_pic}
		--disable-rpath

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		${bfd_flags}
		${binutils_flags}
		${gas_flags}
		${ld_flags}
		${gold_flags}
		${gprofng_flags}

		${enable_nls}
		${enable_plugins}

		${with_debuginfod}
		${with_zlib}
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

binutils_build() {
	_make_build
}

binutils_check() {
	if ${MAKE_CHECK}; then
		_make_check
	fi
}

binutils_stage() {
	_make_stage
}

binutils_pack_hook() {
	# When ${build_triplet} != ${target_triplet} all installed tools will be
	# prefixed with ${target_triplet}-
	#
	# Create links without ${target_triplet}- prefix

	local file
	local link

	for file in $(dir bin); do
		case ${file} in
		${target_triplet}-*)
			link=$(printf %s ${file} | sed "s|^${target_triplet}-||")
			if test ! -f bin/${link}; then
				(cd bin && ln -s ${file} ${link}) || exit
			fi
			;;
		esac
	done
}

binutils_pack() {
	_make_pack binutils_pack_hook
}

binutils_install() {
	_make_install
}

binutils_main() {
	_make_main binutils ${BINUTILS_SRCDIR}
}
