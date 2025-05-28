#!/bin/sh

# BUILD_SYSTEM: autotools

##
# Build GCC (options are as of version 15.1)
#

## Top-level
#
# --enable-year2038
#
# --enable-host-pie
# --enable-host-shared
#
# --enable-c++-tools
# --enable-libada
# --enable-libgm2
# --enable-libssp
# --disable-libstdcxx
# --enable-lto
# --enable-objc-gc
# --enable-vtable-verify
# --enable-libgdiagnostics
#
# --enable-as-accelerator-for=ARG
# --enable-offload-targets=LIST
# --enable-offload-defaulted
#
## Installation
#
# --with-gcc-major-version-only
#
## Build
#
# --disable-bootstrap
#
# --enable-serial-configure
# --enable-serial-build-configure
# --enable-serial-host-configure
# --enable-serial-target-configure
#
# --with-static-standard-libraries
#
# --enable-pgo-build[=lto]
#
# --enable-werror
#
# --with-build-config='NAME ...'
# --with-build-sysroot=DIR
# --with-build-time-tools=DIR
# --with-build-libsubdir=DIR
#
# --with-boot-libs=LIBS
# --with-boot-ldflags=FLAGS
#
# --enable-stage1-languages[=all]
# --enable-stage1-checking[=all]
#
# --with-stage1-libs=LIBS
# --with-stage1-ldflags=FLAGS
#
# --enable-linker-plugin-configure-flags=FLAGS
# --enable-linker-plugin-flags=FLAGS
#
# --with-debug-prefix='A=B ...'
#
## Dependencies
#
# --with-system-zlib
# --with-zstd
#
# --with-gmp=DIR
# --with-gmp-include=DIR
# --with-gmp-lib=DIR
#
# --with-mpfr=DIR
# --with-mpfr-include=DIR
# --with-mpfr-lib=DIR
#
# --with-mpc=DIR
# --with-mpc-include=DIR
# --with-mpc-lib=DIR
#
# --with-isl=DIR
# --with-isl-include=DIR
# --with-isl-lib=DIR
#
# --disable-isl-version-check
#
# --with-target-bdw-gc=DIR
# --with-target-bdw-gc-include=DIR
# --with-target-bdw-gc-lib=DIR
#

################################################################################

## gcc
#
# --enable-host-bind-now
#
## Features
#
# --disable-nls
# --disable-largefile
#
# --disable-analyzer
# --disable-gcov
# --disable-libquadmath-support
# --enable-plugin
#
# --with-diagnostics-color={never,auto,auto-if-env,always}
# --with-diagnostics-urls={never,auto,auto-if-env,always}
#
## Target compiler and libraries
#
# --enable-languages=LIST
#
# --with-specs=SPEC
#
# --enalbe-multiarch
# --enable-multilib
#
# --with-multilib-list=LIST
#
# --enable-cet
#
# [sysroot]
#
# --with-sysroot[=DIR]
#
# --with-native-system-header-dir=dir
# --with-local-prefix=DIR
#
# [installtion]
#
# --enable-version-specific-runtime-libs
#
# --with-gxx-include-dir=DIR
# --with-gxx-libcxx-include-dir=DIR
#
# --with-cpp-install-dir=DIR
#
## Code Generation and Language features
#
# --enable-default-pie
# --enable-default-ssp
#
# --with-stack-clash-protection-guard-size=SIZE
#
# --enable-decimal-float={yes|no|bid|dpd}
# --enable-fixed-point
#
# --enable-threads[=LIB]
# --enable-tls
#
# --enable-sjlj-exceptions
#
# --enable-linker-build-id
# --enable-initfini-arrays
# --enable-comdat
#
# --with-dwarf2
# --with-linker-hash-style={sysv,gnu,both}
# --with-demangler-in-ld
#
# --with-matchpd-partitions=num
# --with-insnemit-partitions=num
#
## Build
#
# --enable-versioned-jit
#
# --disable-build-format-warnings
# --enable-werror-always
#
# [dependencies]
#
# --with-libiconv-prefix=DIR
# --with-libiconv-type=auto|static|shared
#
# --with-libintl-prefix=DIR
# --with-libintl-type=auto|static|shared
#
# --with-zstd=DIR
# --with-zstd-include=DIR
# --with-zstd-lib=DIR
#
## System-specific
#
# --with-long-double-128
#
# [glibc]
#
# --enable-__cxa_atexit
#
# --enable-gnu-indirect-function
# --enable-gnu-unique-object
#
# [newlib]
#
# --enable-newlib-nano-formatted-io
#
# [darwin]
#
# --enable-darwin-at-rpath
# --with-darwin-extra-rpath=LIST
#
## Architecture-specific
#
# [x86]
#
# --enable-cld
# --enable-frame-pointer
#
# [aarch64]
#
# --enable-standard-branch-protection
#
# --enable-fix-cortex-a53-835769
# --enable-fix-cortex-a53-843419
#
# [powerpc]
#
# --enable-secureplt
# --with-long-double-format={ieee,ibm}
#
# [risc-v]
#
# --with-multilib-generator
#
# [s390]
#
# --enable-s390-excess-float-precision
#
## Developer Options
#
# --enable-checking=LIST
# --enable-coverage={opt|noopt}
# --enable-gather-detailed-mem-stats
# --enable-valgrind-annotations
#

## libgcc
#
# --enable-explicit-exception-frame-registration
# --disable-tm-clone-registry
#
# --with-toolexeclibdir=DIR
# --with-slibdir=DIR
#
# --with-system-libunwind
#
## System-specific
#
# --with-glibc-version=M.N
#

################################################################################

## libstdc++v3
#
# --enable-c99
# --enable-long-long
# --enable-wchar_t
#
# --enable-cstdio[=PACKAGE]
# --enable-clocale[=MODEL]
#
# --enable-cheaders-obsolete
# --enable-cheaders[=KIND]
#
# --enable-extern-template
# --enable-fully-dynamic-string
#
# --enable-libstdcxx-allocator[=KIND]
# --enable-libstdcxx-time[=KIND]
# --enable-libstdcxx-threads
# --enable-libstdcxx-filesystem-ts
# --enable-libstdcxx-backtrace
# --enable-libstdcxx-static-eh-pool
#
# --with-libstdcxx-eh-pool-obj-count
# --with-libstdcxx-lock-policy=atomic|mutex|auto
#
# --enable-concept-checks (boost-derived)
#
## API
#
# --enable-libstdcxx-visibility
# --enable-symvers[=STYLE]
#
## Runtime Behavior
#
# --disable-libstdcxx-verbose
#
# --with-libstdcxx-zoneinfo=DIR
#
## Installation
#
# --with-python-dir=DIR
#
## Build
#
# --enable-cxx-flags=FLAGS
#
# --enable-libstdcxx-pch
#
# [debug library]
#
# --enable-libstdcxx-debug
# --enable-libstdcxx-debug-flags=FLAGS
#
## System Specific
#
# --enable-libstdcxx-dual-abi
# --with-default-libstdcxx-abi=ABI
#
# [Linux]
#
# --enable-linux-futex
#
# [newlib]
#
# --with-newlib
#

################################################################################

# If required, also see
#
# [Go]
#
# libgo/configure
# gotools/configure
#
# [Ada]
#
# libada/configure
# gnattools/configure
#
# [Modula-2]
#
# gcc/m2/configure
# libgm2/configure
#
# [Other]
#
# libgrust/configure
# libobjc/configure
# libphobos/configure
#

##
# This functions creates ${prefix}/${libdir}/$1 gcc spec file.
#
gcc_configure_spec() {
	test -d ${prefix}/${libdir} || install -d ${prefix}/${libdir} || exit

	local sysroot=
	local libc_libdir=${libdir}

	if test ${stage} -eq 1; then
		sysroot=${libc_prefix}
	else
		sysroot=${PREFIX}
	fi

	case ${libc} in
	glibc)
		if ${is_64bit}; then
			libc_libdir=lib64
		elif ${is_x32bit}; then
			libc_libdir=libx32
		else
			libc_libdir=lib
		fi
		;;
	esac

	if test -n "${dynamic_linker}"; then
		cat <<-EOF >${prefix}/${libdir}/$1
			*link:
			+ %{static|static-pie: -no-dynamic-linker;: -dynamic-linker ${sysroot}/${libc_libdir}/${dynamic_linker}}
		EOF
	else
		cat <<-EOF >${prefix}/${libdir}/$1
			*link:
			+ -no-dynamic-linker
		EOF
	fi

	test -f ${prefix}/${libdir}/$1 || die "${package}: failed to create ${prefix}/${libdir}/$1"
}

gcc_configure() {
	local log_file=${logdir}/configure.log

	# Write ${libdir}/site.spec
	gcc_configure_spec site.spec

	# Local overrides
	local cflags=$(strip_args "${cflags}" '-f*lto' '-f*fat-lto-objects')
	local cxxflags=$(strip_args "${cxxflags}" '-f*lto' '-f*fat-lto-objects')

	if test -n "${dynamic_linker}" && test ${stage} -gt 1 && ${ENABLE_PIC}; then
		local with_pic="${with_pic} --enable-host-pie --enable-default-pie"
	fi

	# Languages
	local languages='--enable-languages=c,c++'

	if test -n "${gcc_languages-}"; then
		languages="${languages},${gcc_languages}"
	fi

	# Host tools
	local enable_host_shared=--disable-host-shared
	local enable_host_bind_now=

	# Target libraries
	local enable_shared=--disable-shared
	local enable_cet=

	if test -n "${dynamic_linker}"; then
		enable_shared=--enable-shared
	fi

	if ${ENABLE_CET}; then
		enable_cet=--enable-cet
	fi

	# Features
	local enable_analyzer=--disable-analyzer
	local enable_gcov=--disable-gcov
	local enable_lto=--disable-lto
	local enable_nls=--disable-nls
	local enable_plugin=--disable-plugin

	if test ${stage} -eq 3 && ${WITH_GETTEXT}; then
		enable_nls=--enable-nls
	fi

	# Build options
	local bootstrap=--disable-bootstrap

	if test ${stage} -gt 1; then
		# we are brave
		bootstrap=--enable-bootstrap

		enable_analyzer=--enable-analyzer
		enable_gcov=--enable-gcov

		if test -n "${dynamic_linker}"; then
			enable_host_shared=--enable-host-shared

			if ${ENABLE_BIND_NOW}; then
				enable_host_bind_now=--enable-host-bind-now
			fi

			# plugins and lto require dynamic loading
			enable_lto=--enable-lto
			enable_plugin=--enable-plugin
		fi
	fi

	# Dependencies
	local with_libunwind=--without-system-libunwind
	local with_zlib=--without-system-zlib
	local with_zstd=--without-zstd

	if test ${stage} -gt 1; then
		if ${WITH_LIBUNWIND}; then
			with_libunwind=--with-system-libunwind
		fi

		#if ${WITH_ZLIB}; then
		with_zlib=--with-system-zlib
		#fi

		if ${WITH_ZSTD}; then
			with_zstd=--with-zstd
		fi
	fi

	# Options specific to targeted C Library
	local libc_flags=

	case ${libc} in
	glibc)
		local glibc_version=
		local vtable_verify=--disable-vtable-verify

		if test -n "${gcc_glibc_version-}"; then
			glibc_version="--with-glibc-version=${gcc_glibc_version}"
		fi

		# FIXME: apperently, libvtv ignores --with-build-sysroot options which
		# makes it impossible to build libvtv during stage 1

		if test ${stage} -gt 1 && ${gcc_vtable_verify-false}; then
			vtable_verify=--enable-vtable-verify
		fi

		libc_flags="
			${glibc_version}
			--with-__cxa_atexit

			--enable-gnu-indirect-function
			--enable-gnu-unique-object

			${vtable_verify}
		"
		;;
	musl)
		# libvtv requires execinfo.h (backtrace(3)) which is not implemented
		# in musl
		local vtable_verify=--disable-vtable-verify

		if ${gcc_vtable_verify-false}; then
			warning "gcc: --enable-vtable-verify cannot be used with musl"
		fi

		libc_flags="
			${vtable_verify}
		"
		;;
	newlib)
		# TODO
		local vtable_verify=--disable-vtable-verify

		libc_flags="
			--with-newlib
			${vtable_verify}
		"
		;;
	uclibc)
		# libvtv requires execinfo.h (backtrace(3)) which is optional
		# in uclibc-ng
		local vtable_verify=--disable-vtable-verify

		if test ${stage} -gt 1 && ${gcc_vtable_verify-false}; then
			if test -f ${PREFIX}/include/execinfo.h; then
				vtable_verify=--enable-vtable-verify
			else
				warning "gcc: --enable-vtable-verify cannot be used with this configuration of uclibc-ng"
			fi
		fi

		libc_flags="
			--disable-libsanitizer
			${vtable_verify}
		"
		;;
	esac

	# Set gcc-specfiec configure options
	local gcc_flags="
		--enable-threads=posix
		--enable-tls

		${enable_analyzer}
		${enable_gcov}
		${enable_plugin}

		${enable_cet}

		--with-dwarf2
	"

	# Set libstdc++-specifec configure options
	local libstdcxx_flags="
		--enable-libstdcxx-threads
		--enable-libstdcxx-filesystem-ts
		--enable-libstdcxx-static-eh-pool
	"

	# sysroot and friends
	local sysroot="
		--with-sysroot=${PREFIX}
		--with-native-system-header-dir=/include
	"

	# During stage 1 we do not have target C Library in PREFIX
	if test ${stage} -eq 1; then
		sysroot="
			${sysroot}
			--with-build-sysroot=${libc_prefix}
		"
	fi

	# --with-specs
	local specs="--with-specs=%{!specs:-specs=${prefix}/${libdir}/site.spec}"

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

		--disable-dependency-tracking
		--disable-silent-rules
		--disable-werror

		${with_static_libs}
		${enable_shared}
		${enable_host_shared}
		${enable_host_bind_now}
		${with_pic}

		--prefix=${prefix}
		--libdir=${prefix}/${libdir}

		${bootstrap}
		${languages}
		${specs}

		--disable-multilib
		${sysroot}

		${libc_flags}
		${gcc_flags}
		${libstdcxx_flags}

		${enable_nls}
		${enable_lto}

		${with_libunwind}
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
		${configure_options} \
		>>${log_file} 2>&1

	test $? -eq 0 || die "${package}: configuration failed"
}

gcc_build() {
	_make_build
}

gcc_check() {
	if test ${stage} -gt 1 && ${MAKE_CHECK_GCC}; then
		_make_check
	fi
}

gcc_stage() {
	_make_stage
}

gcc_pack_hook() {
	# add ${libdir}/site.spec to archive

	test -d ${libdir} || install -d ${libdir} || exit
	cp ${prefix}/${libdir}/site.spec -t ${libdir} || exit

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

gcc_pack() {
	_make_pack gcc_pack_hook
}

gcc_install() {
	_make_install
}

gcc_main() {
	_make_main gcc ${GCC_SRCDIR}
}
